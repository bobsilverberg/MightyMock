<cfcomponent output="true">
<cfscript>
 this.mocks = [];
 invocations = chr(0);
 expectations = [];//(1);
 index = 1;
 mr = createObject('component','MockRegistry');


 function onMissingMethod(target,args){
    var id = mr.id(target,args);
    expectations[index++] = id;
    return this;
 }

 function getOrderedList(){
  return orderedList;
 }

 function verify(){
  // loop over expectations and see where those
  // fall within the invocations
  return this;
 }

  function init(){
		for(item in arguments){
	    this.mocks[item] =   arguments[item];
	   }
	  invocations = merge();
    return this;
  }

  function getInvocations(){
    return invocations;
  }

  function getExpectations(){
   return expectations;
  }

  function merge(){
    var i = 1;
    var s = '';
    for(i; i <= this.mocks.size(); i++){
      t1 = 'q_#i#';
      t2 = 'q2_#i#';
      'q_#i#' = this.mocks[i]._$getRegistry().invocationRecord;
      'q2_#i#' = this.mocks[i]._$getRegistry().getRegistry();
       s &= 'select * from q_#i#, q2_#i#' & chr(10);
       s &= 'where q_#i#.id = q2_#i#.id ' & chr(10);
      if(i != this.mocks.size()) s &= ' union ' & chr(10);
    }
    s &= 'order by [time] asc' & chr(0);
    invocations = _$query(s);
    return invocations;
  }

</cfscript>

<cffunction name="exists" returntype="boolean">
  <cfargument name="id" type="string" />
  <cfquery name="q" dbtype="query" maxrows="1">
    select count(*) as cnt
    from invocations where id = '#id#'
  </cfquery>
  <cfreturn q.cnt eq 1 >
</cffunction>

<cffunction name="_$query" access="private">
  <cfargument name="qs" type="string" />
  <cfquery name="q" dbtype="query">
     #qs#
  </cfquery>
  <cfreturn q>
</cffunction>

<cffunction name="getInvocationTime" >
  <cfargument name="id" type="string">
  <cfquery name="q" dbtype="query" maxrows="1">
    select [time] from invocations where id = '#id#'
  </cfquery>
  <cfreturn q['time'] />
</cffunction>

</cfcomponent>