//Gjør det mulig å se alle arbeidstimer innenfor en arbeidsdag.
$(document).ready(function() {	
	
	//Må bruke en hook til å feste listeneren, siden det brukes remote calls på siden.
	$("#parent_table").parent().delegate(".row_button", "click", function(){
		childId = "#child"+this.id;
		//Setter options til å vise/skjule arbeidstimene
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