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


  function testGetInvocationTime(){
   var t = order.getInvocationTime('foo_3938');
    order.foo().
     			bar().
     			bah();
   debug( order.getOrderedList() );
   debug(t);
   assert( isnumeric(t) );
  }


  function testOrder(){

    order.foo().
     			bar().
     			bah().
     			verify();

    debug('this will go into order.verify()');

    list = order.getOrderedList();
    for(i=1; i <= list.size(); i++){
      debug( list[i] );
      next = list[i+1];
      thisTime = order.getInvocationTime(list[i]);
      nextTime = order.getInvocationTime(list[i+1]);
      debug(thisTime);
      debug(nextTime);
    }



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