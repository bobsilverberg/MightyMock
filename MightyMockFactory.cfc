<cfcomponent>
 <cfscript>
  function init(){
    return this;
  }

  function create(type){
   return createObject('component','MightyMock').init(type);
  }

 </cfscript>

</cfcomponent>