<cfcomponent hint="I am the property component functions" output="false">

	<!--- Author: Rafe - Date: 28/1/2010 --->
	<cffunction name="displayListingSearch" output="false" access="public" returntype="string" hint="I display the search form for members">

<!--- 		<cfargument name="beds" type="string" default="" required="false" />
		<cfargument name="lst_id" type="string" default="" required="false" /> --->

		<cfargument name="fastFind" type="string" default="" required="false" />

		<cfset var propertySearch = "" /><!--- 
		<cfset var qListingStatuses = getListingStatuses() /> --->

		<cfsaveContent variable="propertySearch">

			<cfoutput>

				<table id="formTable">

					<form action="#request.myself#property.propertyList" method="post">

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Property Search</div></td>
						</tr>
<!--- 

						<tr>
							<td class="leftForm">Beds</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="beds" style="width:250px">
									<option value="0">-</option>
									<cfloop from="1" to="3" index="thisBed">
										<option value="#thisBed#"<cfif arguments.beds is thisBed> selected</cfif>>#thisBed#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="leftForm">Status</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="lst_id" style="width:250px">
									<option value="0">-</option>
									<cfloop query="qListingStatuses">
										<option value="#qListingStatuses.lst_id#"<cfif qListingStatuses.lst_id is arguments.lst_id> selected</cfif>>#qListingStatuses.lst_title#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
 --->

						<tr>
							<td class="leftForm">Fast Find</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" value="#arguments.fastFind#" name="fastFind" style="width:250px" />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<cfif cookie.prf_id eq 1 or cookie.prf_id eq 2>
							<tr>
								<td class="leftForm">Export Results?</td>
								<td class="whiteGutter">&nbsp;</td>
								<td>
									<input type="checkbox" name="propertyExport" value="1" />
								</td>
								<td class="whiteGutter">&nbsp;</td>
								<td class="rightForm">&nbsp;</td>
							</tr>
						</cfif>

						<tr>
							<td class="leftForm">Download PDF</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<a href="SalesListings.pdf">Click here for PDF</a>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Search" name="search" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</form>

				</table>

			</cfoutput>

		</cfsaveContent>

		<cfreturn propertySearch />

	</cffunction>

	<!--- Author: rafe - Date: 1/28/2010 --->
	<cffunction name="getListingStatuses" output="false" access="public" returntype="query" hint="I return all the listing statuses">
		
		<cfset var getListingStatuses = "" />
		
		<cfquery name="getListingStatuses" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT lst_id, lst_title
			FROM listingStatus
			ORDER BY lst_order
		</cfquery>
		
		<cfreturn getListingStatuses />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/28/2010 --->
	<cffunction name="displayListings" output="false" access="public" returntype="string" hint="I return a list of listings for display">
		<!--- 
		<cfargument name="beds" type="numeric" default="0" required="false" />
		<cfargument name="lst_id" type="numeric" default="0" required="false" />	
	 --->
	 	<cfargument name="fastFind" type="string" default="" required="false" />
	 
		<cfset var qListings = "" />
		<cfset var displayListings = "" />
		
		<!--- <cfset qListings = getListings(beds=arguments.beds,lst_id=arguments.lst_id) /> --->
		<cfset qListings = getListings(fastFind=arguments.fastFind) />
		
		<cfsaveContent variable="displayListings">
			<cfoutput>
				 
				<table id="dataTable">
			
					<tr class="tableHeader">
						<td colspan="8">
							<div class="tableTitle">Property List</div>
							<div class="showAll">#qListings.recordCount# Records</div>
						</td>
					</tr>
			
					<tr>
						<th style="text-align:center;">ID</th>
						<th style="text-align:center;">Unit</th>
						<th style="text-align:center;">Type</th>
						<th style="text-align:center;">Block</th>
						<th style="text-align:center;">Price List</th>
						<th>Description</th>
						<th>Availability</th>
						<cfif cookie.prf_id is 1>
							<th style="text-align:center;">Sale Price</th>
						</cfif>
					</tr>
			
					<cfloop query="qListings">
						
