
//Datepicker som brukes når man vil ha en spesifikk dato.
$(function(){
	$("#date").datepicker({
		changeMonth: true,
		dateFormat: "yy-mm-dd",
		maxDate: new Date
	});
});