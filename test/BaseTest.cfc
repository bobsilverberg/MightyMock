<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
    sys = createObject('java','java.lang.System');
	mName = 'foo';
	args = {a=[1,2,3],s='some value'};
	id =  '$' & sys.identityHashCode(mName) & '_' & sys.identityHashCode(args);
    a = [1,2,3,4];
    q = queryNew('asd');
    x = xmlnew();
    x.xmlRoot = XmlElemNew(x,"MyRoot");

    mock = createObject('component','mightymock.MightyMock').init('my.mock');
    mockFactory = createObject('component','mightymock.MightyMockFactory').init();
    $ = mockFactory.create;
</cfscript>

  <cffunction name="getQ" access="private">
		<cfargument name="flag" required="false" default="1">
		<cfif (arguments.flag eq 1)>
			<cf_querysim>
			user
			id,f_name,l_name,group
			1|pocito|mock|33
			2|mighty|mock|33
			3|mitee|mock|33
			</cf_querysim>
		<cfelse>
			<cf_querysim>
			user
			id,f_name,l_name,group
			1|bobo|the clown|22
			2|mighty|mouse|22
			3|pocito|mas|22
			4|kwai chang|caine|22
			</cf_querysim>
		</cfif>

		<cfreturn user>
	</cffunction>
</cfcomponent>