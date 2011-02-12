<cfcomponent hint="I am the component that holds the content functions" output="false">

	<!--- Author: Rafe - Date: 9/26/2009 --->
	<cffunction name="displayContent" output="false" access="public" returntype="string" hint="I return the content based on the fuseAction">

		<cfargument name="page" type="string" default="" required="false" />
		<cfargument name="fuseAction" type="string" default="" required="false" />

		<cfset var content = "" />
		<cfset var qContent = "" />
		<cfset var qOtherContentImages = "" />
		<cfset var qChildContent = "" />
		<cfset var qContentImages = "" />
		
		<cfif len(arguments.page)>
			<cfset qContent = getContent(page=arguments.page) />
		<cfelseif len(arguments.fuseAction)>
			<cfset qContent = getContent(fuseAction=arguments.fuseAction) />
		<cfelseif len(request.fuseAction)>
			<cfset qContent = getContent(fuseAction=request.fuseAction) />
		</cfif>
		
		<cfset qChildContent = getChildContent(parentID=val(qContent.con_id)) />

		<cfsaveContent variable="content">
			
			<cfoutput query="qContent">
				
				<cfif len(gbx_name)>
					<style>
						##outer {background:url(assets/images/upload/gloryBox/#gbx_name#) center top no-repeat;}
					</style>
				</cfif>
				
				<cfset qContentImages = application.imageObj.getContentImages(con_id=qContent.con_id,excludeType="Main,Header") />

				<h2>#ucase(con_title)#</h2>
				
				<cfif len(con_body) or qContentImages.recordCount>
					<ul>
						
						<li>
							
							<cfif qContentImages.recordCount>
							
								<div id="galleryLB">
									<cfif qContentImages.recordCount>
										<div style="float:left">
											<a href="assets/images/upload/#qContentImages.img_name#" title="#img_title#" rel="lightbox" id="firstLB"><img src="assets/images/upload/#qContentImages.img_name#" width="550" style="margin-bottom:5px;border-style:solid;border-width:1px;border-color:##ffffff" /></a>
										</div>		
									</cfif>
									
									<cfif qContentImages.recordCount gt 1>
										<div style="float:right">
											<cfloop query="qContentImages" startrow="2" endrow="6">
												<a href="assets/images/upload/#qContentImages.img_name#" title="#img_title#" rel="lightbox"><div style="float: left; overflow:hidden; height:50px; width:110px;border-style:solid;border-width:1px;border-color:##ffffff;margin-bottom:10px"><img src="assets/images/upload/#qContentImages.img_name#" width="110" style="" /></div></a><br />
											</cfloop>
										</div>
									</cfif>
								
								</div>
								
								<br /><br />
								<!--- 
								<script type="text/javascript">
								    $(document).ready(function() {
								        $("##firstLB").trigger('click');
								    });
								</script>
								 --->
							</cfif>
							
							<br clear="all" />
							
							#con_body#
							
							<cfif len(con_attach1Desc) or len(con_attach2Desc) or len(con_attach3Desc)>
							
								<div style="margin-left: 50px">
									<cfif len(con_attach1Desc)>
										<div style="margin-top:5px; font-size:13px; font-weight: bold">
											<a href="#application.imagePath#attachments/#con_attach1#" target="_blank"><cfif findNoCase("pdf",con_attach1)> <img src="#application.imagePath#acrobat_20x20.png" /> </cfif>#con_attach1Desc#</a>
										</div>
									</cfif>
									<cfif len(con_attach2Desc)>
										<div style="margin-top:5px; font-size:13px; font-weight: bold">
											<a href="#application.imagePath#attachments/#con_attach2#" target="_blank"><cfif findNoCase("pdf",con_attach1)> <img src="#application.imagePath#acrobat_20x20.png" /> </cfif>#con_attach2Desc#</a>
										</div>
									</cfif>
									<cfif len(con_attach3Desc)>
										<div style="margin-top:5px; font-size:13px; font-weight: bold">
											<a href="#application.imagePath#attachments/#con_attach3#" target="_blank"><cfif findNoCase("pdf",con_attach1)> <img src="#application.imagePath#acrobat_20x20.png" /> </cfif>#con_attach3Desc#</a>
										</div>
									</cfif>
								</div>
								
								<p>&nbsp;</p>
								
							</cfif>
				
						</li>
						
					</ul>
					
				</cfif>

			</cfoutput>

		</cfsaveContent>

		<cfreturn content />

	</cffunction>

	<!--- Author: Rafe - Date: 9/27/2009 --->
	<cffunction name="getContent" output="false" access="public" returntype="query" hint="I return all the content based on either ID or the unique page string">

		<cfargument name="page" type="string" default="" required="false" />
		<cfargument name="con_id" type="numeric" default="0" required="false" />
		<cfargument name="fuseAction" type="string" default="" required="false" />

		<cfset var getContent = "" />

		<cfquery name="getContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT top (1) con_id, con_menuTitle, con_title, con_intro, con_body, con_fuseAction, con_isMenu, con_menuArea, con_menuOrder, con_active, con_type, con_gloryBox, con_leftMenuArea, con_approved, con_link, con_metaDescription, con_metaKeywords, con_parentID, con_childListType, con_background, con_gallery, con_attach1, con_attach2, con_attach3, con_attach1Desc, con_attach2Desc, con_attach3Desc, 
<!--- 				img_id, img_title, img_altText, img_name --->

				(
					SELECT img_id 
					FROM wwwImage 
						INNER JOIN wwwcontent_image ON coi_image = img_id 
							AND coi_content = wwwContent.con_id
							AND img_type = 'main'
				) as img_id,
				(
					SELECT img_title
					FROM wwwImage 
						INNER JOIN wwwcontent_image ON coi_image = img_id 
							AND coi_content = wwwContent.con_id
							AND img_type = 'main'
				) as img_title,
				(
					SELECT img_name 
					FROM wwwImage 
						INNER JOIN wwwcontent_image ON coi_image = img_id 
							AND coi_content = wwwContent.con_id
							AND img_type = 'main'
				) as img_name,
				(
					SELECT img_altText
					FROM wwwImage 
						INNER JOIN wwwcontent_image ON coi_image = img_id 
							AND coi_content = wwwContent.con_id
							AND img_type = 'main'
				) as img_altText,
				gbx_name
			FROM wwwContent
				LEFT OUTER JOIN wwwGloryBox on con_background = gbx_id
