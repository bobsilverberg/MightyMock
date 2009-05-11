<cfcomponent output="false" extends="BaseTest">
<cfscript>

  function testMockSpy(){
    spy = createObject('component','mightymock.MightyMock').init('mightymock.test.fixture.MySpyObject',true);

    spy.mockSpy().mockMe().returns('I have been mocked');
    mocked = spy.mockMe();
    debug(mocked);
    assertEquals('I have been mocked', mocked);

    debug(spy._$debugReg());
    debug(spy._$debugInvoke());



    unMocked = spy.leaveMeAlone(1); //execute unmocked method
    debug(unMocked);
    assertEquals('Leave me alone', unMocked);



    pSpy = spy.parentSpy(); //execute unmocked method on parent
    pSpy = spy.parentSpy();
    pSpy = spy.parentSpy();
    debug(pSpy);
    assertEquals('This is a parent method', pSpy);



    spy.verify('once').mockMe();
    spy.verify('once').leaveMeAlone();
    spy.verify('times',3).parentSpy();
  }



  function peepBadMethodException(){
    try{
     this.snook();
    }
    catch(coldfusion.runtime.TemplateProxy$InvalidMethodNameException e){
     debug(e);
    }
  }

  function dynamicExecution(){
    realspy = createObject('component','mightymock.test.fixture.MySpyObject');
    debug(realspy.mockMe());
    oName = 'realSpy';
    method = 'mockMe';

    e = evaluate( '#oName#.#method#(argumentCollection=args)'  );
    debug(e);
    e = evaluate( 'realspy.mockMe()'  );
    debug(e);
  }


   function testCreateLegalSpy(){
    spy = createObject('component','mightymock.MightyMock').init('mightymock.test.fixture.MySpyObject',true);
    debug(spy._$getSpy());
  }



  function testCreateBadSpy(){
   try{
     spy = createObject('component','mightymock.MightyMock').init('bogus.spy',true);
     fail('should not get here');
    }
    catch(InvalidSpyException e){
      debug(e);
    }
  }



  function setUp(){
   fail(' Still need to implement spy... ');
    mock.reset();
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>