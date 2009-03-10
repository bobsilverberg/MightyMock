<cfcomponent output="true">
<cfscript>
 this.mocks = [];

  function init(){
		for(item in arguments){
	    this.mocks[item] =   arguments[item];
	   }
    return this;
  }

  function merge(){
    var i = 1;
    var s = '';
    for(i; i <= this.mocks.size(); i++){
      'variables.q_#i#' = this.mocks[i]._$getRegistry().invocationRecord;
       s &= 'select * from variables.q_#i# ' & chr(10);
      if(i != this.mocks.size()) s &= ' union ' & chr(10);
    }
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