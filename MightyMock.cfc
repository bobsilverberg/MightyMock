<cfcomponent output="true">
	<cfscript>

/*------------------------------------------------------------------------------
      Public API. Any method NOT prefixed with _$ are considered public.
      All other methods are readily available, but will likely produce
      unexpected behavior if not used correctly.
------------------------------------------------------------------------------*/


 function createSpy(name){
   var localSpy = createObject('component', name);
 }

 function createMultipleTypeSafeMocks(name){
     var localSpy = createObject('component', name); //need to implement initParams
     var proxy = createObject('component', name);

     //setSpy(localSpy); //To Do: Change logic o invoke spy methods
     structClear(proxy);
     proxy.snif = _$snif; //sniffer for variables scope
     proxyVars = proxy.snif();
     structClear(proxyVars);
     proxy.variables = proxyVars;

	/* Need to write to THIS and VARIABLES scope because some weird scoping
	   issue when invoking a variable-scoped method from within another
	   method, CF sees this as undefined.
	   Ex: this works normally:
	   function foo(){
	    return bar();
	   }

	   But if copying both foo and bar to another component:
	   newCfc.foo = foo;
	   newCfc.bar = bar;

	   calling foo() fails with undefined bar exception. However, if we
	   do this:
	   newCfc.foo = foo;
	   newCfc.variables.foo = foo;
	   newCfc.bar = bar;
	   newCfc.variables.bar = bar;
	   All is well ...

	*/

	// For this Impl, we might have to be more selective in order to help
	// with performance ...

     for (item in variables){
       proxy[item] = variables[item];
       proxy.variables[item] =  variables[item];
     }

     return proxy;

 }

 function init(){
   var localSpy = '';
   var proxy = '';
   var proxyVars = '';

   /*
    Make "fast mock" and bypass scope acrobatics.
   */
   if( arguments.size()eq 0 ) return this;

   if( arguments.size()eq 1){
     getMetaData(this).name = arguments[1];
     getMetaData(this).fullname = arguments[1];
     return this;
   }

   /*
     Make multiple type safe mocks.
   */
   if(arguments.size()>0) {
	   try{
	    return createMultipleTypeSafeMocks(arguments[1]);
		 }
		 catch (coldfusion.runtime.CfJspPage$NoSuchTemplateException e){
		     _$throw('InvalidMockException',e.getMessage(),e.getDetail());
		 }
  }
 }

 function _$snif(){
  return variables;
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


     //_$setState('registering');
     currentState = 'registering';
		 previousState = 'idle';
     registry.register(target,args); //could return id
     currentMethod['name'] = target;
     currentMethod['args'] = args;
     return this;
   }

   else{
    // _$setState('executing');
    currentState = 'executing';
		previousState = 'registering';
    currentMethod = {};
    retval = _$invokeMock(target,args);
    return retval;
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
    var count = 1;
    _$setState('verifying');
    tempRule[1] = 'verify';
    if(arguments.size()) count = arguments[1];
    tempRule[2] = count;
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

//To Do: Delegate to MockDebug and pretty print mock info
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
variables.registry = createObject('component','MockRegistry');
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