<cfcomponent output="false" extends="BaseTest">
<cfscript>

function testThatEmptyVerifyWorksTheSameAsTimesOne(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.verify().foo(1);
}


function testThatEmptyVerifyWorksMultipleTimes(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.verify().foo(1); //just verifies that foo(1) was called
}


function testThatMultipleInteractionsAndChainedVerifications(){
  mock.foo(1).returns('bar');
  mock.bar('bar').returns('foo');
  mock.foo('{struct}').returns('no');

  mock.foo(1);
  mock.foo(1);
  mock.bar('bar');
  mock.foo(1);
  mock.foo(1);
  mock.bar('bar');
  mock.foo(1);

  debug(mock._$debugInvoke());

 mock.verify('times',5).foo(1).
      verify('times',2).bar('bar')  .
      verify('never').foo('{struct}');

}


function testThatMultipleChainedVerifications(){
  mock.foo(1).returns('bar');

  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  debug(mock._$debugInvoke());

 mock.verify('times',5).foo(1)   .
      verify('atLeast',1).foo(1) .
      verify('atMost',5).foo(1)  .
      verify('count',5).foo(1);

}


function verifyExceptionThrown(){
  debug('is this redundant?');
  mock.foo(1).throws('YouSuckAtUnitTestingException');
  try{
    mock.foo(1);
    fail('should not get here');
   }
   catch(YouSuckAtUnitTestingException e){
   }
   mock.verify('once').foo(1);
}

function verifyCounts(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.verify('times',1).foo(1);
  mock.verify('atLeast',1).foo(1);
  mock.verify('atMost',1).foo(1);
  mock.verify('once').foo(1);
  //mock.verify('never',0).foo(1);
}

function verifyNever(){
  mock.verify('never').foo(1);

}

function verify25MockIterations(){
  var i = 1;
  mock.foo(1).returns('bar');
  for(i; i < 26; i++){
   mock.foo(1);
  }
  mock.verify('count',25).foo(1);
 }


function howToHandlePatternVerification(){
  mock.foo('{string}').returns('asd');
  mock.foo('asd');
  mock.verify('times',1).foo('{string}');
  //mock.verify('times',1).foo('asd');

  fail('If verifying a pattern, should it include all matches?' &
       'Maybe add a column for pattern id if invoked via a pattern match.');
}



  function setUp(){
    mock = createObject('component','expando.MightyMock').init('verify.me');
  }

  function tearDown(){
    mock.reset();
  }


</cfscript>
</cfcomponent>