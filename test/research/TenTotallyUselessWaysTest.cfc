<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function setUp(){
    poc = createObject('component' ,'PlainOldStupidAssCFC');
    assertSame(poc,poc);
  }


  //#7
  function uselessUltraRedundantCallbacksForMorons(){
    var callBackFunc = whatever( poc.echo );
    assertEquals('I LIKE spam.', callBackFunc('I LIKE spam.') );
  }


   //#6
  function totallyMoronicInvocationUsingPageContextAndRequestScope(){
    var localFunc = 'localFunc';
    var page = getPageContext().getRequest().setAttribute( localFunc , poc.echo );
    assertEquals('Hey, let''s go to BestBuy and give the computer staff shit.', request.localFunc('Hey, let''s go to BestBuy and give the computer staff shit.') );
  }


  //#5
  function looserJavaWeanieInvocationUsingCfJspPage(){
   var page = getPageContext().getPage();
   var args = [ 'hey, looser. yo, you suck.' ];
   var actual = createObject('java' ,'coldfusion.runtime.CfJspPage')._invokeUDF(page._get('echo'), 'echo', page, args);
   debug(actual);
   assertEquals( 'hey, looser. yo, you suck.',  actual );

  }


   //#4
  function boneheadedTimeWasterWalkingAroundInCirclesLikeADoucheBag(){
    var actual = getPageContext().getFusionContext().parent.poc.echo('Now this is a real waste of time');
    assertEquals('Now this is a real waste of time', actual);
  }


  //#3
  function two_Totally_DumbAssWaysOfInvokingFunctionsUsingFusionContextAndCFCProxy(){
    var fusionCtx = getPageContext().getFusionContext();
    var cfcproxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(fusionCtx.getPagePath());
    var args = ['dumb ass'];
    var alias = cfcproxy.getMethod('echo');
    assertEquals( args[1] , alias('dumb ass') );
    assertEquals( args[1] , cfcproxy.invoke('echo', args) );
  }


  //#2.
  function wasteMoreTimeYouTurdSuckingMongralFromAnotherPlanet(){
  	var args = ['Punk ass bitch'];
  	var ctx = getPageContext().getFusionContext();
  	var actual = ctx.parent._invoke( ctx.parent.createObject('component','PlainOldStupidAssCFC'), 'echo', args  );
    debug(actual);
    assertEquals( args[1] , actual );
  }


  //#1
  function getAFuckingLifeYouTwistedMonkeyShitHurler() {
  	var methodProxy = chr(0);
  	var args = {1='scum sucking weasel whore'};
  	var ctx = getPageContext().getFusionContext();
  	var plainOldComponent = ctx.parent._invoke( ctx.parent.createObject('component','PlainOldStupidAssCFC'), 'init', args  );
    ctx.parent._set('methodProxy',  ctx.parent.createObject('java','coldfusion.runtime.java.JavaProxy').init( ctx.parent._autoscalarize(plainOldComponent.echo)) );
    actual = methodProxy.invoke('d', 'd', ctx.parent, args);
    debug(actual);
    assertEquals( 'scum sucking weasel whore' , actual );

  }
 </cfscript>





<!---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   "Private" Utility Functions
              The scope is package so they are accessible
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--->
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