<!--- 						<cfquery name="getPrice" dbType="query">
							SELECT spr_price
							FROM request.currentStagePricing
							WHERE spr_beds = #qListings.pro_beds#
						</cfquery> --->
			
						<tr <cfif currentRow mod 2 eq 0>class="darkData"<cfelse>class="lightData"</cfif>>
							<td align="center"><a href="#request.myself#property.propertyForm&pro_id=#pro_id#">#pro_id#</a></td>
							<td align="center">#pro_unitNumber#</td>
							<td align="center">#pro_type#</td>
							<td align="center">#pro_building#</td>
							<td align="center">$#numberFormat(pro_price)#</td>
							<td>#pro_description#</td>
							<td>#pro_availability#</td>
							<cfif cookie.prf_id is 1>
								<td align="center"><cfif val(pro_soldPrice) gt 0>$#numberFormat(val(pro_soldPrice))#</cfif></td>
							</cfif>
						</tr>
			
					</cfloop>
			
				</table>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn displayListings />
	
	</cffunction>
	
	<!--- Author: rafe - Date: 1/28/2010 --->
	<cffunction name="getListings" output="false" access="public" returntype="query" hint="I return the listings based on search params">
		
<!--- 		<cfargument name="beds" type="numeric" default="0" required="false" />
		<cfargument name="lst_id" type="numeric" default="0" required="false" /> --->
		<cfargument name="fastFind" type="string" default="" required="false" />
	
		<cfset var getListings = "" />
		
<!--- 		<cfquery name="getListings" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT lis_id,
				pro_id, pro_building, pro_unitNumber, pro_floor, pro_beds, pro_baths, pro_carspaces, pro_outlook,
				lst_id, lst_title
			FROM listing
				INNER JOIN property on lis_property = pro_id
				INNER JOIN listingStatus on lis_status = lst_id
			WHERE 1 = 1
			
				<cfif arguments.beds gt 0>
					AND pro_beds = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.beds#" list="false" />
				</cfif>
				
				<cfif arguments.lst_id gt 0>
					AND lst_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lst_id#" list="false" />
				</cfif>
				
			ORDER BY lis_id
		</cfquery> --->
		
		<cfquery name="getListings" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT pro_id, pro_unitNumber, pro_type, pro_building, pro_price, pro_description, pro_availability, pro_soldPrice
			FROM property
			WHERE 1 = 1
				<cfif len(arguments.fastFind)>
					AND (
						pro_type like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
						OR 
						pro_description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
						OR 
						pro_availability like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fastFind#%" list="false" />
					)
				</cfif>
			ORDER BY pro_building, pro_unitNumber, pro_price
		</cfquery>
		
		<cfreturn getListings />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/28/2010 --->
	<cffunction name="getProperty" output="false" access="public" returntype="query" hint="I return the details about a given property (pro_id)">
		
		<cfargument name="pro_id" type="numeric" default="0" required="false" />
<!--- 		<cfargument name="lis_id" type="numeric" default="0" required="false" /> --->
	
		<cfset var getProperty = "" />
		
