<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">

	<fuseaction name="contactDetails">
	
		<if condition="isDefined('attributes.save')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<set name="attributes.feedbackFormSuccess" value="0" overwrite="no" />

		<invoke object="application.villaObj" methodcall="displayVillaAddress(attributes.feedbackFormSuccess)" returnVariable="attributes.VillaAddress" />

		<invoke object="application.contactObj" methodcall="displayFeedbackForm(attributes.feedbackFormSuccess)" returnVariable="attributes.feedbackForm" />

		<set name="content.mainContent" value="#attributes.VillaAddress##attributes.feedbackForm#" />

	</fuseaction>

	<fuseaction name="feedbackForm">

		<if condition="isDefined('attributes.save')">
		
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
				<set name="attributes.displayContentOutput" value="" overwrite="yes" />
			</true>
			
			<false>
				<invoke object="application.contentObj" methodcall="displayContent(fuseAction=attributes.fuseAction)" returnVariable="attributes.displayContentOutput" />
			</false>
			
		</if>

		<set name="attributes.feedbackFormSuccess" value="0" overwrite="no" />

		<invoke object="application.contactObj" methodcall="displayFeedbackForm(feedbackSuccess=attributes.feedbackFormSuccess)" returnVariable="attributes.displayFeedbackFormOutput" />

		<set name="content.mainContent" value="#attributes.displayContentOutput##attributes.displayFeedbackFormOutput#" />

	</fuseaction>
	
	<fuseaction name="unsubscribe">
	
		<set name="attributes.email" value="" overwrite="no" />
		
		<if condition="#len(attributes.email)#">
		
			<true>
				<invoke object="application.contactObj" methodCall="unsubscribe(#attributes.email#)" returnVariable="unsubscribeStatus" />
			</true>
			
			<false>
				<set name="unsubscribeStatus" value="0" overwrite="yes" />
			</false>
		
		</if>
		
		<invoke object="application.contactObj" methodCall="unsubscribeForm(unsubscribeStatus=#unsubscribeStatus#)" returnVariable="content.mainContent" />
	
	</fuseaction>


	<fuseaction name="googleMap">

		<set name="request.googleMap" value="1" overwrite="yes" />

		<do action="v_content.displayContent" contentVariable="content.mainContent" append="yes" />

		<do action="v_contact.googleMap" contentVariable="content.mainContent" append="yes" />

	</fuseaction>

	<fuseaction name="formsPage">
	
		<if condition="isDefined('attributes.saveBuyer')">
			<true>
				<invoke object="application.contactObj" methodcall="buyerFormSave(argumentCollection=attributes)" returnVariable="attributes.buyerFormSuccess" />
			</true>
		</if>
		
		<if condition="isDefined('attributes.ownerLogin')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<if condition="isDefined('attributes.agentLogin')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<do action="v_content.displayContent" contentVariable="content.mainContent" append="yes" />
		
		<set name="attributes.buyerFormSuccess" value="0" overwrite="no" />

		<invoke object="application.contactObj" methodcall="displayBuyerForm(attributes.buyerFormSuccess)" returnVariable="attributes.buyerForm" />
		<invoke object="application.contactObj" methodcall="displayAgentLoginForm()" returnVariable="attributes.agentForm" />
		<invoke object="application.contactObj" methodcall="displayOwnerLoginForm()" returnVariable="attributes.ownerForm" />
		<invoke object="application.contactObj" methodcall="displayContactDetails()" returnVariable="attributes.contactDetails" />

		<set name="content.mainContent" value="#content.mainContent##attributes.buyerForm##attributes.agentForm##attributes.ownerForm##attributes.contactDetails#" />

	</fuseaction>

	<fuseaction name="agentLogin">
	
		<if condition="isDefined('attributes.agentLogin')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<invoke object="application.contactObj" methodcall="displayAgentLoginForm()" returnVariable="attributes.agentForm" />
		
		<set name="content.mainContent" value="#attributes.agentForm#" />

	</fuseaction>

	<fuseaction name="ownerLogin">
	
		<if condition="isDefined('attributes.ownerLogin')">
			<true>
				<invoke object="application.contactObj" methodcall="feedbackFormSave(argumentCollection=attributes)" returnVariable="attributes.feedbackFormSuccess" />
			</true>
		</if>
		
		<invoke object="application.contactObj" methodcall="displayOwnerLoginForm()" returnVariable="attributes.ownerForm" />
		
		<set name="content.mainContent" value="#attributes.ownerForm#" />

	</fuseaction>

</circuit>
