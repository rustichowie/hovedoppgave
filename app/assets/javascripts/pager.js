$(document).ready(function(){

if(!$("#prev_button").hasClass("disabled"))
{
	$(".prev_form").submit(function(e){
		
			e.preventDefault();
			
			url = $(this).attr('action');
			$.ajax({
				type: 'get',
				url: url,
				dataType: 'html',
				success: function(json){
						window.location = url;
				}
			});
			
			
		});
	}
	else
	{
		$(".prev_form").submit(function(e){
		
			e.preventDefault();
		});
	}
	if(!$("#next_button").hasClass("disabled"))
	{
		$(".next_form").submit(function(e){
		
			e.preventDefault();
			
			url = $(this).attr('action');
			$.ajax({
				type: 'get',
				url: url,
				dataType: 'html',
				success: function(json){
						window.location = url;
				}
			});
			
			
		});
	}
	else
	{
		$(".next_form").submit(function(e){
		
			e.preventDefault();
		});
	}
});
