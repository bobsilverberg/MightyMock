<cfcomponent output="true">
	<cfscript>

/*------------------------------------------------------------------------------
      Public API. Any method NOT prefixed with _$ are considered public.
      All other methods are readily available, but will likely produce
      unexpected behavior if not used correctly.
------------------------------------------------------------------------------*/



 function init(name){
   var localSpy = '';
   getMetaData(this).name = name;
   getMetaData(this).fullname = name;
   if(arguments.size()>1) {
   try{
     localSpy = createObject('component',arguments[1]); //need to implement initParams
     setSpy(localSpy);
   }
   catch (coldfusion.runtime.CfJspPage$NoSuchTemplateException e){
     _$throw('InvalidSpyException',e.getMessage(),e.getDetail());
   }

   }
   return this;
 }

 function setSpy(iSpy){
  spy = arguments.iSpy;
 }

 function onMissingMethod(target,args){
   var t = chr(0);
   var temp = '';

   if( currentState == 'verifying'){
      verifier.doVerify(tempRule[1], target, args, tempRule[2], registry );
      _$setState('idle');
      return this;
   }

   else if(!registry.exists(target,args)) {

     if (!registry.isPattern(args)){ //pee-yew!
      try{
       //To Do: record the literal and invoke pattern behavior
       t = registry.findByPattern(target,args);
       return _$invokeMock(t['target'],t['args']);
      }
      catch(MismatchedArgumentPatternException e){}
     }


     if(isObject(spy)){
       if(currentState == 'registering'){  //user did mock.register() to prevent execution
         registry.register(target,args);
         currentMethod['name'] = target;
         currentMethod['args'] = args;
         return this;
       }
       else{
         _$setState('executing');
         try{
           if (structIsEmpty(args)){
             temp = evaluate('spy.#target#()');
           }
           else{
             temp = evaluate('spy.#target#()' ); //NOT WORKING with argumentCollection !!!! To Do
           }

           registry.addInvocationRecord(target,args,'ok'); //record call to spy
         }
         catch(any e){
           _$throw(e.type & '_asd',e.getMessage(),e.getDetail());
           registry.addInvocationRecord(target,args,'error'); //record call to spy
         }
         return temp;
       }
     }


     _$setState('registering');
     registry.register(target,args); //could return id
     currentMethod['name'] = target;
     currentMethod['args'] = args;
     return this;
   }

   else{
    _$setState('executing');
    currentMethod = {};
    return _$invokeMock(target,args);
   }

   return '';
 }


  function returns(){
   var arg = '';
   _$setState('idle');
   if( arguments.size() ) arg = arguments[1];
   registry.updateRegistry(currentMethod['name'],currentMethod['args'],'returns',arg);
   return this;
  }

  function throws(type){
   registry.updateRegistry(currentMethod['name'],currentMethod['args'],'throws',type);
   return this;
  }




/*-------------------------------------------------------------------------------------
                            Method  Verifications
-------------------------------------------------------------------------------------*/

  function verify(){
   _$setState('verifying');
    tempRule[1] = 'verifyOnce';
    tempRule[2] = 1;
   return this;
  }

  //Could put all this into onMissingMethod?
  function verifyTimes(count){
    _$setState('verifying');
    tempRule[1] = 'verifyTimes';
    tempRule[2] = arguments.count;
    return this;
  }
  function verifyAtLeast(count){
    _$setState('verifying');
    tempRule[1] = 'verifyAtLeast';
    tempRule[2] = arguments.count;
    return this;
  }
  function verifyAtMost(count){
     _$setState('verifying');
    tempRule[1] = 'verifyAtMost';
    tempRule[2] = arguments.count;
    return this;
  }
  function verifyOnce(){
    _$setState('verifying');
    tempRule[1] = 'verifyOnce';
    tempRule[2] = 1;
    return this;
  }
  function verifyNever(){
     _$setState('verifying');
    tempRule[1] = 'verifyNever';
    tempRule[2] = 0;
    return this;
  }


/*------------------------------------------------------------------------------
                                Utils
------------------------------------------------------------------------------*/

  function debugMock(){
    var mockBug = {};
    structInsert(mockBug, 'MockRegistry', registry.getRegistry());
    structInsert(mockBug, 'InvocationRecord', registry.invocationRecord);
    structInsert(mockBug, 'RegistryDataMap' , registry.registryDataMap);
	  structInsert(mockBug, 'RegistryArgMap' , registry.argMap);
    return mockBug;
  }


  function reset(){
    registry.reset();
	  currentState = states[1];
    currentMethod = {};
    return this;
  }

  function register(){
   _$setState('registering');
   return this;
  }

  function mockSpy(){
   register();
   return this;
  }


/*------------------------------------------------------------------------------
                                Private API.
------------------------------------------------------------------------------*/

  function _$invokeMock(target,args){
    var behavior = registry.getRegisteredBehavior(target,args);

    if(behavior == 'returns') return registry.getReturnsData(target,args);
    if(behavior == 'throws')  _$throw(registry.getReturnsData(target,args));

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
  	previousState = currentState;
    currentState = state;
  }

  function _$getState(){
   return currentState;
  }

  function _$getPreviousState(){
   return previousState;
  }


  function _$getSpy(){
   return spy;
  }




/*------------------------------------------------------------------------------
                          Private Instance Members
------------------------------------------------------------------------------*/
registry = createObject('component','MockRegistry');
matcher = createObject('component','ArgumentMatcher');
verifier = createObject('component','Verifier');

spy = chr(0);     //used if creating a partial mock.

tempRule = [];    //tech debt for verfier


states = [
 'idle',          // mock is waiting to be invoked
 'registering',   // mock is registering methods
 'executing',     // mock is executing a mocked method
 'verifying',      // mock is verifying behavior
 'error'          // problem
];

currentState = states[1];
previousState = '';

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