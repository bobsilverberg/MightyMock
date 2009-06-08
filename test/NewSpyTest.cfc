<cfcomponent output="false" extends="BaseTest">
<cfscript>

  function $houldSpyBeTypeSafe() {
   assertIsTypeOf(spy,'mightymock.test.fixture.MySpyObject');
  }

  function testCreateSpy() {

     spy.foo().returns();
     spy.foo();
     spy.verify().foo();
     debug(spy.debugMock());
  }


 function unmockedMethodShouldExecute() {
   //guard
   spy.mockMe(); //should dump
   //spy.mockMe().returns('I have been mocked');
   //spy.mockMe();
   //assertEquals( 'I have been mocked' , spy.mockMe() );
   //actual
   // debug(spy);
   // assertEquals( 'Leave me alone' , spy.leaveMeAlone() );

  }


  function mockedMethodShouldExecute() {
    testCreateSpy();
  }

  function setUp(){
   spy = $$('mightymock.test.fixture.MySpyObject');
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>