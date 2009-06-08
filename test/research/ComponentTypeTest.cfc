<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>

 function cloneScope(){
    cfc = createObject('component','mightymock.test.fixture.MyComponent');
    cfc.sniff = sniff;
    vars = cfc.sniff();
    //peeping
    cfcscope = createObject('java', vars.getClass().getName());
    dump(cfcscope);
    //delete
    //structClear(vars);
    // structClear(cfc);
    //tempVar = createObject('java', 'coldfusion.runtime.Variable');

    //sdebug(tempVar);

    //copy to cfcscope
	for(item in variables){
      //tempVar = createObject('java', 'coldfusion.runtime.Variable').init(item);
      //tempVar.set(item);
      //tempVar.setValue(variables[item]);
      //debug(item);
      //vars[item] = variables[item];
	  tempVar = vars.bind(item);
       tempVar.set( item );
/*
spyvar = vars.bind('mySpyVar');
    spyvar.set( 'spyvar value' );

*/
       //vars.putVariable(tempVar);
     }

    debug(cfc);
    debug( cfc.iNVOkeHelper() );
   }



 function bindInternaltest(){
    scope = createObject('java', variables.getClass().getName());
    dump(scope);
    newvar = scope.bindInternal('asd');
    newVar.set(123);
    dump(newvar.toString());


   }

  function peepScope(){
    scope = createObject('java', variables.getClass().getName());
    dump(scope);
    newvar = scope.bind('asd');
    dump(newvar.toString());

    cfc = createObject('component','mightymock.test.fixture.MyComponent');
    cfc.sniff = sniff;
    vars = cfc.sniff();
    spyvar = vars.bind('MYSPYVAR'); //set in the variables scope of cfc
    spyvar.set( 'spyvar value' );
    debug(spyvar.toString());
    debug(spyvar.getClass().getName());

    for(item in vars){
    //if(item != 'this'){
     debug(item);
     //debug(  vars[item]  );
    }
    debug(cfc);

    d = cfc.getInjectedSpyVar();
    debug(d);
    //MYSPYVAR does not exist in cfc
    assertEquals('spyvar value',d);
   }

 function peepObjectHandler() {
   ObjectHandler = createObject("java","coldfusion.runtime.java.ObjectHandler");
   dump(ObjectHandler);
 }



//intentional runtime error
function returnNonExistentVar() {
 // var blank = -1;
  return blank;

}

function threadLocalTest() {
 t = createObject('java', 'java.lang.ThreadLocal');
 t.set(returnNonExistentVar);
 foo =t.get();
 foo();
 debug(t);
}
//try to add var blank to the above

 function addToFunctionTest() {

   dump( createObject('java','coldfusion.runtime.UDFMethod') );

   returnNonExistentVarScope = returnNonExistentVar.getSuperScope();
   dump( returnNonExistentVarScope );
   foo = [1,2,3];
   //xcfvar = returnNonExistentVarScope.bindInternal('blank', foo);
  // cfvar.set(returnNonExistentVarScope);
   //dump(cfvar); return;
   cfvar = returnNonExistentVarScope.bind('blank', foo);
   //returnNonExistentVarScope.remove(cfvar);
   myVar = createObject('java','coldfusion.runtime.Variable').init('blank');
   myVar.set(foo);
   //dump(myVar); setters/getters
   returnNonExistentVarScope.putVariable(myVar);
   returnNonExistentVarScope.setScopeType(0);

   assertEquals(foo, returnNonExistentVar() );
   debug(returnNonExistentVar());
   assertFalse( structKeyExists(variables,'blank') );
   debug(returnNonExistentVarScope.getScopeType());
  }

  function peepTemplateProxy(){
   Class = createObject( "java", "java.lang.Class");
   templateProxy = Class.forName("coldfusion.runtime.TemplateProxy");
   udf = createObject('java', 'coldfusion.runtime.UDFMethod');

   dump(udf);
   udf = Class.forName("coldfusion.runtime.UDFMethod");
   //superScopeMeth = udf.getDeclaredMethod('getSuperScope');
   args = [];
   //debug(superScopeMeth.invoke(udf,args));
   scope = createObject("java","coldfusion.runtime.LocalScope").init();
   debug(scope);
  }

  function peepVar(){
   av =   createObject('java','coldfusion.runtime.Variable').init('mynewvar');
   debug(av);
   av.set('foo');
   debug(av.toString());

  }


 function smokeTest(){
   mm = createObject('component','mightymock.MightyMockFactory');
   mock = createObject('component','mightymock.MightyMock');
   $ = mm.create;
   mycfc = $('mightymock.test.fixture.MyComponent');
   // debug( mycfc );
   debug( mycfc.simple() );
   debug( mycfc._$getState() );

    mycfc._$dump('dump missing method?');
    mycfc.foo().returns('i am here');
    a = mycfc.foo();
    debug(a);
    assertEquals('i am here',a  );

    mycfc.verify(1).foo();
 }



 function typeShouldBeWhatITellIt(){
   mm = createObject('component','mightymock.MightyMockFactory');
   mock = createObject('component','mightymock.MightyMock');
   $ = mm.create;
   foo = $('mightymock.test.fixture.Logger');
   r = foo.simple();
   debug(r);
   //assertEquals( r , 'nyuck nyuck' );

 }

function peepObject(){
  cfc = createObject('component','mightymock.test.fixture.MyComponent');
  cfc.sniff = sniff;
  vars = cfc.sniff();
  for(item in vars){
    //if(item != 'this'){
     debug(item);
     debug(  vars[item]  );
   // }

  }
 debug(' -------------------- THIS SCOPE -----------------------');
  for(item in cfc){
      debug(item);
      debug( getMetaData(cfc[item]) );
  }

}

function sniff(){
 return variables;
}



</cfscript>

<cffunction name="testType" access="private">
  <cfargument name="o" type="com.foo.bar">
</cffunction>



</cfcomponent>