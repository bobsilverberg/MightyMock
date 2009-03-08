<cfcomponent hint="Example Component To Mock" output="false">

<cffunction name="myMethod">
  <cfargument name="foo" />
  <cfset myData = myOtherComponent.doSomething('foo') />
  <!--- Do something with myData --->
  <cfreturn true />
</cffunction>

<cffunction name="myMethod">
  <cfargument name="foo" />
  <cfset myOtherComponent.writeToLog('Hello.') />
  <!--- do a bunch of other stuff ... --->
  <cfset myOtherComponent.writeToLog('Good bye.') />
</cffunction>


</cfcomponent>