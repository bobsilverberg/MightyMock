<cfcomponent>
<cfscript>
	//change as needed
	exceptionType = 'mxunit.exception.AssertionFailedError';

 rules = {
      times='{?}',
      count='{?}',
      once=1,
      atLeast='{?}',
      atMost='{?}',
      never=0
     };


  function _$ruleExists(argRule){
    return structKeyExists(rules,argrule);
  }

   function verify(argrule,expected,target,args,mockreg){
     var result = '';
     var details = '';
     var calls = '';

     if(!_$ruleExists(argRule)) _$throw('InvalidRuleException',' Rule not found.', 'Rule #ucase(argrule)# was not found in Verifier component.');

     result =  _$assertRule(argrule,expected,target,args,mockReg);

     if(!result){ //_$buildMessage(...)
       calls = mockReg.getInvocationRecordsById(target,args).recordCount;
       details &= '
      Expected #target#( w/#args.size()# arguments ) to be verfied using rule
      "#ucase(argrule)#" : #expected# time(s), but #target# was actually called #calls# time(s).
     ';
     _$throw(exceptionType,'Mock verification failed. ',details);
     }

     return result;
   }


  function _$assertRule(argrule,expected,target,args,mockreg){
     var rows = mockReg.getInvocationRecordsById(target,args);
		 var ruleKey = arguments.argrule;
		 var ruleVal = rules[arguments.argrule];
		 var actualCount = rows.recordCount;
		 switch(ruleKey){
			case 'times':
		    return actualCount == expected;
		   break;

	     case 'count':
		    return actualCount == expected;
		   break;

		   case 'once':
		    return actualCount == 1;
		   break;

		   case 'atLeast':
		    return actualCount >= expected;
		   break;

		   case 'atMost':
		    return actualCount <= expected;
		   break;

	     case 'never':
	       return actualCount == 0;
	     break;


		   default:
		    return false;
		   break;
	   }

 }

</cfscript>


<cffunction name="_$throw">
	<cfargument name="type" required="false" default="mxunit.exception.AssertionFailedError">
	<cfargument name="message" required="false" default="failed behaviour">
	<cfargument name="detail" required="false" default="Details details ...">
  <cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>
</cfcomponent>