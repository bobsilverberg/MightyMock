<cfcomponent extends="BaseTest">
<cfscript>
function testThatMockIsDesiredType(){
   m1 = $(dummy, true);
   m2 = $(mockery, true);
   debug( getMetaData(m1).name );
   debug( getMetaData(m2).name );

   debug( m2.debugMock() );
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