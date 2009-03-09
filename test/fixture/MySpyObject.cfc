<cfcomponent output="false">
<!---
  fixture for Spy or partial mock implementation.

  NOTE: Mock should also invoke or mock parent methods, too.
        also should be able to accept any init params.
 --->

  <cffunction name="init">
    <cfreturn this />
  </cffunction>

	<cffunction name="mockMe" access="public" output="false" returntype="Any">
		<cfreturn 'I have not Been Mocked' />
	</cffunction>

	<cffunction name="leaveMeAlone" access="public" output="false" returntype="Any">
		<cfreturn 'I should return' />
	</cffunction>
</cfcomponent>