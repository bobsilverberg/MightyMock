<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function testOrder() {
     for(i=1;i<=order.mocks.size();i++){
       m = order.mocks[i];
       debug( m.debugMock() );
     }


    q = order.merge();
    debug(q);

  /*
     order.foo().
     			  bar().
     			  bah().
     			  verify();
  */


  }



  function setUp(){
    mock1 = createObject('component','mightymock.MightyMock').init('mock1');
    mock2 = createObject('component','mightymock.MightyMock').init('mock2');
    mock3 = createObject('component','mightymock.MightyMock').init('mock3');

    mock1.foo().returns();
    mock2.bar().returns();
    mock3.bah().returns();

    mock1.foo();
    mock2.bar();
    mock3.bah();

    order = createObject('component','mightymock.Order').init(mock1,mock2,mock3);
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>