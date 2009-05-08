<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>

/*
 Demonstrates how to use MightyMock to stub out data provided by a
 collaborator.

*/
  function mockVerificationTest(){
    //The component under test needs data provided by the collaborator
    var comp = createObject('component','TheComponent');

    //1. Create the mock
    var mock = createObject('component','mightymock.MightyMock').
                            init('mightymock.examples.TheCollaborator');
     //2. Define behavior ... return void
     mock.logStuff().returns();

     //3. Inject mock into component under test
     comp.setCollaborator(mock);

     //4. Exercise the component under test
     actual = comp.callLoggerALot();

     //5. Verify that the mock was called
     mock.verifyTimes(25).logStuff();


  }

  function peepWhatAVerificationFailureLooksLike(){
    //The component under test needs data provided by the collaborator
    var comp = createObject('component','TheComponent');

    //1. Create the mock
    var mock = createObject('component','mightymock.MightyMock').
                            init('mightymock.examples.TheCollaborator');
     //2. Define behavior ... return void
     mock.logStuff().returns();

     //3. Inject mock into component under test
     comp.setCollaborator(mock);

     //4. Exercise the component under test
     actual = comp.callLoggerALot();

     //5. Verify that the mock was called
     //Should be 25 and will fail intentionally
     mock.verifyTimes(20).logStuff();


  }


</cfscript>
</cfcomponent>