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

  function loggerTraceShouldDoSomething() {
     
     mmFactory = createObject('component','mightymock.MightyMockFactory');
     $ = mmFactory.create;
     //jQuery-like alias - makes is cleaner, imo.
     $ = mmFactory.create; 

     uuid = createUUID();
     logMessage = 'messy bed; messy head';

     esapi            = $('org.owasp.esapi.ESAPI');
     sessionFacade    = $('org.owasp.esapi.SessionFacade');
     authenticator    = $('org.owasp.esapi.Authenticator');
     securityConfig   = $('org.owasp.esapi.SecurityConfiguration');
     encoder          = $('org.owasp.esapi.Encoder');
     user             = $('org.owasp.esapi.User');
    
     //define behaviours
     esapi.setSecurityConfiguration(securityConfig).returns();
     esapi.securityConfiguration().returns(securityConfig); 

     esapi.setSessionFacade(sessionFacade).returns();   
     esapi.sessionFacade().returns(sessionFacade);

     esapi.setEncoder(encoder).returns();
     esapi.encoder().returns(encoder);

     esapi.setAuthenticatior(authenticator).returns();
     esapi.authenticator().returns(authenticator);

     encoder.encodeForHTML(logMessage).returns(logMessage);

     securityConfig.getProperty('LogEncodingRequired').returns(false);
     sessionFacade.getProperty("loggingID").returns(uuid);
     
     authenticator.setCurrentUser(user).returns();
     authenticator.getCurrentUser().returns(user);
     user.getUserName().returns('the_mighty_mock');
     user.getLastHostAddress().returns('127.0.0.1');
     
     //inject mock into mock; aka, mock acrobatics
     esapi.setEncoder(encoder);
     esapi.setSessionFacade(sessionFacade);
     esapi.setAuthenticatior(authenticator);

     //instantiate CUT
     logger = createObject('component','mightymock.test.fixture.Logger').init('mylogger','debug',esapi);
     logger.setLevel('trace');
     
     //exercise method
     logger.trace(logMessage) ;
    

     //Not a whole lot of verification. Just wanted the mock to work.
     esapi.verify().sessionFacade();
     user.verify().getUserName();
     order = createObject('component','mightymock.OrderedExpectation').init(esapi,user);
    
      order.setEncoder(encoder).
            setSessionFacade(sessionFacade).
            setAuthenticatior(authenticator).
            sessionFacade().
            authenticator().
            securityConfiguration().
            getUserName().
						getLastHostAddress().
						verify();
  }


</cfscript>
</cfcomponent>