//JQueryen til pageren, altså funskjonaliteten til å kunne velge neste og forige måned

$(document).ready(function(){

//Sjekker manuelt om den inneholder klassen disabled,
//den blir disabled om måneden er tom.
if(!$("#prev_button").hasClass("disabled"))
{
	$(".prev_form").submit(function(e){
			
			//tvinger formet til å ikke submitte på normal måte.
			e.preventDefault();
			
			url = $(this).attr('action');
			//Ajax forespørsel som sender deg til forige måned
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
	
	//Fungerer på samme måte som den ovenfor
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
