<cfcomponent extends="BaseTest">
<cfscript>
function testThatMockIsDesiredType(){
   m1 = $(dummy, true);
   m2 = $(mockery, true);
   m1.foo().returns('bar');
   m2.bar().returns('foo');

   //debug(m1);
   //debug(m2);
   debug( m1.debugMock() );
   debug( m2.debugMock() );

  assertIsTypeOf(m1, 'mightymock.test.fixture.Dummy');
  assertIsTypeOf(m2, 'mightymock.test.fixture.Mockery');
  assertIsTypeOf(mock, 'mightymock.test.fixture.Dummy');

}

function testThatInitIsCallingCreateTypeSafeMocks(){


}

function testCreateMultiplTypeSafeMocks(){
  mymock =  createObject('component','mightymock.MightyMock').createMultipleTypeSafeMocks(dummy);
  mymock2 =  createObject('component','mightymock.MightyMock').createMultipleTypeSafeMocks(mockery);
  assertIsTypeOf(mymock, 'mightymock.test.fixture.Dummy');
  assertIsTypeOf(mymock2, 'mightymock.test.fixture.Mockery');
  assertIsTypeOf(mock, 'mightymock.test.fixture.Dummy');

}

</cfscript>


<cffunction name="foo" access="private">
 <cfargument name="asd" type="mightymock.test.fixture.Dummy">

</cffunction>

</cfcomponent>