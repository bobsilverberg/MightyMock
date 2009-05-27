<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
function peepCFPage(){
  //debug( getPageContext() );
  getPageContext().setCurrentLineNo(911);   
  debug(  getPageContext().getCurrentLineNo()  );
  //This is what we want!
  ctx = getPageContext().getFusionContext();
  debug( ctx );
  hookie = 'hooky';
  //CFPage object
  //getPageContext().getFusionContext().setCurrentLineNo( javacast('int', 234) );
  
  debug( ctx.parent._autoscalarize('hookie') );
  
  request.foo = 'bar';
  debug( ctx.getApplicationName() );
  
  debug(ctx.instance);
  
   pp = createObject('java' ,'coldfusion.runtime.CFPage');
 debug(pp);  

     
}

  
  
 function metaDataUsingDots(){
   debug( lookAtMe.getAccess() );
   debug( lookAtMe.getReturnType() );
   debug( lookAtMe.getMetaData() );
   debug( lookAtMe() );
 }   
    
 function peepMethodMetaData() {
   md1 =  getMetaData(lookAtMe) ; //no parent info
   
   debug( lookAtMe.getClass() );
   
   
   //getDeclaredMethod(java.lang.String, java.lang.Class[])
   ptypes = [];
   //debug( lookAtMe.getClass().getDeclaredMethod('runFunction',ptypes) );  
   //ret = lookAtMe.runFunction('ads','ads');


   methods = lookAtMe.getClass().getDeclaredMethods();

   for(i=1;i < arrayLen(methods);i++){
    n = methods[i].getName();
    
    if(n == 'runFunction'){
      debug(n);	
      debug(  methods[i] );
      //debug(  methods[i].getDeclaringClass().getName()  );
      debug(  methods[i].getTypeParameters() );
      args = [1,2];
     //debug( methods[i].invoke('ads', args) );
    }
    
  
   }  
   
 return; 
 
 
   for(i=1;i < arrayLen(methods);i++){
    debug(  methods[i].getName() );
    debug(  methods[i] );
    //debug(  methods[i].getDeclaringClass().getName()  );
    debug(  methods[i].getTypeParameters() );
    args = [1,2];
    //debug( methods[i].invoke('ads', args) );
   }


}


function peepVars(){
   thisThang = createObject('component' ,'mightymock.test.research.FunctionMetaDataTest');
   tp = createObject('java' ,'coldfusion.runtime.TemplateProxy');//.init('mightymock.test.research.FunctionMetaDataTest');
   debug( tp ); //
   debug( getPageContext() );

}


function execCfcViaJava(){
   jp = createObject('java' ,'coldfusion.runtime.java.JavaProxy').init(this);
   
   debug( jp.toString() );
   debug('javaproxy');
   debug(jp);
   //debug( jp.getMethodMetaData('lookAtMePub') );
   args = {p='arg1',2='sdf',3='hjk'};
   v = jp.invoke('lookAtMePub', args, getPageContext());
   debug(v);
   
   debug( jp.values() );
   
   
   debug( jp.isInstanceOf('mxunit.framework.TestCase') );
   debug( jp.writeReplace() ); 
   debug( jp.resolveMethod('lookAtMePub',true) );
   
    newvar = jp.bindInternal('newvar');
    newVar.set(123);
    debug(newvar);
    debug(newvar.getValue());
    jp.put('myProxyMethodRef',lookAtMe);
    foo = jp.get( 'myProxyMethodRef' );
    
    newPubMethod = jp.bindInternal('newMethod');
    newVar.set(lookAtMe);
    
    debug(jp.page); //get the entire page context
    debug( jp.writeReplace() ); 
    
    
    debug(foo);
    debug(foo()); 
   
}

function attributeCollectionPeep(){
   ac = createObject('java' ,'coldfusion.runtime.AttributeCollection'); 
   debug( ac ); 
}

function execFunctionViaJava(){
   jp = createObject('java' ,'coldfusion.runtime.java.JavaProxy').init(lookAtMe);
   debug( jp.toString() );
   debug('javaproxy');
   debug(jp);
   debug(jp.getPagePath());
   debug(jp.getAccess());
   //v = jp.invoke(getPageContext().getFusionContext());
 // invoke(java.lang.Object, java.lang.String, java.lang.Object, java.lang.Object[])
   
   args = [1,2];
   sargs = {};
   sargs.p = 'imaparam';
   v = jp.invoke(this, 'asd', getPageContext().getPage(), sargs);
   debug(v);
   assertEquals( sargs.p, v );
   
   dump(jp.getMethodAttributes());
   
   className = jp.getClass().getName();
   debug(className);
   
  //  class = createObject('java' ,'java.lang.Class').forName( className & '.class' );
   
   
 
   
}


function introspectCFFunctionJava(){
   javaproxy = createObject('java' ,'coldfusion.runtime.java.JavaProxy').init(this);
   debug('javaproxy');
   debug(javaproxy);
   args = [1,2];
   v = javaproxy.invoke('lookAtMePub', args, getPageContext());
   debug(v);
   
   debug( lookAtMe.getClass().getSuperClass().getName() );
   //debug( lookAtMe.getClass() );
   
   
   return;
   superClass = createObject('java' ,lookAtMe.getClass().getSuperClass().getName());
   debug(superClass.getMethodAttributes());
  // debug( superClass.getPagePath() );
   //debug(superClass.getMetadata());
   //null debug( lookAtMe.getClass().getEnclosingClass() );
   //null debug( lookAtMe.getClass().getDeclaringClass().getName() );
  lookAtme.getClass().getEnclosingMethod();//  debug( );
  foo = lookAtme.getClass().newInstance();
  debug( 'foo.getMetaData()' );
  debug( foo.getMetaData() );
  //foo.runFunction();
  debug( 'lookAtMe.getClass().getDeclaredFields()' );
  fields = lookAtMe.getClass().getDeclaredFields();
  debug( fields );
  debug( "lookAtMe.getClass().getDeclaredField('metaData')" );
  debug( lookAtMe.getClass().getDeclaredField('metaData') );
  debug( lookAtMe.getClass().getDeclaredField('metaData').toString()  );
 
  
  
  
}
 

</cfscript>
<cffunction name="lookAtMePub" returntype="Any" access="public">
  <cfargument name="p" type="any" required="no" default="asdasdads" >
  <cfreturn p />
</cffunction>


<cffunction name="lookAtMe" returntype="Any" access="private">
  <cfargument name="p" type="any" required="no" default="looky looky" >
  <cfreturn p />
</cffunction>

</cfcomponent>