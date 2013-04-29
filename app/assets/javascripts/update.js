//Oppdaterer approve/unapprove knappene, og legger til en passende label.


$(document).ready(function() {	

	//når en av knappene trykkes
	$("#parent_table").parent().delegate(".approve_buttons","click" ,function(){
		id = this.id;
		
		$(".approve_form").submit(function(e){
		
			e.preventDefault();
			
			url = $(this).attr('action');
			//får tilbake et json object som enten er true eller false fra serveren.	
			$.ajax({
				type: 'put',
				url: url,
				dataType: 'json',
				success: function(json){
					//Fjerner knappene og legger til label.
					$('.button_row'+id).remove();
					$("#last_td"+id).css("text-align", "center");
					if(json.approved == true)
						$("#last_td"+id).html("<span class=\"last_td label label-success\">Timene er allerede godkjent</span>");
					else
						$("#last_td"+id).html("<span class=\"last_td label label-important\">Timene er blitt underkjent</span>");
				}
			});
			
			
		});

	});
	//Åpner vinduet til å kunne delvis godkjenne ting.
	$("#parent_table").parent().delegate(".open_modal","click",function(){
		id = $(this).data('id');
			$("#myModal"+id).modal('show');
	});
	
	

});