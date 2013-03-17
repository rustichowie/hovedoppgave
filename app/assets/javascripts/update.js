$(document).ready(function() {	

	$(".approve_buttons").click(function(){
		id = this.id;

		$(".button_to").submit(function(e){
		
			e.preventDefault();
			
			url = $(this).attr('action');
			alert(this);
			$.ajax({
				type: 'put',
				url: url,
				dataType: 'json',
				success: function(json){
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
	$(".open_modal").click(function(){
			$("#myModal").modal('show');
	});
	
	

});