$(document).ready(function() {	
	
	$('#parent_table > tbody > tr').click(function(){
		childId = "#child_row"+this.id;
		if($(childId).is(":visible")){
    		$(childId).hide();
    	}
    	else
    	{	
    		$(childId).show();
    	}
    	
    	
	});

});