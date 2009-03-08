<cfcomponent output="false" extends="BaseTest">
<cfscript>
matcher = createObject('component','mightymock.ArgumentMatcher');


function testType(){
  type = matcher.type( 123 );
  assertEquals('{numeric}', type , 'numeric failue');

  type = matcher.type( now() );
  assertEquals('{date}', type , 'date failue');

  type = matcher.type(testType);
  assertEquals('{udf}', type, 'udf failue');

  type = matcher.type( args );
  assertEquals('{struct}', type, 'struct failue');

  type = matcher.type( a );
  assertEquals('{array}', type, 'array failue');

  type = matcher.type( q );
  assertEquals('{query}', type, 'query failue');

  type = matcher.type( x );
  assertEquals('{xml}', type, 'xml failue');

  type = matcher.type(true);
  assertEquals('{boolean}', type, 'bool failue');

  type = matcher.type(this);
  assertEquals('{object}', type, 'cfc object failue');

  type = matcher.type(sys);
  assertEquals('{object}', type, 'java object failue');


 assert (isBinary(toBinary(toBase64(mname))) , 'should be true');
/*
  type = matcher.type( toBinary( toBase64(mname)) );
  assertEquals('{binary}', type, 'binary failue');
*/
}


</cfscript>
</cfcomponent>