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
<title>茄子健康-微习惯 : </title>
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
	href="/healthmanager/resources/css/animate.min.css" />	
<link rel="stylesheet" type="text/css"
	href="/healthmanager/resources/css/home.css" />
<script type="text/javascript" charset="utf-8"
	src="/healthmanager/resources/js/appframework.min.js"></script>
<script type="text/javascript">
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
	    // 发送给好友
	    WeixinJSBridge.on('menu:share:appmessage', function (argv) {
	        WeixinJSBridge.invoke('sendAppMessage', {
	            "appid": "123",
	            "img_url": "https://mmbiz.qlogo.cn/mmbiz/sEAlex1QSeSaLeDajbFAAYtmlD76XLc5QDBU0Inr29ehAA61u8HRheOCymjLQYL76SVcN63QgCqolc7gSOlj9A/0",
	            "img_width": "60",
	            "img_height": "60",
	            "link": location.href,
	            "desc":  document.title,
	            "title": "茄子健康-微习惯"
	        }, function (res) {
	            _report('send_msg', res.err_msg);
	        })
	    });
	
	    // 分享到朋友圈
	    WeixinJSBridge.on('menu:share:timeline', function (argv) {
	        WeixinJSBridge.invoke('shareTimeline', {
	            "img_url": "https://mmbiz.qlogo.cn/mmbiz/sEAlex1QSeSaLeDajbFAAYtmlD76XLc5QDBU0Inr29ehAA61u8HRheOCymjLQYL76SVcN63QgCqolc7gSOlj9A/0",
	            "img_width": "60",
	            "img_height": "60",
	            "link": location.href,
	            "desc":  document.title,
	            "title": "茄子健康-微习惯：" + document.title 
	        }, function (res) {
	            _report('timeline', res.err_msg);
	        });
	    });
	}, false);
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
						var glowFlag = true;
						var drinkTime = [ "7:00", "8:30", "10:00", "11:00",
											"13:30", "15:00", "17:00", "20:30" ];
						var shareDesc = ["茄子健康8杯水打卡~简单健康又有趣～大家都来试试吧！",
						                 "茄子健康8杯水打卡：搞定1杯啦～好的开始！继续加油！",
						                 "茄子健康8杯水打卡：2杯喽～2杯喽～心情棒棒哒～",
						                 "茄子健康8杯水打卡：搞定3杯喽！差不多就一半了～",
						                 "茄子健康8杯水打卡：4杯！半数达成！",
						                 "茄子健康8杯水打卡：完成5杯啦！胜利在望！",
						                 "茄子健康8杯水打卡：不知不觉6杯了～身心舒畅有木有～",
						                 "茄子健康8杯水打卡：第7杯！只差1杯喽！",
						                 "茄子健康8杯水打卡：第8杯！今日目标达成！明天再接再厉！"];
						var qiezisaids = [];
						<c:forEach var="item" items="${qiezisaids}" varStatus="status">
						qiezisaids[<c:out value="${status.index}"/>] = '${item}';
						</c:forEach>
						
						<c:forEach var="item" items="${records}" varStatus="status">
						records['${item.cupNumber}'] = '${item.starLevel}';
						</c:forEach>
						
						/** debug function : tobe remove for production */
						$('#resetBtn')
						.on(
								'click',
								function(e) {
									var opts = {
										type : "DELETE",
										success : function(data) {
											records = {};
											recordsSize = 0;
											initAllCups();
										},
										url : "/healthmanager/rest/drinkrecord/" + uid,
										data : null,
										contentType : "application/json",
										dataType : "json"
									}
									$.ajax(opts);
								});
						
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

						initAllCups();
						glowClickableCircle();
						function glowClickableCircle() {
							if(glowFlag) {
								glowFlag = false;
								$('#clickableCircleImg').addClass('glow');
								$('#clickableCircleImg').removeClass('glow_off');
							}else {
								glowFlag = true;
								$('#clickableCircleImg').addClass('glow_off');
								$('#clickableCircleImg').removeClass('glow');
							}
							setTimeout(function(){glowClickableCircle();},1000 );
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
						
						function initAllCups() {
							drawHeaderText(recordsSize);
							for (var i = 0; i < 8; i++) {
								if(records[i+1]) {
									displayCup((i + 1), 1, parseInt(records[i+1]));
								} else {
									displayCup((i + 1), 0 , null, drinkTime[i]);
								}
							}
						}
						function drawHeaderText(recordsSize) {
							var cups = parseInt(recordsSize);
							var windowTitle = shareDesc[0];
							if( cups === 0) {
								windowTitle = shareDesc[0];
							} else if( cups > 0 && cups <= 8) {
								windowTitle = shareDesc[cups];
							} else {
								windowTitle = shareDesc[8];
							}
							document.title=windowTitle;
							$('#contentHeader').empty();
							var qiezisaid = getQieZiSaid(cups);
							if(qiezisaid.indexOf("8-n") >= 0) {
								qiezisaid = qiezisaid.replace(/8-n/,(8-recordsSize));
							}
							qiezisaid = qiezisaid.replace(/n/,recordsSize);
							if(qiezisaid == null) {
								qiezisaid = '茄子君说：已经喝了' + recordsSize + '杯水了！剩下的' + (8-cups)+ '杯也要加油！记得每杯200毫升左右噢～';
							}
							//var qiezisaid = '茄子君说：已经喝了' + recordsSize + '杯水了！剩下的' + (8-recordsSize)+ '杯也要加油！记得每杯200毫升左右噢～';
							$('#contentHeader').html(qiezisaid);
						}
						
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
											'<img id="clickableCircleImg" src="/healthmanager/resources/images/circle_on.png"' +
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
									cupStr = '<div id="cupNumText'+ cupNumber + '" align="center" style="' + forthCupSpecialCase + '" ' +
											'class="circle overlayText"> ' +
											' <p class="cupText">' + cupNumber + '</p> ' +
										'</div> ' +
										'<div id="cupImgArea'+ cupNumber + '" ' +
											'style="position: relative; width: 100%; height: 100%; ' + forthCupSpecialCase + '">' +
											'<img id="cupCircle'+ cupNumber + '" src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle" ' +
												' style="position: absolute; z-index: 2;" /> <img ' +
												'  class="cupStar" src="/healthmanager/resources/images/star_3.png" ' +
												' style="width: 119px; height: 88px; position: absolute; z-index: 3; top: -2px; left: -16px;" />' +
										'</div>' ;
								} else if(starLevel === 2) {
									cupStr = '<div id="cupNumText'+ cupNumber + '" align="center" style="' + forthCupSpecialCase + '" class="circle overlayText">' + 
									'<p class="cupText">' + cupNumber + '</p>' + 
								'</div>' + 
								'<div id="cupImgArea'+ cupNumber + '" style="position: relative; width: 100%; height: 100%;' + forthCupSpecialCase + '">' + 
									'<img src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle" ' + 
										' style="position: absolute; z-index: 2;" /> <img ' + 
										'  class="cupStar"  src="/healthmanager/resources/images/star_2.png" ' + 
										' style="width: 16px; height: 15px; position: absolute; z-index: 3; top: 52px; left: 13px;" />' + 
									'<img src="/healthmanager/resources/images/star_2.png" ' + 
										'  class="cupStar" style="width: 16px; height: 15px; position: absolute; z-index: 4; top: 52px; left: 35px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png" ' + 
										'  class="cupStar" style="width: 16px; height: 15px; position: absolute; z-index: 5; top: 52px; left: 57px;" />' + 
								'</div>	' ;
								} else {
									cupStr = '<div id="cupNumText'+ cupNumber + '" align="center" style="' + forthCupSpecialCase + '" class="circle overlayText">' + 
									'<p class="cupText">' + cupNumber + '</p>' + 
								'</div>' + 
								'<div id="cupImgArea'+ cupNumber + '" style="position: relative; width: 100%; height: 100%;' + forthCupSpecialCase + '">' + 
									'<img id="cupCircle'+ cupNumber + '" src="/healthmanager/resources/images/planet_' + cupNumber + '.png" class="circle"' + 
										' style="position: absolute; z-index: 2;" /> <img ' + 
										' src="/healthmanager/resources/images/star_2.png" ' + 
										' class="cupStar" style="width: 16px; height: 15px; position: absolute; z-index: 3; top: 52px; left: 13px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png"' + 
										' class="cupStar" style="width: 16px; height: 15px; position: absolute; z-index: 4; top: 52px; left: 35px;" />' + 
									'<img src="/healthmanager/resources/images/star_1.png"' + 
										' class="cupStar" style="width: 16px; height: 15px; position: absolute; z-index: 5; top: 52px; left: 57px;" />' + 
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
													
													drawHeaderText(recordsSize);
													/** animate effect */
													/**
													$('#contentHeader').addClass('bounceOutUp');
													setTimeout(function(){
														$('#contentHeader').removeClass('bounceOutUp');
														$('#contentHeader').addClass('bounceInRight');
														},100);*/
													
													displayCup(parseInt(innerCupNumber), 1, data.obj.starLevel);
													$('#cupCircle'+innerCupNumber).addClass('animated bounceInRight');
													$('#cupNumText'+innerCupNumber).hide();
													$('#cupImgArea' + innerCupNumber).children('img.cupStar').hide();
													setTimeout(function(){
														$('#cupNumText'+innerCupNumber).show();
														$('#cupNumText'+innerCupNumber).addClass('animated bounceInRight');
														
														setTimeout(function(){
															$('#cupImgArea' + innerCupNumber).children('img.cupStar').show();
															$('#cupImgArea' + innerCupNumber).children('img.cupStar').addClass('animated bounceInRight');
															},200);
														
														},200);
													
													if(parseInt(innerCupNumber) <= 7) {
														displayCup(parseInt(innerCupNumber) + 1 , 0 ,null, drinkTime[innerCupNumber]);
													}
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
						function getTimeForHour(hourTime) {
							var today = new Date();
							var hour = parseInt(hourTime.split(":")[0]);
							var min = parseInt(hourTime.split(":")[1]);
							today.setHours(hour,min,0,0)
							return today.getTime();
						}
						function getQieZiSaid(cupNum) {
							var result;
							var refTime = new Date();
							var currentTime = new Date().getTime();
							if(cupNum === 0) {
								if( currentTime >= getTimeForHour( "0:0") && currentTime < getTimeForHour("5:0")) {
									result = qiezisaids[0];
								} else if(currentTime >= getTimeForHour("5:0") && currentTime <= getTimeForHour("7:30")) {
									result = qiezisaids[1];
								} else if(currentTime > getTimeForHour("7:30") && currentTime <= getTimeForHour("8:30")) {
									result = qiezisaids[2];
								} else if(currentTime > getTimeForHour("8:30") && currentTime < getTimeForHour("13:30")) {
									result = qiezisaids[3];
								} else if(currentTime >= getTimeForHour("13:30") && currentTime <= getTimeForHour("20:30")) {
									result = qiezisaids[4];
								} else if(currentTime > getTimeForHour("20:30")) {
									result = qiezisaids[5];
								}
							} else if(cupNum === 8) {
								if( currentTime >= getTimeForHour("0:0") && currentTime < getTimeForHour("5:0")) {
									result = qiezisaids[10];
								} else if( currentTime >= getTimeForHour("5:0") && currentTime < getTimeForHour("20:0")) {
									result = qiezisaids[11];
								} else if( currentTime >= getTimeForHour("20:0") && currentTime < getTimeForHour("23:59")) {
									var all3Star = $('#content').find('img[src$="/star_3.png"]').length;
									if(all3Star === 8) {
										result = qiezisaids[13];
									} else {
										result = qiezisaids[12];
									}
								} 
							} else {
								// 1 ~ 7 cups
								if( currentTime >= getTimeForHour("0:0") && currentTime < getTimeForHour("5:0")) {
									result = qiezisaids[6];
								} else if( currentTime >= getTimeForHour("5:0") && currentTime <= (getTimeForHour(drinkTime[cupNum-1]) - 45*60*1000)) {
									result = qiezisaids[7];
								} else if( currentTime >= (getTimeForHour(drinkTime[cupNum-1]) - 45*60*1000) && currentTime <= getTimeForHour(drinkTime[cupNum])) {
									result = qiezisaids[8];
								}  else if( currentTime >=  getTimeForHour(drinkTime[cupNum])) {
									result = qiezisaids[9];
								}
							}
							return result;
						}
						
					});
</script>

</head>

<body>

	<div class="main">
		<div id="contentHeader" class="animated">茄子君说：已经喝了
				${fn:length(records)}杯水了！剩下的${8-fn:length(records)}杯也要加油！记得每杯200毫升左右噢～</div>

		<div id="contentBody">
		
		<div id="floater"></div>
		<div id="content">
			<table width="100%" style="margin-left: auto; margin-right: auto; ">
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
		 
	</div>


</body>
</html>