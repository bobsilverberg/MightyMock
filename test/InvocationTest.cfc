<cfcomponent output="false" extends="BaseTest">

<!--- Argument Normalization is on the todo list --->
 <cffunction name="mismatchedArgumentTypesShouldPass">
 <cfscript>
  mock.reset();
  mock.foo(bar='{string}').returns('bar');
  assert(mock.foo('asdasdasdasd') == 'bar') ;
  </cfscript>
</cffunction>

<cfscript>

function wildcardRodeo() {
  mock.foo('{*}').returns('asd');

  assertEquals( mock.foo() , 'asd' );

  assertEquals( mock.foo(123) , 'asd' );
  assertEquals( mock.foo() ,'asd' );
  assertEquals( mock.foo(a),'asd' );

  mock.reset();

  mock.foo('{+}').returns('asd');
  assertEquals( mock.foo('asdasd') , 'asd' );
  assertEquals( mock.foo(123) , 'asd' );
  assertEquals( mock.foo(s) ,'asd' );
  assertEquals( mock.foo(a),'asd' );

}

function testNamedArgsException() {

  mock.foo(bar=1).returns('asd');
  assert( mock.foo(bar=1) == 'asd' );

  mock.foo(bar='{string}').returns('bar');
  assert( mock.foo(bar='asdasdasdasd') == 'bar' );
  mock.reset();

  mock.foo('{string}').returns('bar');
  assert( mock.foo('asdasdasdasd') == 'bar' );

}

 function canUnregisteredMockReturnNull(){
   mock.reset();
   r1 = mock.foo();
   r2 = mock.foo();
   debug(r1);
   debug(r2);

 }

function $shouldThrowRegisteredException(){
  mock.foo(1).throws('YouSuckAtUnitTestingException');
  debug( mock.debugMock() );
  try{
   res = mock.foo(1);
    debug(res);
    fail('should not get here');
   }
   catch(YouSuckAtUnitTestingException e){
    debug(e);
   }
}



function attemptingToRegisterTheSamePatternShouldThrowMeaningfulException(){
  try{
   mock.foo(1).returns(1);
   //mock.reset(); resetting the mock clears it
   mock.foo(1).returns(2);
   debug( mock.debugMock() );
  }
  catch(coldfusion.runtime.java.MethodSelectionException e){
  fail('
    After a method is registered with a returns and executes, attempting
    to perform another returns throws MethodSelectionException. should
    be a workaround. At a minimum, it should be well documented.
  ');
  }
}


function orderingOfPatternDeclarationShouldNotMatter(){
   mock.foo('{array}').returns('array');
   mock.foo('{string}').returns('string');
   mock.foo('{numeric}').returns('number');

   actual = mock.foo(a);
   assert( actual.equals('array') );

   actual = mock.foo('asd');
   assert( actual.equals('string') );

   actual = mock.foo(1);
   assert( actual.equals('number') );

}

function invokeArrayPattern(){
  var a2 = [1,2,3,4,5,6,7,8,9];
  mock.foo('{array}').returns('array');
  actual = mock.foo(a);
  debug(actual);
  assert( actual.equals('array') );

  actual = mock.foo(a2);
  debug(actual);
  assert( actual.equals('array') );

}


function shouldBeAbleToExecuteMultipleUniquePatterns(){
  mock.foo('{numeric}','{numeric}').returns('yumnum');
  actual = mock.foo(1,1);
  debug(actual);
  assert( actual.equals('yumnum') );

  actual = mock.foo(1231,6786);
  debug(actual);
  assert( actual.equals('yumnum') );

  mock.foo('{string}').returns('string');
  actual = mock.foo('asd');
  debug(actual);
  assert( actual.equals('string') );

}


function invoke2Numerics(){
  mock.foo('{numeric}','{numeric}').returns('yumnum');
  actual = mock.foo(1,1);
  debug(actual);
  assert( actual.equals('yumnum') );
}

function invokeNumericOnPattern(){
  mock.foo('{numeric}').returns('yumnum');
  actual = mock.foo(1);
  debug(actual);
  assert( actual.equals('yumnum') );
}


function  doMock(){
  mock.foo('asd').returns(a);
  actual = mock.foo('asd');
  debug(actual);
  assertEquals(4,actual.size());
}


function  doMockMoo(){
  mock.foo('{string}').returns('yup .. uh huh ... a string.');
  actual = mock.foo('asd');
  debug(actual);

  actual = mock.foo('ghjghj');
  debug(actual);

   mock.foo(1);
  mock.returns();
  actual = mock.foo(1);
  debug(actual);

  actual =  mock.foo( ' ' );
  debug(actual);

  actual =  mock.foo( ' mmn kkj asd 9 ioaso asoiujasd ' & 1 );
  debug(actual);

  actual =  mock.foo( -1 );
  debug(actual);

}

function invokeNonregisteredMethodWithMatchingPatternShouldReturn (){
  var pArgs = {1='{string}'};
  var pArgs2 = {1='barbar',2=-912389.0123,3=a};
  mr.register('foo',args);
  mr.register('foo',pArgs);
  mr.register('foo',pArgs2);
  itemArgs = mr.getArgumentMapEntry( 'foo', pArgs2 );
  debug(itemArgs);
  assert( 3==itemArgs.size() );

  targs = {1='asdasdasd'};
  t = mr.findByPattern('foo', targs);

}


function tryCatchFromMM(){

    target = 'foo';
    patternArgs =   {1='{string}'};
    try{
       t = mr.findByPattern(target,args);
       //return _$invokeMock(t.target,t.args);
      }
    catch(MismatchedArgumentPatternException e){}
}

function tearDown(){
  mock = '';
  reg = '';
  mr = '';

}

function setUp(){
  mock = createObject('component','mightymock.MightyMock').init();
  mock.reset();
  reg = mock._$getRegistry();
  mr = createObject('component','mightymock.MockRegistry');
}
</cfscript>


</cfcomponent>