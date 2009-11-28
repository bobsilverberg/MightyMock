<cfcomponent output="false" extends="BaseTest">

<cffunction name="createPartialShouldThrow" mxunit:expectedException="MightyMock.MockFactory.partialMocksNotImplemented">
	<cfset 	mock = mf.createMock("mxunit.framework.TestCase","partial") />
</cffunction>


<cfscript>

/* Bill's tests for MightyMockFactory.cfc
	Now using this test component to test MockFactory.cfc used for MXUnit integration
	
function testMockCreation(){
   mock1 = $('foo');
   assertIsTypeOf(mock1,'foo');
   mock1.reset();
   mock2 = $();
   debug(mock2);
   assertIsTypeOf(mock2,'WEB-INF.cftags.component');
}
*/

function createNoNameNoTypeShouldCreateNamelessFastMock() {
	mock = mf.createMock();
	assertIsTypeOf(mock,"MightyMock.MightyMock");
	assertEquals("",mock.getMocked().name);
}


function createNameedNoTypeShouldCreateNamedFastMock() {
	mock = mf.createMock("foo");
	assertIsTypeOf(mock,"MightyMock.MightyMock");
	assertEquals("foo",mock.getMocked().name);
}

function createTypeSafeShouldCreateTypeSafeMock() {
	mock = mf.createMock("mxunit.framework.TestCase","typeSafe");
	assertIsTypeOf(mock,"mxunit.framework.TestCase");
	assertEquals("mxunit.framework.TestCase",mock.getMocked().name);
}

function createWithActualObjectShouldCreateTypeSafeMock() {
	testCase = createObject("component","mxunit.framework.TestCase");
	mock = mf.createMock(testCase);
	assertIsTypeOf(mock,"mxunit.framework.TestCase");
	assertEquals("mxunit.framework.TestCase",mock.getMocked().name);
}

  function setUp(){
  
  mf = createObject("component","MightyMock.MockFactory");
   
  }

  function tearDown(){

  }



</cfscript>
</cfcomponent>