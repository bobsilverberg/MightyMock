<cfcomponent output="false" extends="BaseTest">
<cfscript>

function setUp(){
 matcher = createObject('component','mightymock.ArgumentMatcher');
}



function findByPatternTest(){

}


function matchLiterlToPatterns(){
   var actual = false;
   var literal = { 1='bar', 2=321654};
   var pattern = { 1='{string}', 2='{numeric}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   s = {1=1};
   literal = { 1='bar', 2=s};
   pattern = { 1='{string}', 2='{struct}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=a};
   pattern = { 1='{string}', 2='{array}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=q};
   pattern = { 1='{string}', 2='{query}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this};
   pattern = { 1='{string}', 2='{object}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this, 3=s, 4=a, 5='barbarmcfate'};
   pattern = { 1='{string}', 2='{object}', 3='{struct}', 4='{array}', 5='{string}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

}



function argumentMatcherPassesWithWildCards(){
   var actual = false;
   var incomming = { 1='bar', 2=321654};
   var existing = { 1='{*}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual,'did not match {*}');

   existing = { 1='{+}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual,'did not match {+}');
}



function argumentMatcherShouldFailWithUnMatchedNumberOfArgs(){
  var incomming = {1=1,2=2,3=3};
  var existing = {1=1,2=2,3=3,4=4};
  try{
   assert( matcher.match(incomming,existing) );
   fail('should not get here');
  }
  catch(MismatchedArgumentNumberException e){

  }
}

function $matchOrderedArgsShouldWork(){
   var actual = false;
   var incomming = { 1='bar', 2=321654};
   var existing = { 1='{string}', 2='{numeric}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming,3,'asd');
   structInsert(existing, 3,'{string}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 'arbitrary' ,'asd');
   structInsert(existing, 'arbitrary','{string}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 4, a);
   structInsert(existing, 4 ,'{array}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 5, args);
   structInsert(existing, 5 ,'{struct}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 6, sys);
   structInsert(existing, 6 ,'{object}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 7, q);
   structInsert(existing, 7 ,'{query}');

   debug( matcher.type( incomming['7'] ) );

   actual = matcher.match(incomming,existing) ;

   debug(incomming);
   debug(existing);
   assert(actual);

}

</cfscript>
</cfcomponent>