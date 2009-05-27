<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
 function peepMethodMetaData() {
   md1 =  getMetaData(lookAtMe) ; //no parent info
   debug( md1 );
   debug( lookAtMe.getAccess() );
   debug( lookAtMe.getReturnType() );
   debug( lookAtMe.getMetaData() );
   //ret = lookAtMe.runFunction('ads','ads');

   /*
  getAccess
   debug( lookAtMe.getAccess() );
   debug( lookAtMe.getReturnType() );
   debug( lookAtMe.getMetaData() );
   */

   methods = lookAtMe.getClass().getDeclaredMethods();

   for(i=1;i < arrayLen(methods);i++){
    debug(  methods[i].getName() );
    debug(  methods[i] );
    debug(    methods[i].getDeclaringClass().getName()  );
   // debug(  methods[i].getMetaData() ); getTypeParameters()
   }


}

</cfscript>

<cffunction name="lookAtMe" returntype="Any" access="private">
  <cfargument name="ads" type="any" required="no" default="asdasdads" >
  <cfreturn arguments.ads />
</cffunction>

</cfcomponent>