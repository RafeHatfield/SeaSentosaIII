<cffunction name="canAccess" access="public" returntype="boolean">

	<cfargument name="fuseAction" type="string" required="yes">

	<cfset var hasAccess = false />

	<cfquery name="validateUser" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
		SELECT 1
		FROM profileFuses
			INNER JOIN processFuses On pff_processFuse = pfu_id
			INNER JOIN users ON usr_profile = pff_profile
		WHERE pfu_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseAction#" />
			AND usr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
	</CFQUERY>

	<cfif validateuser.recordCount>
		<cfset hasAccess = true />
	</cfif>

	<cfreturn hasAccess />

</cffunction>