<cfcomponent output="false" extends="mxunit.framework.TestCase">
  <!---
   MightyMock should support creating and collaboration of multiple
   mocks. So, if an object under test is dependent on another object,
   which uses yet another object, this should be able to be mocked
   easily!

   Example:

   CUT Logger depends on Controller which depends on Foobar

   Logger.testMe() calls Controller.foo() which calls Foobar.bar() ...

   Logger.testMe(){
     ...
     Controller.foo().bar();
   }

	<cffunction name="LoggerShouldBeAbleLogTrace" access="public" returntype="void" output="false">
		<cftry>
			<cfset testLogger.trace("TRACE Message") />

			<cfcatch type="Any">
				<cfset fail("trace() failed")>
			</cfcatch>
		</cftry>
	</cffunction>
   --->
<cfscript>

  function testRegisterMockAsCollaboratorParameter(){
     foo = $.create('foo');
     bar = $.create('bar');

     foo.setBar('i see the light').returns(bar);
     foo.asd(bar).returns('asd');
     //foo.getBar().returns(bar);

     debug(foo.debugMock());
     debug(bar.debugMock());

     assertEquals( 1,1 );

  }

  function testDeepChainedCollaborators(){
     foo = $.create('foo');
     bar = $.create('bar');

     foo.setBar(bar).returns(chr(0));
     foo.getBar().returns(bar);

     debug(foo.debugMock());
     debug(bar.debugMock());

     foo.setBar(bar);
     b = foo.getBar();

     debug(b);

  }


  function testLoggerFAIL() {

     esapi = $.create('org.owasp.esapi.ESAPI');
     esapi.reset();
     sessionFacade = $.create('org.owasp.esapi.sessionFacade');
     sessionFacade.getProperty("loggingID").returns(createUUID());

     esapi.setSessionFacade(sessionFacade).returns();
     esapi.sessionFacade().returns(sessionFacade);

     esapi.setSessionFacade(sessionFacade);


     logger = createObject('component','mightymock.test.fixture.Logger').init('mylogger','warn',esapi);
     debug(logger);

     r = logger.trace('trace me') ;

     debug(esapi.debugMock());
     debug(sessionFacade.debugMock());

     esapi.verify().sessionFacade();

  }



  function setUp(){
  	$ = createObject('component','mightymock.MightyMockFactory');

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>