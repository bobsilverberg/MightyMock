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
    spyvar = vars.bind('mySpyVar');
    spyvar.set( 'spyvar value' );
    debug(spyvar.toString());

     for(item in vars){
    //if(item != 'this'){
     debug(item);
     //debug(  vars[item]  );
    }
    debug(cfc);

    d = cfc.getInjectedSpyVar();
    debug(d);
   }

  function peepTemplateProxy(){
   Class = createObject( "java", "java.lang.Class");
   templateProxy = Class.forName("coldfusion.runtime.TemplateProxy");
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