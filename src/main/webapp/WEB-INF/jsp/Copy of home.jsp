<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--HTML5 doctype-->
<html>
<head>
<title>Eggplant Health Manager</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-capable" content="yes" />
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/icons.css" />
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/afui.custom.css" />
<script type="text/javascript" charset="utf-8"
	src="/healthmanager/resources/js/appframework.ui.min.js"></script>
<script type="text/javascript">
	$.ui.ready(function() {
		$.ui.toggleHeaderMenu();
		$.feat.nativeTouchScroll = false; //Disable native scrolling globally
		$.ui.removeFooterMenu();

		var uid = '${uid}';
		var records = {};
		<c:forEach var="item" items="${records}" varStatus="status">     
		records['${item.cupNumber}']='${item.recordTime}';
		</c:forEach> 
		console.log(records);

		$('#drinkBtn').on('click', function(e) {
			var opts = {
				type : "POST",
				success : function(data) {
					$("#currentDay").html(data.obj.time);
					$("#total").html(data.obj.total);
				},
				url : "/healthmanager/rest/drinkrecord/add/" + uid,
				data : null,
				contentType : "application/json",
				dataType : "json"
			}
			$.ajax(opts);
		});

		$('#historyBtn').on(
				'click',
				function(e) {

					$('#drinkBtn').hide();
					var opts = {
						type : "GET",
						success : function(data) {
							$("#searchResultBox").empty();
							var result = "";
							$.each(data, function(id, element) {
								result += "<li>" + element.time + " : "
										+ element.total + "杯" + "</li>";
							});
							$("#searchResultBox").html(result);
						},
						url : "/healthmanager/rest/drinkrecord/history/"
								+ uid,
						data : null,
						contentType : "application/json",
						dataType : "json"
					}
					$.ajax(opts);
				});

		$('#todayBtn').on('click', function(e) {

			$('#drinkBtn').show();
			var opts = {
				type : "GET",
				success : function(data) {
					$("#searchResultBox").empty();
					var result = "";
					result += '<li id="uid">' + data.uid + '</li>';
					result += '<li id="currentDay">' + data.time + '</li>';
					result += '<li id="total">' + data.total + '</li>';
					$("#searchResultBox").html(result);
				},
				url : "/healthmanager/rest/drinkrecord/today/" + uid,
				data : null,
				contentType : "application/json",
				dataType : "json"
			}
			$.ajax(opts);
		});

		 
		
		function drawProcess(id, text, circle) {
			var el = document.getElementById(id); // get canvas
			var options = {
				percent : el.getAttribute('data-percent') || 25,
				size : el.getAttribute('data-size') || (el.offsetWidth-10),
				lineWidth :  el.getAttribute('data-line') || 15,
				rotate : el.getAttribute('data-rotate') || 0
			}

			var canvas = document.createElement('canvas');
			var span = document.createElement('span');
			span.textContent = text;

			if (typeof (G_vmlCanvasManager) !== 'undefined') {
				G_vmlCanvasManager.initElement(canvas);
			}

			var ctx = canvas.getContext('2d');
			canvas.width = canvas.height = options.size;

			el.appendChild(span);
			el.appendChild(canvas);
			if(circle) {
				var x = 50,
			    y = 50,
			    // Radii of the white glow.
			    innerRadius = 5,
			    outerRadius = 50,
			    // Radius of the entire circle.
			    radius = 30;
				
				ctx.translate(options.size / 2, options.size / 2); // change center
				//ctx.rotate((-1 / 2 + options.rotate / 180) * Math.PI); // rotate -90 deg
				var radius = (options.size - options.lineWidth) / 2;
				
				var gradient = ctx.createRadialGradient(x, y, innerRadius, x, y, outerRadius);
				gradient.addColorStop(0, '#8EBAFF');
				gradient.addColorStop(1, '#4070FF');
				ctx.arc(0, 0, radius, 0, Math.PI * 2, false);
				//ctx.arc(x, y, radius, 0, 2 * Math.PI);
				ctx.fillStyle = gradient;
				ctx.fill();
				
				ctx.translate(0-options.size / 2, 0-options.size / 2 + 2);
				ctx.fillStyle = "white"; 
				ctx.font = "bold 14px serif";
				ctx.fillText(text,options.size / 2 - 18,options.size / 2);
			}else {
				ctx.translate(options.size / 2, options.size / 2); // change center
				ctx.rotate((-1 / 2 + options.rotate / 180) * Math.PI); // rotate -90 deg

				//imd = ctx.getImageData(0, 0, 240, 240);
				var radius = (options.size - options.lineWidth) / 2;

				var drawCircle = function(color, lineWidth, percent) {
					//percent = Math.min(Math.max(0, percent || 1), 1);
					ctx.beginPath();
					ctx.arc(0, 0, radius, 0, Math.PI * 2 * percent, false);
					ctx.strokeStyle = color;
					ctx.lineCap = 'round'; // butt, round or square
					ctx.lineWidth = lineWidth;
					ctx.stroke();
				};
				
				drawCircle('#efefef', options.lineWidth, 100 / 100);
				drawCircle('#97A71D', options.lineWidth, options.percent / 100);
			}

			
			
		}
		var drinkTime = [ "7:00", "8:30", "10:00", "11:30", "14:00", "15:30",
				"18:00", "21:00" ];
		for (var i = 0; i < 8; i++) {
			
			if(records[i+1]) {
				drawProcess("cup" + (i + 1),"第"+ (i + 1) + "杯",true);
			} else {
				drawProcess("cup" + (i + 1), drinkTime[i]);
				$('#cup' + (i + 1)).bind('click', function(e) {
					var cupID = $(this).attr('id');
					var cupNumber = cupID.substring(3);
					var opts = {
							type : "POST",
							success : function(data) {
								$('#' + cupID).unbind('click');
								$('#' + cupID).empty();
								drawProcess(cupID,"第"+ cupNumber + "杯",true);
							},
							url : "/healthmanager/rest/drinkrecord/add/" + uid + "/" + cupNumber ,
							data : null,
							contentType : "application/json",
							dataType : "json"
						}
						$.ajax(opts);
				});
			}
		}

	});
