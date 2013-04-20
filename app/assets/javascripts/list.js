//Gjør det mulig å se alle timer innenfor en arbeidsdag.
$(document).ready(function() {	
	
	$("#parent_table").parent().delegate(".row_button", "click", function(){
		childId = "#child"+this.id;
		var showoptions = {"direction" : "down","mode" : "show"};
		var hideoptions = {"direction" : "up","mode" : "hide"};
		if($(childId).is(":visible")){
    		$(childId).effect("slide", hideoptions, 200);
    	}
    	else
    	{	
    		$(childId).effect("slide", showoptions, 500);
    	}
	});
	

});