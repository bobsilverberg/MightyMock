<cfcomponent>
 <cfscript>
  mocks = [];


  function init(){
    return this;
  }



  function create(){
    if(arguments.size() eq 0 )  return createObject('component','MightyMock').init();
    if(arguments.size() eq 1 )  return createObject('component','MightyMock').init(arguments[1]);
    if(arguments.size() eq 2 )  return createObject('component','MightyMock').init(arguments[1],true);
  }

  function listMocks(){
   return arrayToList(mocks);
  }
 </cfscript>

</cfcomponent>