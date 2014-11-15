<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--HTML5 doctype-->
<html>
<head>
<title>健康8杯水</title>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-capable" content="yes" />
<!-- 
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/icons.css" />
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/afui.custom.css" /> -->
<script type="text/javascript" charset="utf-8"
	src="/healthmanager/resources/js/appframework.min.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						//$.ui.toggleHeaderMenu();
						//$.feat.nativeTouchScroll = false; //Disable native scrolling globally
						//$.ui.removeFooterMenu();

						var uid = '${uid}';
						var records = {};
						<c:forEach var="item" items="${records}" varStatus="status">
						records['${item.cupNumber}'] = '${item.recordTime}';
						</c:forEach>
						console.log(records);

						$('#drinkBtn')
								.on(
										'click',
										function(e) {
											var opts = {
												type : "POST",
												success : function(data) {
													$("#currentDay").html(
															data.obj.time);
													$("#total").html(
															data.obj.total);
												},
												url : "/healthmanager/rest/drinkrecord/add/"
														+ uid,
												data : null,
												contentType : "application/json",
												dataType : "json"
											}
											$.ajax(opts);
										});

						$('#historyBtn')
								.on(
										'click',
										function(e) {

											$('#drinkBtn').hide();
											var opts = {
												type : "GET",
												success : function(data) {
													$("#searchResultBox")
															.empty();
													var result = "";
													$
															.each(
																	data,
																	function(
																			id,
																			element) {
																		result += "<li>"
																				+ element.time
																				+ " : "
																				+ element.total
																				+ "杯"
																				+ "</li>";
																	});
													$("#searchResultBox").html(
															result);
												},
												url : "/healthmanager/rest/drinkrecord/history/"
														+ uid,
												data : null,
												contentType : "application/json",
												dataType : "json"
											}
											$.ajax(opts);
										});

						$('#todayBtn')
								.on(
										'click',
										function(e) {

											$('#drinkBtn').show();
											var opts = {
												type : "GET",
												success : function(data) {
													$("#searchResultBox")
															.empty();
													var result = "";
													result += '<li id="uid">'
															+ data.uid
															+ '</li>';
													result += '<li id="currentDay">'
															+ data.time
															+ '</li>';
													result += '<li id="total">'
															+ data.total
															+ '</li>';
													$("#searchResultBox").html(
															result);
												},
												url : "/healthmanager/rest/drinkrecord/today/"
														+ uid,
												data : null,
												contentType : "application/json",
												dataType : "json"
											}
											$.ajax(opts);
										});

						function fade(elem, time) {
							var startOpacity = elem.style.opacity || 1;
							elem.style.opacity = startOpacity;

							(function go() {
								elem.style.opacity -= startOpacity
										/ (time / 100);

								// for IE
								elem.style.filter = 'alpha(opacity='
										+ elem.style.opacity * 100 + ')';

								if (elem.style.opacity > 0)
									setTimeout(go, 100);
								else
									elem.style.display = 'none';
							})();
						}

						var drinkTime = [ "7:00", "8:30", "10:00", "11:30",
								"14:00", "15:30", "18:00", "21:00" ];
						/**
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
						}*/

					});
</script>

<style>
html,body {
	margin: 0;
	padding: 0;
	height: 100%;
}

.main {
	min-height: 100%;
	height: auto !important;
	height: 100%;
	margin: 0 auto -60px;
}

.contain {
	width: 100%;
}

.footer {
	height: 60px;
	clear: both;
	font-size: 1.3em;
	font-weight: bold;
	color: #C8C8C8;
	padding-left: 20px;
}


.cuptr {
	height: 100px;
	text-align: center;
}

.cuptd {
	height: 100px;
	text-align: left;
	vertical-align: middle;
}

.cupCenterTd {
	height: 90px;
	vertical-align: middle;
}

.circlebg {
	width: 90px;
	height: 90px;
	vertical-align: middle;
	text-align: center;
	background-image: url("/healthmanager/resources/images/circle.png");
	background-size: 90px 90px;
	background-repeat: no-repeat;
}

.circle {
	width: 85px;
	height: 85px;
}

.circleText {
	position: absolute;
	z-index: 10;
	vertical-align: middle;
}

.cupText {
	margin-top: 20px;
	font-style: italic;
	font-weight: bold;
	font-size: 26px;
	font-family: Arial, Helvetica, sans-serif;
	-webkit-text-stroke: 2 #2b263a;
	color: white;
	-webkit-text-fill-color: white;
	-webkit-text-stroke: 1px #2b263a;
	/** Simulated effect for Firefox and Opera
       and nice enhancement for WebKit
	text-shadow: 2px 2px 0 #2b263a;*/
}

