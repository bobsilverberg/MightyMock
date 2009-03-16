<cfcomponent output="true">
	<cfscript>

/*------------------------------------------------------------------------------
      Public API. Any method NOT prefixed with _$ are considered public.
      All other methods are readily available, but will likely produce
      unexpected behavior if not used correctly.
------------------------------------------------------------------------------*/

//should be separate object!
 function mockify(objfunc, data){
  var name = getMetaData(objfunc).name;
  var template = '<cfcomponent><cffunction name="#name#" access="public"><cfreturn "bar"></cffunction></cfcomponent>';
  var id = createUUID();
  var fileName = expandPath('/mightymock/#id#.cfc');
  var tempO = '';
  var oCfcPath = objfunc.getPagePath();
  //var targetO = '';
  var targetO = createObject('java','coldfusion.cfc.CFCProxy').init(oCfcPath);
  method = targetO.getThisScope();
  fileWrite(fileName,template);
  tempO = createObject( 'component', id );

  fileDelete(fileName);
  obj.func = tempO[name];

  return targetOs;
 }


 function init(){
   var localSpy = '';
   var proxyVars = '';

   /*
    Make "fast mock" and bypass scope acrobatics.
   */
   if( arguments.size() eq 0 ) return this;

   if( arguments.size() eq 1){
     getMetaData(this).name = arguments[1];
     getMetaData(this).fullname = arguments[1];
     return this;
   }

   /*
     Make multiple type safe mocks.
   */
   if( arguments.size() eq 2 ) {
	   try{
	    return createMultipleTypeSafeMocks(arguments[1]);
		 }
		 catch (coldfusion.runtime.CfJspPage$NoSuchTemplateException e){
		     _$throw('InvalidMockException',e.getMessage(),e.getDetail());
		 }
  }
 }

 function createSpy(name){
   var localSpy = createObject('component', name);
   _$throw('UnimplementedException','createSpy(name) is not yet implemented','');
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



/*
     for (item in localVars){
       if(!item == 'this'){
         proxy[item] = variables[item];
         proxy.variables[item] =  variables[item];
       };
     }
*/

     	proxy.RETURNS = RETURNS ;
			proxy._$SETSTATE = _$SETSTATE;
			proxy.variables._$SETSTATE = _$SETSTATE;
			proxy.DEBUGMOCK =  DEBUGMOCK;
			proxy.variables.DEBUGMOCK =  DEBUGMOCK;
			proxy._$GETPREVIOUSSTATE  =  _$GETPREVIOUSSTATE;
			proxy.variables._$GETPREVIOUSSTATE  =  _$GETPREVIOUSSTATE;
			proxy.MOCKSPY = MOCKSPY;
			proxy.variables.MOCKSPY = MOCKSPY;
			proxy.VERIFYATLEAST=VERIFYATLEAST;
			proxy.variables.VERIFYATLEAST=VERIFYATLEAST;
			proxy.THROWS = THROWS ;
			proxy.variables.THROWS = THROWS ;
			proxy._$INVOKEMOCK = _$INVOKEMOCK;
			proxy.variables._$INVOKEMOCK = _$INVOKEMOCK;
			proxy.VERIFYONCE = VERIFYONCE;
			proxy.variables.VERIFYONCE = VERIFYONCE;
			proxy.variables.CURRENTMETHOD=CURRENTMETHOD;
			proxy._$THROW = _$THROW;
			proxy.variables._$THROW = _$THROW;
			proxy.variables.STATES = STATES;
			proxy.variables.PREVIOUSSTATE = PREVIOUSSTATE;
			proxy.VERIFYNEVER = VERIFYNEVER;
			proxy.variables.VERIFYNEVER = VERIFYNEVER;
			proxy._$GETSPY =_$GETSPY;
			proxy.variables._$GETSPY =_$GETSPY;
			proxy.variables.TEMPRULE =TEMPRULE;
			proxy.SETSPY=SETSPY;
			proxy.variables.SETSPY=SETSPY;
			proxy.variables.CURRENTSTATE = variables.CURRENTSTATE;
			proxy._$DEBUGREG = _$DEBUGREG ;
			proxy.variables._$DEBUGREG = _$DEBUGREG;
			proxy.variables.REGISTRY = REGISTRY;
			proxy._$GETSTATE =_$GETSTATE;
			proxy.RESET = RESET;
			proxy.variables.RESET = RESET;
			proxy.ONMISSINGMETHOD  = ONMISSINGMETHOD;
			proxy.VERIFYATMOST=VERIFYATMOST;
			proxy.variables.VERIFYATMOST=VERIFYATMOST;
			proxy.variables.MATCHER = MATCHER;
			proxy.variables.SPY= SPY;
			proxy.variables.VERIFIER = VERIFIER;
			proxy.REGISTER = REGISTER;
			proxy.variables.REGISTER = REGISTER;
			proxy._$DEBUGINVOKE = _$DEBUGINVOKE;
			proxy._$DUMP = _$DUMP;
			proxy.VERIFY = VERIFY;
			proxy.variables.VERIFY = VERIFY;
			proxy.VERIFYTIMES = VERIFYTIMES;
			proxy.variables.VERIFYTIMES = VERIFYTIMES;
			proxy._$GETREGISTRY = _$GETREGISTRY;
			proxy.variables._$GETREGISTRY = _$GETREGISTRY;

     return proxy;

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
    structInsert(mockBug," MockName", getMetaData(this).name );
    structInsert(mockBug, 'MockRegistry', registry.getRegistry());
    structInsert(mockBug, 'InvocationRecord', registry.invocationRecord);
    structInsert(mockBug, 'RegistryDataMap' , registry.registryDataMap);
	  structInsert(mockBug, 'RegistryArgMap' , registry.argMap);
    return mockBug;
  }


  function reset(){
    registry.reset();
	  _$setState('idle');
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


//sniffer hook into another object's variables scope
 function _$snif(){
  return variables;
 }

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