<!--- 				LEFT OUTER JOIN wwwContent_Image on con_id = coi_content
				LEFT OUTER JOIN wwwImage on coi_image = img_id
					AND img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Main" list="false" /> --->
			WHERE 1 = 1

				<cfif arguments.con_id is 0 and not len(arguments.page) and not len(arguments.fuseAction)>
					AND 1 = 0
				</cfif>

				<cfif arguments.con_id gt 0>
					AND con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
				<cfelseif len(arguments.page)>
					AND con_sanitise = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#" list="false" />
				<cfelseif len(arguments.fuseAction)>
					AND con_fuseAction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseAction#" list="false" />
				</cfif>

		</cfquery>

		<cfreturn getContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/2/2009 --->
	<cffunction name="getAllContent" output="false" access="public" returntype="any" hint="I return all the content in the system, grouped by their menu area">

		<cfargument name="mna_id" type="numeric" default="0" required="false" />
		<cfargument name="showUnapprovedOnly" type="string" default="0" required="false" />
		<cfargument name="approved" type="string" default="" required="false" />
		<cfargument name="con_type" type="string" default="" required="false" />
		<cfargument name="excludeContent" type="string" default="" required="false" />
		<cfargument name="fastFind" type="string" default="" required="false" />
		<cfargument name="menuArea" type="string" default="" required="false" />

		<cfset var getAllContent = "" />

		<cfquery name="getAllContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mna_id, mna_title, mna_order,
				con_id, con_type, con_menuTitle, con_title, con_link, con_isMenu, con_menuOrder, con_fuseAction, con_active, con_approved, con_sanitise, con_childListType
			FROM wwwContent
				LEFT OUTER JOIN wwwMenuArea on con_menuArea = mna_id
			WHERE 1 = 1

				<cfif arguments.mna_id gt 0>
					AND mna_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mna_id#" list="false" />
				</cfif>

				<cfif yesNoFormat(arguments.approved)>
					AND con_approved = 1
				</cfif>

				<cfif yesNoFormat(arguments.showUnapprovedOnly)>
					AND con_approved = 0
				</cfif>

				<cfif listLen(arguments.con_type)>
					AND con_type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="true" />)
				</cfif>

				<cfif listLen(arguments.excludeContent)>
					AND con_id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.excludeContent#" list="true" />)
				</cfif>

				<cfif len(arguments.fastFind)>
					AND (
						con_title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
						OR
						con_body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
					)
				</cfif>

				<cfif val(arguments.menuArea) gt 0>
					AND mna_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menuArea#" list="true" />)
				</cfif>

			<!--- GROUP BY mna_id, mna_title, con_id, con_menuTitle, con_title, con_isMenu, con_menuOrder, con_fuseAction, con_active, con_approved, con_type --->
			ORDER BY con_type, mna_order, con_parentID, con_menuOrder
		</cfquery>

		<cfreturn getAllContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="contentSave" output="false" access="public" returntype="any" hint="I save the details of the edited content page, including the image upload mechanism">

		<cfargument name="con_isMenu" type="string" default="0" required="false" />
		<cfargument name="con_active" type="string" default="0" required="false" />
		<cfargument name="con_approved" type="string" default="0" required="false" />
		<cfargument name="old_con_approved" type="string" default="0" required="false" />

		<cfset var fileName = "" />
		<cfset var newFileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileNameSanitise = "" />
		<cfset var imageInterpolation = "highQuality" />
		<cfset var imageCounter = arguments.contentImageCount />
		<cfset var img_id = "" />
		<cfset var img_title = "" />
		<cfset var img_altText = "" />
		<cfset var updateImage = "" />
		<cfset var updateImageOrder = "" />
		<cfset var updateContent = "" />
		<cfset var addContent = "" />
		<cfset var attach1File = "" />
		<cfset var attach2File = "" />
		<cfset var attach3File = "" />

		<cfset arguments.con_isMenu = yesNoFormat(arguments.con_isMenu) />
		<cfset arguments.con_active = yesNoFormat(arguments.con_active) />
		<cfset arguments.con_approved = yesNoFormat(arguments.con_approved) />
		<cfset arguments.old_con_approved = yesNoFormat(arguments.old_con_approved) />

		<cfif len(arguments.con_attach1)>
			
			<cffile action="upload" filefield="con_attach1" destination="#application.imageUploadPath#attachments/" nameconflict="makeUnique">
			<cfset attach1File = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />
			<cffile action="rename" source="#application.imageUploadPath#attachments/#cffile.ServerFile#" destination="#application.imageUploadPath#attachments/#attach1File#" />

		</cfif>

		<cfif len(arguments.con_attach2)>
			
			<cffile action="upload" filefield="con_attach2" destination="#application.imageUploadPath#attachments/" nameconflict="makeUnique">
			<cfset attach2File = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />
			<cffile action="rename" source="#application.imageUploadPath#attachments/#cffile.ServerFile#" destination="#application.imageUploadPath#attachments/#attach2File#" />

		</cfif>

		<cfif len(arguments.con_attach3)>
			
			<cffile action="upload" filefield="con_attach3" destination="#application.imageUploadPath#attachments/" nameconflict="makeUnique">
			<cfset attach3File = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />
			<cffile action="rename" source="#application.imageUploadPath#attachments/#cffile.ServerFile#" destination="#application.imageUploadPath#attachments/#attach3File#" />

		</cfif>

		<cfif arguments.con_id gt 0>

			<cfquery name="updateContent"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwContent SET
					con_menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_menuTitle#" list="false" />,
					con_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_title#" list="false" />,
					con_body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_body#" list="false" />,
					con_intro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_intro#" list="false" />,
					con_isMenu = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_isMenu#" list="false" />,
					con_menuArea = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuArea#" list="false" />,
					con_menuOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuOrder#" list="false" />,
					con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.con_parentID)#" list="false" />,
					con_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_active#" list="false" />,
					con_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="false" />,
					con_link = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_link#" list="false" />,
					con_metaDescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaDescription#" list="false" />,
					con_metaKeywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaKeywords#" list="false" />,
					con_childListType = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_childListType#" list="false" />,
					con_background = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_background#" list="false" />,
					
					<cfif len(attach1File)>
						con_attach1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attach1File#" list="false" />,
					</cfif>
					
					con_attach1Desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach1Desc#" list="false" />,
					
					<cfif len(attach2File)>
						con_attach2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attach2File#" list="false" />,
					</cfif>
					
					con_attach2Desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach2Desc#" list="false" />,
					
					<cfif len(attach3File)>
						con_attach3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attach3File#" list="false" />,
					</cfif>
					
					con_attach3Desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach3Desc#" list="false" />


					<cfif arguments.old_con_approved neq arguments.con_approved>
						, con_approved = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_approved#" list="false" />
						<cfif arguments.con_approved>
							, con_approvedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
							, con_approvedDate = getDate()
						</cfif>
					</cfif>

				WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addContent"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwContent	(
					con_menuTitle,
					con_title,
					con_body,
					con_intro,
					con_isMenu,
					con_menuArea,
					con_menuOrder,
					con_active,
					con_type,
					con_sanitise,
					con_parentID,
					con_link,
					con_approved,
					con_metaDescription,
					con_metaKeywords,
					con_childListType,
					con_background,
					
					<cfif len(attach1File)>
						con_attach1,
					</cfif>
					
					con_attach1Desc,
					
					<cfif len(attach2File)>
						con_attach2,
					</cfif>
					
					con_attach2Desc,
					
					<cfif len(attach3File)>
						con_attach3,
					</cfif>
					
					con_attach3Desc


					<cfif arguments.con_approved>
						, con_approvedBy
						, con_approvedDate
					</cfif>

				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_menuTitle#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_body#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_intro#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_isMenu#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuArea#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_menuOrder#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_type#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sanitise(arguments.con_title)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.con_parentID)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_link#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.con_approved#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaDescription#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_metaKeywords#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_childListType#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_background#" list="false" />,
					
					<cfif len(attach1File)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attach1File#" list="false" />,
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach1Desc#" list="false" />,
					
					<cfif len(attach2File)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attach2File#" list="false" />,
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach2Desc#" list="false" />,
					
					<cfif len(attach3File)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attach3File#" list="false" />,
					</cfif>
					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_attach3Desc#" list="false" />


					<cfif arguments.con_approved>
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
						, getDate()
					</cfif>
				)
				SELECT SCOPE_IDENTITY() AS contentID
			</cfquery>

			<cfset arguments.con_id = addContent.contentID />

		</cfif>

		<!--- content images --->
		<cfloop from="1" to="3" index="thisLoop">

			<cfif len(evaluate("arguments.img_name#thisLoop#"))>

				<cffile action="upload" filefield="img_name#thisLoop#" destination="#application.imageUploadPath#/" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

				<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
				<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

				<cffile action="rename" source="#application.imageUploadPath#/#fileName#" destination="#application.imageUploadPath#/#fileNameSanitise#">

				<cfset newFileName = cffile.serverFileName & '_672.' & cffile.serverFileExt />
				<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_672.' & cffile.serverFileExt />

				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#/#FileNameSanitise#" />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />

				<cfset ImageSetAntialiasing(imageInMem) />

				<cfset ImageResize(imageInMem, 672, "", imageInterpolation) />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset finalWidth = imageCR.width />
				<cfset finalHeight = imageCR.height />
				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#/#newFileNameSanitise#" overwrite="yes" />

				<!--- add new image to database for this content --->

				<cftransaction>

					<cfset imageCounter = imageCounter + 1 />

					<cfquery name="addImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwImage (
							img_title,
							img_name,
							img_type,
							img_altText,
							img_height,
							img_width,
							img_origName,
							img_origHeight,
							img_origWidth
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.img_title#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Content" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.img_altText#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#finalHeight#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#finalWidth#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#origHeight#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#origWidth#" list="false" />
						)

						SELECT SCOPE_IDENTITY() AS imageID
					</cfquery>

					<cfquery name="addGalleryImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwContent_Image (
							coi_content,
							coi_image,
							coi_order
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#imageCounter#" list="false" />
						)
					</cfquery>

				</cftransaction>

			</cfif>

		</cfloop>

		<cfloop from="1" to="#arguments.contentImageCount#" index="thisImage">
			
			<cfif isDefined("arguments.imgDelete#thisImage#")>

				<cfset img_id = evaluate("arguments.imgID#thisImage#") />

				<cfquery name="deleteContentImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwContent_Image
					WHERE coi_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND coi_content = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
				</cfquery>

			<cfelse>

				<cfset img_id = evaluate("arguments.imgID#thisImage#") />
				<cfset img_title = evaluate("arguments.imgTitle#thisImage#") />
				<cfset img_altText = evaluate("arguments.imgAltText#thisImage#") />
				<cfset img_order = evaluate("arguments.imgOrder#thisImage#") />

				<cfquery name="updateImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwImage SET
						img_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_title#" list="false" />,
						img_altText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_altText#" list="false" />
					WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
				</cfquery>

				<cfquery name="updateImageOrder" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwContent_Image SET
						coi_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_order#" list="false" />
					WHERE coi_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND coi_content = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_id#" list="false" />
				</cfquery>

			</cfif>

		</cfloop>

		<!--- header images --->
		<cfloop from="1" to="3" index="thisLoop">

			<cfset imageCounter = 0 />

			<cfif len(evaluate("arguments.himg_name#thisLoop#"))>

				<cffile action="upload" filefield="himg_name#thisLoop#" destination="#application.imageUploadPath#" nameconflict="makeUnique">
	
				<cfset fileName = cffile.serverFileName & '.' & cffile.serverFileExt />
				<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />
	
				<cffile action="rename" source="#application.imageUploadPath#/#fileName#" destination="#application.imageUploadPath#/#fileNameSanitise#">

				<!--- add new image to database for this content --->

				<cftransaction>

					<cfset imageCounter = imageCounter + 1 />

					<cfquery name="addImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwImage (
							img_title,
							img_name,
							img_type,
							img_altText,
							img_height,
							img_width,
							img_origName,
							img_origHeight,
							img_origWidth
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.himg_title#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Header" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.himg_altText#thisLoop#')#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="60" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="932" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="60" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="932" list="false" />
						)

						SELECT SCOPE_IDENTITY() AS imageID
					</cfquery>

					<cfquery name="addGalleryImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwContent_Image (
							coi_content,
							coi_image,
							coi_order
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#imageCounter#" list="false" />
						)
					</cfquery>

				</cftransaction>

			</cfif>

		</cfloop>

		<cfloop from="1" to="#arguments.headerImageCount#" index="thisImage">

			<cfif isDefined("arguments.himgDelete#thisImage#")>

				<cfset img_id = evaluate("arguments.himgID#thisImage#") />

				<cfquery name="deleteContentImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwContent_Image
					WHERE coi_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND coi_content = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
				</cfquery>

			<cfelse>

				<cfset img_id = evaluate("arguments.himgID#thisImage#") />
				<cfset img_title = evaluate("arguments.himgTitle#thisImage#") />
				<cfset img_altText = evaluate("arguments.himgAltText#thisImage#") />
				<cfset img_order = evaluate("arguments.himgOrder#thisImage#") />

				<cfquery name="updateImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwImage SET
						img_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_title#" list="false" />,
						img_altText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#img_altText#" list="false" />
					WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
				</cfquery>

				<cfquery name="updateImageOrder" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					UPDATE wwwContent_Image SET
						coi_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_order#" list="false" />
					WHERE coi_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND coi_content = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.con_id#" list="false" />
				</cfquery>

			</cfif>

		</cfloop>

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="sanitise" returntype="string" output="false" hint="I remove all non-alphnumeric characters from a string">

		<cfargument name="String" type="string" required="yes"/>

		<cfset var ResultString = arguments.String/>

		<cfset ResultString = ReReplace(LCase(ResultString), "[^a-z0-9]+", "-", "all")/>
		<cfset ResultString = ReReplace(ResultString, "^[\-]+", "")/>
		<cfset ResultString = ReReplace(ResultString, "[\-]+$", "")/>

		<cfreturn ResultString/>

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBoxes" output="false" access="public" returntype="query" hint="I return all the glory box files in the system">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />
		<cfargument name="gbx_type" type="string" default="" required="false" />

		<cfset var getGloryBoxes = "" />

		<cfquery name="getGloryBoxes" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_id, gbx_title, gbx_name, gbx_type, gbx_type, gbx_active
			FROM wwwGloryBox
			WHERE 1 = 1
				AND gbx_type = 'Image'
			
				<!--- <cfif arguments.gbx_active> --->
					AND gbx_active = 1
				<!--- </cfif> --->

			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBoxes />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBoxesDefault" output="false" access="public" returntype="query" hint="I return all the glory box files in the system">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />
		<cfargument name="gbx_type" type="string" default="" required="false" />

		<cfset var getGloryBoxes = "" />

		<cfquery name="getGloryBoxes" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_title as imageTitle, gbx_name as imageName
			FROM wwwGloryBox
			WHERE 1 = 1
			
				<cfif arguments.gbx_active>
					AND gbx_active = 1
				</cfif>
				
				<cfif len(arguments.gbx_type)>
					AND gbx_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />
				</cfif>
				
			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBoxes />

	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getGloryBox" output="false" access="public" returntype="query" hint="I return a glory box based on id">

		<cfargument name="gbx_id" type="numeric" default="0" required="true" />

		<cfset var getGloryBox = "" />

		<cfquery name="getGloryBox" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gbx_id, gbx_title, gbx_name, gbx_type, gbx_active
			FROM wwwGloryBox
			WHERE gbx_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gbx_id#" list="false" />
			ORDER BY gbx_title
		</cfquery>

		<cfreturn getGloryBox />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="gloryBoxSave" output="false" access="public" returntype="any" hint="I save the details about the glory box">

		<cfargument name="gbx_active" type="boolean" default="0" required="false" />

		<cfset var updateGloryBox = "" />
		<cfset var addGloryBox = "" />
		<cfset var fileName = "" />
		<cfset var imageInterpolation = "highPerformance" />

		<cfif arguments.gbx_id gt 0>

			<cfquery name="updateGloryBox"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwGloryBox SET
					gbx_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_title#" list="false" />,
					gbx_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_name#" list="false" />,
					gbx_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />,
					gbx_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gbx_active#" list="false" />
				WHERE gbx_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gbx_id#" list="false" />
			</cfquery>

		<cfelseif len(arguments.gbx_name)>

			<cffile action="upload" filefield="gbx_name" destination="#application.imageUploadPath#gloryBox" nameconflict="makeUnique">

			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath#gloryBox/#fileName#" destination="#application.imageUploadPath#gloryBox/#fileNameSanitise#">

			<cfset newFileName = cffile.serverFileName & '_1024.' & cffile.serverFileExt />
			<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_1024.' & cffile.serverFileExt />

			<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#gloryBox/#FileNameSanitise#" />

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset origWidth = imageCR.width />
			<cfset origHeight = imageCR.height />

			<cfset ImageSetAntialiasing(imageInMem) />

			<cfset ImageResize(imageInMem, "1024", "", imageInterpolation) />
			