.cupTimeHour {
	font-style: italic;
	font-weight: bold;
	font-size: 26px;
	font-family: Arial, Helvetica, sans-serif;
	color: white;
}

.cupTimeMin {
	font-weight: bold;
	font-size: 16px;
	font-family: Arial, Helvetica, sans-serif;
	color: white;
}
</style>
</head>

<body
	style="background-image: url('/healthmanager/resources/images/bg.png'); background-size: 100% 100%; background-repeat: repeat;">

	<div class="main">
		<div class="contain">

			<div style="font-size: 1.0em; font-weight: bold; color: white;padding: 20px 0px 20px 20px;">茄子君说：已经喝了
				${fn:length(records)}杯水了！剩下的${8-fn:length(records)}杯也要加油！记得每杯200毫升左右噢～</div>

			<div style="margin-left: 15px;">
				<table width="100%">
					<tr class="cuptr">
						<td width="33%" class="cuptd">
							<div align="center" style="position: absolute; z-index: 10;"
								class="circle">
								<p class="cupText">1</p>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/planet_1.png"
									class="circle" style="position: absolute; z-index: 2;" /> <img
									src="/healthmanager/resources/images/star_2.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />
							</div>
						</td>
						<td width="33%" class="cuptd">
							<div align="center" style="position: absolute; z-index: 10;"
								class="circle">
								<p class="cupText">2</p>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/planet_1.png"
									class="circle" style="position: absolute; z-index: 2;" /> <img
									src="/healthmanager/resources/images/star_2.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />
							</div>
						</td>
						<td class="cuptd">
							<div align="center" style="position: absolute; z-index: 10;"
								class="circle">
								<p class="cupText">3</p>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/planet_1.png"
									class="circle" style="position: absolute; z-index: 2;" /> <img
									src="/healthmanager/resources/images/star_2.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />
								<img src="/healthmanager/resources/images/star_1.png"
									style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />
							</div>
						</td>
					</tr>
					<tr class="cuptr">
						<td colspan="3" class="cuptd">
							<table style="width: 100%; height: 100%;">
								<tr style="vertical-align: middle !important; height: 90px;">
									<td class="cuptd" width="50%" align="right">
										<div align="center"
											style="position: absolute; z-index: 5; margin-left: 50px;"
											class="circle">
											<p class="cupText">4</p>
										</div>
										<div
											style="position: relative; width: 100%; height: 100%; margin-left: 50px;">
											<img src="/healthmanager/resources/images/planet_1.png"
												class="circle" style="position: absolute; z-index: 2;" /> <img
												src="/healthmanager/resources/images/star_3.png"
												style="width: 119px; height: 88px; position: absolute; z-index: 3; top: -2px; left: -16px;" />
										</div>
									</td>
									<td class="cuptd" width="50%" align="left">
										<div align="center" style="position: absolute; z-index: 10;"
											class="circle">
											<p class="cupText">5</p>
										</div>
										<div style="position: relative; width: 100%; height: 100%;">
											<img src="/healthmanager/resources/images/planet_1.png"
												class="circle" style="position: absolute; z-index: 2;" /> <img
												src="/healthmanager/resources/images/star_2.png"
												style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />
											<img src="/healthmanager/resources/images/star_1.png"
												style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />
											<img src="/healthmanager/resources/images/star_1.png"
												style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="cuptr" valign="middle">
						<td width="33%" class="cuptd" valign="middle">
							<div align="center" class="circle circleText">
								<div style="vertical-align: middle; margin-top: 25px;">
									<span class="cupTimeHour">18</span><span class="cupTimeMin">:30</span>
								</div>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/circle_on.png"
									style="position: absolute; z-index: 2; width: 90px; height: 90px;" />
							</div>
						</td>
						<td width="33%" class="cuptd" valign="middle">
							<div align="center" class="circle circleText">
								<div style="vertical-align: middle; margin-top: 25px;">
									<span class="cupTimeHour">18</span><span class="cupTimeMin">:30</span>
								</div>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/circle_off.png"
									style="position: absolute; z-index: 2; width: 90px; height: 90px;" />
							</div>
						</td>
						<td width="33%" class="cuptd" valign="middle">

							<div align="center" class="circle circleText">
								<div style="vertical-align: middle; margin-top: 25px;">
									<span class="cupTimeHour">18</span><span class="cupTimeMin">:30</span>
								</div>
							</div>
							<div style="position: relative; width: 100%; height: 100%;">
								<img src="/healthmanager/resources/images/circle_off.png"
									style="position: absolute; z-index: 2; width: 90px; height: 90px;" />
							</div>
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>
	<div class="footer">
	<a style="color: white;">今天</a> | <a>往日</a>
	</div>

	 
</body>
</html>