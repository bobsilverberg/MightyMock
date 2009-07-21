<cfcomponent output="false" extends="mxunit.framework.TestCase">
 <cfinclude template="cookie.jsp" />
  <cfscript>
    function setUp(){
    j2eeCookie = createObject('java' ,'javax.servlet.http.Cookie').init('myjee_cookie','my_value');
    debug( j2eeCookie );
    j2eeCookie.setComment('cookie kung fu');
    j2eeCookie.setDomain('localhost');
    j2eeCookie.setPath('/');
    j2eeCookie.setMaxAge(365 * 24 * 60 * 60);
    j2eeCookie.setSecure(true);
    j2eecookie.setVersion(1);
    j2eeCookie.setValue('new cookie value');
  	debug(  'comment: ' & j2eecookie.getComment()  );
		debug(	j2eecookie.getDomain()  );
		debug(	'max age:' & j2eecookie.getMaxAge()  );
		debug(	'name: ' & j2eecookie.getName()  );
		debug(	j2eecookie.getPath()  );
		debug(	'secure: ' & j2eecookie.getSecure()  );
		debug(	'value: ' & j2eecookie.getValue()  );
		debug(	'version: ' & j2eecookie.getVersion()  );
	
    response = getPageContext().getResponse();
    response.setHeader("SET-COOKIE", "myjee_cookie=my_new_value; HttpOnly; Secure;");
    response.setHeader("SET-COOKIE", "CFID=NEWID; HttpOnly; Secure;");
    response.setHeader("SET-COOKIE", "JSESSIONID=hack_me; HttpOnly; Secure;");
    
    
    //doesn't look like it's adding the cookie
    getPageContext().getResponse().addCookie(j2eecookie);
    cookie.myj2eeCookie = j2eecookie;
    
    }
    
    function setCookie(){
     //should just call setup and set the cookie
    }
  </cfscript>

<cffunction name="dumpCookieScope">
 <cfscript>
   c = createObject('java' ,cookie.getClass().getName());
   dump(c);
  </cfscript>
</cffunction>

<cffunction name="eatACookieYoullFeelBetter">
  <cfcookie name="test_cookie" value="test_data" />
  <cfscript>
    mycookies = getPageContext().getRequest().getCookies();
    for(i=1;i<=arrayLen(mycookies);i++){
     c = mycookies[i];
     debug(c.getName());
    }
    //cfcookie
    debug(cookie);
    
    
    /*
    //can we swap cookies?
    structClear(cookie);
    cookie = structNew();
    cookie = {};
    a = structKeyArray(cookie);
    
    for(item in cookie){
     debug(item);
     //clobber item
     item = '';
    }    

    cookie = duplicate(j2eecookie); 
    debug(cookie);
    cookie = j2eecookie;
    cookie.clear();
    asas = cookie.remove("CFTOKEN");
    i = cookie.keySet().iterator();
    while(i.hasNext()){
      o = i.next();
      debug(o);
      cookie.remove(o);
      o = '';
    }
    debug(cookie.values().size());
    debug(cookie);
*/
  </cfscript>
</cffunction>

 <cfscript>
  
function peepSession(){
    dump(session.getSessionId());
    ses = createObject('java' , session.getClass().getName()); 
    dump(ses); 
    
}
  </cfscript>   

</cfcomponent>