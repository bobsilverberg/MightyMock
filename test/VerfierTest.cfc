<cfcomponent output="false" extends="BaseTest">
<cfscript>

function peepVerifyOnceFailure(){
  verifier.verify( 'once', 1, 'foo', args, mr );
}

function peepVerifyAtLeastFailure(){
  verifier.verify( 'atleast', 1, 'foo', args, mr );
}

function peepInvalidRule(){
  verifier.verify( 'asdasd', 1, 'foo', args, mr );
}

  function testVerifyOnce() {
    mr.addInvocationRecord('foo',args,'ok');
    r = verifier.verify( 'once', 1, 'foo', args, mr );
    debug(r);
    assert(r);
  }

function testVerifyTimes(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verify( 'times', 4, 'foo', args, mr );
  debug(r);
  assert(r);

 }


function testVerifyPeriodically(){
 var i = 1;
  for(i; i < 20; i++){
   mr.addInvocationRecord('foo',args,'ok');
   r = verifier.verify( 'times', i, 'foo', args, mr );
   assert(r);
  }

 }

 function testVerifyCount(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verify( 'count', 4, 'foo', args, mr );
  debug(r);
  assert(r);

 }


 function testVerifyAtLeast(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verify( 'atLeast', 4, 'foo', args, mr );
  assert(r);
  debug(r);
  r = verifier.verify( 'atLeast', 1, 'foo', args, mr );
  assert(r);

  try{
   r = verifier.verify( 'atLeast', 5, 'foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}
 }


 function testVerifyAtMost(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verify( 'atMost', 12, 'foo', args, mr );
  assert(r);

  try{
   r = verifier.verify( 'atMost', 5, 'foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}

 }


function testVerifyNever(){
  r = verifier.verify( 'never', 0, 'foo', args, mr );
  assert(r);
  debug(r);

  mr.addInvocationRecord('foo',args,'ok');
  try{
   r = verifier.verify( 'never', 0, 'foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}

 }


  function setUp(){
    verifier = createObject('component','expando.Verfier');
    mr = createObject('component','expando.MockRegistry');
  }

  function tearDown(){

  }


</cfscript>


</cfcomponent>