<cfcomponent output="true" extends="ParentSpyObject">
<!---
  fixture for Spy or partial mock implementation.

  NOTE: Mock should also invoke or mock parent methods, too.
        also should be able to accept any init params.
 --->

  <cffunction name="init">
    <cfargument name="args">  
    <cfreturn this />
  </cffunction>

	<cffunction name="mockMe" access="public" output="true" returntype="Any">
        <cfdump var="#arguments#">
        <cfreturn 'I have not Been Mocked' />
	</cffunction>

	<cffunction name="leaveMeAlone" access="public" output="true" returntype="Any">
		<cfreturn 'Leave me alone' />
	</cffunction>
</cfcomponent>