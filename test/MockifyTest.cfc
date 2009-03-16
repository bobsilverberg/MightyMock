<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function testMockify() {
     mockifyThis = createObject('component','mightymock.test.fixture.Mockify');

     mocker = $();

     mocker.mockify(mockifyThis, mockifyThis.foo, 'bar' );//.returns('bar');

      udf = createObject('java','coldfusion.runtime.UDFMethod');
      debug(udf);

      debug(mockifyThis.foo.getClass().getSuperclass().getName());
      debug(mockifyThis.foo.getClass().getSimpleName());
      debug(mockifyThis.foo.getSuperScope());
      debug(mockifyThis.foo.getPagePath());

      debug( getMetaData(mockifyThis.foo) );

     //result = mockifyThis.foo();
    // assertEquals( 'bar', result );

  }



  function setUp(){

  }

  function tearDown(){

  }


</cfscript>



</cfcomponent>