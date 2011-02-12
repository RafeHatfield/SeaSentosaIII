<cfcomponent extends="fusebox5.Application" output="false">

	<!--- set application name based on the directory path --->
	<cfset this.name = "ss3Live_ii" />

	<!--- enable debugging --->
	<cfif listFind(cgi.SERVER_NAME,'local','.')>
		<cfset FUSEBOX_PARAMETERS.debug = true />
	</cfif>
		<cfset FUSEBOX_PARAMETERS.mode = "development-full-load" />

	<cfparam name="application.seoURL" default="0" />

	<cfif application.seoURL>

		<cfset FUSEBOX_PARAMETERS.queryStringStart ="/" /><!---  // default: ? --->
		<cfset FUSEBOX_PARAMETERS.queryStringSeparator ="/" /><!---  // default: & --->
		<cfset FUSEBOX_PARAMETERS.queryStringEqual = "/" /><!---  // default: = --->

	</cfif>

	<!--- force the directory in which we start to ensure CFC initialization works: --->
	<cfset FUSEBOX_CALLER_PATH = getDirectoryFromPath(getCurrentTemplatePath()) />

	<cffunction name="onApplicationStart" returntype="boolean" output="false" access="public" hint="I am executed when the application starts">

		<cfset super.onApplicationStart() />

		<!--- development --->
		<cfif listFindNoCase(cgi.SERVER_NAME,"local",".")>
			
			<cfset application.baseURL = "http://local.ssiii.local/" />
			<cfset application.DBDSN = "ssiiiDSN" />
			<cfset application.DBUserName = "sa" />
			<cfset application.DBPassword = "g3t0ut" />

			<cfset application.reservationObj = createObject( 'component', 'ssiii.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'ssiii.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'ssiii.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'ssiii.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'ssiii.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'ssiii.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'ssiii.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'ssiii.com.contact' ) />
			<cfset application.ctaObj = createObject( 'component', 'ssiii.com.cta' ) />
			<cfset application.systemObj = createObject( 'component', 'ssiii.com.system' ) />
			<cfset application.propertyObj = createObject( 'component', 'ssiii.com.property' ) />

			<cfset application.googleKey = "" />

			<cfset application.online = "0" />

		<cfelseif listFindNoCase(cgi.PATH_INFO,"ssiii","/")>
			<!---  AND NOT listFindNoCase(cgi.SERVER_NAME,"seasentosa",".") --->
			<cfset application.baseURL = "http://www.seasentosa.com/ssiii/" />
			<cfset application.DBDSN = "SSIIIdsn" />
			<cfset application.DBUserName = "ssdsnUser" />
			<cfset application.DBPassword = "ssdsn2010" />

			<cfset application.reservationObj = createObject( 'component', 'seasentosaH201781.ssiii.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'seasentosaH201781.ssiii.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'seasentosaH201781.ssiii.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'seasentosaH201781.ssiii.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'seasentosaH201781.ssiii.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'seasentosaH201781.ssiii.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'seasentosaH201781.ssiii.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'seasentosaH201781.ssiii.com.contact' ) />
			<cfset application.ctaObj = createObject( 'component', 'seasentosaH201781.ssiii.com.cta' ) />
			<cfset application.systemObj = createObject( 'component', 'seasentosaH201781.ssiii.com.system' ) />
			<cfset application.propertyObj = createObject( 'component', 'seasentosaH201781.ssiii.com.property' ) />

			<cfset application.googleKey = "" />

			<cfset application.online = "0" />


		<cfelse>

		<!--- live --->
			<cfset application.baseURL = "http://www.seasentosa.com/" />
			<cfset application.DBDSN = "ssDSNIII" />
			<cfset application.DBUserName = "bSentosa" />
			<cfset application.DBPassword = "mySent0sa" />

			<cfset application.reservationObj = createObject( 'component', 'sentosaH198951.com.reservation' ) />
			<cfset application.menuObj = createObject( 'component', 'sentosaH198951.com.menu' ) />
			<cfset application.villaObj = createObject( 'component', 'sentosaH198951.com.villa' ) />
			<cfset application.contentObj = createObject( 'component', 'sentosaH198951.com.content' ) />
			<cfset application.imageObj = createObject( 'component', 'sentosaH198951.com.image' ) />
			<cfset application.newsObj = createObject( 'component', 'sentosaH198951.com.news' ) />
			<cfset application.memberObj = createObject( 'component', 'sentosaH198951.com.member' ) />
			<cfset application.contactObj = createObject( 'component', 'sentosaH198951.com.contact' ) />
			<cfset application.systemObj = createObject( 'component', 'sentosaH198951.com.system' ) />
			<cfset application.ctaObj = createObject( 'component', 'sentosaH198951.com.cta' ) />

			<!--- this key is for balisentosa.asianvhm.com --->
			<!--- <cfset application.googleKey = "ABQIAAAA-QoBVtFL2SWaVJEUzeBfOhT6Z1grzXIAr9CQeNPy8sD9XSooIRQMBdAmeetYxNgvVBuf3f_8TtmraA" /> --->

			<!--- this key is for balisentosa.com --->
			 <cfset application.googleKey = "" />

			<cfset application.online = "1" />

		</cfif>

		<cfset application.imagePath = "assets/images/upload/" />
		<cfset application.imagePathBase = "assets/images/" />
		<cfset application.path = ExpandPath('/')>
		<cfset application.imageUploadPath = application.path & "assets\images\upload\" />
		<cfset application.flashUploadPath = application.path & "assets\flash\" />

		<cfset application.feedbackEmail = "info@balisentosa.com" />
		<cfset application.reservationEmail = "reservations@balisentosa.com" />
		<cfset application.adminEmail = "rafe@asianvhm.com" />

		<cfset application.appInitialized = true />

		<cfset application.systemSettings = application.systemObj.getSystemSettings() />
		
		<cfreturn True />

	</cffunction>

	<cffunction name="onFuseboxApplicationStart">

		<cfset super.onFuseboxApplicationStart() />

		<!--- code formerly in fusebox.appinit.cfm or the appinit global fuseaction --->
		<cfset myFusebox.getApplicationData().startTime = now() />

	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" output="false" access="public" hint="I am executed at the atart of each request">

		<cfargument name="targetPage" />

		<cfset super.onRequestStart(argumentCollection=arguments) />

		<cfif StructKeyExists(URL, "appReload")>
			<!--- reinitialise the application scope --->
			<cfset onApplicationStart() />
		</cfif>

		<!--- these vars are used in the layout files --->
		<cfparam name='request.styleSheetList' default='' />
		<cfparam name='request.jsList' default='' />
		<cfparam name='request.bodyParams' default='' />
		<cfparam name='request.footerJS' default='' />

		<cfset request.pathInfo = cgi.script_name & cgi.path_info />

		<cfset request.TinyMCEIncluded = "false" />
		<cfset request.url = "http://" & cgi.http_host />
		<cfset request.fullURL = request.url & cgi.script_name & "?" & cgi.query_string />

		<!--- get the page content, store it in a request var for later use --->
		<cfparam name="attributes.page" default="" />

		<cfif not len(attributes.page)>
			<cfset request.qContent = application.contentObj.getContent(fuseAction=attributes.fuseAction) />
			<cfif not request.qContent.recordCount>
				<cfset attributes.page = "home" />
				<cfset request.qContent = application.contentObj.getContent(page=attributes.page) />
			</cfif>
		<cfelse>
			<cfset request.qContent = application.contentObj.getContent(page=attributes.page) />
		</cfif>
		
		<cfset request.qContentImages = application.imageObj.getContentImagesWeb(con_id=val(request.qContent.con_id)) />

		<cfif not request.qContentImages.recordCount>
			<cfset request.qContentImages = application.contentObj.getGloryBoxesDefault(gbx_active=1, gbx_type='Image') />
		</cfif>

		<cfif len(request.qContent.con_title)>
			<cfset request.pageTitle = "Sea Sentosa, Bali" & ' - ' & request.qContent.con_title />
		<cfelse>
			<cfset request.pageTitle = "Sea Sentosa, Bali" & ' - ' & application.systemSettings.sys_pageTitle />
		</cfif>

		<cfif len(request.qContent.con_metaDescription)>
			<cfset request.metaDescription = request.qContent.con_metaDescription />
		<cfelse>
			<cfset request.metaDescription = application.systemSettings.sys_metaDescription />
		</cfif>

		<cfif len(request.qContent.con_metaKeywords)>
			<cfset request.metaKeywords = request.qContent.con_metaKeywords />
		<cfelse>
			<cfset request.metaKeywords = application.systemSettings.sys_metaKeywords />
		</cfif>

		<cfif isDefined("attributes.newsletterSave")>
			<cfset request.checkNewsLetterSave = application.contactObj.miniNewsLetterSave(attributes.newsLetterEmail) />
			<!--- <cfset request.checkNewsLetterSave = "1" /> --->
		<cfelse>
			<cfset request.checkNewsLetterSave = "0" />
		</cfif>
		
		<cfif request.checkNewsLetterSave is 1>
			<cflocation url="#request.myself#content.display&page=newsletter-thanks" />
		</cfif>

		<cfparam name="attributes.languageChange" default="" />
		
		<cfif len(attributes.languageChange) gt 0>
			<cflocation url="#attributes.languageChange#" />
		</cfif>
		
		<cfset request.fuseAction = attributes.fuseAction />
		
		<cfreturn True />

	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="true" access="public" hint="I am executed when all pages in the request have finished processing">

		<cfargument name="targetPage" />
		<!--- Pass request to Fusebox. --->
		<cfset super.onRequestEnd(arguments.targetPage) />

	</cffunction>
	
	<cffunction name="onError">

		<cfargument name="Exception" required="true" />
		<cfargument name="EventName" type="String" required="true" />
		<!--- <cfargument name="errorTemplate" type="string" default="" required="true" /> --->
		
		<cfset var cferror = arguments.exception />
		
<!--- 		<cfif application.online>
		
			<cfmail to="rafe@asianvhm.com" from="rafe@asianvhm.com" subject="Bali Sentosa Web Error" type="html">
	
				<cfoutput>
					<table width="100%" border="0" cellspacing="1" cellpadding="2">
						<tr valign="top"><td width="20%">URL</td><td>#cgi.HTTP_Referer#</td></tr>
						<tr valign="top"><td width="20%">Translated</td><td>#cgi.Path_Translated#</td></tr>
						<tr valign="top"><td width="20%">Error</td><td><cfif IsDefined("cfError.message")>#cfError.Message#<cfelse>Undefined.</cfif></td></tr>
						<cfif isDefined("cferror.rootcause.sql")><tr valign="top"><td width="20%">SQL</td><td>#cferror.rootcause.sql#</td></tr></cfif>
						<cfif isDefined("cferror.rootcause.detail") AND Len(cferror.rootcause.detail)><tr valign="top"><td width="20%">Detail</td><td>#cferror.rootcause.detail#</td></tr></cfif>
					</table>
	
					<cfdump var="#cferror#">
	
					<br><br>Dump of all CGI Variables:<br><cfdump var="#cgi#">
					<br><br>Dump of all Attributes Variables:<br><cfdump var="#attributes#">
					<br><br>Dump of all CLIENT Variables:<br><cfdump var="#client#">
					<br><br>Dump of all URL Variables:<br><cfdump var="#url#">
					<br><br>Dump of all FORM Variables:<br><cfdump var="#form#">
				</cfoutput>
	
			</cfmail>
	
			<cflocation url="/error/error.cfm" />
			
		<cfelse> --->
		
			<cfoutput>	
				
				<table width="100%" border="0" cellspacing="1" cellpadding="2">
					<tr valign="top"><td width="20%">URL</td><td>#cgi.HTTP_Referer#</td></tr>
					<tr valign="top"><td width="20%">Translated</td><td>#cgi.Path_Translated#</td></tr>
					<tr valign="top"><td width="20%">Error</td><td><cfif IsDefined("cfError.message")>#cfError.Message#<cfelse>Undefined.</cfif></td></tr>
					<cfif isDefined("cferror.rootcause.sql")><tr valign="top"><td width="20%">SQL</td><td>#cferror.rootcause.sql#</td></tr></cfif>
					<cfif isDefined("cferror.rootcause.detail") AND Len(cferror.rootcause.detail)><tr valign="top"><td width="20%">Detail</td><td>#cferror.rootcause.detail#</td></tr></cfif>
				</table>
				
			</cfoutput>
			
			<cfdump var="#cferror#">

			<br><br>Dump of all CGI Variables:<br><cfdump var="#cgi#">
			<br><br>Dump of all Attributes Variables:<br><cfdump var="#attributes#">
			<br><br>Dump of all CLIENT Variables:<br><cfdump var="#client#">
			<br><br>Dump of all URL Variables:<br><cfdump var="#url#">
			<br><br>Dump of all FORM Variables:<br><cfdump var="#form#">
					
<!--- 		</cfif> --->

	</cffunction>
	
</cfcomponent>