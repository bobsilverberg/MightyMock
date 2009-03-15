<cfcomponent extends="BaseTest">
<cfscript>
 function typeShouldBeWhatITellIt(){
   foo = $('com.foo.bar');
   bar = $('com.foo.bar');	
   o = createObject('java','java.lang.Object');
   //assertIsTypeOf( foo, 'com.foo.bar' );
   debug(foo);
   debug(bar);
   //debug(o.getClass());
   // testType(foo);
   v = createObject('java', variables.getClass().getName());
   debug(v);
   
 }

</cfscript>

<cffunction name="testType" access="private">
  <cfargument name="o" type="com.foo.bar">
</cffunction>

</cfcomponent>