<cfcomponent output="false" extends="BaseTest">
<cfscript>

function $updateRegistryShouldAllowObjects(){
  obj = createObject('component','mightymock.test.fixture.MyComponent');
	debug(obj);

  mr.register('foo',args);
  mr.updateRegistry('foo',args,'returns', obj);

  debug(mr);
}


function register2Patterns(){
  var pArgs = {1='{string}'};
  var pArgs2 = {1='{struct}'};
  mr.register('foo',args);
  mr.register('foo',pArgs);
  mr.register('foo',pArgs2);
  debug(mr.argMap);
}


function argMapGetsPopulatedWithActualArgs(){
  var pArgs = {1='{string}'};
  var pArgs2 = {1='{struct}'};
  mr.register('foo',args);
  mr.register('foo',pArgs);
  mr.register('foo',pArgs2);
  debug(mr.argMap);
  debug('how best to persist arguments?');

  assert( 3==mr.argMap.size(), 'how did extra items get added to argMap?' );
}

function getArgMapEntry(){
  var pArgs = {1='{string}'};
  var pArgs2 = {1='barbar',2=-912389.0123,3=a};
  mr.register('foo',args);
  mr.register('foo',pArgs);
  mr.register('foo',pArgs2);
  itemArgs = mr.getArgumentMapEntry( 'foo', pArgs2 );
  debug(itemArgs);
  assert( 3==itemArgs.size() );
 }

function invokedNonExistentMethodWithMatchingPatternShouldBehaveAsPattern(){
  var pArgs = {1='{string}'};
  var pArgs2 = {1='{struct}'};
  var lArgs = {1='barbarmcfate'};
  //register 2 patterns
  mr.register('foo',pArgs);
  mr.register('foo',pArgs2);

  //given foo ( lArgs ) will behave like foo( pArgs )

  mr.updateRegistry('foo',pArgs, 'returns', 'hello');
  mr.updateRegistry('foo',pArgs2, 'returns', '');

  retval = mr.getReturnsData('foo',pArgs);
  /**/
  debug(retval);
  debug(mr.getRegistry());
  debug(mr.registryDataMap);
  debug(mr.argMap);

  //guard.
  assert ( ! mr.exists('foo',lArgs) );

  behavior = mr.findByPattern('foo',lArgs);
  debug(behavior);

  assert( behavior['target'] == 'foo' );
  assertEquals( pArgs,behavior['args'] );

}

function invokedNonExistentMethodWithOutMatchingPatternShouldThrowException(){

  var lArgs = {1='barbarmcfate'};
  try{
   behavior = mr.findByPattern('foo',lArgs);
   fail('should not get here');
  }
  catch(MismatchedArgumentPatternException e){}


}

function testCountInvocations(){

   var id = mr.id('foo',args);
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   debug(mr.invocationRecord);
   //get with ok status?
   assertEquals(5,mr.invocationRecord.recordCount);
}


function testGetInvocationsById(){

   mr.addInvocationRecord('foobar',args,'ok');
   mr.addInvocationRecord('foobar',args,'ok');
   mr.addInvocationRecord('foobar',args,'ok');
   mr.addInvocationRecord('foobar',args,'ok');
   mr.addInvocationRecord('foobar',args,'ok');

   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');
   mr.addInvocationRecord('foo',args,'ok');

   ins = mr.getInvocationRecordsById('foobar',args);
   debug(ins);
   assertEquals(5,ins.recordCount);
}

function getRegisteredBehaviorThrows(){
  mr.register('foo',args);
  mr.updateRegistry('foo',args,'throws', 'myexception');
  actual = mr.getRegisteredBehavior('foo',args);
  debug(mr.getRegistry());
  assertEquals('throws',actual);
}

function getRegisteredBehavior(){
  mr.register('foo',args);
  mr.updateRegistry('foo',args,'returns', 100);
  actual = mr.getRegisteredBehavior('foo',args);
  assertEquals('returns',actual);
}