<!--- 
			<cfset ImageCrop(imageInMem, "0", "0", "665", "311") />
 --->

			<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

			<cfset finalWidth = imageCR.width />
			<cfset finalHeight = imageCR.height />

			<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#gloryBox/#newFileNameSanitise#" overwrite="yes" />

<!--- 
			<cffile action="upload" filefield="gbx_name" destination="#application.imageUploadPath#gloryBox/" nameconflict="makeUnique" accept="application/x-shockwave-flash">
			<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
 --->

			<cfquery name="addGloryBox"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwGloryBox	(
					gbx_title,
					gbx_name,
					gbx_type
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newFileNameSanitise#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbx_type#" list="false" />
				)
			</cfquery>

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletters" output="false" access="public" returntype="query" hint="i return all of the newsletters in the system">

		<cfset var getNewsletters = "" />

		<cfquery name="getNewsletters" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT nsl_id, nsl_title, nsl_dateEntered
			FROM wwwNewsletter
			ORDER BY nsl_dateEntered DESC
		</cfquery>

		<cfreturn getNewsletters />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletter" output="false" access="public" returntype="query" hint="i return all of the newsletters in the system">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var getNewsletter = "" />

		<cfquery name="getNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT nsl_id, nsl_title, nsl_body, nsl_dateEntered
			FROM wwwNewsletter
			WHERE nsl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
		</cfquery>

		<cfreturn getNewsletter />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="getNewsletterContent" output="false" access="public" returntype="query" hint="I return the content that is attached to a newsletter">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var getNewsletterContent = "" />

		<cfquery name="getNewsletterContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_menuTitle, con_title, con_body, con_menuOrder, con_type, con_sanitise, con_fuseAction, con_link,
				img_id, img_name, img_title, img_altText, img_height, img_width
			FROM wwwContent
				INNER JOIN wwwNewsletter_Content ON con_id = nlc_content
					AND con_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Content" list="false" />
				LEFT OUTER JOIN wwwContent_Image on con_id = coi_content
				LEFT OUTER JOIN wwwImage on coi_image = img_id
			WHERE nlc_newsletter = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
			ORDER BY nlc_order
		</cfquery>

		<cfreturn getNewsletterContent />

	</cffunction>

	<!--- Author: Rafe - Date: 10/8/2009 --->
	<cffunction name="newsletterSave" output="false" access="public" returntype="numeric" hint="I save the newsletter and send back the ID">

		<cfargument name="nsl_id" type="numeric" default="0" required="true" />

		<cfset var addNewsletter = "" />
		<cfset var updateNewsletter = "" />
		<cfset var newsletterID = arguments.nsl_id />

		<cfif arguments.nsl_id gt 0>

			<cfquery name="updateNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwNewsletter SET
					nsl_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_title#" list="false" />,
					nsl_body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_body#" list="false" />
				WHERE nsl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwNewsletter (
					nsl_title,
					nsl_body
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nsl_body#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS newsletterID
			</cfquery>

			<cfset newsletterID = addNewsletter.newsletterID />

		</cfif>
		
		<cfparam name="arguments.contentList" default="" />
		
		
			<cftransaction>
				
				<!--- remove all existing content in the newsletter then add back only items in the contentlist --->
				<cfquery name="removeNSLContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwNewsletter_Content
					WHERE nlc_newsletter = <cfqueryparam cfsqltype="cf_sql_integer" value="#newsletterID#" list="false" />
				</cfquery>
			
				<cfloop list="#arguments.contentList#" index="thisContent">
					<cfquery name="addNSLContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
						INSERT INTO wwwNewsletter_Content (
							nlc_newsletter,
							nlc_content
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#newsletterID#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#thisContent#" list="false" />
						)
					</cfquery>
				</cfloop>
			
			</cftransaction>



		<cfif arguments.con_id gt 0>

			<cfquery name="addNewsletterContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwNewsletter_Content (
					nlc_newsletter,
					nlc_content
					<cfif isNumeric(nlc_order)>
						, nlc_order
					</cfif>
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#newsletterID#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />
					<cfif isNumeric(nlc_order)>
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nlc_order#" list="false" />
					</cfif>
				)
			</cfquery>

		</cfif>

		<cfreturn newsletterID />

	</cffunction>

	<!--- Author: Rafe - Date: 10/13/2009 --->
	<cffunction name="newsletterSend" output="false" access="public" returntype="any" hint="I send a newsletter to the select group">

		<cfargument name="nsl_id" type="numeric" default="" required="true" />
		<cfargument name="grp_id" type="string" default="" required="true" />
		<cfargument name="int_id" type="string" default="" required="false" />
		<cfargument name="cou_id" type="string" default="" required="false" />
		<cfargument name="fastfind" type="string" default="" required="false" />

		<cfset var addSentNewsletter = "" />
		<cfset var getMembers = application.memberObj.getMembers(fastfind=arguments.fastfind,groupList=arguments.grp_id,validEmail=1,interestList=arguments.int_id,countryList=arguments.cou_id) />
		<cfset var thisGroup = "" />
		
		<cfparam name="arguments.resend" default="0" />
		
		<cfif not arguments.resend>
			
			<cfquery name="getRecipients" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				SELECT mnl_member
				FROM member_newsletter
				WHERE mnl_newsletter = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
			</cfquery>
			
			<cfif getRecipients.recordCount>
				<cfset recipientList = valueList(getRecipients.mnl_member) />
				
				<cfquery name="getMembers" dbtype="query">
					SELECT *
					FROM getMembers
					WHERE mem_id NOT IN (
						#recipientList#
					)
				</cfquery>
			</cfif>
			
		</cfif>

		<cfloop query="getMembers">
			
			<cfset emailContent = displayNewsletter(arguments.nsl_id) />
			
			<cfmail to="rafe@asianvhm.com" from="res@balisentosa.com" subject="Sentosa Newsletter" type="html">
				#emailContent#
			</cfmail>

			<cfquery name="addSentNewsletter" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO member_newsletter (
					mnl_member,
					mnl_newsletter
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#mem_id#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nsl_id#" list="false" />
				)
			</cfquery>

		</cfloop>

		<cfreturn getMembers.recordCount />

	</cffunction>

	<!--- Author: rafe - Date: 12/7/2009 --->
	<cffunction name="getContentParents" output="false" access="public" returntype="query" hint="I return a query with the content that can be parents">
		
		<cfset var getContentParents = "" />
		
		<cfquery name="getContentParents" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_menuTitle
			FROM wwwContent
			WHERE con_menuArea = 16
				AND con_parentID = 0
		</cfquery>
		
		<cfreturn getContentParents />
		
	</cffunction>
	
	<!--- Author: rafe - Date: 3/7/2010 --->
	<cffunction name="getNonMenuParents" output="false" access="public" returntype="query" hint="I return a query with content that can be a parent, but isn't on the main menu">
		
		<cfset var getNonMenuParents = "" />
		
		<cfquery name="getNonMenuParents" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_menuTitle
			FROM wwwContent
			WHERE con_id NOT IN (
				SELECT con_id
				FROM wwwContent
				WHERE con_menuArea = 16
					AND con_parentID = 0
			)
			ORDER BY con_menuTitle
		</cfquery>
		
		<cfreturn getNonMenuParents />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="displayGloryBoxForm" output="false" access="public" returntype="string" hint="I return the form for adding / updating glory box items">
		
		<cfargument name="gbx_id" type="numeric" default="0" required="false" />
	
		<cfset var gloryBoxForm = "" />
		<cfset var qGloryBox = getGloryBox(arguments.gbx_id) />
		
		<cfsaveContent variable="gloryBoxForm">
			
			<cfoutput>
				
				<table id="formTable">

					<form action="#request.myself#web.gloryBoxList" method="post" enctype="multipart/form-data">
			
						<input type="hidden" name="gbx_id" value="#qGloryBox.gbx_id#" />
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Background</div></td>
						</tr>
			
						<tr>
							<td class="leftForm">Title</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="gbx_title" value="#qGloryBox.gbx_title#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Type</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="gbx_type" style='width:250px'>
									<option value="Image"<cfif qGloryBox.gbx_type is "Image"> selected</cfif>>Image</option>
									<!--- <option value="Flash"<cfif qGloryBox.gbx_type is "Flash"> selected</cfif>>Flash</option> --->
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">File</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<cfif qGloryBox.gbx_id gt 0>
									<!--- #qGloryBox.gbx_name# --->
									<img src="#application.imagePath#glorybox/#qGloryBox.gbx_name#" width="300" />
									<input type="hidden" name="gbx_name" value="#qGloryBox.gbx_name#" />
								<cfelse>
									<input type="file" name="gbx_name" value="" /><br />
									<em>All images will be resized to 1024 px wide</em>
								</cfif>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Active</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="gbx_active" value="1"<cfif qGloryBox.gbx_active is 1> checked</cfif>>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
			
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button" />
							</td>
						</tr>
			
					</form>
			
				</table>
				
			</cfoutput>
			
		</cfsaveContent>
		
		<cfreturn gloryBoxForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="displayGloryBoxList" output="false" access="public" returntype="string" hint="I return a list of all the gloryboxes in the system">
		
		<cfset var gloryBoxList = "" />
		<cfset var qGloryBoxes = getGloryBoxes() />
		
		<cfsaveContent variable="gloryBoxList">
			<cfoutput>
				<table id="dataTable">

					<tr class="tableHeader">
						<td colspan="4">
							<div class="tableTitle">Glory Box List</div>
							<div class="showAll">#qGloryBoxes.recordCount# Records</div>
						</td>
					</tr>
			
					<tr>
						<th style="text-align:center;">ID</th>
						<th>Title</th>
						<th>Name</th>
						<th>Type</th>
						<th>Active</th>
					</tr>
			
					<cfloop query='qGloryBoxes'>
			
						<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
							<td align="center"><a href="#request.myself#web.gloryBoxList&gbx_id=#gbx_id#">#gbx_id#</a></td>
							<td><a href="#request.myself#web.gloryBoxList&gbx_id=#gbx_id#">#gbx_title#</a></td>
							<td>#gbx_name#</td>
							<td>#gbx_type#</td>
							<td><cfif gbx_active is 1>Yes<cfelse>No</cfif></td>
						</tr>
			
					</cfloop>
			
				</table>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn gloryBoxList />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="gloryBox" output="false" access="public" returntype="string" hint="I return the glory box images">
		
		<cfargument name="page" type="string" default="" required="false" />
		<cfargument name="con_id" type="numeric" default="0" required="false" />
		<cfargument name="fuseAction" type="string" default="" required="false" />

		<cfset var qContent = "" />
		<cfset var contentID = "0" />
		<!--- <cfset var qGloryBoxes = getGloryBoxes(active=1) /> --->
		<cfset var qGloryBoxes = "" />
		<cfset var gloryBox = "" />
		
		<cfif len(arguments.page)>
			<cfset qContent = getContent(page=arguments.page) />
		<cfelseif len(arguments.fuseAction)>
			<cfset qContent = getContent(fuseAction=arguments.fuseAction) />
		<cfelseif len(request.fuseAction)>
			<cfset qContent = getContent(fuseAction=request.fuseAction) />
		</cfif>
		
		<cfif qContent.recordCount>
			<cfset contentID = qContent.con_id />
		</cfif>

		<cfsaveContent variable="gloryBox">
			<cfoutput>
				<ul id="featured">
					<cfloop query="qGloryBoxes">
						<li>
							<img src="#application.imagePath#gloryBox/#gbx_name#" alt="#gbx_title#" width="932" height="160" />
						</li>
					</cfloop>
				</ul>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn gloryBox />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/1/2010 --->
	<cffunction name="getGloryMessage" output="false" access="public" returntype="query" hint="I return a query with the current glory message">
		
		<cfset var getGloryMessage = "" />
		
		<cfquery name="getGloryMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT TOP(1) gbm_title, gbm_link, gbm_linkText
			FROM wwwGloryBoxMessage
		</cfquery>
		
		<cfreturn getGloryMessage />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/1/2010 --->
	<cffunction name="displayGloryMessageForm" output="false" access="public" returntype="string" hint="I return the form for adding / updating glory box items">
		
		<cfset var gloryMessageForm = "" />
		<cfset var qGloryMessage = getGloryMessage() />
		
		<cfsaveContent variable="gloryMessageForm">
			
			<cfoutput>
				
				<table id="formTable">

					<form action="#request.myself#web.gloryMessage" method="post">
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Glory Box Message</div></td>
						</tr>
			
						<tr>
							<td class="leftForm">Title</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="gbm_title" value="#qGloryMessage.gbm_title#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Link</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="gbm_link" value="#qGloryMessage.gbm_link#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Link Text</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="gbm_linkText" value="#qGloryMessage.gbm_linkText#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button" />
							</td>
						</tr>
			
					</form>
			
				</table>
				
			</cfoutput>
			
		</cfsaveContent>
		
		<cfreturn gloryMessageForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/1/2010 --->
	<cffunction name="gloryMessageSave" output="false" access="public" returntype="any" hint="I save the details about the glory message">
		
		<cfset var gloryMessageRemove = "" />
		<cfset var gloryMessageSave = "" />
		
		<cfquery name="gloryMessageRemove" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			DELETE FROM wwwGloryBoxMessage
		</cfquery>
		
		<cfquery name="gloryMessageSave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			INSERT INTO wwwGloryBoxMessage (
				gbm_title,
				gbm_link,
				gbm_linkText
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbm_title#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbm_link#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gbm_linkText#" list="false" />
			)
		</cfquery>
		
	</cffunction>

	<!--- Author: rafe - Date: 3/2/2010 --->
	<cffunction name="getChildContent" output="false" access="public" returntype="query" hint="I return a query with all the child content for this page">
		
		<cfargument name="parentID" type="numeric" default="0" required="true" />
	
		<cfset var getChildContent = "" />
		
		<cfquery name="getChildContent" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT con_id, con_type, con_title, con_menuTitle, con_link, con_sanitise, con_fuseAction, con_body
			FROM wwwContent
			<cfif arguments.parentID neq 0>
				WHERE con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentID#" list="false" />
			<cfelse>
				WHERE 1 = 0
			</cfif>
		
				AND con_active = 1
		</cfquery>
		
		<cfreturn getChildContent />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/2/2010 --->
	<cffunction name="displaySitemap" output="false" access="public" returntype="string" hint="I return a sitemap for public consumption">
		
		<cfset var displaySitemap = "" />
		<cfset var qMenu = application.menuObj.getMenu(active=1,menuArea="16") />
		<cfset var qSubMenu = application.menuObj.getSubMenus() />
		
		<cfsaveContent variable="displaySitemap">
			<cfoutput>
				<ul>
					<li>
				<ul>
				
					<cfloop query="qMenu">
					
						<li style="margin-top: 15px">
						
							<cfif qMenu.con_type is "Content" and not len(qMenu.con_fuseAction)>
								<a href="#request.myself#content.display&page=#qMenu.con_sanitise#">#ucase(qMenu.con_menuTitle)#</a>
							<cfelseif qMenu.con_type is "Content" and len(qMenu.con_fuseAction)>
								<a href="#request.myself##qMenu.con_fuseAction#&page=#qMenu.con_sanitise#">#ucase(qMenu.con_menuTitle)#</a>
							<cfelseif qMenu.con_type is "Link">
								<a href="#qMenu.con_link#">#ucase(qMenu.con_menuTitle)#</a>
							</cfif>
													
							<cfquery name="qThisSubMenu" dbType="query">
								SELECT *
								FROM qSubMenu
								WHERE con_parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qMenu.con_id#" list="false" />
								ORDER BY con_menuOrder
							</cfquery>
							
							<cfif qThisSubMenu.recordCount>
								<ul>
									<cfloop query="qThisSubMenu">
										<li style="margin-top: 5px"> -
											<cfif qThisSubMenu.con_type is "Content" and not len(qThisSubMenu.con_fuseAction)>
												<a href="#request.myself#content.display&page=#qThisSubMenu.con_sanitise#">#qThisSubMenu.con_menuTitle#</a>
											<cfelseif qThisSubMenu.con_type is "Content" and len(qThisSubMenu.con_fuseAction)>
												<a href="#request.myself##qThisSubMenu.con_fuseAction#&page=#qThisSubMenu.con_sanitise#">#qThisSubMenu.con_menuTitle#</a>
											<cfelseif qThisSubMenu.con_type is "Link">
												<a href="#qThisSubMenu.con_link#">#qThisSubMenu.con_menuTitle#</a>
											</cfif>
										</li>
									</cfloop>
								</ul>
							</cfif>
								
						</li>
						
					</cfloop>
					
				</ul>
				</li>
				</ul>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn displaySitemap />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/8/2010 --->
	<cffunction name="displayNewsletter" output="false" access="public" returntype="string" hint="I return the newsletter">
		
		<cfargument name="nsl_id" type="numeric" default="0" required="false" />
		
		<cfset var displayNewsletter = "" />
		<cfset var qNewsletter = getNewsletter(arguments.nsl_id) />
		<cfset var qNewsletterContent = getNewsletterContent(arguments.nsl_id) />
		
		<cfsaveContent variable="displayNewsletter">
			<cfoutput>
				<STYLE type="text/css">
				   * {
						font-family: Verdana;
						color: ##333333;
						font-size: 11px; 
						white-space: normal;
					}
				</STYLE>
				<table cellpadding="0" cellspacing="0" width="930">
					<tr>
						<td width="699"><img src="#application.baseURL#assets/images/upload/newsletter/newsletterHeadLeft.png" /></td>
						<td width="231"><img src="#application.baseURL#assets/images/upload/newsletter/newsletterHeadRight.png" /></td>
					</tr>
					<tr>
						<td width="699"><img src="#application.baseURL#assets/images/upload/newsletter/newsletterGlory.jpg" /></td>
						<td width="231" bgColor="##9E9462">
							<ul>
							<cfloop query="qNewsletterContent">
								<cfif len(con_menuTitle)><li style="color: white">#con_menuTitle#</li></cfif>
							</cfloop>
							</ul>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="padding:20px 20px 20px 20px; border-left-style: solid; border-bottom-style: solid; border-right-style: solid; border-width: 1px;">
							<h2>#qNewsletter.nsl_title#</h2>
							
							<p>#qNewsletter.nsl_body#</p>
							
							<hr>
							
							<cfloop query="qNewsletterContent">
								
								<cfquery name="getThisImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
									SELECT img_id, img_name
									FROM wwwImage
										INNER JOIN wwwContent_Image on img_id = coi_image
									WHERE coi_content = <cfqueryparam cfsqltype="cf_sql_integer" value="#qNewsletterContent.con_id#" list="false" />
										AND img_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="Main" list="false" />
								</cfquery>
								
								<cfif getThisImage.recordCount>
							 		<img src="#application.baseURL#assets/images/upload/#getThisImage.img_name#" style="float: left; padding-right:10px" width="150" />
								</cfif>
								
								<h3>#con_title#</h3>
								
								<p>#listGetAt(con_body,1,"/")#/p></p>
								
								<p>
									<cfif qNewsletterContent.con_type is "Content" and not len(qNewsletterContent.con_fuseAction)>
										<a href="#application.baseURL#index.cfm?fuseaction=content.display&page=#qNewsletterContent.con_sanitise#">Click here for more information.</a>
									<cfelseif qNewsletterContent.con_type is "Content" and len(qNewsletterContent.con_fuseAction)>
										<a href="#application.baseURL#index.cfm?fuseaction=#qNewsletterContent.con_fuseAction#&page=#qNewsletterContent.con_sanitise#">Click here for more information.</a>
									<cfelseif qChildContent.con_type is "Link">
										<a href="#qNewsletterContent.con_link#">Click here for more information.</a>
									</cfif>
								</p>
								
								<div style="clear:both"></div>
								
								<hr style="margin-top:10px;margin-bottom:10px">
						
							</cfloop>
							
						</td>
					</tr>
				</table>

			</cfoutput>
		</cfsaveContent>
		
		<!--- <cfmail to="rafe@asianvhm.com" from="res@balisentosa.com" subject="#qNewsletter.nsl_title#" type="html">
			#displayNewsletter#
		</cfmail> --->
		
		<cfreturn displayNewsletter />
		
	</cffunction>

	<!--- Author: rafe - Date: 9/27/2010 --->
	<cffunction name="displayPano" output="false" access="public" returntype="string" hint="I return a pano">
		
		<cfargument name="panoSWF" type="string" default="seasentosa_sunset.swf" required="false" />
		
		<cfset var panoString = "" />
		
		<cfsaveContent variable="panoString">
			<cfoutput>
			
