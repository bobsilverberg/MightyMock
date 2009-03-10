<cfcomponent output="true">
<cfscript>
 this.mocks = [];
 invocations = chr(0);

  function init(){
		for(item in arguments){
	    this.mocks[item] =   arguments[item];
	   }
	  invocations = merge();
    return this;
  }

  function getInvocations(){
   return invocations;
  }

  function merge(){
    var i = 1;
    var s = '';
    for(i; i <= this.mocks.size(); i++){
      'variables.q_#i#' = this.mocks[i]._$getRegistry().invocationRecord;
       s &= 'select * from variables.q_#i# ' & chr(10);
      if(i != this.mocks.size()) s &= ' union ' & chr(10);
    }
    s &= 'order by [time] asc' & chr(0);
    return _$query(s);
  }

</cfscript>

<cffunction name="_$query" access="private">
  <cfargument name="qs" type="string" />
  <cfquery name="q" dbtype="query">
     #qs#
  </cfquery>
  <cfreturn q>
</cffunction>
</cfcomponent>