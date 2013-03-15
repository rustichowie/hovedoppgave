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