<cfcomponent extends="mxunit.framework.TestCase" output="false">

	<cffunction name="testMyComponentInteractions">
		<!--- Create an mock --->
		<cfset mock = createObject('component','MightyMock').init('MyOtherComponent');
		<!--- Define Behavior --->
		<cfset mock.doSomething('foo').returns( 123456 ) />
		<!--- Inject into component --->
		<cfset myComponent.setMyOtherComponent(mock) />
		<!--- Exercise MyComponent --->
		<cfset myComponent.myMethod('foo') />
	</cffunction>

<cffunction name="testMyComponent">
  <!--- Create an mock --->
	<cfset mock = createObject('component','MightyMock').init('MyOtherComponent');
	<!--- Define Behavior --->
	<cfset mock.writeToLog ('Hello.').returns() />
	<cfset mock.writeToLog ('Good Bye.').returns() />
	<cfset myComponent.setMyOtherComponent(mock) />
	<!--- Exercise MyComponent --->
	<cfset myComponent.myMethod('foo') />
	<!--- Verify --->
	<cfset mock.verify ('times', 1).writeToLog ('Hello.') />
	<cfset mock.verify ('times', 1).writeToLog ('Good Bye.') />
</cffunction>

<cffunction name="testFoo">
 <cfset mock.verify('times',5).foo(1).
             verify('atLeast',1).foo(1).
             verify('atMost',5).foo(1).
             verify('count',5).foo(1)   />
</cffunction>

<cffunction name="setHeaders">
  <cfset myCollaborator.setHeader('X-Foo','Bar') />
  <cfset myCollaborator.setHeader('X-Bar','Foo') />
  <cfset myCollaborator.setHeader('X-Name','Mouse') />
  <cfset myCollaborator.setHeader('X-Value','Cheese') />
</cffunction>

<cffunction name="setHeaders">
  <cfset mock.myCollaborator.setHeader('X-Foo','Bar').returns() />
  <cfset mock.myCollaborator.setHeader('X-Bar','Foo').returns() />
  <cfset mock.myCollaborator.setHeader('X-Name','Mouse').returns() />
  <cfset mock.myCollaborator.setHeader('X-Value','Cheese').returns() />

  <cfset mock.myCollaborator.setHeader('{string}','{}').returns() />
</cffunction>

<cfscript>
 verify(string type, int count).mockedMethod( params );

</cfscript>
</cfcomponent>