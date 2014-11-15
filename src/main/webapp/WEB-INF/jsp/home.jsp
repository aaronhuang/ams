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
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/home.css" />
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
						var readonly = ${empty readonly};
						var recordsSize = ${fn:length(records)};
						<c:forEach var="item" items="${records}" varStatus="status">
						records['${item.cupNumber}'] = '${item.starLevel}';
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

						var drinkTime = [ "7:00", "8:30", "10:00", "11:00",
								"13:30", "15:00", "17:00", "20:30" ];
						
						for (var i = 0; i < 8; i++) {
							if(records[i+1]) {
								displayCup((i + 1), 1, parseInt(records[i+1]));
							} else {
								displayCup((i + 1), 0 , null, drinkTime[i]);
							}
						}
						
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
						
						function displayCup(cupNumber , cupState , starLevel , timeText) {
							var cupElementTd = $("#cup" + cupNumber);
							cupElementTd.empty();
							var cupStr,forthCupSpecialCase='';
							if(cupNumber === 4) {
								forthCupSpecialCase='margin-left: 50px;';
							}
							
							if(cupState === 0) {
								var timeTextArray = timeText.split(":");
								if(cupNumber === (recordsSize+1)) {
									//clickable cup
									cupStr = '<div align="center" style="' + forthCupSpecialCase + '" class="circle circleText">' +
											'<div style="vertical-align: middle; margin-top: 25px;">' +
												'<span class="cupTimeHour">'+timeTextArray[0]+'</span><span class="cupTimeMin">:'+timeTextArray[1]+'</span>' +
											'</div>' +
										'</div>' +
										'<div style="position: relative; width: 100%; height: 100%;' + forthCupSpecialCase + '">' +
											'<img src="/healthmanager/resources/images/circle_on.png"' +
												'style="position: absolute; z-index: 2; width: 90px; height: 90px;" />' +
										'</div>';
								} else {
									//unclickable cup
									cupStr = '<div align="center" style="' + forthCupSpecialCase + '" class="circle circleText">' +
												 '<div style="vertical-align: middle; margin-top: 25px;">' +
													'<span class="cupTimeHour">'+timeTextArray[0]+'</span><span class="cupTimeMin">:'+timeTextArray[1]+'</span>' + 
												 '</div>' +
											'</div>' +
											'<div style="position: relative; width: 100%; height: 100%;' + forthCupSpecialCase + '">' +
												'<img src="/healthmanager/resources/images/circle_off.png"' +
													'style="position: absolute; z-index: 2; width: 90px; height: 90px;" />' +
											'</div>';
								}
								
							} else if(cupState === 1) {
								if(starLevel === 3) {
									cupStr = '<div align="center" style="" ' +
											'class="circle overlayText"> ' +
											' <p class="cupText">' + cupNumber + '</p> ' +
										'</div> ' +
										'<div ' +
											'style="position: relative; width: 100%; height: 100%; ">' +
											'<img src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle" ' +
												' style="position: absolute; z-index: 2;" /> <img ' +
												' src="/healthmanager/resources/images/star_3.png" ' +
												' style="width: 119px; height: 88px; position: absolute; z-index: 3; top: -2px; left: -16px;" />' +
										'</div>' ;
								} else if(starLevel === 2) {
									cupStr = '<div align="center" style="' + forthCupSpecialCase + '" class="circle overlayText">' + 
									'<p class="cupText">' + cupNumber + '</p>' + 
								'</div>' + 
								'<div style="position: relative; width: 100%; height: 100%;"' + forthCupSpecialCase + '>' + 
									'<img src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle"' + 
										'style="position: absolute; z-index: 2;" /> <img' + 
										'src="/healthmanager/resources/images/star_2.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />' + 
									'<img src="/healthmanager/resources/images/star_2.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />' + 
								'</div>	' ;
								} else {
									cupStr = '<div align="center" style="' + forthCupSpecialCase + '" class="circle overlayText">' + 
									'<p class="cupText">' + cupNumber + '</p>' + 
								'</div>' + 
								'<div style="position: relative; width: 100%; height: 100%;' + forthCupSpecialCase + '">' + 
									'<img src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle"' + 
										'style="position: absolute; z-index: 2;" /> <img ' + 
										'src="/healthmanager/resources/images/star_2.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 3; top: 55px; left: 10px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 4; top: 55px; left: 32px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png"' + 
										'style="width: 20px; height: 17px; position: absolute; z-index: 5; top: 55px; left: 54px;" />' + 
								'</div>	' ;
								}
								
									
							} 
							cupElementTd.append(cupStr);
							
							if(cupState === 0) {
								<c:if  test="${empty readonly}">
								if(cupNumber === (recordsSize + 1)) {
									$('#cup' + (cupNumber)).bind('click', function(e) {
										var cupID = $(this).attr('id');
										var innerCupNumber = cupID.substring(3);
										var opts = {
												type : "POST",
												success : function(data) {
													recordsSize = recordsSize + 1;
													$('#' + cupID).unbind('click');
													$('#' + cupID).empty();
													console.log("recordsSize : " + recordsSize);
													console.log(data);
													$('#contentHeader').empty();
													
													var qiezisaid = '茄子君说：已经喝了' + recordsSize + '杯水了！剩下的' + (8-recordsSize)+ '杯也要加油！记得每杯200毫升左右噢～';
													$('#contentHeader').html(qiezisaid);
													displayCup(parseInt(innerCupNumber), 1, data.obj.starLevel);
													displayCup(parseInt(innerCupNumber) + 1 , 0 ,null, drinkTime[innerCupNumber]);
													
													
												},
												url : "/healthmanager/rest/drinkrecord/add/" + uid + "/" + innerCupNumber ,
												data : null,
												contentType : "application/json",
												dataType : "json"
											}
											$.ajax(opts);
									});
								}
								</c:if>
							}
							
							
						}

					});
</script>

</head>

<body>

	<div class="main">
		<div>
			<div id="contentHeader">茄子君说：已经喝了
				${fn:length(records)}杯水了！剩下的${8-fn:length(records)}杯也要加油！记得每杯200毫升左右噢～</div>

			<div id="contentBody">
				<table width="100%">
					<tr class="cuptr">
						<td width="33%" class="cuptd" id="cup1">
						</td>
						<td width="33%" class="cuptd" id="cup2">
						</td>
						<td class="cuptd" id="cup3">
						</td>
					</tr>
					<tr class="cuptr">
						<td colspan="3" class="cuptd">
							<table style="width: 100%; height: 100%;">
								<tr style="vertical-align: middle !important; height: 90px;">
									<td class="cuptd" width="50%" align="right" id="cup4">
										
									</td>
									<td class="cuptd" width="50%" align="left" id="cup5">
										
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="cuptr" valign="middle">
						<td width="33%" class="cuptd" valign="middle" id="cup6">
						</td>
						<td width="33%" class="cuptd" valign="middle" id="cup7">
							
						</td>
						<td width="33%" class="cuptd" valign="middle" id="cup8">
						</td>
					</tr>
				</table>
			</div>

		</div>
	</div>
	<div class="footer">
		<a class="selected">今天</a> | <a>往日</a>
	</div>


</body>
</html>