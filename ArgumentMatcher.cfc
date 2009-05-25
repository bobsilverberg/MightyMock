<cfcomponent>
<cfscript>

  /*
  Requirement: Matches both the order or name of arguments. This is
  accomplished by understanding how the method being mocked is invoked
  by the component under tests; e.g.,

  script:
  function doSomething(foo,bar){
    obj.theMethod(foo,bar);
  }
  This is invoked using positional style and can be mocked like this:
  mock.theMethod( '{string}','{query}' ).returns(''); or
  mock.theMethod( foo='{string}', bar='{query}' ).returns(''); or
  It's more reliable to use named parameters as argumentcollection is
  an unordered map.

  CFML
  <cffunction name="doSomething">
	 <cfargument name="foo" />
	 <cfargument name="bar" />
	 <cfinvoke object="obj" method="theMethod"
	 					              foo="#foo#" bar="#bar#" />
	</cffunction>

   The above should be mocked using named parameter syntax to ensure
   argument matching:

   mock.theMethod( foo='{string}', bar='{query}' ).returns('');
*/

  function match(literal,pattern){
    var i = 0;
    var argType = '';
    var element = '';
    var key = '';
    var oArg = '';
    var flag = false;
    var oStringVal = '';
    var literalKeyString = structKeyArray(literal).toString();
    var patternKeyString = structKeyArray(pattern).toString();

   //maybe a wildcard
   if(pattern.size() == 1){
     flag = pattern.contains('{*}');
     if(flag) return flag;
     flag = pattern.contains('{+}');
     if(literal.size() && flag) return flag;
   }

   if( literal.size() != pattern.size() ){
     $throw('MismatchedArgumentNumberException',
            'Different number of parameters.',
            'Make sure the same number of paramters are passed in.');
   }

  if(literalKeyString != patternKeyString){
   $throw('NamedArgumentConflictException',
          'Different parameter type definition.',
          'It appears that you defined a mock using named or ordered arguments, but attempted to invoke it otherwise. Please use either named or ordered argument, but not both.');
   }


   for(key in literal){
     element = literal[key];
     oArg = pattern[key];
     argType = type(element);
     if( argType != oArg ) {
       if(isObject(element)){
        oStringVal = 'cfc or java class';
       }
       else{
        oStringVal = element.toString();
       }
      $throw('MismatchedArgumentPatternException',
             'Was looking at "#key# = #oStringVal#" and trying to match it to type: #oArg.toString()#',
             'Make sure the component being mocked matches parameter patterns, e.g., struct={struct}');
     }
   }

    return true;
  }




/*
  there's probably a better way to look up the type ...
*/
  function type(arg){
   if (isDate(arg)) return '{date}';
   if (isObject(arg)) return '{object}';
   if (isStruct(arg)) return '{struct}';
   if (isCustomFunction(arg)) return '{udf}';
   if (isNumeric(arg)) return '{numeric}';
   if (isArray(arg)) return '{array}';
   if (isQuery(arg)) return '{query}';
   if (isXML(arg)) return '{xml}';
   if (isBoolean(arg)) return '{boolean}';
   if (isBinary(arg)) return '{binary}';
   if (isImage(arg)) return '{image}';
   return '{string}';
   $throw('UnknownTypeException', 'Unknown type for #arg.toString()#');
  }
	</cfscript>




<cffunction name="$throw">
	<cfargument name="type" required="false" default="mxunit.exception.AssertionFailedError">
	<cfargument name="message" required="false" default="failed behaviour">
	<cfargument name="detail" required="false" default="Details details ...">
  <cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>

</cfcomponent>