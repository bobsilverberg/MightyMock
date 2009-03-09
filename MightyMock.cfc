<cfcomponent output="true">
	<cfscript>

/*------------------------------------------------------------------------------
      Public API. Any method NOT prefixed with _$ is considered public.
      All other methods are readily available, but will likely produce
      unexpected behavior if not used correctly.
------------------------------------------------------------------------------*/



 function init(name){
   var localSpy = '';
   getMetaData(this).name = name;
   getMetaData(this).fullname = name;
   if(arguments.size()==2) {
     localSpy = createObject('component',arguments[2]); //need to implement initParams
     setSpy(localSpy);
   }
   return this;
 }

 function setSpy(iSpy){
  spy = arguments.iSpy;
 }

 function onMissingMethod(target,args){
   var t = chr(0);

   if(currentState == states[4]){
      verifier.verify(tempRule[1], tempRule[2], target, args, registry);
      return this;
   }

   else if(!registry.exists(target,args)) {

     if (!registry.isPattern(args)){ //pee-yew!
      try{
       t = registry.findByPattern(target,args);
       return _$invokeMock(t['target'],t['args']);
      }
      catch(MismatchedArgumentPatternException e){}

      //if spy != '' ...
      //register and execute?
     }


     currentState = states[2];
     registry.register(target,args); //could return id
     currentMethod['name'] = target;
     currentMethod['args'] = args;
     return this;
   }

   else{
    currentState = states[3];
    currentMethod = {};
    return _$invokeMock(target,args);
   }

   return '';
 }


  function returns(){
   var arg = '';
   currentState = states[1];
   if( arguments.size() ) arg = arguments[1];
   registry.updateRegistry(currentMethod['name'],currentMethod['args'],'returns',arg);
   return this;
  }

  function throws(type){
   registry.updateRegistry(currentMethod['name'],currentMethod['args'],'throws',type);
   return this;
  }


//Not sure about this and the coupling
  function verify(){
   var count = 0;
   var rule = '';
   currentState = states[4];

   switch(arguments.size()){

     case 0:
      tempRule[1] = 'atLeast';
      tempRule[2] = 1;
     break;

     case 1:
      if(arguments[1] == 'once') {
		    tempRule[1] = arguments[1];
		    tempRule[2] = 1;
		   }
		   else if(arguments[1] == 'never'){
		    tempRule[1] = arguments[1];
		    tempRule[2] = 0;
		   }
		   else{
		    _$throw("NoSuchRuleException", arguments[1]);
		   }
     break;

     default:
      tempRule[1] = arguments[1];
      tempRule[2] = arguments[2];
     break;


   }
   return this;
  }

 //should delegate resets to object
  function reset(){
    registry.registry =  queryNew('id,type,method,argid,returns,throws,time');
	  registry.invocationRecord =  queryNew('id,time,status');
	  registry.registryDataMap = {};
	  registry.argMap = {};
	  currentState = states[1];
    currentMethod = {};
    return this;
  }




/*------------------------------------------------------------------------------
                                Private API.
------------------------------------------------------------------------------*/

  function _$invokeMock(target,args){
    var behavior = registry.getRegisteredBehavior(target,args);
    if(behavior == 'returns') return registry.getReturnsData(target,args);
    if(behavior == 'throws') _$throw(registry.getReturnsData(target,args));

  }

  function _$debugReg(){
    return registry.getRegistry();
  }

  function _$debugInvoke(){
    return registry.invocationRecord;
  }

  function _$getRegistry(){
   return registry;
  }

  function _$setState(state){
   this.currentState = state;
  }

/*------------------------------------------------------------------------------
                          Private Instance Members
------------------------------------------------------------------------------*/
registry = createObject('component','MockRegistry');
matcher = createObject('component','ArgumentMatcher');
verifier = createObject('component','Verfier');
spy = chr(0); //used if creating a partial mock.

tempRule = []; //tech debt for verfier...

states = [
 'idle',          // mock is waiting to be invoked
 'registering',   // mock is registering (mocking) methods
 'executing',     // mock is executing a mocked method
 'verfying',
 'error'
];

currentState = states[1];

currentMethod = {};

</cfscript>



<cffunction name="_$dump">
  <cfdump var="#arguments[1]#">
</cffunction>


<cffunction name="_$throw">
	<cfargument name="type" required="false" default="mxunit.exception.AssertionFailedError">
	<cfargument name="message" required="false" default="Failed Mock Behaviour">
	<cfargument name="detail" required="false" default="">
  <cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>

</cfcomponent>