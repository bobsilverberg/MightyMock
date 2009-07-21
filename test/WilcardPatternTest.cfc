<cfcomponent output="false" extends="BaseTest">
<cfscript>



	function findByPatternTest() {
     mock.foo('{+}').returns(123);

     reg = mock._$getRegistry();
     assert( reg.isWildCardPattern('{+}') );

     p = reg.findByPattern('foo','{+}');

     actual = mock.foo('asd');
     debug( mock.debugMock() );
  }


 function makeSureWildcardRegistersOK(){
    mock.foo('{+}').returns(123);
   debug( mock.debugMock() );
   //actual = mock.foo('asd');


    reg = mock._$getRegistry();
		debug(reg);
   // assert(actual);
   // mock.verify().foo('asd');
   args = {1='{+}'};
   behavior = reg.GETREGISTEREDBEHAVIOR('foo',args);
   debug(behavior);
   data = reg.getReturnsData('foo',args);
   debug(data);

  }



  function setUp(){
    mock.reset();

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>