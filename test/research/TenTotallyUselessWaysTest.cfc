<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
 
 
  function setUp(){
    poc = createObject('component' ,'PlainOldStupidAssCFC');
    assertSame(poc,poc); 
  }

 
  //#10
  function uselessRedundantCallbacksForMorons(){
    var callBackFunc = whatever( poc.echo );
    assertEquals('I LIKE spam.', callBackFunc('I LIKE spam.') );
  }
 
 
   //#9
  function uselessMoronicInvocationUsingPageContextAndRequestScope(){
    var localFunc = 'localFunc';
    var page = getPageContext().getRequest().setAttribute( localFunc , poc.echo );
    assertEquals('Hey, let''s go to BestBuy and give the computer staff shit.', request.localFunc('Hey, let''s go to BestBuy and give the computer staff shit.') );
  }  
 
  
  //#8
  function looserJavaWeanieInvocationUsingCfJspPage(){
   var page = getPageContext().getPage();
   var args = [ 'hey, looser. yo, you suck.' ];
   var actual = createObject('java' ,'coldfusion.runtime.CfJspPage')._invokeUDF(page._get('echo'), 'echo', page, args);
   debug(actual);
   assertEquals( 'hey, looser. yo, you suck.',  actual );
   
  }
  

   //#7
  function boneheadWastingTimeWalkingAroundInCirclesLikeADoucheBag(){
    var actual = getPageContext().getFusionContext().parent.poc.echo('Now this is a real waste of time');
    assertEquals('Now this is a real waste of time', actual);
  }  
  
  
  //#6
  function two_Totally_DumbAssWaysInvokingFunctionsUsingFusionContextAndCFCProxy(){
    var fusionCtx = getPageContext().getFusionContext();
    var cfcproxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(fusionCtx.getPagePath());
    var args = ['dumb ass'];
    var alias = cfcproxy.getMethod('echo');
    assertEquals( args[1] , alias('dumb ass') );
    assertEquals( args[1] , cfcproxy.invoke('echo', args) );   
  }  
  
  //#1.
  function getAFuckingLifeYouMoronMonkeyShitHurler(){
  
  }
   
 </cfscript>





<!---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   "Private" Utility Functions
                   The scope is package so they are accessible
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~---> 
 <cffunction name="whatever" access="package">
  <cfargument name="func" />
  <cfset var localFunction = arguments.func />
  <cfreturn localFunction />
 </cffunction>
 
 <cffunction name="echo" access="package">
  <cfargument name="message" />
  <cfreturn arguments.message />
 </cffunction>

 
</cfcomponent>