+++
date = "2015-12-15T00:54:57-05:00"
draft = true
title = "Downloads"

+++

<div id="registered">

Please fill out the form below before downloading software. The form is optional, but
it helps us keep track of how many users we have and is critical for justifying future work.

Registering really helps us -- Thanks!

<br/>

<br/>

<form id="download_form">
<table class="download_form">
	<tr><td align="right"><b>Email address:</b></td><td colspan="2"><input type="text" name="email" placeholder="you@example.com"/></td></tr>
	<tr><td align="right"><b>Organization:</b></td><td colspan="2"><input type="text" name="org"/></td></tr>
	<tr><td align="right"><b>Type:</b></td><td colspan="2">
		<input type="radio" name="orgtype" value="academia"> Research University / Academic</input><br/>
		<input type="radio" name="orgtype" value="clinical"> Hospital / Clinical</input><br/>
		<input type="radio" name="orgtype" value="institute"> Independent research institute</input><br/>
		<input type="radio" name="orgtype" value="govt"> Government</input><br/>
		<input type="radio" name="orgtype" value="industry"> Biotech / Industry</input><br/>
		<input type="radio" name="orgtype" value="other"> Other</input> &nbsp; <input type="text" name="orgtype_other" class="small_input"/>
	</td></tr>
	<tr><td align="right"><b>Install location:</b></td><td colspan="2">
		<input type="radio" name="installtype" value="workstation"> Single-user workstation / PC</input><br/>
		<input type="radio" name="installtype" value="server"> Multi-user server</input><br/>
		<input type="radio" name="installtype" value="cluster"> HPC cluster</input><br/>
		<input type="radio" name="installtype" value="other"> Other</input> &nbsp; <input type="text" name="installtype_other" class="small_input"/>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td></td><td><input type="submit" value="Submit and proceed to downloads" class="btn btn-primary"/></td><td align="right"><a href="/downloads/direct" class="btn" id="skip_register" onclick="return are_you_sure();">Skip this...</a></td></tr>
</table>
</form>

<br/>

All of the software available here for download is under an open-source license.

</div>
