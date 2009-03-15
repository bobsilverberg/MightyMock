<cfcomponent extends="BaseTest">
<cfscript>
function testThatMockIsDesiredType(){
  m1 = $(dummy, true);
  assertIsTypeOf( m1, dummy );
  m2 = $(dummy);
  m3 = $('asd');
  debug(m2);
  debug(m3);
  assertIsTypeOf( m2, 'mightymock.test.fixture.Dummy' );
 try{
   foo(m2);
   fail('should fail');
  }
  catch(any e){

  }

}
</cfscript>


<cffunction name="foo" access="private">
 <cfargument name="asd" type="mightymock.test.fixture.Dummy">

</cffunction>

</cfcomponent>