<%@ page language="java" import="java.util.*"%>
<%
//String username=request.getParameter("username");
//if(username==null) username="";


Date now = new Date();
//String timestamp = now.toString();
Cookie cookie = new Cookie ("jsp_cookie","jsp_cookie_value");
cookie.setMaxAge(365 * 24 * 60 * 60);
response.addCookie(cookie);

%>

in jsp