<!--- 				<style type="text/css"> 
					<!--
					##apDiv1 {
						position:absolute;
						left:50px;
						top:50;
						height:400px;
						z-index:1;
						width: 672;
						background-color: ##FFFFFF;
					}
					-->
					</style> 
					<script src="Scripts/swfobject_modified.js" type="text/javascript"></script>  --->
				<script type="text/javascript" src="assets/js/swfobject.js"></script>
				<script type="text/javascript">
					swfobject.registerObject("myFlashContent", "9.0.0");
				</script>
				
				<ul>
					<li>
						<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="672" height="450" id="myFlashContent">
							<param name="movie" value="assets/images/tours/#arguments.panoSWF#" />
							<!--[if !IE]>-->
							<object type="application/x-shockwave-flash" data="assets/images/tours/#arguments.panoSWF#" width="672" height="450">
							<!--<![endif]-->
								<a href="http://www.adobe.com/go/getflashplayer">
									<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
								</a>
							<!--[if !IE]>-->
							</object>
							<!--<![endif]-->
						</object>
<!--- 					<div id="apDiv1"> 
					  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="672" height="400" align="middle" id="FlashID" title="Beach View"> 
					    <param name="movie" value="assets/images/tours/seasentosa_sunset.swf" /> 
					    <param name="quality" value="high" /> 
					    <param name="wmode" value="opaque" /> 
					    <param name="swfversion" value="6.0.65.0" /> 
					    <!-- This param tag prompts users with Flash Player 6.0 r65 and higher to download the latest version of Flash Player. Delete it if you donÕt want users to see the prompt. --> 
					    <param name="expressinstall" value="Scripts/expressInstall.swf" /> 
					    <param name="allowfullscreen" value="true" /> 
					    <param name="BGCOLOR" value="##FFFFFF" /> 
					    <!-- Next object tag is for non-IE browsers. So hide it from IE using IECC. --> 
					    <!--[if !IE]>--> 
					    <object data="assets/images/tours/seasentosa_sunset.swf" type="application/x-shockwave-flash" width="672" height="400" align="middle"> 
					      <!--<![endif]--> 
					      <param name="quality" value="high" /> 
					      <param name="wmode" value="opaque" /> 
					      <param name="swfversion" value="6.0.65.0" /> 
					      <param name="expressinstall" value="Scripts/expressInstall.swf" /> 
					      <param name="allowfullscreen" value="true" /> 
					      <param name="BGCOLOR" value="##FFFFFF" /> 
					      <!-- The browser displays the following alternative content for users with Flash Player 6.0 and older. --> 
					      <div> 
					        <h4>Content on this page requires a newer version of Adobe Flash Player.</h4> 
					        <p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p> 
					      </div> 
					      <!--[if !IE]>--> 
					    </object> 
					    <!--<![endif]--> 
					  </object> 
					</div>  --->

<!--- 					<script type="text/javascript"> 
					<!--
					swfobject.registerObject("FlashID");
					//-->
					</script> --->
					
					</li>
					
				</ul>
			
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn panoString />
		
	</cffunction>

</cfcomponent>
















