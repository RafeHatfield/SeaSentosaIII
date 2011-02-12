<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">
	
		
		<fuseaction name="exchange" permissions="1,2,3,4,5|">
			<set name="attributes.lis_id" overwrite="no" value="0"/>
			<set name="exchangeForm" overwrite="no" value=""/>
			<!--
			<if condition="cookie.prf_id is 1">
				<true>
					<invoke object="application.propertyObj" methodcall="displayExchangeForm(lis_id=attributes.lis_id)" returnVariable="exchangeForm" />
				</true>
			</if>
			-->
			<invoke methodcall="displayPaymentSchedule(lis_id=attributes.lis_id)" object="application.propertyObj" returnVariable="paymentSchedule"/>
			
			<set name="content.mainContent" overwrite="yes" value="#exchangeForm##paymentSchedule#"/>
		</fuseaction>
	
		
		<fuseaction name="exchangeDetails" permissions="1,2,3,4,5|">
			<set name="attributes.lis_id" overwrite="no" value="0"/>
			  
			<invoke methodcall="displayExchangeDetails(argumentCollection=attributes)" object="application.propertyObj" returnVariable="exchangeDetails"/>
			
			<!--
			<invoke object="application.propertyObj" methodcall="displayPaymentSchedule(lis_id=attributes.lis_id)" returnVariable="paymentSchedule" />
			-->
			
			<set name="content.mainContent" overwrite="yes" value="#exchangeDetails#"/>
		</fuseaction>
	
		
		<fuseaction name="materialList" permissions="1,2,3,4,5|">
			<set name="attributes.mat_id" overwrite="no" value="0"/>
			
			<invoke methodcall="displayMaterialForm(mat_id=#attributes.mat_id#)" object="application.marketingObj" returnVariable="content.mainContent"/>
			
			<invoke methodcall="displayMaterialList()" object="application.marketingObj" returnVariable="MaterialList"/>
			
			<set name="content.mainContent" overwrite="yes" value="#content.mainContent##MaterialList#"/>
		</fuseaction>
	
		
		<fuseaction name="propertyForm" permissions="1,2,3,4,5|">
			<set name="attributes.pro_id" overwrite="no" value="0"/>
			
			<if condition="isDefined('attributes.save')">
				<true>
					<invoke methodcall="propertySave(argumentCollection=attributes)" object="application.propertyObj" returnVariable="attributes.pro_id"/>
					<relocate addtoken="false" url="#myself#property.propertyList"/>
				</true>
			</if>
			
			<invoke methodCall="displayPropertyForm(pro_id=attributes.pro_id)" object="application.propertyObj" returnVariable="propertyForm"/>
			
			<set name="content.mainContent" overwrite="no" value="#propertyForm#"/>
			
			<!--
			
			<invoke object="application.propertyObj" methodcall="getProperty(pro_id=attributes.pro_id)" returnVariable="qProperty" />
			<invoke object="application.propertyObj" methodcall="getListingStatuses()" returnVariable="qListingStatuses" />
			
			<if condition="qProperty.recordCount">
				<true>
					<set name="attributes.pro_building" value="#qProperty.pro_building#" />
					<set name="attributes.pro_unitNumber" value="#qProperty.pro_unitNumber#" />
					<set name="attributes.pro_floor" value="#qProperty.pro_floor#" />
					<set name="attributes.pro_beds" value="#qProperty.pro_beds#" />
					<set name="attributes.pro_baths" value="#qProperty.pro_baths#" />
					<set name="attributes.pro_carspaces" value="#qProperty.pro_carspaces#" />
					<set name="attributes.pro_outlook" value="#qProperty.pro_outlook#" />
					<set name="attributes.pro_description" value="#qProperty.pro_description#" />
					<set name="attributes.lst_id" value="#qProperty.lst_id#" />
				</true>
				<false>
					<set name="attributes.pro_building" value="" />
					<set name="attributes.pro_unitNumber" value="" />
					<set name="attributes.pro_floor" value="" />
					<set name="attributes.pro_beds" value="" />
					<set name="attributes.pro_baths" value="" />
					<set name="attributes.pro_carspaces" value="" />
					<set name="attributes.pro_outlook" value="" />
					<set name="attributes.pro_description" value="" />
					<set name="attributes.lst_id" value="2" />
				</false>
			</if>
			
			<do action='v_property.propertyForm' contentVariable="content.mainContent" append="yes" />
			-->
		</fuseaction>
	
		
		<fuseaction name="propertyList" permissions="1,2,3,4,5|">
			<xfa name="editProperty" value="property.propertyForm"/>
			
			<set name="attributes.fastFind" overwrite="no" value=""/>
			
			<set name="listingsList" overwrite="no" value=""/>
			  
			<invoke methodcall="displayListingSearch(fastFind=attributes.fastFind)" object="application.propertyObj" returnVariable="content.mainContent"/>
			
			<invoke methodcall="displayListings(argumentCollection=attributes)" object="application.propertyObj" returnVariable="listingsList"/>
			
			<set name="content.mainContent" overwrite="yes" value="#content.mainContent##listingsList#"/>
		</fuseaction>
	
	</circuit>
