$(document).ready(function() {	
	
	$('#main_table > tbody > tr').click(function(){
		childId = "#child_row" + this.id;
		//cellId = "#icon"+this.id;
		if($(childId).is(":visible")){
    		$(childId).hide();
    		//$(cellId).removeClass('icon-chevron-down');
    		//$(cellId).addClass('icon-chevron-right');
    	}
    	else
    	{	
    		$(childId).show();
    		//$(cellId).addClass('icon-chevron-down');
    		//$(cellId).removeClass('icon-chevron-right');
    	}
    	
    	
	});

});