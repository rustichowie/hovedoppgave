
//Dobbel datepicker, brukes får å gi en start og slutt dato.
//Brukes i loggen.
$(function() {
    $("#datepicker-from").datepicker({
    defaultDate: "+1w",
      changeMonth: true,
      dateFormat: "yy-mm-dd",
      onClose: function( selectedDate ) {
        $( "#datepicker-to" ).datepicker( "option", "minDate", selectedDate );
      }
  });
	$("#datepicker-to").datepicker({
      defaultDate: "+1w",
      changeMonth: true,
      dateFormat: "yy-mm-dd",
      onClose: function( selectedDate ) {
        $( "#datepicker-from" ).datepicker( "option", "maxDate", selectedDate );
      }
    });
});


