<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 등록</title>
<script src='resources/js/lib/jquery.min.js'></script>

<script>
	function add_plan() {
		var scheduleContext = $("#scheduleContext").val();
		var scheduleTitle = $("#scheduleTitle").val();
		var schedulePlace = $("#schedulePlace").val();
		var scheduleDay = $("#scheduleDay").val();
		var empId = $("#empId").val();
		var businessWith = $("#businessWith").val();

		if (scheduleContext < 2 || schedulePlace == "") {
			alert("내용을 확인해주세요.")
		} else {
			$.ajax({
				method : "get",
				data:"businessWith="+businessWith,
				url : "selectBusinessNo",
				dataType : 'text',
				async : false,
				success : function(resp) {

						var sendData = {
							"businessNo" : resp,
							"scheduleTitle" : scheduleTitle,
							"scheduleDay" : scheduleDay,
							"schedulePlace" : schedulePlace,
							"scheduleContext" : scheduleContext
						}

						$.ajax({
							method : 'POST',
							url : 'insertPlan',
							data : JSON.stringify(sendData),
							async : false,
							contentType : 'application/json;charset=UTF-8',
							success : function(resp) {
								opener.render(sendData);
								//alert("전송완료");
							},
							error : function() {
								alert("에러_")
							}
						})//끝

						window.close();

				}
			})

		}
	}

	function close_plan() {
		window.close()
	}
</script>


</head>
<body>
	<h2 align="center">[일정등록]</h2>
	<div>


		<table>
			<tr>
				<td><input type="hidden" id="businessWith"
					value="${businessWith}" /></td>
			</tr>
			<tr>

				<td><input type="hidden" id="scheduleNo" readonly="readonly" /></td>
				<td><input type="hidden" id="empId"
					value="${sessionScope.loginId}" /></td>
			</tr>

			<tr>
				<td>날짜</td>
				<td><input type="date" id="scheduleDay" readonly="readonly"
					value="${selectDate}" />
			</tr>

			<tr>
				<td>일정제목</td>
				<td><input type="text" id="scheduleTitle" name="scheduleTitle" /></td>
			</tr>

			<tr>
				<td>장소</td>
				<td><input type="text" id="schedulePlace" name="schedulePlace" /></td>
			</tr>

			<tr>
				<td>일정내용</td>
				<td><textarea rows="4" cols="20" id="scheduleContext"
						name="scheduleContext"></textarea></td>
			</tr>


			<tr align="center">
				<td colspan="2"><input type="button" value="등록" id="addPlan"
					onclick="add_plan()"> <input type="reset" value="취소"
					id="closePlan" onclick="close_plan()"></td>
			</tr>

		</table>


	</div>

</body>
</html>