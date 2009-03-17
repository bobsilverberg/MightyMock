<cfcomponent output="false">
  <cfscript>

	  matcher = createObject('component','ArgumentMatcher');

	  function setMatcher(m){
      matcher = arguments.m;
	  }

	  this.registry =  queryNew('id,type,method,argid,returns,throws,time');
	  this.invocationRecord =  queryNew('id,time,status,pattern');
	  this.registryDataMap = {};
	  this.argMap = {};

		patterns =[
	  '{string}',
	  '{any}',
	  '{date}',
	  '{object}',
	  '{struct}',
	  '{udf}',
	  '{numeric}',
	  '{array}',
	  '{query}',
	  '{xml}',
	  '{boolean}',
	  '{binary}',
	  '{image}',
	  '{*}',
	  '{+}'
	];



  function register(target,args){
    var id = id(target,args);
    queryAddRow(this.registry,1);
    querySetCell(this.registry,'id',id);
    querySetCell(this.registry,'type', argType(args));
    querySetCell(this.registry,'method',target);
    querySetCell(this.registry,'argid',argId(args));
    querySetCell(this.registry,'returns', '{undefined}');
    querySetCell(this.registry,'throws', '{undefined}');
    querySetCell(this.registry,'time', getTickCount());
    this.argMap[id] = args;
 }

  function getArgumentMapEntry(target,args){
   var id = id(target,args);
   return this.argMap[id]; //where to catch undefined element exception? client?
  }


  function updateRegistry(target,args,column,value){
    var rowNum = getRowNum(target,args);
    var id = id(target,args);
    var mapId = 'behaviordata_' & id;

    //  used to check for value.toString() == '{undefined}' ... forget why. doh!
    //  maybe to control how returns behaves. maybe it should just return null
    //  if not mocked?
    this.registryDataMap[mapId] = value;
    querySetCell(getRegistry(),column, mapId, rowNum);

  }


  function getReturnsData(target,args){
    var id = id(target,args);
    //To Do: !!
    /*
      Record the literal reference and associated pattern.
    */
    addInvocationRecord(target,args,'ok');
    return this.registryDataMap['behaviordata_' & id];
  }

  function getRegisteredBehavior(target,args){
  	var mock = findMock(target,args);
  	if (mock.returns != '{undefined}') return 'returns';
  	if (mock.throws != '{undefined}') return 'throws';
  	$throw('UnmockedBehaviorException',' "#target#(...)" has not been mocked.',' This happens when you attempt to execute a object.method() that has not been mocked. Make sure you specify returns or throws behavior for this method.');
  }


  function exists(target,args){
   var item = findMock(target,args);
   return item.recordCount > 0;
  }


  function id(target,args){
   return uCase(target) & '_' &  argId(args) ;
  }

  function argId(args){
    var caseInsensitiveArgs = uCase(args.toString());
    return caseInsensitiveArgs.hashCode();
  }


  function argType(args){
   try{
      if (isPattern(args)) return 'pattern';
      return 'litteral';
    }
    catch(coldfusion.runtime.ScopeCastException e){
     $throw(type='InvalidArgumentTypeException',message='arguments not pattern or litteral : @',detail='argType(#args.toString()#)');
    }
  }

  function isPattern(args){
	 //iterate over	known patterns and see if value exists
	 var i = 1;
	 var isPattern = false;
   var item = '';
   for(item in args){
    if( patterns.contains(args[item]) ){
     isPattern =  true;
    }
    else {
     return false;
    }
   }
	 return isPattern;
	}


//invocation record smells like another object
 function addInvocationRecord(target,args,status){ //
    var id = id(target,args);
    sleep(5);//ensures, fwiw, that the recorded time will be unique
    queryAddRow(this.invocationRecord,1);
    querySetCell(this.invocationRecord,'id',id);
    querySetCell(this.invocationRecord,'time', getTickCount());
    querySetCell(this.invocationRecord,'status',status);
    querySetCell(this.invocationRecord,'pattern','');
 }

  function getRegistry(){
   return this.registry;
  }

  function reset(){
    this.registry =  queryNew('id,type,method,argid,returns,throws,time');
	this.invocationRecord =  queryNew('id,time,status,pattern');
	this.registryDataMap={};
	this.argMap = {};
  }
	</cfscript>

<cffunction name="getInvocationRecordsById">
  <cfargument name="target" type="string" />
  <cfargument name="args" type="struct" />
	<cfset var lid = id(target,args) />
	<cfquery name="q" dbtype="query">
	 select *
	 from this.invocationRecord
	 where id = '#lid#'
	</cfquery>
	<cfreturn q>
</cffunction>


<cffunction name="findMock">
  <cfargument name="target" type="string" />
  <cfargument name="args" type="struct" />
	<cfset var lid = id(target,args) />
	<cfquery name="q" dbtype="query" maxrows="1">
	 select *
	 from this.registry
	 where id = '#lid#'
	</cfquery>
	<cfreturn q>
</cffunction>

<cffunction name="findByPattern">
  <cfargument name="target" type="string" />
  <cfargument name="args" type="struct" />
	<cfset var lid = id(target,args) />
	<cfset var patternArgs =  {} />
    <cfset var isMatch = false />
    <cfset var behavior = {} />
    <cfquery name="q" dbtype="query">
	  select *
	  from this.registry
	  where type='pattern' and method = '#target#'
    </cfquery>
  <cfloop query="q">
    <cfset patternArgs = this.argMap[q.id] />
    <cftry>
      <cfset isMatch = matcher.match(args,patternArgs) />
      <cfif isMatch>
       <cfset behavior['target'] = q.method />
       <cfset behavior['args']   = patternArgs />
       <cfreturn behavior />
      </cfif>
      <cfcatch type="MismatchedArgumentNumberException"></cfcatch>
      <cfcatch type="MismatchedArgumentPatternException"></cfcatch>
    </cftry>
  </cfloop>
  <cfset $throw('MismatchedArgumentPatternException',
                'An argument pattern could not be found for this litteral argument collection.',
                '#args.toString()#')/>
</cffunction>

<cffunction name="getRowNum">
  <cfargument name="target" type="string" />
	<cfargument name="args" type="struct" />
	<cfset var id = id(target,args)>
	<cfset var rownum = 0 />
	<cfquery name="q" dbtype="query">
	 select *
	 from this.registry
	</cfquery>
	<cfoutput query="q">
	 <cfif q.id eq id>
		 <cfreturn q.currentRow>
		</cfif>
	</cfoutput>
	<cfset $throw('InvalidRegistryEntryException','No entry exists for #id#. ', 'Make sure item is correctly registered.') />
</cffunction>

<cffunction name="$throw">
	<cfargument name="type" required="false" default="mxunit.exception.AssertionFailedError">
	<cfargument name="message" required="false" default="failed behaviour">
	<cfargument name="detail" required="false" default="Details details ...">
  <cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>
</cfcomponent>