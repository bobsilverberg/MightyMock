<cfcomponent output="false" extends="BaseTest">
<cfscript>

function mockedSpyMethodShouldVerify() {
 spy.mock().foo();
 spy.foo();
 spy.foo();
 spy.foo();
 spy.verifyTimes(3).foo();

}

function unMockedSpyMethodShouldVerify() {
 spy.leaveMeAlone();
 spy.leaveMeAlone();
 spy.leaveMeAlone();
 spy.verifyTimes(3).leaveMeAlone();
}

function mockify() {
 spy.mock().mockMe().returns('I was mockified. My goodness.');
 retVal = spy.mockMe();
 debug(retVal);
 assertEquals( 'I was mocker. My goodness.' , retVal );
 spy.mockMe();
 spy.verifyTimes(2).mockMe();
}



  function shouldSpyBeTypeSafe() {
   assertIsTypeOf(spy,'mightymock.test.fixture.MySpyObject');
  }

  function testCreateSpy() {
     spy.mock().foo().returns();
     spy.foo();
     spy.verify().foo();
     debug(spy.debugMock());
  }


 function $mockedAndunmockedMethodShouldExecuteAndBeRecorded() {
    spy.mock('possible options here').foo().returns('bar');
    spy.leaveMeAlone();
    retVal = spy.leaveMeAlone();
    debug(retVal);
    assertEquals( 'Leave me alone.' , retVal );
    assertEquals( 'bar' , spy.foo() );
    debug(spy.debugMock());
  }



  function setUp(){
   spy = $$('mightymock.test.fixture.MySpyObject');
  }

  function tearDown(){
    spy.reset();
  }


</cfscript>
</cfcomponent>