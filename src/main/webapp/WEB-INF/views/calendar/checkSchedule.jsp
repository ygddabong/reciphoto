<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 수정</title>
<script src='resources/js/lib/jquery.min.js'></script>
<script>

function close_plan(){
   
   window.close()
}

$(function(){
	$("#updateSchedule").on("click",updateSchedule);
	
    

})
function updateSchedule(){
	
	var businessNo=$("#businessNo").val();
	var scheduleNo=$("#scheduleNo").val();
    var scheduleTitle = $("#scheduleTitle").val();
  	var scheduleDay=  $("#scheduleDay").val();
	var scheduleContext = $("#scheduleContext").val();
    var schedulePlace = $("#schedulePlace").val();
    var empId =$("#empId").val();
	var schedule_Day = $("#schedule_Day").val();
	$("#scheduleDay").val(schedule_Day);
	var scheduleDay = $("#scheduleDay").val();
	
    var sendData ={
    		"businessNo" :businessNo,
    		"scheduleNo" : scheduleNo,
    		"scheduleTitle" : scheduleTitle,
    		"scheduleDay" : scheduleDay,
    		"scheduleContext" : scheduleContext,
    		"schedulePlace" : schedulePlace
    		}
    
    var send = {
    		id : scheduleNo,
    		start: scheduleDay,
    		title : scheduleTitle,
    		description : scheduleContext
    }
    

    
	
	$.ajax({
		method:'post',
		url:'updateSchedule',
		data: JSON.stringify(sendData),
		dataType:'text',
		contentType : 'application/json;charset=UTF-8',
		async : false,
		success:function(resp){
			opener.render3(send);
			window.close();
		},
		error:function(){
			alert("수정 오류");
		}
	})
}

</script>
</head>
<body>
<h2 align="center">[일정확인]</h2>
   <div>


         <table>
            <tr>
            
               <td><input type="hidden" id="businessNo" value="${Schedule.businessNo}"  /></td>
      				
            </tr>
            <tr>
            
               <td><input type="hidden" id="scheduleNo" value="${Schedule.scheduleNo}"  /></td>
               
               <td><input type="hidden" id="empId" value="${sessionScope.loginId}"/></td>
            </tr>
            
            <tr>
               <td>날짜</td>
               <td><input type="date" id="scheduleDay" name="scheduleDay" readonly="readonly"  value="${Schedule.scheduleDay}"/>
               <input type="hidden" id="schedule_Day" value="${Schedule.scheduleDay}" />
                  
            </tr>

            <tr>
               <td>일정제목</td>
               <td><input type="text" id="scheduleTitle" name="scheduleTitle" value="${Schedule.scheduleTitle}" /></td>
            </tr>
            
            <tr>
               <td>장소</td>
               <td><input type="text" id="schedulePlace" name="schedulePlace"  value="${Schedule.schedulePlace}" /></td>
            </tr>
      
            <tr>
               <td>일정내용</td>
               <td><textarea rows="4" cols="20" id="scheduleContext" name="scheduleContext"  >${Schedule.scheduleContext}</textarea></td>
            </tr>


            <tr align="center">
               <td colspan="2">
               <input type="button" value="수정" id ="updateSchedule" /></td>
              <td> <input type="reset" value="취소" id ="closePlan" onclick="close_plan()"/></td>
            </tr>

         </table>
      
      
   </div>

</body>
</html>