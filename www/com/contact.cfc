<cfcomponent hint="I am the system settings function" output="false">

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="displayFeedbackForm" output="false" access="public" returntype="string" hint="I display the feedback form">

		<cfargument name="feedbackSuccess" type="boolean" default="0" required="false" />

		<cfset var feedbackForm = "" />

		<cfoutput>

			<cfsaveContent variable="feedbackForm">
				
				<h3>Feedback Form</h3>

				<cfif yesNoFormat(arguments.feedbackSuccess)>

					<div>
						<p><strong>Thank you for contacting us.</strong></p>

						<p><strong>We will respond to your enqiry as soon as possible.</strong></p>
					</div>
					
				<cfelse>
				
					<p>To contact us electronically, please submit the on-line form. You will receive an immediate on-screen confirmation letting you know that we have received your questions, requests or comments. We will reply as soon as we can.</p>
	
					<p>Please note that all fields marked with the asterisk (*) are required fields.</p>
	
					<div class="formboxMain">
						<cfform action="index.cfm?fuseaction=contact.feedbackForm" name="newsletterForm">
							<p><label>Title</label><select><option>Mr</option><option>Mrs</option><option>Ms</option><option>Dr</option></select></p>
							<p><label>First Name*</label><cfinput required="yes" message="Please provide your first name." name="mem_firstName" type="text"></p>
							<p><label>Last Name*</label><cfinput required="yes" message="Please provide your last name." name="mem_surname" type="text"></p>
							<p><label>Email Address*</label><cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" type="text" /></p>
							<p><label>Feedback</label><textarea name="mes_body"></textarea></p>
							<p class="btn_submit"><input type="submit" value="submit" name="save" /></p>
						</cfform>
					</div>

				</cfif>
					
			</cfsaveContent>

			<cfreturn feedbackForm />

		</cfoutput>

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="feedbackFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the feedback form on the website">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="2") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Website Feedback Form Submission",mes_body=arguments.mes_body) />

			<cfset feedbackEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<cfreturn feedbackSuccess />

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="messageSave" output="false" access="public" returntype="any" hint="I save the feedback message into the database">

		<cfargument name="mem_id" type="numeric" default="0" required="false" />
		<cfargument name="mes_title" type="string" default="" required="false" />
		<cfargument name="mes_body" type="string" default="" required="false" />

		<cfset var addMessage = "" />

		<cfquery name="addMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			INSERT INTO Message (
				mes_title,
				mes_body,
				mes_member
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mes_title#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mes_body#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mem_id#" list="false" />
			)
			SELECT SCOPE_IDENTITY() AS messageID
		</cfquery>

		<cfreturn addMessage.messageID />

	</cffunction>

	<!--- Author: Rafe - Date: 10/7/2009 --->
	<cffunction name="messageEmail" output="false" access="public" returntype="any" hint="I email the feedback message to the site feedback email address">

		<cfargument name="mes_id" type="numeric" default="" required="false" />
		<cfargument name="toEmail" type="string" default="" required="false" />

		<cfset var emailSuccess = "0" />
		<cfset var getMessage = "" />

		<cfif len(arguments.toEmail)>

			<cfquery name="getMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				SELECT mes_title, mes_body, mes_member,
					mem_email
				FROM Message
					INNER JOIN Member on mes_member = mem_id
				WHERE mes_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes_id#" list="false" />
			</cfquery>

			<cfmail to="#arguments.toEmail#" bcc="#application.adminEmail#" from="#getMessage.mem_email#" subject="#getMessage.mes_title#">
				#mes_body#
			</cfmail>

		</cfif>

		<cfset emailSuccess = "1" />

		<cfreturn emailSuccess />

	</cffunction>

	<!--- Author: Rafe - Date: 11/9/2009 --->
	<cffunction name="displayFacilitiesForm" output="false" access="public" returntype="any" hint="">

		<cfargument name="facilitiesSuccess" type="boolean" default="0" required="false" />

		<cfset var facilitiesForm = "" />

		<cfoutput>

			<cfsaveContent variable="facilitiesForm">

				<cfif yesNoFormat(arguments.facilitiesSuccess)>

					<div>
						<p><strong>Thank you for contacting us.</strong></p>

						<p><strong>We will respond to your enqiry as soon as possible.</strong></p>
					</div>

				</cfif>

				<div align="center">

					<cfform name="feedbackForm" method="post" action="index.cfm?fuseaction=#arguments.fuseAction#" style="font-size: 1.2em;">

						<table style="border: medium none ;" border="0" cellpadding="0" cellspacing="6" width="400">

							<tbody>

								<tr>
									<td align="left"><strong>Title:</strong><br>
										<select name="mem_title" style="width: 300px;">
											<option value=""></option>
											<option value="Mr">Mr</option>
											<option value="Mrs">Mrs</option>
											<option value="Miss">Miss</option>
											<option value="Ms">Ms</option>
											<option value="Dr">Dr</option>
										</select>
									</td>
								</tr>

								<tr>
									<td align="left"><strong>First Name*:</strong><br><cfinput required="yes" message="Please provide your first name." name="mem_firstName" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Last Name*:</strong><br><cfinput required="yes" message="Please provide your last name." name="mem_surname" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Email Address*:</strong><br><cfinput validate="email" required="yes" message="Please enter a valid email address" name="mem_email" style="width: 300px;" type="text"></td>
								</tr>

								<tr>
									<td align="left"><strong>Requirements:</strong><br><textarea name="mes_body" style="width: 300px; height: 100px;"></textarea></td>
								</tr>

								<tr>
									<td align="left"><input value="Submit" name="save" style="width: 100px;" type="submit">&nbsp;<input value="Clear Form" style="width: 100px;" type="reset"></td>
								</tr>

							</tbody>

						</table>

					</cfform>

				</div>

			</cfsaveContent>

			<cfreturn facilitiesForm />

		</cfoutput>

	</cffunction>

	<!--- Author: Rafe - Date: 12/9/2009 --->
	<cffunction name="facilitiesFormSave" output="false" access="public" returntype="any" hint="">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<!--- <cftry> --->

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="10") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Website Event Enquiry Form Submission",mes_body=arguments.mes_body) />

			<cfset facilitiesEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<!--- 	<cfcatch>
			</cfcatch>

		</cftry> --->

		<cfreturn feedbackSuccess />

	</cffunction>
	
	<!--- Author: Rafe - Date: 12/9/2009 --->
	<cffunction name="newsletterFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the feedback form on the website">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<!--- <cftry> --->

			<cfset memberID = application.memberObj.memberSave(argumentCollection=arguments) />

			<cfset memberGroup = application.memberObj.memberGroupSave(mem_id=memberID, grp_id="2") />

			<cfset messageID = messageSave(mem_id=memberID,mes_title="Newsletter Sign-up") />

			<cfset feedbackEmail = messageEmail(mes_id=messageID,toEmail=application.feedbackEmail) />

			<cfset feedbackSuccess = "1" />

		<!--- 	<cfcatch>
			</cfcatch>

		</cftry> --->

		<cfreturn feedbackSuccess />

	</cffunction>

	<!--- Author: rafe - Date: 2/15/2010 --->
	<cffunction name="miniNewsLetterSave" output="false" access="public" returntype="numeric" hint="I save the newsletter subscription from the home page with only an email address and return a var indicating success">
		
		<cfargument name="memberEmail" type="string" default="" required="false" />
		
		<cfset var saveSuccess = "0" />
		<cfset var checkMember = "" />
		<cfset var removeGroup = "" />
		<cfset var addGroup = "" />
		<cfset var addMember = "" />
		
		<cfif len(arguments.memberEmail) gt 5>
		
			<cfquery name="checkMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				SELECT mem_id
				FROM member
				WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberEmail)#" list="false" />
			</cfquery>
			
			<cfif checkMember.recordCount>
				
				<cfquery name="removeGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					DELETE FROM member_group
					WHERE mgr_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkMember.mem_id#" list="false" />
						AND mgr_group = 1
				</cfquery>
				
				<cfquery name="addGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO member_group (
						mgr_member,
						mgr_group
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#checkMember.mem_id#" list="false" />,
						1
					)
				</cfquery>
				
			<cfelse>
			
				<cfquery name="addMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO member (
						mem_email
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.memberEmail)#" list="false" />
					)
					SELECT SCOPE_IDENTITY() AS memberID
				</cfquery>
			
				<cfquery name="addGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
					INSERT INTO member_group (
						mgr_member,
						mgr_group
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#addMember.memberID#" list="false" />,
						1
					)
				</cfquery>
				
			</cfif>
		
			<cfset saveSuccess = "1" />
		
		</cfif>
		
		<cfreturn saveSuccess />	
		
	</cffunction>

	<!--- Author: rafe - Date: 3/1/2010 --->
	<cffunction name="unsubscribe" output="false" access="public" returntype="string" hint="I unsubscribe a member based on email address">
		
		<cfargument name="email" type="string" default="" required="true" />
		
		<cfset var unsubscribe = "" />
		<cfset var unsubscribeCheck = "" />
		<cfset var unsubscribeStatus = "" />
		
		<!--- first check we have a member with this email address --->
		<cfquery name="unsubscribeCheck" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id
			FROM member
			WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" list="false" />
		</cfquery>
		
		<cfif unsubscribeCheck.recordCount>
			
			<cfquery name="unsubscribe" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE member SET
					mem_dnd = 1
				WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" list="false" />
			</cfquery>
			
			<cfset unsubscribeStatus = 1 />
			
		<cfelse>
			
			<cfset unsubscribeStatus = 0 />
			
		</cfif>
		
		<cfreturn unsubscribeStatus />
		
	</cffunction>

	<!--- Author: rafe - Date: 3/1/2010 --->
	<cffunction name="unsubscribeForm" output="false" access="public" returntype="string" hint="I provide a form to unsubscribe, or a message for a successful unsubscription.">
		
		<cfargument name="unsubscribeStatus" type="boolean" default="0" required="false" />
		
		<cfset var unsubscribeForm = "" />
		
		<cfsaveContent variable="unsubscribeForm">
			<cfoutput>
				<cfif arguments.unsubscribeStatus is 1>
					
					<h1>Unsubscribe Successful!</h1>
					
					<p>If at any time you wish to be part of our regular updates again, please sign up to our newsletter.</p>
					
				<cfelse>
				
					<h1>Unsubscribe</h1>
					
					<p>Please enter your email below and press the "Remove Me" button.</p>
					
					<div class="formboxMain">
						<cfform action="index.cfm?fuseaction=contact.unsubscribe" name="newsletterForm">
							<p><label>Email Address*</label><cfinput validate="email" required="yes" message="Please enter a valid email address" name="email" type="text" /></p>
							<p class="btn_submit"><input type="submit" value="remove me" name="save" /></p>
						</cfform>
					</div>
					
				</cfif>
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn unsubscribeForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 9/12/2010 --->
	<cffunction name="displayBuyerForm" output="false" access="public" returntype="string" hint="I return a form to allow buyers to register their details">
		
		<cfargument name="buyerSuccess" type="boolean" default="0" required="false" />

		<cfset var feedbackForm = "" />

		<cfoutput>

			<cfsaveContent variable="feedbackForm">

				<cfif yesNoFormat(arguments.buyerSuccess)>

		            <!--- <h2>CONTACT US</h2> --->
		               
					<ul>
						<li>
							<p><strong>Thank you for contacting us.</strong></p>

							<p><strong>We will respond to your enqiry as soon as possible.</strong></p>
						</li>
					</ul>
				     
				<cfelse>
				
					<script>
						$(document).ready(function(){
							
							$.validator.addMethod("defaultText", function(value, element) {
							    return value != element.defaultValue;
							}, "");
							
						  $("##buyerForm").validate({
						   rules: {
						     senderFirstName: {
						     	required: true,
						     	defaultText: true
						     },
						     senderLastName: {
						     	required: true,
						     	defaultText: true
						     },						     
						     senderEmail: {
						       required: true,
						       email: true
						     },
						     senderCountry: {
						     	required: true,
						     	defaultText: true
						     },
						     senderMsg: {
						     	required: true,
						     	defaultText: true
						     },
						     senderInt: {
						     	required: true
						     }
						     
						   },
						  messages: { 
						  	senderFirstName: "Please enter your first name",
						  	senderLastName: "Please enter your last name",
							senderEmail: "Please enter a valid email address",
							senderCountry: "Please enter your country",
							senderMsg: "Please enter a message",
							senderInt: "Please choose an interest"
							},
errorPlacement: function(error, element) { 
if ( element.is(":checkbox") ) 
error.appendTo ( element.parent().parent() ); 
else 
error.appendTo( element.parent() ); 
}
						  
						  });
						});
					</script>
				
					<div class="form_box">
						
		                <form action="index.cfm" id="buyerForm" name="buyerForm" method="post">
			                
			                <input type="hidden" name="fuseaction" value="contact.formsPage" />
			                
		                   <!---  <h2>CONTACT US</h2> --->
		                    
		                    <ul>
		                        <li>
		                            <input name="senderFirstName" id="senderFirstName" type="text" class="textinput" onfocus="if(this.value=='First Name') this.value=''" onblur="if(this.value=='') this.value='First Name'" value="First Name"/>
		                        </li>
		                        <li>
		                            <input name="senderLastName" id="senderLastName" type="text" class="textinput"  onfocus="if(this.value=='Last Name') this.value=''" onblur="if(this.value=='') this.value='Last Name'" value="Last Name"/>
		                        </li>
		                        <li>
		                            <input name="senderEmail" type="text" onfocus="if(this.value=='Email Address') this.value=''" onblur="if(this.value=='') this.value='Email Address'" value="Email Address" class="textinput  "/>
		                        </li>
		                        <li>
		                            <input name="senderPhone" type="text" onfocus="if(this.value=='Phone Number') this.value=''" onblur="if(this.value=='')this.value='Phone Number'"  value="Phone Number" class="textinput"/>
		                        </li>
		                        <li>
		                            <input name="senderAddr" type="text" onfocus="if(this.value=='Address') this.value=''" onblur="if(this.value=='') this.value='Address'" value="Address" class="textinput"/>
		                        </li>
		                        <li>
		                            <input name="senderCity" type="text" onfocus="if(this.value=='City') this.value=''" onblur="if(this.value=='') this.value='City'" value="City" class="textinput"/>
		                        </li>
		                        <li>
		                            <input name="senderCountry" id="senderCountry" type="text" onfocus="if(this.value=='Country') this.value=''" onblur="if(this.value=='')this.value='Country'" value="Country" class="textinput"/>
		                        </li>
		                        <li>
		                            <input name="senderHow" type="text" onfocus="if(this.value=='How did you hear about us?') this.value=''" onblur="if(this.value=='')this.value='How did you hear about us?'" value="How did you hear about us?" class="textinput"/>
		                        </li>
		                        <li> <span>INTERESTED IN?</span>
		                            <p>
		                                <input type="checkbox" name="senderInt" value="checkbox" id="CheckboxGroup1_0" class="check"/>
		                                <label>one bedroom</label>
		                                <input type="checkbox" name="senderInt" value="checkbox" id="CheckboxGroup1_1" class="check"/>
		                                <label>two bedroom</label>
		                                <input type="checkbox" name="senderInt" value="checkbox" id="CheckboxGroup1_2" class="check"/>
		                                <label>two bedbroom modular</label>
		                                <input type="checkbox" name="senderInt" value="checkbox" id="CheckboxGroup1_3" class="check"/>
		                                <label>penthouse</label>
		                            </p>
		                        </li>
		                        <li>
		                            <textarea name="senderMsg" id="senderMsg" cols="" rows="" onfocus="if(this.value='Your Message Here...')this.value=''" onblur="if(this.value=='')this.value='Your Message Here...'">Your Message Here...</textarea>
		                        </li>
		                        <li>
		                            <input name="saveBuyer" type="submit" class="input_button" value="SEND" />
									<!--- <input name="" type="button" class="input_button" value="RESET"/> --->
		                        </li>
		                    </ul>
		                    
		                </form>
		            </div>
		            
				</cfif>
					
			</cfsaveContent>

			<cfreturn feedbackForm />

		</cfoutput>

	</cffunction>

	<!--- Author: rafe - Date: 9/19/2010 --->
	<cffunction name="displayAgentLoginForm" output="false" access="public" returntype="string" hint="I display the form that allows agents to login">
		
		<cfset var agentLoginForm = "" />
		
		<cfsaveContent variable="agentLoginForm">
			<cfoutput>

				<h3>AGENT LOGIN</h3>
				
				<form name="" action="admin/index.cfm?fuseaction=login.doLogin">
				
					<ul>
						<li>
							<input name="username" type="text" class="input_text" onfocus="if(this.value=='USERNAME') this.value=''" onblur="if(this.value=='') this.value='USERNAME'" value="USERNAME" />
							<input name="password" type="password" class="input_name" onfocus="if(this.value=='PASSWORD') this.value=''" onblur="if(this.value=='') this.value='PASSWORD'" value="PASSWORD" />
						</li>
						<li class="last_button">
							<input name="agentLogin" type="submit" class="input_button" value="SEND" />
							<!--- <input name="" type="button" class="input_button" value="RESET"/> --->
						</li>
					</ul>
				
				</form>
		                    
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn agentLoginForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 9/19/2010 --->
	<cffunction name="displayOwnerLoginForm" output="false" access="public" returntype="string" hint="I display the form that allows owners to login">
		
		<cfset var ownerLoginForm = "" />
		
		<cfsaveContent variable="ownerLoginForm">
			<cfoutput>

                <h3>OWNER LOGIN</h3>
                
				<form name="" action="admin/index.cfm?fuseaction=login.doLogin">
				
	                <ul>
	                    <li>
	                        <input name="username" type="text" class="input_text" onfocus="if(this.value=='USERNAME') this.value=''" onblur="if(this.value=='') this.value='USERNAME'" value="USERNAME"/>
	                        <input name="password" type="password" class="input_name" onfocus="if(this.value=='PASSWORD') this.value=''" onblur="if(this.value=='') this.value='PASSWORD'" value="PASSWORD" />
	                    </li>
	                    <li>
	                        <input name="ownerLogin" type="submit" class="input_button" value="SEND" />
	                       <!---  <input name="" type="button" class="input_button" value="RESET"/> --->
	                    </li>
	                </ul>
				
				</form>
		                    
			</cfoutput>
		</cfsaveContent>
		
		<cfreturn ownerLoginForm />
		
	</cffunction>

	<!--- Author: rafe - Date: 9/19/2010 --->
	<cffunction name="displayContactDetails" output="false" access="public" returntype="string" hint="I return the contact details">
		
		<cfset var contactDetails = "" />
		
		<cfsaveContent variable="contactDetails">
			<cfoutput>
			
	            <div class="sea_sentosa">
	                <h2>SEA SENTOSA</h2>
	                <p>Sales Office. Jl. Oberoi and Echo Beach<br />
	                    Bali - Indonesia</p>
	                <p>Tel. +62.361.888.1234<br />
	                <a href="mailto:sales@seasentosa.com">sales@seasentosa.com</a></p>
	            </div>

			</cfoutput>
		</cfsaveContent>
		
		<cfreturn contactDetails />
		
	</cffunction>

	<!--- Author: rafe - Date: 9/19/2010 --->
	<cffunction name="buyerFormSave" output="false" access="public" returntype="any" hint="I save the results of submitting the buyer form on the website">

		<cfset var memberID = "" />
		<cfset var addMemberGroup = "" />
		<cfset var memberGroup = "" />
		<cfset var feedbackSuccess = "0" />
		<cfset var messageID = "" />

		<cfparam name="arguments.senderFirstName" default="" />
		<cfparam name="arguments.senderLastName" default="" />
		<cfparam name="arguments.senderEmail" default="" />
		<cfparam name="arguments.senderPhone" default="" />
		<cfparam name="arguments.senderAddr" default="" />
		<cfparam name="arguments.senderCity" default="" />
		<cfparam name="arguments.senderCountry" default="" />
		<cfparam name="arguments.senderHow" default="" />
		<cfparam name="arguments.senderInt" default="" />
		<cfparam name="arguments.senderMsg" default="" />

		<!--- check if email already exists --->
		<cfquery name="checkEmail" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			SELECT mem_id
			FROM member
			WHERE mem_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderEmail#" list="false" />
		</cfquery>

		<cfif checkEmail.recordCount>
			
			<cfset memberID = checkEmail.mem_id />
			
			<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				UPDATE member SET 
					mem_firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderFirstName#" list="false" />,
					mem_surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderLastName#" list="false" />,
					mem_countryName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderCountry#" list="false" />,
					mem_homePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderPhone#" list="false" />,
					mem_interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderInt#" list="false" />,
					mem_hearHow = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderHow#" list="false" />,
					mem_suburb = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderCity#" list="false" />
				WHERE mem_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkEmail.mem_id#" list="false" />
			</cfquery>
			
		<cfelse>
		
			<cfquery name="updateMember" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO member (
					mem_firstName,
					mem_surname,
					mem_email,
					mem_countryName,
					mem_homePhone,
					mem_interests,
					mem_hearHow,
					mem_suburb
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderFirstName#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderLastName#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderEmail#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderCountry#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderPhone#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderInt#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderHow#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderCity#" list="false" />
				)
				SELECT SCOPE_IDENTITY() AS memberID
			</cfquery>
			
			<cfset memberID = updateMember.memberID />
			
		</cfif>

		<cftransaction>
		
			<cfquery name="removeGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				DELETE FROM member_group
				WHERE mgr_member = <cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
					AND mgr_group = <cfqueryparam cfsqltype="cf_sql_integer" value="15" list="false" />
			</cfquery>
		
			<cfquery name="addMemberGroup" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
				INSERT INTO member_group (
					mgr_member,
					mgr_group
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="15" list="false" />
				)
			</cfquery>
		
		</cftransaction>


		<cfquery name="addMessage" datasource="#application.DBDSN#" username="#application.DBUserName#" password="#application.DBPassword#">
			INSERT INTO Message (
				mes_title,
				mes_body,
				mes_member
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Website Registration arguments.Contact" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.senderMsg#" list="false" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#" list="false" />
			)
		</cfquery>

