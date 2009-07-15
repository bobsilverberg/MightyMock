<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function testCompiler() {
     compiler = createObject("java","coldfusion.compiler.cfml40");
     dump(compiler);
     cs = createObject('java', 'coldfusion.compiler.CharStream');
     debug(cs);
     tc = createObject('java', 'coldfusion.compiler.NeoTranslationContext');
     debug(tc);
  }



  function setUp(){

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>