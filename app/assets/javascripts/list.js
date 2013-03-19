//Gjør det mulig å se alle timer innenfor en arbeidsdag.
$(document).ready(function() {	
	
	$('.row_button').click(function(){
		childId = "#child"+this.id;
		if($(childId).is(":visible")){
    		$(childId).hide();
    	}
    	else
    	{	
    		$(childId).show();
    	}
    	
    	
	});

});