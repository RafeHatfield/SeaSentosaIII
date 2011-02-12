<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">

	<fuseaction name="galleryList">

		<set name="attributes.gal_id" value="0" overwrite="no" />

		<invoke object="application.imageObj" methodcall="displayGallery(attributes.gal_id)" returnVariable="content.gloryBox" />
		
		<invoke object="application.imageObj" methodcall="displayGalleryList(attributes.gal_id)" returnVariable="content.mainContent" />

	</fuseaction>

	<fuseaction name="villasForSale">
		
		<set name="attributes.displayMode" value="noGlory" overwrite="yes" />
		
		<do action="v_content.displayContent" contentVariable="content.mainContent" append="yes" />
		
		<invoke object="application.villaObj" methodCall="villasForSale()" returnVariable="villasForSale" />
		
		<set name="content.mainContent" value="#content.mainContent##villasForSale#" overwrite="yes" />
		
	</fuseaction>

</circuit>