<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function testMergeMocks() {
     /*
     for(i=1;i<=order.mocks.size();i++){
       m = order.mocks[i];
       debug( m.debugMock() );
     }
     */

    q = order.getInvocations();
    debug(q);

    assert (isQuery(q));
    assert( 4 == q.recordCount );
  }


  function testOrder(){

    order.foo().
     			bar().
     			bah().
     			verify();

  }


  function setUp(){
    mock1 = createObject('component','mightymock.MightyMock').init('mock1');
    mock2 = createObject('component','mightymock.MightyMock').init('mock2');
    mock3 = createObject('component','mightymock.MightyMock').init('mock3');

    mock1.foo().returns();
    mock1.foo(1).returns();
    mock2.bar().returns();
    mock3.bah().returns();

    mock1.foo();
    mock2.bar();
    mock3.bah();
    mock1.foo(1);

    order = createObject('component','mightymock.Order').init(mock1,mock2,mock3);
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>