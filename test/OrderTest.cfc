<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function testMergeMocks() {
     /*
     for(i=1;i<=order.mocks.size();i++){
       m = order.mocks[i];
       debug( m.debugMock() );
     }
     */

    q = order.getExpectations();
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
   /*
      mock1.foo();
      mock2.bar();
      mock3.bah();
      mock1.foo(1);
   */
   
    //define order:
    order.foo().
          bar().
     	  verify();

    q = order.getExpectations();
    orderedList  = valueList( q.method );
    
    errorMessage = 'Expected methods to be called in this order: #orderedList#. ';
    errorDetails = '';
      
    debug('this will go into order.verify()');
    debug(q);
    list = order.getOrderedList();
    
    for(i=1; i <= list.size(); i++){
      current = list[i];    
      //what if it's not there? fail(...)
      thisTime = order.getInvocationTime(current);
      
      if(i < list.size()){
       next = list[i+1];
       nextTime = order.getInvocationTime(next);
      }      
      else {
        nextTime = -1;
      }
      debug('thisTime: ' & current & ' : ' & thisTime);
      debug('nextTime: ' & next & ' : ' & nextTime);
     // if(nextTime == -1) ; we're done
      
      if(nextTime < thisTime){
      	//collect first, then check ...
       // __throw(' #current# was called out of order.', 'Expected:#orderedList#. current=#current#, next=#next#');
        errorDetails &= 'Caught : #current# was called before #next# ';
      }
    }
  
    if(len(errorDetails)) __throw(errorMessage, errorDetails);

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


<cffunction name="__throw">
 <cfargument name="message" />
 <cfargument name="detail" />
 <cfthrow type="mxunit.exception.AssertionFailedError" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>
</cfcomponent>