<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>

 function asd(){
  m =  createObject('component','mightymock.test.fixture.MyComponent');
  debug(m);
  ss = m.invokeHelper.getSuperScope();
  //debug(ss);
  //setSuperScope(coldfusion.runtime.Scope)
  // INVOKEHELPER();

dump( getPageContext() );
}



function dumpTypes(){
 dump(p);
 dump(m);
 dump(tp);

}


function setUp(){
tp = createObject('java', 'coldfusion.runtime.TemplateProxy');
p = createObject('java', 'coldfusion.runtime.CfJspPage');
m = createObject('java', 'coldfusion.runtime.UDFMethod');

/*

coldfusion.runtime.UndefinedVariableException: Variable REGISTRY is undefined. at 
coldfusion.runtime.CfJspPage._get(CfJspPage.java:251) at 
coldfusion.runtime.CfJspPage._get(CfJspPage.java:236) at 
cfMightyMock2ecfc1137873012$funcONMISSINGMETHOD.runFunction(/home/billy/webapps/mightymock/MightyMock.cfc:90) at 
coldfusion.runtime.UDFMethod.invoke(UDFMethod.java:418) at 
coldfusion.runtime.UDFMethod$ArgumentCollectionFilter.invoke(UDFMethod.java:324) at 
coldfusion.filter.FunctionAccessFilter.invoke(FunctionAccessFilter.java:59) at 
coldfusion.runtime.UDFMethod.runFilterChain(UDFMethod.java:277) at 
coldfusion.runtime.UDFMethod.invoke(UDFMethod.java:233) at 
coldfusion.runtime.TemplateProxy.invoke(TemplateProxy.java:469) at 
coldfusion.runtime.TemplateProxy.invoke(TemplateProxy.java:308) at 
coldfusion.runtime.CfJspPage._invoke(CfJspPage.java:2272) at 
cfComponentTypeTest2ecfc1037696340$funcSMOKETEST.runFunction(/home/billy/webapps/mightymock/test/ComponentTypeTest.cfc:101) at 
coldfusion.runtime.UDFMethod.invoke(UDFMethod.java:418) at 
coldfusion.runtime.UDFMethod$ArgumentCollectionFilter.invoke(UDFMethod.java:324) at 
coldfusion.filter.FunctionAccessFilter.invoke(FunctionAccessFilter.java:59) at 
coldfusion.runtime.UDFMethod.runFilterChain(UDFMethod.java:277) at
 coldfusion.runtime.UDFMethod.invoke(UDFMethod.java:463) at 
coldfusion.runtime.TemplateProxy
*/
}


</cfscript>
</cfcomponent>