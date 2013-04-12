function timeTickFormatter(val,axis) {
	var hours = Math.floor(val/100);
  if (val > 999)
  {
  	
  	val = val+"";
  	var minutes = val.substr(2);
  }
  else
  {
  	val = val+"";
  	var minutes = val.substr(1);
  }
  return hours+":"+minutes;
};
function transTime(val) {
	var hours = Math.floor(val/100);
	if (val > 999)
  	{
  		//var minutes = Math.round((val/100 - hours)*10);
  		val = val+"";
  		var minutes = val.substr(2);
  	}
  	else
  	{
  		hours = "0"+hours;
  		//var minutes = Math.round((val/10 - hours*10)*10);
  		val = val+"";
  		var minutes = val.substr(1);
  	}

	return hours+":"+minutes;
}

$(function () {    
    var options = {
            series:{
                lines: {  
                	show: true,                       
                    fill: false
                },
                points: {
                	show: true
                },
                
            },
            xaxis: {
                mode: "time"//,
                //timeformat: "%Y/%m/%d"
            },
            yaxis: {
            	mode: "time",
            	minTickSize: [1, "second"],
            	min:0, max: 2400,
            	tickFormatter:timeTickFormatter,
            	autoscaleMargin: 20
            	//timeformat: "%H:%M"
            },
            grid:{
                backgroundColor: { colors: ["#969696", "#5C5C5C"] },
                minBorderMargins: 120,
                hoverable: true,
                mouseActiveRadius: 10  //specifies how far the mouse can activate an item
            },
            clickable:true,
            hoverable: true
    };

    var plot = $.plot($("#example-section11 #flotcontainer"), [data11_1, data11_2], options);  
    
    $("#example-section11 #flotcontainer").UseTooltip();
});


$.fn.UseTooltip = function () {
    var previousPoint = null;
    
    $(this).bind("plothover", function (event, pos, item) {         
        if (item) {
            if (previousPoint != item.dataIndex) {
                previousPoint = item.dataIndex;

                $("#tooltip").remove();
                
                var x = item.datapoint[0];
                var y = item.datapoint[1];     
                var date = new Date(x);
                var dato = date.getUTCDate()+1; //månedene starter på 0 i js
                var maaned = date.getUTCMonth()+1; //dagene starter på 0 i sj
                var aar = date.getFullYear();
                
                var fulldato = "Dato: "+ dato +"."+maaned+"."+aar;
                
                showTooltip(item.pageX, item.pageY, fulldato +"<br/>" + "<strong>"+"Tidspunkt: "+ transTime(y) +"</strong> ");
            }
        }
        else {
            $("#tooltip").remove();
            previousPoint = null;
        }
    });
};

function showTooltip(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 20,
        border: '2px solid #4572A7',
        padding: '2px',     
        size: '10',   
        'background-color': '#fff',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}
