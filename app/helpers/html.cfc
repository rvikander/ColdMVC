<cfcomponent extends="coldmvc.app.util.ViewHelper">

	<!------>

	<cffunction name="table" access="public" output="false" returntype="string">
		<cfargument name="class" required="false" default="list" />

		<cfset configure(arguments) />

		<cfoutput>
		<cfsavecontent variable="arguments.field">
			<cfif arguments.label neq "">
				<div class="header">#arguments.label#</div>
			</cfif>
			<cfif arguments.class eq "grid">
				<table width="100%" cellspacing="1" class="grid" />
			<cfelseif arguments.class eq "plain">
				<table cellspacing="0" class="plain" />
			<cfelse>
				<table width="100%" cellspacing="0" class="#arguments.class#" />
			</cfif>
		</cfsavecontent>
		</cfoutput>

	 	<cfreturn trim(arguments.field) />

	</cffunction>

	<!------>

	<cffunction name="tr" access="public" output="false" returntype="string">
		<cfargument name="index" required="false" default="1" />
		<cfargument name="class" required="false" default="" />

		<cfif not isNumeric(arguments.index)>
			<cfset arguments.index = 1 />
		</cfif>

		<cfif arguments.index mod 2>
			<cfset arguments.class = trim("row odd #arguments.class#") />
		<cfelse>
			<cfset arguments.class = trim("row even #arguments.class#") />
		</cfif>

		<cfset configure(arguments) />

		<cfreturn '<tr #arguments.common#>' />

	</cffunction>

	<!------>

	<cffunction name="tag" access="public" output="false" returntype="string">

		<cfset configure(arguments) />

		<cfif arguments.common eq "">
			<cfreturn "<#arguments.tag#>" />
		<cfelse>
			<cfreturn "<#arguments.tag# #arguments.common#>" />
		</cfif>

	</cffunction>

	<!------>

</cfcomponent>