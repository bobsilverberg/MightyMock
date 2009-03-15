<cfcomponent output="false" extends="BaseTest">
<cfscript>

function $mockShouldBeAbleToReturnOtherMock(){
   mock2 = createObject('component','mightymock.MightyMock').init(mockery);
   //debug(mock2);
   mock.foo('asd').returns(mock2);
   t = mock.foo('asd');
   assertIsTypeOf(t, mockery);
}

function methodShouldBeAbleToReturnObject(){
   mock.reset();
   mock.foo('asd').returns(this);
   t = mock.foo('asd');
   assertIsTypeOf(t,'WEB-INF.cftags.component');
}

function clearOrResetMock(){
  mock.foo('asd').returns('asd');
  mock.foo('asd');
  debug(mock.debugMock());
  mock.reset();
  reg = mock._$getRegistry();
  debug(reg.invocationRecord);
  assert( reg.invocationRecord.recordCount == 0, 'invocation records still there' );
  assert( reg.registry.recordCount == 0, 'registry items still there' );

}


function simpleVerifyTest(){
 mock.foo('asd').returns('asd');

 mock.foo('asd');
 mock.verifyTimes(1).foo('asd');


 mock.foo2('asd').returns('123');
 mock.foo2('asd');
 mock.verify().foo2('asd');


 mock.verifyAtLeast(1).foo('asd');


  mock.foo2('asd');
  mock.foo2('asd');
  debug( mock.debugMock() );
  mock.verifyAtMost(3).foo2('asd');

  mock.verifyNever().xxx('asd');

  mock.bling(a).returns(true);
  mock.bling(a);
  mock.verifyOnce().bling(a);


}



function whatHappensIf(){
 mock.foo('asd');
 debug( mock._$debugReg() );
 try{
  f = mock.foo('asd');
  fail('should not get here');
 }
 catch(UndefinedBehaviorException e){}

}

 function testRegisterNewMock(){
  mock.foo('bar').returns('foo');
  debug( mock.$debugReg());

 }

 function testThrows(){
   mock.foo('bar').throws( 'foobar' );
   try{
     mock.foo('bar');
     fail('should not get here.');
   }
   catch(foobar e){}


 }

 function testInvokeMock(){
  mock.foo('bar').returns( 'foobar' );
  actual = mock.foo('bar');
  debug( actual );
  assertEquals('foobar', actual);

 }

  function testStubalicous(){
  mock.foo('bar').returns( getQ() );
  actual = mock.foo('bar');
  debug( actual );
  assert(1,actual.recordCount);

 }


  function setUp(){
   //mock = createObject('component','mightymock.MightyMock').init('my.mock');
  }

  function tearDown(){
    mock.reset();
  }



</cfscript>


<cffunction name="getQ" access="private">
  <cf_querysim>
   logger
   foo,bar
	 1|2

	</cf_querysim>
	<cfreturn logger/>
</cffunction>

</cfcomponent>