<!---  --->

<cfmail to="sales@seasentosa.com" bcc="rafe.hatfield@gmail.com" from="sales@seasentosa.com" subject="Sea Sentosa: Website Registration"><cfoutput>
A client registered their interest for Sea Sentosa with the following inarguments.tion:

Name: #arguments.senderFirstName# #arguments.senderLastName#
Email: #arguments.senderEmail#
Phone: #arguments.senderPhone#
Address: #arguments.senderAddr#
City: #arguments.senderCity#
Country: #arguments.senderCountry#
How do you hear about us : #senderHow#
Interest: #arguments.senderInt#
Message: #arguments.senderMsg#
</cfoutput>
</cfmail>

<cfmail to="#arguments.senderEmail#" from="sales@seasentosa.com" bcc="rafe.hatfield@gmail.com" subject="Thanks for Registering your Interest with Sea Sentosa"><cfoutput>Dear #arguments.senderFirstName# #arguments.senderLastName#,

Many thanks for enquiring about Sea Sentosa in Echo Beach, Canggu.

One of our Sales Managers will be in touch with you shortly to follow up on your request.

With best regards,

Sea Sentosa Sales Team</cfoutput>
</cfmail>

		<cfset feedbackSuccess = "1" />

		<cfreturn feedbackSuccess />

	</cffunction>

</cfcomponent>