function resetRegisteredBehavior(){

  mr.register('foo',args);
  mr.updateRegistry('foo',args,'returns', 100);
  actual = mr.getRegisteredBehavior('foo',args);
  debug(actual);
  assertEquals('returns',actual);

  mr.updateRegistry('foo', args, 'returns', '{undefined}');


  try{
    q = mr.getRegisteredBehavior('foo',args);
    debug(q);
    fail('should not get here');
  }
  catch(UnmockedBehaviorException e){
     debug(e);
   }
  //assertEquals('undefined',actual);

}



function givenIdReturnRegistryRowNumber(){
  mr.register('foo',args);
  rowNum = mr.getRowNum('foo',args);
  debug(rowNum);
  assertEquals(1,rowNum);
  pargs = {1='{query}'};
  mr.register('foo',pargs);
  rowNum = mr.getRowNum('foo',pargs);
  debug(mr.getRegistry());
  assertEquals(2,rowNum);
}

function updateReturnsData(){
  var oArgs = {1='{struct}'};
  mr.register('foo',oArgs);
  //update: target,args,column,value
  mr.updateRegistry('foo',oArgs,'returns', args);
  row = mr.findMock('foo',oArgs);
  debug(row);
  debug(mr.getReturnsData('foo',oArgs));
  assertEquals(args, mr.getReturnsData('foo',oArgs));
 }


 function updateThrowsData(){
  var oArgs = {1='{struct}'};
  mr.register('foo',oArgs);
  //update: target,args,column,value
  mr.updateRegistry('foo',oArgs,'throws', 'MyExceptionType');
  row = mr.findMock('foo',oArgs);
  debug(row);

  debug(mr);

  debug(mr.getReturnsData('foo',oArgs));
 // assertEquals( 'MyExceptionType', mr.getReturnsData('foo',oArgs));
 }

function testExists(){
 var temp = mr.register('foo',args);
 var actual = mr.exists('foo',args);
 assert(actual);

 actual = mr.exists('barbarMcFadden',args);
 assert(!actual);

}

function findShouldReturnLitteralItem(){
  var temp = mr.register('foo',args);
  var row = mr.findMock('foo',args);
  debug(row);
}


function isPatternShouldReturnTrue(){
  var	 args = {foo='{string}',bar='{any}'};
  var res = mr.isPattern(args);
  res = mr.isPattern(args);
  assert(res);
}

function isPatternShouldReturnFalseOnLiteral(){
  var	args = {a=[1,2,3],s='some value',foo='{string}',bar='{any}',asd=1};
  var res = mr.isPattern(args);
  //debug( createObject('java',args.getClass().getName() ) );
  debug(res);
  assert(!res, 'huh?');
}



 function testImplicitInit() {
     assert( isquery(mr.registry) );
     assert( isquery(mr.invocationrecord) );
  }


  function typeShouldReturnLiteral(){
    var type = mr.argType(args);
    assertEquals('litteral',type);
  }


  function typeShouldReturnPattern(){
    var pArgs = {1='{string}'};
    var type = mr.argType(pArgs);
    assertEquals('pattern',type);
  }


  function typeShouldThrowExceptionOnInvalidArgs(){
    var pArgs =  {1='{string}',2=1,3='asd',4=a};//'{string},1,asd';
    for(item in pArgs){
      try{
       debug(pArgs[item]);
        mr.argType(pArgs[item]);
        fail('should not get here. failed on #pArgs[item]#');
      }
      catch(InvalidArgumentTypeException e){}
    }
   }//end test


  function testRegisterLiteral() {
     mr.register('foo',args);
     debug(mr.getRegistry());
  }

  function idBuildsIdFromMethodAndArgHashcode(){
   var id = mr.id('foo',args);
   var expected = 'foo' & '_' & uCase(args.toString()).hashCode();
   debug(id);
   debug(expected);
   assertEquals(expected,id);
  }


  function argIdBuildsIdFromHashcode(){
   var id = mr.argid(args);
   var expected = uCase(args.toString()).hashCode();
   debug(id);
   debug(expected);
   assertEquals(expected,id);
  }


  function setUp(){
    mr = createObject('component','mightymock.MockRegistry');
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>