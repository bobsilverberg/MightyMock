<cfcomponent>
<cfscript>

  function init(){
    return this;
  }

  function run() {
   return 'running';
}
function echo(arg){
 return arguments.arg;  
}

</cfscript>
</cfcomponent>