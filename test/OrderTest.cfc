<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function $toDo(){
   order.one().two().three().verifyExact();
   order.one().three().verifyRange();
   fail('to do');
  }


  function testGetInvocationTime(){
   var t = order.getInvocationTime('one_3938');
    order.one().
     			two().
     			three();
   debug( order.getExpectations() );
   debug(t);
   assert( isnumeric(t) );
  }


function FailWhenExpectationsAreNotMet(){

     debug('This does what is expected, but not wrapped in try catch cause I''m too tired tonight ...');


     order.one().
           two().
           four().
           three().
     	     verify();

     expectations = order.getExpectations();
     invocations  = order.getInvocations();
     orderedList  = valueList( invocations.method );

     debug( expectations );
     debug( invocations );
     debug(orderedList);

     currentExpectation = '';
     currentExpectationTime = '';
     nextExpectation = '';
     nextExpectationTime = '';

     numberOfExpectations = expectations.size();

	     for(i=1; i <= numberOfExpectations; i++){
	        currentExpectation = expectations[i];
	        //debug(currentExpectation);
	        if(!order.exists(expectations[i])){
	          __throw( '#currentExpectation# not found in invocation list.','To Do: Print list of methods' );
	        }

	       if(i < numberOfExpectations) {
	          nextExpectation = expectations [i+1];
	          debug(nextExpectation);
	          if(!order.exists(nextExpectation)){
	            __throw( '#nextExpectation# not found in invocation list.','To Do: Print list of methods' );
	          }

           currentExpectationTime = order.getInvocationTime(currentExpectation);
	         nextExpectationTime = order.getInvocationTime(nextExpectation);

	         if(currentExpectationTime > nextExpectationTime ) {
	           __throw( 'Expectation Failure : #currentExpectation# invoked AFTER #nextExpectation#.','Actual invocation sequence was "#orderedList#", but expectations were defined as #arrayToList(expectations)#' );
	         }

	        }



	     }


  }



function passWhenExpectationsMet(){
     order.one().
           two().
           three().
     	     verify();

     expectations = order.getExpectations();
     invocations  = order.getInvocations();
     orderedList  = valueList( invocations.method );

     debug( expectations );
     debug( invocations );
     debug(orderedList);

     currentExpectation = '';
     currentExpectationTime = '';
     nextExpectation = '';
     nextExpectationTime = '';

     numberOfExpectations = expectations.size();

	     for(i=1; i <= numberOfExpectations; i++){
	        currentExpectation = expectations[i];
	        //debug(currentExpectation);
	        if(!order.exists(expectations[i])){
	          __throw( '#currentExpectation# not found in invocation list.','To Do: Print list of methods' );
	        }

	       if(i < numberOfExpectations) {
	          nextExpectation = expectations [i+1];
	          debug(nextExpectation);
	          if(!order.exists(nextExpectation)){
	            __throw( '#nextExpectation# not found in invocation list.','To Do: Print list of methods' );
	          }

           currentExpectationTime = order.getInvocationTime(currentExpectation);
	         nextExpectationTime = order.getInvocationTime(nextExpectation);

	         if(currentExpectationTime > nextExpectationTime ) {
	           __throw( 'Expectation Failure : #currentExpectation# invoked AFTER #nextExpectation#.','Actual invocation sequence was "#orderedList#", but expectations were defined as #arrayToList(expectations)#' );
	         }

	        }



	     }


  }




  function failWhenExpectationNotFound(){
     order.foo().
           meh().
     	     verify();

     debug( order.getExpectations() );
     expectations = order.getExpectations();
     try{
	     for(i=1; i <= expectations.size(); i++){
	        debug(expectations[i]);
	        if(!order.exists(expectations[i])){
	          __throw( '#expectations[i]# not found in invocation list.','To Do: Print list of methods' );
	        }

	     }
	    fail('should not get here.');
     }
     catch(mxunit.exception.AssertionFailedError e){}

  }




  function setUp(){
    mock1 = createObject('component','mightymock.MightyMock').init('mock1');
    mock2 = createObject('component','mightymock.MightyMock').init('mock2');
    mock3 = createObject('component','mightymock.MightyMock').init('mock3');
/*
    //define behavior
    mock1.foo().returns();
    mock1.foo(1).returns();
    mock2.bar().returns();
    mock3.bah().returns();

    //invoke
    mock1.foo();
    mock2.bar();
    mock3.bah();
    mock1.foo(1);
 */

    mock1.one().returns();
    mock1.two().returns();
    mock2.three().returns();
    mock3.four().returns();

    mock1.one();
    mock1.two();
    mock2.three();
    mock3.four();



    order = createObject('component','mightymock.Order').init(mock1,mock2,mock3);
  }

  function tearDown(){

  }


</cfscript>


<cffunction name="__throw" access="private">
 <cfargument name="message" />
 <cfargument name="detail" />
 <cfthrow type="mxunit.exception.AssertionFailedError" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>
</cfcomponent>