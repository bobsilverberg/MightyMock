<cfcomponent output="false" extends="BaseTest">
<cfscript>

 function semanticPatternsNeedToCoexist() {
  mock.reset();
  mock.foo(bar='foo').returns(true);
  mock.foo('foo').returns(true);
  assert( mock.foo('foo') );
  assert( mock.foo(bar='foo') );

 }

 function peepWildCardPatternExec(){
    mock.foo('{+}').returns(true);
    actual = mock.foo('asd');

    debug( mock.debugMock() );
   // assert(actual);
    mock.verify().foo('asd');
  }


  function peepPatternExec(){
    mock.foo('{string}').returns(true);
    actual = mock.foo('asd');
    mock.foo('asd');
    debug( mock.debugMock() );
    assert(actual);
    mock.verify(2).foo('{string}');
  }





  function setUp(){
    mock.reset();
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>