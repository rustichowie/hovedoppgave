$(document).ready(function() {	

	$(".remote").click(function(){
		id = this.id;
		$(".button_to").submit(function(){
			document.getElementById("partly_approved_button"+id).className += " disabled";
			document.getElementById("disapproved_button"+id).className += " disabled";
			document.getElementById("approved_button"+id).className += " disabled";
});

	});
	
});