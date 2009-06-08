<cfcomponent output="false">
<cffunction name="echoCFC" access="public">
 <cfargument name="cfc" type="mightymock.test.fixture.Dummy" />
 <cfreturn arguments.cfc />
</cffunction>
</cfcomponent>