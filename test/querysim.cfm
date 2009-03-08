<!--- QuerySim.cfm by hal.helms@TeamAllaire.com --->
<cfsetting enablecfoutputonly="Yes">

<!---
UserInfo
userID,firstName,lastName,userGroups
100|Stan|Cox|33

returns a query called "UserInfo" with 4 columns of information about Stan Cox.

--->


<cfif thistag.HasEndTag
  AND thistag.ExecutionMode IS "start">
        <!--- do nothing --->
<cfelseif thistag.HasEndTag AND thistag.ExecutionMode IS "end">
        <cfset RawData = Trim( Thistag.generatedContent )>
        <cfset Thistag.generatedContent = "">

        <cfset lineNum = 0>
        <cfloop list="#RawData#" delimiters="#chr(10)##chr(13)#" index="line">
                <cfset lineNum = lineNum + 1>

                <cfset thisLineData = Trim(ListLast(line, "="))>

                <!--- first line is the query name --->
                <cfif lineNum IS 1>
                        <cfset myQueryname = thisLineData >

                <!--- second line is the , delimited column List --->
                <cfelseif lineNum IS 2>
                        <cfset myColumnList = thisLineData>
                        <cfset aQuery = QueryNew( myColumnList )>

                <!--- the rest are | delimited list of values --->
                <cfelse>
                        <!--- add a row to the query --->
                        <cfset QueryAddRow( aQuery )>

                        <cfset colNum = 0>
                        <cfloop list="#myColumnList#" delimiters="," index="mycolumn">
                                <cfset colNum = colNum + 1>
                                <cfif ListLen( thisLineData )>
                                        <cfif ListGetAt(thisLineData, colNum, '|' ) NEQ "null">
                                                <cfset QuerySetCell(aQuery, mycolumn, ListGetAt(thisLineData, colNum, "|"))>
                                        </cfif>
                                <cfelse>
                                        <cfset QuerySetCell(aQuery, mycolumn, "")>
                                </cfif>
                        </cfloop>
                </cfif>

        </cfloop>

        <cfset SetVariable( 'caller.' & myQueryname, aQuery )>

<cfelse>

        <cfif NOT FileExists( "#attributes.SimFile#" )>
                <cfoutput>QuerySim encountered a problem when trying to read the associated ini file. This may be due to a missing file or an incorrect path. The SimFile must be an absolute path.</cfoutput>
        </cfif>

        <cfset listOfColumns = GetProfileString( "#attributes.SimFile#", "#attributes.QueryName#", "QueryColumns" )>

        <cfset aQuery = QueryNew( listOfColumns )>

        <cfloop from="1" to="100" index="i">
                <cfset simData = GetProfileString( "#attributes.SimFile#", "#attributes.QueryName#", "SimData#i#" )>

                <cfif NOT Len( Trim( simData ) )>
                        <cfbreak>
                </cfif>

                <cfset QueryAddRow( aQuery )>

                <cfloop from="1" to="#ListLen( listOfColumns )#" index="j">
                        <cfset QuerySetCell( aQuery, Trim( ListGetAt( listOfColumns, j ) ), ListGetAt( simData, j, '|' ) )>
                </cfloop>
        </cfloop>

        <cfif IsDefined('attributes.rQueryName')>
                <cfset SetVariable( 'caller.' & attributes.rQueryName, aQuery )>
        <cfelse>
                <cfset SetVariable( 'caller.' & attributes.QueryName, aQuery )>
        </cfif>

</cfif>
<cfsetting enablecfoutputonly="No">
