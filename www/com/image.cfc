<cfcomponent hint="I hold the image functions" output="false">

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="showImage" output="false" access="public" returntype="string" hint="I return the html for an image tag, including a link to a larger image">

		<cfargument name="img_id" type="numeric" default="0" required="true" />
		<cfargument name="class" type="string" default="" required="false" />
		<cfargument name="showLink" type="boolean" default="1" required="false" />
		<cfargument name="path" type="string" default="" required="false" />
		<cfargument name="forceWidth" type="string" default="0" required="false" />

		<cfset var imgString = "" />
		<cfset var getImage = "" />

		<cfset getImage = getImageByID(img_id=arguments.img_id) />

		<cfoutput query="getImage">

			<cfsaveContent variable="imgString">

				<cfif len(getImage.img_origName) and arguments.showLink>
					<a href="#request.myself#content.showImage&img_id=#arguments.img_id#" target="_blank">
				</cfif>

				<img src="#application.imagePath##arguments.path#/#img_name#" target="_new" alt="#img_altText#"<cfif val(img_width)gt 0 and arguments.forceWidth is 0> width="#img_width#"<cfelseif arguments.forceWidth is 0> width="#arguments.forceWidth#"</cfif><cfif val(img_height)gt 0> width="#img_height#"</cfif><cfif len(arguments.class)> class="#arguments.class#"</cfif> />

				<cfif len(getImage.img_origName) and arguments.showLink>
					</a>
				</cfif>

			</cfsaveContent>

		</cfoutput>

		<cfreturn imgString />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="getImageByID" output="false" access="public" returntype="query" hint="I return a query with details for an image">

		<cfargument name="img_id" type="numeric" default="0" required="true" />

		<cfset var getImage = "" />

		<cfquery name="getImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT img_id, img_name, img_title, img_type, img_altText, img_height, img_width, img_origName, img_origHeight, img_origWidth
			FROM wwwImage
			WHERE img_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.img_id#" list="false" />
		</cfquery>

		<cfreturn getImage />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGalleries" output="false" access="public" returntype="query" hint="I return all the galleries">

		<cfargument name="active" type="string" default="1" required="false" />
		<cfargument name="gal_type" type="string" default="" required="false" />

		<cfset var getGalleries = "" />

		<cfquery name="getGalleries" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gal_id, gal_title, gal_active, gal_image, gal_type,
				(
					SELECT COUNT(1)
					FROM wwwGallery_Image
					WHERE gai_gallery = gal_id
				) AS imageCount
			FROM wwwGallery
			WHERE 1 = 1
			
				<cfif yesNoFormat(arguments.active)>
					AND gal_active = 1
				</cfif>
				
				<cfif len(arguments.gal_type) gt 0>
					AND gal_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_type#" list="false" />
				</cfif>
				
			ORDER BY gal_order, gal_title
		</cfquery>

		<cfreturn getGalleries />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGallery" output="false" access="public" returntype="query" hint="I return a gallery based on the ID">

		<cfargument name="gal_id" type="numeric" default="0" required="true" />

		<cfset var getGallery = "" />

		<cfquery name="getGallery" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT TOP(1) gal_id, gal_title, gal_active, gal_image, gal_type
			FROM wwwGallery
				<cfif arguments.gal_id gt 0>
					WHERE gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
				<cfelse>
					WHERE 1 = 0
				</cfif>
			ORDER BY gal_order
		</cfquery>

		<cfreturn getGallery />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="gallerySave" output="false" access="public" returntype="any" hint="i save the information for a cta">

		<cfargument name="gal_active" type="string" default="0" required="false" />

		<cfset var updateGallery = "" />
		<cfset var addGallery = "" />

		<cfset var imageInterpolation = "highPerformance" />

		<cfset arguments.gal_active = yesNoFormat(arguments.gal_active) />

		<cfif arguments.gal_id gt 0>

			<cfquery name="updateGallery"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwGallery SET
					gal_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_title#" list="false" />,
					gal_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gal_active#" list="false" />,
					gal_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_type#" list="false" />
				WHERE gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
			</cfquery>

		<cfelse>

			<cfquery name="addGallery"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwGallery	(
					gal_title,
					gal_active,
					gal_type
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.gal_active#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_type#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS galleryID
			</cfquery>

			<cfset arguments.gal_id = addGallery.galleryID />

		</cfif>

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="getGalleryImages" output="false" access="public" returntype="query" hint="I get all the images in a gallery">

		<cfargument name="gal_id" type="numeric" default="" required="true" />

		<cfset var getGalleryImages = "" />

		<cfquery name="getGalleryImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT gal_title,
				gai_order,
				img_id, img_title, img_name, img_height, img_width, img_altText, img_type, img_origName, img_origHeight, img_origWidth
			FROM wwwGallery
				INNER JOIN wwwGallery_Image ON gal_id = gai_gallery
					<cfif arguments.gal_id gt 0>
						AND gal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
					<cfelse>
						AND gal_order = 1
					</cfif>
				INNER JOIN wwwImage ON gai_image = img_id
			ORDER BY gai_order
		</cfquery>

		<cfreturn getGalleryImages />

	</cffunction>

	<!--- Author: Rafe - Date: 10/16/2009 --->
	<cffunction name="galleryImagesSave" output="false" access="public" returntype="any" hint="I save and update the images in a gallery">

		<cfset var fileName = "" />
		<cfset var newFileName = "" />
		<cfset var fileNameSanitise = "" />
		<cfset var newFileNameSanitise = "" />
		<cfset var imageInterpolation = "highPerformance" />
		<cfset var imageCounter = arguments.galleryImageCount />
		<cfset var img_id = "" />
		<cfset var img_title = "" />
		<cfset var img_altText = "" />
		<cfset var updateImage = "" />
		<cfset var updateImageOrder = "" />
		
		<cfset var qGallery = getGallery(arguments.gal_id) />
		
<!--- 		<cfdump var="#arguments#">
		<cfdump var="#qGallery#">
		<cfabort> --->

		<cfloop from="1" to="3" index="thisLoop">

			<cfif len(evaluate("arguments.img_name#thisLoop#"))>

				<cffile action="upload" filefield="img_name#thisLoop#" destination="#application.imageUploadPath#slideshow/" nameconflict="makeUnique" accept="image/gif, image/jpeg, image/jpg, image/pjpeg">

				<cfset FileName = cffile.serverFileName & '.' & cffile.serverFileExt />
				<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

				<cffile action="rename" source="#application.imageUploadPath#slideshow/#fileName#" destination="#application.imageUploadPath#slideshow/#fileNameSanitise#">

				<cfimage action="read" name="imageInMem" source="#application.imageUploadPath#slideshow/#FileNameSanitise#" />

				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset origWidth = imageCR.width />
				<cfset origHeight = imageCR.height />

				<cfset ImageSetAntialiasing(imageInMem) />
				
				<cfif qGallery.gal_type is "Villa For Sale">
					
					<cfif origWidth gt "665">
						<cfset ImageResize(imageInMem, "665", "", imageInterpolation) />
					</cfif>

				<cfelse><!--- standard gallery --->
				
					<cfset ImageResize(imageInMem, "665", "", imageInterpolation) />
	
					<cfset ImageCrop(imageInMem, "0", "0", "665", "311") />
	
				</cfif>
				
				<cfimage action="info" source="#imageInMem#" structName="ImageCR" />

				<cfset finalWidth = imageCR.width />
				<cfset finalHeight = imageCR.height />

				<cfset newFileName = cffile.serverFileName & '_665.' & cffile.serverFileExt />
				<cfset newFileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '_665.' & cffile.serverFileExt />
				
				<cfimage source="#imageInMem#" action="write" destination="#application.imageUploadPath#slideshow/#newFileNameSanitise#" overwrite="yes" />

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
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Slideshow" list="false" />,
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
						INSERT INTO wwwGallery_Image (
							gai_gallery,
							gai_image,
							gai_order
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#addImage.imageID#" list="false" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#imageCounter#" list="false" />
						)
					</cfquery>

				</cftransaction>

			</cfif>

		</cfloop>

		<cfloop from="1" to="#arguments.galleryImageCount#" index="thisImage">

			<cfif isDefined("arguments.imgDelete#thisImage#")>

				<cfset img_id = evaluate("arguments.imgID#thisImage#") />

				<cfquery name="deleteGalleryImage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM wwwGallery_Image
					WHERE gai_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND gai_gallery = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gal_id#" list="false" />
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
					UPDATE wwwGallery_Image SET
						gai_order = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_order#" list="false" />
					WHERE gai_image = <cfqueryparam cfsqltype="cf_sql_integer" value="#img_id#" list="false" />
						AND gai_gallery = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.gal_id#" list="false" />
				</cfquery>

			</cfif>

		</cfloop>

	</cffunction>

	<!--- Author: Rafe - Date: 10/22/2009 --->
	<cffunction name="getContentImages" output="false" access="public" returntype="query" hint="I return all the images for a content ID, optionally excluding a type (eg all except Main for putting at the bottom of a content page)">

		<cfargument name="con_id" type="numeric" default="" required="true" />
		<cfargument name="excludeType" type="string" default="Main" required="false" />

		<cfset var getContentImages = "" />

		<cfquery name="getContentImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT coi_order,
				img_id, img_title, img_name, img_height, img_width, img_altText, img_type, img_origName, img_origHeight, img_origWidth
			FROM wwwContent_Image
				INNER JOIN wwwContent ON coi_content = con_id
				INNER JOIN wwwImage ON coi_image = img_id
			WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />

				<cfif len(arguments.excludeType)>
					AND img_type NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeType#" list="true" />)
				</cfif>
				
			ORDER BY coi_order
		</cfquery>

		<cfreturn getContentImages />

	</cffunction>

	<!--- Author: Rafe - Date: 10/22/2009 --->
	<cffunction name="getContentImagesWeb" output="false" access="public" returntype="query" hint="I return all the images for a content ID, optionally excluding a type (eg all except Main for putting at the bottom of a content page)">

		<cfargument name="con_id" type="numeric" default="" required="true" />
		<cfargument name="excludeType" type="string" default="Main" required="false" />

		<cfset var getContentImages = "" />

		<cfquery name="getContentImages" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT img_title as imageTitle, img_name as imageName
			FROM wwwContent_Image
				INNER JOIN wwwContent ON coi_content = con_id
				INNER JOIN wwwImage ON coi_image = img_id
			WHERE con_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.con_id#" list="false" />

				<cfif len(arguments.excludeType)>
					AND img_type NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.excludeType#" list="true" />)
				</cfif>

		</cfquery>

		<cfreturn getContentImages />

	</cffunction>

	<!--- Author: rafe - Date: 2/14/2010 --->
	<cffunction name="displayGallery" output="false" access="public" returntype="string" hint="I return a list of galleries">
		
		<cfargument name="gal_id" type="numeric" default="0" required="false" />
		
		<cfset var displayGallery = "" />
		<cfset var qGallery = getGalleryImages(arguments.gal_ID) />
		
		<cfsaveContent variable="displayGallery">
			
			<cfoutput>
						
			 	<div class="maincontent">
			 	
			        <div class="gallery_photos">
			        
			        	<div id="slider2" class="sliderwrapper gallery_img"> 
			        	       
							<cfloop query="qGallery">        
				            	<div class="contentdiv">
				                  	<img src="#application.imagePath#slideshow/#img_name#" alt="" width="600" height="400" />
				              		<p>#img_title#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
				                </div>       
							</cfloop>  
							  
						</div>
			                
						<div id="paginate-slider2" class="gallery_img_list"> 
							  
							<ul style="list-style:none;">         
								<cfloop query="qGallery">    
						        	<li style="padding-right: 10px;padding-bottom: 10px"><a href="##" class="toc" style=""><img src="#application.imagePath#slideshow/#img_name#" alt="" width="43" height="36" style="border-style:solid;border-width:1px" /></a></li>
						        </cfloop>
						    </ul>    
						               
						</div>
			                
						<script type="text/javascript">                
						featuredcontentslider.init({
						    id: "slider2",  //id of main slider DIV
						    contentsource: ["inline", ""],  //Valid values: ["inline", ""] or ["ajax", "path_to_file"]
						    toc: "markup",  //Valid values: "##increment", "markup", ["label1", "label2", etc]
						    nextprev: ["", "Next"],  //labels for "prev" and "next" links. Set to "" to hide.
						    revealtype: "mouseover", //Behavior of pagination links to reveal the slides: "click" or "mouseover"
						    enablefade: [true, 0.1],  //[true/false, fadedegree]
						    autorotate: [true, 3000],  //[true/false, pausetime]
						    onChange: function(previndex, curindex){  //event handler fired whenever script changes slide
						        //previndex holds index of last slide viewed b4 current (1=1st slide, 2nd=2nd etc)
						        //curindex holds index of currently shown slide (1=1st slide, 2nd=2nd etc)
						    }
						})                
						</script>
			
					</div>
					
				</div>
	
			</cfoutput>
			
		</cfsaveContent>
		
		<cfreturn displayGallery />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/14/2010 --->
	<cffunction name="displayGalleryList" output="false" access="public" returntype="any" hint="">
		
		<cfset var galleryList = "" />
		<cfset var qGalleries = getGalleries(active=1,gal_type='Standard') />
		
		<cfsaveContent variable="galleryList">
			
			<cfoutput>
				
				<br /><br />
				<h3>PHOTO GALLERY</h3>
				
					<ul>
						<cfloop query="qGalleries">
							<li> <a href="#request.myself#accommodation.galleryList&gal_id=#qGalleries.gal_id#">#gal_title#</a></li>
						</cfloop>
					</ul>
		
			</cfoutput>
			
		</cfsaveContent>
		
		<cfreturn galleryList />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/12/2010 --->
	<cffunction name="displayGalleryForm" output="false" access="public" returntype="string" hint="I return a form for editing galleries">
		
		<cfargument name="gal_id" type="numeric" default="0" required="false" />
				
		<cfset var galleryForm = "" />
		<cfset var qGallery = getGallery(gal_id=arguments.gal_id) />
		
		<cfsaveContent variable="galleryForm">
			<cfoutput>
				<table id="formTable">

					<form action="#request.myself#web.galleryList" method="post" enctype="multipart/form-data">
			
						<input type="hidden" name="gal_id" value="#arguments.gal_id#" />
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Gallery</div></td>
						</tr>
			
						<tr>
							<td class="leftForm">Title</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="gal_title" value="#qGallery.gal_title#" style="width:250px" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Active</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="gal_active" value="1"<cfif yesNoFormat(qGallery.gal_active)> checked</cfif>>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			 
						<tr>
							<td class="leftForm">Type</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="gal_type" style="width:250px">
									<option value="Content"<cfif qGallery.gal_type is "Content"> selected</cfif>>Content</option>
									<option value="Standard"<cfif qGallery.gal_type is "Standard"> selected</cfif>>Standard</option>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>
			
					</form>
			
				</table>
				
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn galleryForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/12/2010 --->
	<cffunction name="adminGalleryList" output="false" access="public" returntype="any" hint="">
		
		<cfset var qGalleries = getGalleries() />
		<cfset var galleryList = "" />
		
		<cfsaveContent variable="galleryList">
			<cfoutput>
				<table id="dataTable">

					<tr class="tableHeader">
						<td colspan="5">
							<div class="tableTitle">Galleries</div>
							<div class="showAll">#qGalleries.recordCount# Records</div>
						</td>
					</tr>
			
					<tr>
						<th style="text-align:center;">ID</th>
						<th>Title</th>
						<th>Type</th>
						<th>Gallery</th>
						<th>Num Images</th>
						<th>Active</th>
					</tr>
			
					<cfloop query="qGalleries">
			
						<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
							<td align="center"><a href="#request.myself#web.galleryList&gal_id=#qGalleries.gal_id#">#qGalleries.gal_id#</a></td>
							<td><a href="#request.myself#web.galleryList&gal_id=#qGalleries.gal_id#">#qGalleries.gal_title#</a></td>
							<td>#qGalleries.gal_type#</td>
							<td><a href="#request.myself#web.galleryImagesForm&gal_id=#qGalleries.gal_id#">Edit Images</a></td>
							<td>#qGalleries.imageCount#</td>
							<td><cfif qGalleries.gal_active>Yes<cfelse>No</cfif></td>
						</tr>
			
					</cfloop>
			
				</table>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn galleryList />
		
	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getHeaders" output="false" access="public" returntype="query" hint="I return all the glory box files in the system">

		<cfargument name="hdr_active" type="boolean" default="0" required="false" />
		<cfargument name="hdr_type" type="string" default="" required="false" />

		<cfset var getHeaders = "" />

		<cfquery name="getHeaders" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT hdr_id, hdr_title, hdr_name, hdr_description, hdr_type, hdr_type, hdr_active
			FROM wwwHeader
			WHERE 1 = 1
				AND hdr_type = 'Image'
			
				<cfif arguments.hdr_active>
					AND hdr_active = 1
				</cfif>

			ORDER BY hdr_title
		</cfquery>

		<cfreturn getHeaders />

	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="displayHeaderList" output="false" access="public" returntype="string" hint="I return a list of all the Headers in the system">
		
		<cfset var HeaderList = "" />
		<cfset var qHeaders = getHeaders() />
		
		<cfsaveContent variable="HeaderList">
			<cfoutput>
				<table id="dataTable">

					<tr class="tableHeader">
						<td colspan="5">
							<div class="tableTitle">Header List</div>
							<div class="showAll">#qHeaders.recordCount# Records</div>
						</td>
					</tr>
			
					<tr>
						<th style="text-align:center;">ID</th>
						<th>Title</th>
						<th>Name</th>
						<th>Type</th>
						<th>Active</th>
					</tr>
			
					<cfloop query='qHeaders'>
			
						<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
							<td align="center"><a href="#request.myself#web.HeaderList&hdr_id=#hdr_id#">#hdr_id#</a></td>
							<td><a href="#request.myself#web.HeaderList&hdr_id=#hdr_id#">#hdr_title#</a></td>
							<td>#hdr_name#</td>
							<td>#hdr_type#</td>
							<td><cfif hdr_active is 1>Yes<cfelse>No</cfif></td>
						</tr>
			
					</cfloop>
			
				</table>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn HeaderList />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="displayHeaderForm" output="false" access="public" returntype="string" hint="I return the form for adding / updating glory box items">
		
		<cfargument name="hdr_id" type="numeric" default="0" required="false" />
	
		<cfset var HeaderForm = "" />
		<cfset var qHeader = getHeader(arguments.hdr_id) />
		
		<cfsaveContent variable="HeaderForm">
			
			<cfoutput>
				
				<table id="formTable">

					<form action="#request.myself#web.HeaderList" method="post" enctype="multipart/form-data">
			
						<input type="hidden" name="hdr_id" value="#qHeader.hdr_id#" />
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Header</div></td>
						</tr>
			
						<tr>
							<td class="leftForm">Title</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="hdr_title" value="#qHeader.hdr_title#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Description</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<textarea name="hdr_description" style="width:250px;height:50px">#qHeader.hdr_description#</textarea>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Type</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="hdr_type" style='width:250px'>
									<option value="Image"<cfif qHeader.hdr_type is "Image"> selected</cfif>>Image</option>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">File</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<cfif qHeader.hdr_id gt 0>
									<!--- #qHeader.hdr_name# --->
									<img src="#application.imagePath#Header/#qHeader.hdr_name#" width="300" />
									<input type="hidden" name="hdr_name" value="#qHeader.hdr_name#" />
								<cfelse>
									<input type="file" name="hdr_name" value="" /><br />
									<em>Images will not be resized, but will be displayed as 932px x 160px</em>
								</cfif>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Active</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="checkbox" name="hdr_active" value="1"<cfif qHeader.hdr_active is 1> checked</cfif>>
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
		
		<cfreturn HeaderForm />
		
	</cffunction>

	<!--- Author: Rafe - Date: 10/3/2009 --->
	<cffunction name="getHeader" output="false" access="public" returntype="query" hint="I return a glory box based on id">

		<cfargument name="hdr_id" type="numeric" default="0" required="true" />

		<cfset var getHeader = "" />

		<cfquery name="getHeader" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT hdr_id, hdr_title, hdr_description, hdr_name, hdr_type, hdr_active
			FROM wwwHeader
			WHERE hdr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hdr_id#" list="false" />
			ORDER BY hdr_title
		</cfquery>

		<cfreturn getHeader />

	</cffunction>

	<!--- Author: Rafe - Date: 10/4/2009 --->
	<cffunction name="HeaderSave" output="false" access="public" returntype="any" hint="I save the details about the glory box">

		<cfargument name="hdr_active" type="boolean" default="0" required="false" />

		<cfset var updateHeader = "" />
		<cfset var addHeader = "" />
		<cfset var fileName = "" />

		<cfif arguments.hdr_id gt 0>

			<cfquery name="updateHeader"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE wwwHeader SET
					hdr_title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_title#" list="false" />,
					hdr_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_name#" list="false" />,
					hdr_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_description#" list="false" />,
					hdr_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_type#" list="false" />,
					hdr_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.hdr_active#" list="false" />
				WHERE hdr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hdr_id#" list="false" />
			</cfquery>

		<cfelseif len(arguments.hdr_name)>

			<cffile action="upload" filefield="hdr_name" destination="#application.imageUploadPath#Header" nameconflict="makeUnique">

			<cfset fileName = cffile.serverFileName & '.' & cffile.serverFileExt />
			<cfset fileNameSanitise = application.contentObj.sanitise(cffile.serverFileName) & '.' & cffile.serverFileExt />

			<cffile action="rename" source="#application.imageUploadPath#header/#fileName#" destination="#application.imageUploadPath#header/#fileNameSanitise#">

			<cfquery name="addHeader"  datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO wwwHeader	(
					hdr_title,
					hdr_description,
					hdr_name,
					hdr_type
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_title#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_description#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileNameSanitise#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hdr_type#" list="false" />
				)
			</cfquery>

		</cfif>

	</cffunction>

	<!--- Author: rafe - Date: 2/19/2010 --->
	<cffunction name="header" output="false" access="public" returntype="string" hint="I return the glory box images">
		
		<cfargument name="con_id" type="numeric" default="0" required="false" />

		<cfset var qHeaders = getHeaders(hdr_active=1) />
		<cfset var header = "" />
		<cfset var qContentHeaders = getContentImages(con_id=arguments.con_id,excludeType='Main,Content') />
		
		<cfif not qContentHeaders.recordCount>
			<cfsaveContent variable="Header">
				<cfoutput>
					<ul id="featured">
						<cfloop query="qHeaders">
							<li>
								<img src="#application.imagePath#Header/#hdr_name#" alt="#hdr_title#" width="932" height="160" />
							</li>
						</cfloop>
					</ul>
				</cfoutput>
			</cfsaveContent>
		<cfelse>
			<cfsaveContent variable="Header">
				<cfoutput>
					<ul id="featured">
						<cfloop query="qContentHeaders">
							<li>
								<img src="#application.imagePath#/#img_name#" alt="#img_title#" width="932" height="160" />
							</li>
						</cfloop>
					</ul>
				</cfoutput>
			</cfsaveContent>
		</cfif>
		
		<cfreturn header />
		
	</cffunction>







</cfcomponent>
