</script>

<style>
#header {
	display: none;
}

#navbar {
	display: none;
}

/**
.circle {
	position: relative;
	width: 31%;
	height: 80px;
	margin-left: 5px;
	margin-top: 10px; 
	text-align: center;
	float: left;
	background :linear-gradient(to bottom, #40b3ff, #09f);
	-moz-border-radius: 50px;
	-webkit-border-radius: 50px;
	border-radius: 50px;
}*/

.annular {
	position: relative;
	width: 31%;
	margin-left: 5px;
	margin-top: 10px; 
	text-align: center;
	float: left;
}

canvas {
	display: block;
	position: absolute;
	top: 0;
	left: 0;
}

span {
	color: #555;
	display: block;
	line-height: 90px;
	text-align: center;
	width: 90%;
	font-family: sans-serif;
	font-size: 20px;
}
</style>
</head>

<body>
	<div id="afui">
		<div id="content">
			<div class="panel" js-scrolling="true"
				style="background-color: black;">
				<div
					style="margin: 20px; font-size: 1.1em; font-weight: bold; color: white;">茄子君说：已经喝了
					${fn:length(records)}杯水了！剩下的${8-fn:length(records)}杯也要加油！记得每杯200毫升左右噢～</div>

				<div class="annular" id="cup1" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup2" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup3" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup4" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup5" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup6" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup7" data-percent="0" data-line="4"></div>
				<div class="annular" id="cup8" data-percent="0" data-line="4"></div>

				<br style="clear: both">
				<div
					style="margin-left: 20px; margin-top: 30px; display: block; float: left; font-size: 1.3em; font-weight: bold; color: white;">
					<a>今天</a> | <a>往日</a>
				</div>

			</div>
		</div>
	</div>
</body>
</html>