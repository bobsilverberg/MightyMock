<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>

/*
 Demonstrates how to use MightyMock to stub out data provided by a
 collaborator.

*/
  function stubUserTest(){
    //The component under test needs data provided by the collaborator
    var comp = createObject('component','TheComponent');

    //1. Create the mock
    var mock = createObject('component','mightymock.MightyMock').
                            init('mightymock.examples.TheCollaborator');
     //2. Define behavior
     mock.getUser(1).returns(stubData());

     //3. Inject mock into component under test
     comp.setCollaborator(mock);

     //4. Exercise the component under test
     actual = comp.getUserAsStruct(1);

     //Do some tests to verify our component under test does what it should
     assertEquals(1,actual.id);
     assertEquals('mocked_bill',actual.name);
     assertEquals('mocked_bill@bill.com', actual.email);

  }


</cfscript>


<!---
  Goal is to use this data instead of the data provided by TheCollaborator.
 --->
<cffunction name="stubData" access="private">
    <cf_querysim>
   data
   id,name,email
   1|mocked_bill|mocked_bill@bill.com
  </cf_querysim>
  <cfreturn data />
</cffunction>

</cfcomponent>