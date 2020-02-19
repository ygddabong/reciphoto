<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<link rel="stylesheet" href="resources/css/statisticCompany.css">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
	google.charts.load('current', {
		'packages' : ['corechart','geochart'],
		'mapsApiKey': 'AIzaSyB2lk2ZcgCftdqo3nGHjyRcG7MnKGy5GLc'
	});
    
	$(function() {
		var author = $('.authorization').val()
		if (author == 'manager') {
			$('.head_1_item1_ul_li').css({
				marginLeft : '20px'
			})
			$('.head_1_item1_ul_li').css({
				marginRight : '20px'
			})
		}
		var companyNo = $('.companyNo').val()
		$.ajax({
			url: 'bringLcData',
			method: 'get',
			data: "companyNo=" + companyNo,
			dataType: 'json',
			contentType: 'application/json; charset: UTF-8',
			success: function(dates) {
				var locationData  = '';
					locationData += '<option>지역선택</option>'
				$.each(dates,function(index,item) {
					locationData += '<option value="'+ item +'">' + item + '</option>'
				})
				$('.sc_mainup_left_title_select').html(locationData)
				
				var categoryData = '<option>선택</option>'
					categoryData +='<option value="식비">식비</option>'
					categoryData +='<option value="교통비">교통비</option>'
					categoryData +='<option value="숙박비">숙박비</option>'
					categoryData +='<option value="유류비">유류비</option>'
					categoryData +='<option value="접대비">접대비</option>'
					categoryData +='<option value="기타">기타</option>'
				$('.sc_mainup_right_title_select').html(categoryData)
			}	
		})
		$('.sc_mainup_left_title_select').on('change',selectLocation)
		$('.sc_mainup_right_title_select').on('change',selectCategory)
	})
	
	function selectLocation() {
		google.charts.setOnLoadCallback(chartLocation);
		var location = $(this).val()
		$.ajax({
			url : 'sendLocation',
			type : 'GET',
			data : 'location=' + location, 
			dataType : 'json',
			contentType : 'application/json; charset=UTF-8',
			success : function(datas) {
				chartLocation(datas)
			}
		})
	}
	
	function selectCategory() {
		var category = $(this).val()
		$.ajax({
			url : 'sendCategory',
			type : 'GET',
			data : 'category=' + category, 
			dataType : 'json',
			contentType : 'application/json; charset=UTF-8',
			success : function(datas) {
				chartCategory(datas)
			}
		})
	}
	
	function chartLocation(datas) {
		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;
		
		$.each(datas, function(index, item) {
			
			if (item["ITEMCATEGORY"] == "식비") {
				food += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "유류비") {
				oil += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "숙박비") {
				home += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "접대비") {
				sale += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "교통비") {
				bus += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "기타") {
				etc += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

		})
	
		var data = google.visualization.arrayToDataTable([
				[ 'BusinessTrip', 'Money' ], [ '식비', food ], [ '유류비', oil ],
				[ '접대비', sale ], [ '교통비', bus ], [ '숙박비', home ],
				[ '기타', etc ] ]);

		var options = {
			slices : {
				0 : {
					color : 'dc3f76'
				},
				1 : {
					color : '2e9ca6'
				},
				2 : {
					color : '7446b9'
				},
				3 : {
					color : '9fb328'
				},
				4 : {
					color : 'f96232'
				},
				5 : {
					color : 'silver'
				}
			},
			is3D : true,
			chartArea : {
				left : '10%',
				top : '10%',
				width : '80%',
				height : '80%'
			},
			legend : {
				position : 'labeled',
				textStyle : {
					color : 'black',
					fontSize : 12
				}
			},
		};

		var chart = new google.visualization.PieChart(document.querySelector('.sc_mainup_left_content'));
		chart.draw(data, options);
	}
	
	function chartCategory(datas) {
		
		for (var i = 0; i < datas.length-1; i++) {
			if(datas[i]["PROPORTION"] > datas[i+1]["PROPORTION"]) {
				var temp = datas[i]
				datas[i] = datas[i+1]
				datas[i+1] = temp
			}
		}
		
		
		var number = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
		
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Country');
		data.addColumn('number', 'Value'); 
		data.addColumn({type:'string', role:'tooltip'});
		var ivalue = new Array();
		
		for(var i = 0; i < datas.length; i++) {
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '서울특별시') {
				data.addRows([[{v:'KR-11', f:'Seoul Teugbyeolsi'},checkPortion(datas[i]["PROPORTION"]),'서울특별시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '부산광역시') {
				data.addRows([[{v:'KR-26', f:'Busan Gwang\'yeogsi'},checkPortion(datas[i]["PROPORTION"]),'부산광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '대구광역시') {
				data.addRows([[{v:'KR-27',f:'Daegu Gwang\'yeogsi'},checkPortion(datas[i]["PROPORTION"]),'대구광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '인천광역시') {
				data.addRows([[{v:'KR-28',f:'Incheon Gwang\'yeogsi'},checkPortion(datas[i]["PROPORTION"]),'인천광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '광주광역시') {
				data.addRows([[{v:'KR-29',f:'Gwangju Gwang\'yeogs'},checkPortion(datas[i]["PROPORTION"]),'광주광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '대전광역시') {
				data.addRows([[{v:'KR-30',f:'Daejeon Gwang\'yeogsi'},checkPortion(datas[i]["PROPORTION"]),'대전광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '울산광역시') {
				data.addRows([[{v:'KR-31',f:'Ulsan Gwang\'yeogsi'},checkPortion(datas[i]["PROPORTION"]),'울산광역시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '경기도') {
				data.addRows([[{v:'KR-41',f:'Gyeonggido'},checkPortion(datas[i]["PROPORTION"]),'경기도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '강원도') {
				data.addRows([[{v:'KR-42',f:'Gwangju Gwang\'yeogs'},checkPortion(datas[i]["PROPORTION"]),'강원도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '충청북도') {
				data.addRows([[{v:'KR-43',f:'Chungcheongbugdo'},checkPortion(datas[i]["PROPORTION"]),'충청북도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '충청남도') {
				data.addRows([[{v:'KR-44',f:'Chungcheongnamdo'},checkPortion(datas[i]["PROPORTION"]),'충청남도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '전라북도') {
				data.addRows([[{v:'KR-45',f:'Jeonrabugdo'},checkPortion(datas[i]["PROPORTION"]),'전라북도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '전라남도') {
				data.addRows([[{v:'KR-46',f:'Jeonranamdo'},checkPortion(datas[i]["PROPORTION"]),'전라남도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '경상북도') {
				data.addRows([[{v:'KR-47',f:'Gyeongsangbugdo'},checkPortion(datas[i]["PROPORTION"]),'경상북도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '경상남도') {
				data.addRows([[{v:'KR-48',f:'Gyeongsangnamdo'},checkPortion(datas[i]["PROPORTION"]),'경상남도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
			
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '제주특별자치도') {
				data.addRows([[{v:'KR-49',f:'Jejudo'},checkPortion(datas[i]["PROPORTION"]),'제주특별자치도' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
				
			if(datas[i]["BUSINESSLOCATIONMAIN"] == '세종특별자치시') {
				data.addRows([[{v:'KR-50',f:'Sejong'},checkPortion(datas[i]["PROPORTION"]),'세종특별자치시' +  Math.round(datas[i]["PROPORTION"]*100) + '%']]);
			}
		}
		
		var options = {
			backgroundColor: {fill:'#FFFFFF',stroke:'#FFFFFF' ,strokeWidth:0 },
			colorAxis:  {minValue: 0, maxValue: 9,  colors: ['#FFFF80','#FFFF00','#FFCD00','#FF8D00','#FF4E00','#FF1600','#B21600','#711600','#321600','#001600']},
			legend: 'none',	
			backgroundColor: {fill:'#FFFFFF',stroke:'#FFFFFF' ,strokeWidth:0 },	
			datalessRegionColor: '#f5f5f5',
			displayMode: 'regions', 
			enableRegionInteractivity: 'true', 
			resolution: 'provinces',
			sizeAxis: {minValue: 1, maxValue:1, minSize:10,  maxSize: 10},
			region:'KR', 
			keepAspectRatio: true,
			tooltip: {textStyle: {color: '#444444'}, trigger:'focus'}	
		};
		
		var chart = new google.visualization.GeoChart(document.querySelector('.sc_mainup_right_content')); 
		chart.draw(data, options);
	}
	
	function checkPortion (num) {
	      if(0.00<=num && num<0.05) { return 0; }
	      if(0.05<=num && num<0.10) { return 1; }
	      if(0.10<=num && num<0.15) { return 2; }
	      if(0.15<=num && num<0.20) { return 3; }
	      if(0.20<=num && num<0.25) { return 4; }
	      if(0.25<=num && num<0.30) { return 5; }
	      if(0.30<=num && num<0.37) { return 6; }
	      if(0.37<=num && num<0.44) { return 7; }
	      if(0.44<=num && num<0.51) { return 8; }
	      if(0.51<=num && num<=1) { return 9; }
	   }

</script>
<body>
	<div class="wrapper">
		<input class="companyNo" type="hidden" value="${sessionScope.companyNo}">
		<input class="authorization" type="hidden" value="${sessionScope.empAuthorization}">
		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
					<input class="authority_check" type="hidden"
						value="${sessionScope.empAuthorization}">
					<ul>
						<li>
							<a class="head_a_word">ReciPhoto</a>
						</li>
						<li>
							<c:if test="${sessionScope.empAuthorization == 'employee'}">
								<a href="statistic" class="head_a_word_emp">Statistic</a>
							</c:if>
							<c:if test="${sessionScope.empAuthorization == 'manager'}">
								<a href="statisticManager" class="head_a_word_emp">Statistic</a>
							</c:if>
						</li>
						<c:if test="${sessionScope.loginId != null}">
							<li>
								<a href="calendar" class="head_a_word">Calendar</a>
							</li>
						</c:if>	
					</ul>
				</div>
				<div id="head_1_item2" class="head_logo">
					<div>
						<a href="${pageContext.request.contextPath}"><img
							class="images" src="images/head_logo2.png"></a>
					</div>
				</div>
				<div id="head_1_item3" class="head_btn1">
					<ul>
						<li class="login_btn">
							<div class="login_image">
								<img src="images/login_logo2.png">
							</div>
							<div class="login_charater">
								<c:if test="${sessionScope.empAuthorization == 'employee'}">
									<a href="updateEmployee" class="head_a_word" id="word_login">${sessionScope.loginName}(Employee)</a>
								</c:if>
								<c:if test="${sessionScope.empAuthorization == 'manager'}">
									<a href="updateEmployee" class="head_a_word" id="word_login">${sessionScope.loginName}(Manager)</a>
								</c:if>

							</div>
						</li>
						<li class="signup_btn">
							<div class="signup_image">
								<c:if test="${sessionScope.loginId == null}">
									<img src="images/signup_logo1.png">
								</c:if>
								<c:if test="${sessionScope.loginId != null}">
									<img src="images/logout2.png">
								</c:if>
							</div>
							<div class="signup_charater">
								<a class="head_a_word" href="logout">Logout</a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="statisticCompany">
		
			<div class="sc_menu">
				<div class="sc_menu_menubar">
					<div class="sc_menu_menubar1">
						<a href="statisticManager">Employee</a>
					</div>
					<div class="sc_menu_menubar2">
						<a href="statisticCompany">Company</a>
					</div>
				</div>
				<div class="sc_menu_blank">
				</div>
			</div>
			
			<div class="sc_main">
				<div class="sc_mainup">
					<div class="sc_mainup_left">
						<div class="sc_mainup_left_title">
							<div class="sc_mainup_left_title_image">
								<div>
									<img src="images/extend_graph.png">
								</div>
							</div>
							<div class="sc_mainup_left_title_title">
								<div>
									지역별 출장비 비율
								</div>	
							</div>
							<div class="sc_mainup_left_title_selectDiv">
								<select class="sc_mainup_left_title_select">
								</select>
							</div>
						</div>
						<div class="sc_mainup_left_content">
						</div>
					</div>
					<div class="sc_mainup_right">
						<div class="sc_mainup_right_title">
							<div class="sc_mainup_right_title_image">
								<div>
									<img src="images/extend_graph.png">
								</div>
							</div>
							<div class="sc_mainup_right_title_title">
								<div>
									전국 출장비 비교(카테고리별)
								</div>
							</div>
							<div class="sc_mainup_right_title_selectDiv">
								<select  class="sc_mainup_right_title_select">
									<option>선택</option>
									<option value="식비">식비</option>
									<option value="교통비">교통비</option>
									<option value="숙박비">숙박비</option>
									<option value="유류비">유류비</option>
									<option value="접대비">접대비</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="sc_mainup_right_content">
						</div>
					</div>
				</div>
				<div class="sc_maindown">
					<div class="sc_maindown_title">
						<div class="sc_maindown_title_image">
							<div>
								<img src="images/extend_graph.png">
							</div>
						</div>
						<div class="sc_maindown_title_title">
							<div>
								연도별 사용 금액
							</div>	
						</div>
					</div>
					<div class="sc_maindown_content">
					</div>
				</div>
			</div>
			
			<div class="sc_blank">
			
			</div>
		</div>
	</div>
</body>
</html>