<!--- 		<cfquery name="getProperty" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT lis_id, 
				pro_building, pro_unitNumber, pro_floor, pro_beds, pro_baths, pro_carspaces, pro_outlook, pro_description,
				lst_id, lst_title
			FROM listing
				INNER JOIN property on lis_property = pro_id
				INNER JOIN listingStatus on lis_status = lst_id
			WHERE 1 = 1
			
				<cfif arguments.pro_id gt 0>
					AND pro_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_id#" list="false" />
				</cfif>
				
				<cfif arguments.lis_id gt 0>
					AND lis_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lis_id#" list="false" />
				</cfif>
				
		</cfquery> --->
		
		<cfquery name="getProperty" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT pro_id, pro_unitNumber, pro_type, pro_building, pro_price, pro_description, pro_availability, pro_soldPrice
			FROM  property
			WHERE 1 = 1
			
				<cfif arguments.pro_id gt 0>
					AND pro_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_id#" list="false" />
				<cfelse>
					AND 1 = 0
				</cfif>
				
		</cfquery>
		
		<cfreturn getProperty />
		
	</cffunction>

	<!--- Author: rafe - Date: 1/28/2010 --->
	<cffunction name="propertySave" output="false" access="public" returntype="any" hint="I save the details for a property">
		
		<cfargument name="pro_id" type="numeric" default="0" required="false" />
	
		<cfset var propertySave = "" />
		<cfset var listingSave = "" />
		<cfset var propertyID = "" />
		
		<cfif arguments.pro_id lte 0>
			<!--- 
			<cfquery name="propertySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO property (
					pro_building,
					pro_unitNumber,
					pro_floor,
					pro_beds,
					pro_baths,
					pro_carspaces,
					pro_outlook,
					pro_description,
					pro_modifiedBy
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_building#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_unitNumber#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_floor#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_beds#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_baths#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_carspaces#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_outlook#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_description#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS propertyID
			</cfquery>
			 --->
			<cfquery name="propertySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO property (
					pro_unitNumber, 
					pro_type, 
					pro_building, 
					pro_price, 
					pro_description, 
					pro_availability,
					pro_soldPrice
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_unitNumber)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_type#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_building#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_price)#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_description#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_availability#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_soldPrice)#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS propertyID
			</cfquery>
			
			<cfset propertyID = propertySave.propertyID />
			
	<!--- 		<cfquery name="listingSave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO listing (
					lis_property,
					lis_status,
					lis_planPricing, 
					lis_active,
					lis_modifiedBy
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#propertyID#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lst_id#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
				)
			</cfquery> --->
			
		<cfelse>
			
			<!--- <cfquery name="propertySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE property SET
					pro_building = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_building#" list="false" />,
					pro_unitNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_unitNumber#" list="false" />,
					pro_floor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_floor#" list="false" />,
					pro_beds = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_beds#" list="false" />,
					pro_baths = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_baths#" list="false" />,
					pro_carspaces = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_carspaces#" list="false" />,
					pro_outlook = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_outlook#" list="false" />,
					pro_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_description#" list="false" />,
					pro_modifiedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
				WHERE pro_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_id#" list="false" />
			</cfquery> --->
			
			<cfquery name="propertySave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE property SET
					pro_unitNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_unitNumber)#" list="false" />, 
					pro_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_type#" list="false" />, 
					pro_building = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_building#" list="false" />, 
					pro_price = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_price)#" list="false" />, 
					pro_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_description#" list="false" />, 
					pro_availability = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_availability#" list="false" />,
					pro_soldPrice = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.pro_soldPrice)#" list="false" />
				WHERE pro_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_id#" list="false" />
			</cfquery>
			
			<!--- 
			<cfquery name="listingSave" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE listing SET
					lis_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lst_id#" list="false" />,
					lis_modifiedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.usr_id#" list="false" />
				WHERE lis_property = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_id#" list="false" />
					AND lis_active = 1
			</cfquery>
		 --->
		</cfif>
		
	</cffunction>

	<!--- Author: rafe - Date: 2/2/2010 --->
	<cffunction name="displayPaymentSchedule" output="false" access="public" returntype="string" hint="I return a view on exchange details">
		
		<cfargument name="lis_id" type="numeric" default="0" required="false" />
	
		<cfset var displayPaymentSchedule = "" />
		<cfset var qProperty = getProperty(lis_id=arguments.lis_id) />
		
		<cfsaveContent variable="displayPaymentSchedule">
			
			<cfoutput>
				
				<cfquery name="getPrice" dbType="query">
					SELECT spr_price
					FROM request.currentStagePricing
					WHERE spr_beds = #qProperty.pro_beds#
				</cfquery>
				
				<h1>Property: Apt #qProperty.pro_unitNumber#, Floor #qProperty.pro_floor#, Building #qProperty.pro_building# - $#numberFormat(getPrice.spr_price)#</h1>
				 
				<cfset pay1 = 10000 />
				<cfset pay2 = evaluate((getPrice.spr_price*0.4)-10000) />
				<cfset pay3 = getPrice.spr_price*0.25 />
				<cfset pay4 = getPrice.spr_price*0.25 />
				<cfset pay5 = getPrice.spr_price - pay1 - pay2 - pay3 - pay4 />
				
				<table id="formTable">

					<tr class="tableHeader">
						<td colspan='5'><div class="tableTitle">Payment Schedule</div></td>
					</tr>

					<tr>
						<td class="leftForm">Deposit</td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">#numberFormat(pay1)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>

					<tr>
						<td class="leftForm">Due Dilligence (#dateFormat(dateAdd('d','30',now()),'mmm d')#)</td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">#numberFormat(pay2)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>

					<tr>
						<td class="leftForm">Due at 30% Complete</td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">#numberFormat(pay3)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>

					<tr>
						<td class="leftForm">Due at 60% Complete</td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">#numberFormat(pay4)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>

					<tr>
						<td class="leftForm">Due at Project Complete</td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">#numberFormat(pay5)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>
					
					<tr>
						<td class="leftForm"><strong>Total Paid</strong></td>
						<td class="whiteGutter">&nbsp;</td>
						<td>
							<div style="width:50px" align="right">$#numberFormat(pay1 + pay2 + pay3 + pay4 + pay5)#</div>
						</td>
						<td class="whiteGutter">&nbsp;</td>
						<td class="rightForm">&nbsp;</td>
					</tr>
					
					<tr>
						<td class="formFooter" colspan="5">
							&nbsp;
						</td>
					</tr>

				</table>

			</cfoutput>
			
		</cfsaveContent>
		
		<cfreturn displayPaymentSchedule />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/5/2010 --->
	<cffunction name="displayExchangeForm" output="false" access="public" returntype="string" hint="I return the form for registering an exchange">
		
		<cfargument name="lis_id" type="numeric" default="0" required="false" />
	
		<cfset var displayExchangeForm = "" />
		<cfset var qAgents = application.usersObj.getAgents() />
		<cfset var qUsers = application.usersObj.getUsers() />
		<cfset var qMembers = application.memberObj.getMembers() />
		<cfset var qProperty = getProperty(lis_id=arguments.lis_id) />
		
		<cfsaveContent variable="displayExchangeForm">
			<cfoutput>
							
				<cfquery name="getPrice" dbType="query">
					SELECT spr_price
					FROM request.currentStagePricing
					WHERE spr_beds = #qProperty.pro_beds#
				</cfquery>
				
				<h1>Property: Apt #qProperty.pro_unitNumber#, Floor #qProperty.pro_floor#, Building #qProperty.pro_building# - $#numberFormat(getPrice.spr_price)#</h1>
				
				<table id="formTable">
					
					<form action="#request.myself#property.exchangeDetails" method="post">

						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Exchange Details</div></td>
						</tr>
	
						<tr>
							<td class="leftForm">Buyer</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="member" style="width:250px">
									<cfloop query="qMembers">
										<option value="#mem_id#">#mem_firstname# #mem_surname#</option>
									</cfloop>
								</select>
								<a href="#request.myself#member.memberForm">Add New</a>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
		
						<tr>
							<td class="leftForm">In-house Agent</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="agent1" style="width:250px">
									<cfloop query="qAgents">
										<option value="#usr_id#">#usr_firstName# #usr_surname#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
	
						<tr>
							<td class="leftForm">On-shore Agent</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="agent2" style="width:250px">
									<option value="">-</option>
									<cfloop query="qAgents">
										<option value="#usr_id#">#usr_firstName# #usr_surname#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
	
						<tr>
							<td class="leftForm">Off-shore Agent</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="agent2" style="width:250px">
									<option value="">-</option>
									<cfloop query="qAgents">
										<option value="#usr_id#">#usr_firstName# #usr_surname#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
	<!--- 

						<tr>
							<td class="leftForm">Refer</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="refer1" style="width:250px">
									<option value="">-</option>
									<cfloop query="qAgents">
										<option value="#usr_id#">#usr_firstName# #usr_surname#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
 --->

						<tr>
							<td class="leftForm">Refer Fee</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<select name="intro1" style="width:250px">
									<option value="">-</option>
									<cfloop query="qUsers">
										<option value="#usr_id#">#usr_firstName# #usr_surname#</option>
									</cfloop>
								</select>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Submit" name="save" class="button" onMouseOver="this.className='buttonOver';" onMouseOut="this.className='button';">
							</td>
						</tr>

					</form>

				</table>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn displayExchangeForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 2/9/2010 --->
	<cffunction name="displayExchangeDetails" output="false" access="public" returntype="string" hint="I return the details about the exchange">
		
		<cfset var exchangeDetails = "" />
		
		<cfsaveContent variable="exchangeDetails">
			<cfoutput>
				#system.exchangeBreakdown#
				<cfdump var="#arguments#">
				<cfdump var="#request.qProjectSettings#">
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn exchangeDetails />
		
	</cffunction>

	<!--- Author: rafe - Date: 4/22/2010 --->
	<cffunction name="displayPropertyForm" output="false" access="public" returntype="string" hint="I return the form for editing a property">
		
		<cfargument name="pro_id" type="string" default="0" required="false" />
	
		<Cfset var displayPropertyForm = "" />
		<cfset var qProperty = getProperty(arguments.pro_id) />

		<cfsaveContent variable="displayPropertyForm">
			<cfoutput>
				
				<table id="formTable">
			
					<form action="#request.myself#property.propertyForm" method="post">
			
						<input type="hidden" name="pro_id" value="#arguments.pro_id#">
			
						<tr class="tableHeader">
							<td colspan='5'><div class="tableTitle">Property</td>
						</tr>
			
						<tr>
							<td class="leftForm">Unit Number</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_unitNumber" value="#qProperty.pro_unitNumber#" style='width:250px'>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Type</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_type" value="#qProperty.pro_type#" style='width:250px'>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Building</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_building" value="#qProperty.pro_building#" style='width:250px'>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>

						<tr>
							<td class="leftForm">Price</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_price" value="#qProperty.pro_price#" style='width:250px'>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Sold Price</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_soldPrice" value="#qProperty.pro_soldPrice#" style='width:250px'>
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Availability</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_availability" value="#qProperty.pro_availability#" style='width:250px' />
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="leftForm">Desc</td>
							<td class="whiteGutter">&nbsp;</td>
							<td>
								<input type="text" name="pro_description" value="#qProperty.pro_description#" style='width:250px' />
			
								<!--- <cfmodule template="/assets/tiny_mce/tinyMCE.cfm"
								  instanceName="pro_description"
								  value="#qProperty.pro_description#"
								  width="600"
								  height="100"
								  toolbarset="Basic" /> --->
			
							</td>
							<td class="whiteGutter">&nbsp;</td>
							<td class="rightForm">&nbsp;</td>
						</tr>
			
						<tr>
							<td class="formFooter" colspan="5">
								<input type="submit" value="Save" name='save' onMouseOver="this.className='buttonOver'" onMouseOut="this.className='button'" class="button">
							</td>
						</tr>
			
					</form>
			
				</table>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn displayPropertyForm />
		
	</cffunction>

</cfcomponent>















