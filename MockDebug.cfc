<cfcomponent>
<!---
    to do: pretty print info about the currently mocked object


What's important to print?

Name of Object being mocked,
Is it a spy?
Is it simple or type safe?
What are the registered behaviors?
What has been invoked?
--->
<cfscript>


function debug(mock,verbose){
 var mockBug = {};
 var registry = mock._$getRegistry();
 structInsert(mockBug," MockName", getMetaData(mock).name );
 structInsert(mockBug, 'Registered Methods', registry.getRegistry());
 structInsert(mockBug, 'Invocation Records', registry.invocationRecord);
 structInsert(mockBug, 'Returns and Throws Data' , registry.registryDataMap);
 structInsert(mockBug, 'Method Arguments' , registry.argMap);
 return mockBug;
}

</cfscript>
</cfcomponent>