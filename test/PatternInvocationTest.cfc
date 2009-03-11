<cfcomponent output="false" extends="BaseTest">
<cfscript>
  
  
  function peepPatternExec(){
    mock.foo('{string}').returns(true);
    actual = mock.foo('asd');
    debug( mock.debugMock() );
    assert(actual);
    //mock.verify().foo('asd');
  }
  
   function peepWildCardPatternExec(){
    mock.foo('{string}').returns(true);
    actual = mock.foo('asdasd');
    debug( mock.debugMock() );
    //assert(actual);
  }
  

  
  function setUp(){
  
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>