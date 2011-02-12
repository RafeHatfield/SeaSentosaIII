<div>

	<div>
		<h1>My Sea Sentosa</h1>
	</div>

	<div>

		<div>
		
			<cfoutput query='getMenu' group='mse_title'>

				<div>
					<span>#mse_title#</span>
				</div>

				<ul>
					<cfoutput>
						<cfif canAccess("#pfu_name#")>
							<li><a href="#myself##pro_name#.#pfu_name#">#pfu_title#</a></li>
						<!--- <cfelse>
							<li>***<a href="#myself##pro_name#.#pfu_name#">#pfu_title#</a></li> --->
						</cfif>
					</cfoutput>
				</ul>

			</cfoutput>

		</div>

	</div>

</div>