<cfcomponent output="false" extends="BaseTest">
<cfscript>

function clearOrResetMock(){
 mock.foo('asd').returns('asd');
 debug(mock._$debugReg() );
 mock.reset();
 debug(mock._$debugReg() );
}


function simpleVerifyTest(){
 mock.foo('asd').returns('asd');
 mock.foo('asd');
 mock.verify().foo('asd');
 mock.verify().foo('asd'); //synonym


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
   mock = createObject('component','mightymock.MightyMock').init('my.mock');
  }

  function tearDown(){

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
