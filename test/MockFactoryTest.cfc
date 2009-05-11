<cfcomponent output="false" extends="BaseTest">
<cfscript>

function testMockCreation(){
   mock1 = $('foo');
   assertIsTypeOf(mock1,'foo');
   mock1.reset();
   mock2 = $();
   debug(mock2);
   assertIsTypeOf(mock2,'WEB-INF.cftags.component');
}


  function setUp(){
   
  }

  function tearDown(){

  }



</cfscript>
</cfcomponent>