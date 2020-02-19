<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출장 일정 등록</title>
<script src='resources/js/lib/jquery.min.js'></script>

<script>
	var coworkerList = [];
	var BusinessList = [];
	var send = {};

	$(function() {
		var startDate = $("#startDate").val();
		$("#start_date").val(startDate);

		var endDate = $("#endDate").val();
		$("#end_date").val(endDate);

		$("#add").on('click', add_coworker);
		$('#addBusiness').on('click', add_Business);
		$('#closePlan').on('click', close_plan);
		$("#btn_click").on('click', sendBusiness)

	})

	function add_Business(list) {
		var BusinessName = $("#BusinessName").val();
		var business_memo = $("#business_memo").val();
		var Main = $("#Main").val();
		var Sub = $("#Sub").val();
		var start_date = $("#start_date").val();
		var end_date = $("#end_date").val();
		var color = $("#color").val();
		
		send = {
			"businessName" : BusinessName,
			"businessStart" : start_date,
			"businessEnd" : end_date,
			"businessMemo" : business_memo,
			"businessColor" : color
		}
		

		$.each(list, function(index, item) {

			var empid = item.empid;
			var sendData = {
				"businessName" : BusinessName,
				"businessMemo" : business_memo,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessLocationMain" : Main,
				"businessLocationSub" : Sub,
				"businessColor" : color,
				"empId" : empid
			}
			BusinessList.push(sendData);
			
		})
	}

	function sendBusiness() {
		
		var BusinessName = $("#BusinessName").val();
		var business_memo = $("#business_memo").val();
		var Main = $("#Main").val();
		var Sub = $("#Sub").val();
		var start_date = $("#start_date").val();
		var end_date = $("#end_date").val();
		var color = $("#color").val();
		
	
		var sendData = { //로그인된 아이디 혼자 저장할때 + 본인 출장
				"businessName" : BusinessName,
				"businessMemo" : business_memo,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessLocationMain" : Main,
				"businessLocationSub" : Sub,
				"businessColor" : color,
				"empId" : $("#loginId").val()
			}
			BusinessList.push(sendData);
		
			send = {
				"businessName" : BusinessName,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessMemo" : business_memo,
				"businessColor" : color
			}
		
		
		
		$.ajax({
			method : 'POST',
			url : 'insertBusiness',
			dataType : 'json',
			data : JSON.stringify(BusinessList),
			contentType : 'application/json;charset=UTF-8',
			success : function(resp) {
				opener.render2(send)
				window.close();
			},
			error : function() {
				alert("insertBusinessError");
			}
		});
	}

	function close_plan() {
		window.close()
	}

	function add_coworker() {
		var companyNo = $("#companyNo").val();
		window.open("addCoworker?companyNo=" + companyNo, "ADDPLAN_1",
				"top=200,left=200,width=500,height=200");
	}

	function CoworkerList(list) {
		var result = '';
		for ( var i in list) {
			result += '<div class="content">';
			result += '<p class="id"> ' + list[i].empname + '</p>';
			result += '</div>';
		}

		$("#result_2").html(result);

	}
</script>


</head>
<body>
	<h2 align="center">[출장 일정 등록]</h2>
	<div>


		<table>
			<tr>
				<td>출장 제목</td>
				<td><input type="text" id="BusinessName" name="BusinessName" /></td>
			</tr>

			<tr>
				<td>Start</td>
				<td><input type="date" id="start_date" value="2018-08-08"
					name="start_date" readonly="readonly" /> <input type="hidden"
					id="startDate" value="${startDate}" readonly="readonly" /></td>
			</tr>

			<tr>
				<td>End</td>
				<td><input type="date" id="end_date" value="2018-08-08"
					name="end_date" readonly="readonly" /> <input type="hidden"
					id="endDate" value="${endDate}" readonly="readonly" /></td>
			</tr>

			<tr>
				<td>장소 1</td>
				<td><input type="text" id="Main" name="Main" /></td>
			</tr>

			<tr>
				<td>장소 2</td>
				<td><input type="text" id="Sub" name="Sub" /></td>
			</tr>
			<tr>
			<td>색상 선택</td>
			<td><select id="color" name="color">
					<option value="#ff9f89">빨강</option>
					<option value="#FFFF00">노랑</option>
					<option value="#04B404">초록</option>
			</select></td>
			</tr>
			<tr>
				<td>출장메모</td>
				<td><input type="text" id="business_memo"></td>
			</tr>
			<tr>
				<td>동료선택</td>
				<td><input type="button" id="add" value=" 동료선택 + " /></td>
			</tr>



			<tr>
			</tr>

			<tr>
				<td>동행 할 사람 목록</td>
				<td>
					<div id="result_2"></div>
				</td>
			</tr>

			<tr>
				<td><input type="hidden" id="loginId"
					value="${sessionScope.loginId}" /></td>
			</tr>


			<tr align="center">
				<td colspan="2"><input type="button" value="등록" id="btn_click">
					<input type="reset" value="취소" id="closePlan"></td>
			</tr>
			<tr>
				<td class="result"></td>
			</tr>


		</table>

		<input type="hidden" id="companyNo" value="${sessionScope.companyNo}">


	</div>

</body>
</html>