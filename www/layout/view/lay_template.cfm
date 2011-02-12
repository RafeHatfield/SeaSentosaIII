<cfcontent reset="true"><cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<cfparam name="request.pageTitle" default="Sea Sentosa" />
		<title>#request.pageTitle#</title>

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="description" content="#request.metaDescription#" />
		<meta name="keywords" content="#request.metaKeywords#" />
		
		<link href="assets/css/main.css" rel="stylesheet" type="text/css" media="screen" />
		<link href="assets/css/listmenu_fallback.css" rel="stylesheet" type="text/css" media="screen" />
		<link rel="stylesheet" href="assets/css/listmenu_v.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="assets/css/jquery.lightbox-0.5.css" />
		
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script> 
		<script type="text/javascript" src="assets/js/jquery.validate.js"></script>
		<script type="text/javascript" src="assets/js/jquery.lightbox-0.5.js"></script>
		<script type="text/javascript" src="assets/js/jquery.innerfade.js"></script>
		<script type="text/javascript" src="assets/js/fsmenu.js"></script>
		
		<!--[if lte IE 6]>
		<style type="text/css" media="all">@import "assets/css/ie6.css";</style>
		<![endif]-->
		
		<script type="text/javascript">
			$(document).ready(
				function(){
					$('ul##featured').innerfade({
						speed: 1000,
						timeout: 5000,
						type: 'sequence',
						containerheight: '160px'
					});
				});
		</script>
		
		<script type="text/javascript">
		    $(function() {
		        $('##galleryLB a').lightBox();
		    });
		</script>
								
	</head>
	<body>
		<div id="outer">
		<div id="container">
		    <!--Header Start-->
		    #content.header#
		    <!--Header End-->
		    <div id="content">
		        <!--Sidebar Start-->
		       #content.mainMenu#
		        <!--Sidebar End-->
		        <!--Maincontent Start-->
		        <div id="maincontent">
			        <div class="form_box">
		            	#content.mainContent#
		            </div>
		        </div>
		        <!--Maincontent End-->
		    </div>
		</div>
		<!--Footer Start-->
		#content.footerBar#
		<!--Footer End-->
		</div>
	</body>
</html>
</cfoutput>