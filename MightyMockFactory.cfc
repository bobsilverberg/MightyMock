<cfcomponent>
 <cfscript>
  mocks = [];


  function init(){
    return this;
  }

 

  function create(){
    var type = '';
    var mock = chr(0);
    if(arguments.size()) type = arguments[1];
	mock = createObject('component','MightyMock').init(type);
    //arrayAppend(mocks,mock); mocks undefined? too early!
    return mock;
  }

  function listMocks(){
   return arrayToList(mocks);
  }
 </cfscript>

</cfcomponent>