<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>Test</title>
<script src="resources/jquery-3.3.1.min.js"></script>
<style>
.left-box {
 
  float: left;
  width: 50%;
}
.right-box {
 
  float: right;
  width: 50%;
}
.dragAndDropDiv {
   border: 2px dashed #92AAB0;
   width: 550px;
   height: 500px;
   color: #92AAB0;
   text-align: center;
   vertical-align: middle;
   padding: 10px 0px 10px 10px;
   font-size: 200%;
   display: table-cell;
}

.progressBar {
   width: 500px;
   height: 22px;
   border: 1px solid #ddd;
   border-radius: 5px;
   overflow: hidden;
   display: inline-block;
   margin: 0px 10px 5px 5px;
   vertical-align: top;
}

.progressBar div {
   height: 100%;
   color: #fff;
   text-align: right;
   line-height: 22px;
   /* same as #progressBar height if we want text middle aligned */
   width: 0;
   background-color: #4CAF50;
   border-radius: 3px;
}

.statusbar {
   border-top: 1px solid #A9CCD1;
   min-height: 25px;
   width: 99%;
   padding: 10px 10px 0px 10px;
   vertical-align: top;
}

.statusbar:nth-child(odd) {
   background: #EBEFF0;
}

.filename {
   display: inline-block;
   vertical-align: top;
   width: 250px;
}

.filesize {
   display: inline-block;
   vertical-align: top;
   color: #30693D;
   width: 100px;
   margin-left: 10px;
   margin-right: 5px;
}

.abort {
   background-color: #A8352F;
   -moz-border-radius: 4px;
   -webkit-border-radius: 4px;
   border-radius: 4px;
   display: inline-block;
   color: #fff;
   font-family: arial;
   font-size: 13px;
   font-weight: normal;
   padding: 4px 15px;
   cursor: pointer;
   vertical-align: top
}
</style>
<script type="text/javascript">
              $(function(){
                var objDragAndDrop = $(".dragAndDropDiv");
                $('#Progress_Loading').hide();
             
                
                $(document).on("dragenter",".dragAndDropDiv",function(e){
                    e.stopPropagation();
                    e.preventDefault();
                    $(this).css('border', '2px solid #0B85A1');
                });
                $(document).on("dragover",".dragAndDropDiv",function(e){
                    e.stopPropagation();
                    e.preventDefault();
                });
                $(document).on("drop",".dragAndDropDiv",function(e){
                     
                    $(this).css('border', '2px dotted #0B85A1');
                    e.preventDefault();
                    var files = e.originalEvent.dataTransfer.files;
                    if (files.length > 1) {
                        alert('하나의 그림만 올려주세요.');
                        return;
                    }
                    if (files[0].type.match(/image.*/)) {
                                $(e.target).css({
                            "background-image": "url(" + window.URL.createObjectURL(files[0]) + ")",
                            "outline": "none",
                            "background-size": "100% 100%"
                        });
                    }else{
                      alert('이미지파일이 아닙니다.');
                      return;
                    }
                    handleFileUpload(files,objDragAndDrop);
                });
                 
                $(document).on('dragenter', function (e){
                    e.stopPropagation();
                    e.preventDefault();
                });
                $(document).on('dragover', function (e){
                  e.stopPropagation();
                  e.preventDefault();
                  objDragAndDrop.css('border', '2px dotted #0B85A1');
                });
                $(document).on('drop', function (e){
                    e.stopPropagation();
                    e.preventDefault();
                });
                 
                function handleFileUpload(files,obj)
                {
                   for (var i = 0; i < files.length; i++) 
                   {
                        var fd = new FormData();
                        fd.append('file', files[i]);
                  
                        var status = new createStatusbar(obj); //Using this we can set progress.
                        status.setFileNameSize(files[i].name,files[i].size);
                        sendFileToServer(fd,status);
                  
                   }
                }
                 
                var rowCount=0;
                function createStatusbar(obj){
                         
                    rowCount++;
                    var row="odd";
                    if(rowCount %2 ==0) row ="even";
                  //  this.statusbar = $("<div class='statusbar "+row+"'></div>");
                   // this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
                   // this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
                   // this.progressBar = $("<div class='progressBar'><div></div></div>").appendTo(this.statusbar);
                   // this.abort = $("<div class='abort'>중지</div>").appendTo(this.statusbar);
                     
                    obj.after(this.statusbar);
                  
                    this.setFileNameSize = function(name,size){
                        var sizeStr="";
                        var sizeKB = size/1024;
                        if(parseInt(sizeKB) > 1024){
                            var sizeMB = sizeKB/1024;
                            sizeStr = sizeMB.toFixed(2)+" MB";
                        }else{
                            sizeStr = sizeKB.toFixed(2)+" KB";
                        }
                  
                      //  this.filename.html(name);
                       // this.size.html(sizeStr);
                    }
                     
                    
                    this.setProgress = function(progress){       
                        var progressBarWidth =progress*this.progressBar.width()/ 100;  
                      
                        this.progressBar.find('div').animate({ width: progressBarWidth }, 4000).html(progress + "% ");
                        if(parseInt(progress) >= 100)
                        {
                           
                           //this.abort.hide();
                        }
                    }
                     
                    this.setAbort = function(jqxhr){
                        var sb = this.statusbar;
                        this.abort.click(function()
                        {
                           
                            jqxhr.abort();
                            sb.hide();
                        });
                    }
                }
                 
                function sendFileToServer(formData,status)
                {
                  //  var uploadURL = "/fileUpload/post"; //Upload URL
                    var extraData ={}; //Extra Data.
                    var jqXHR=$.ajax({
                            xhr: function() {
                            var xhrobj = $.ajaxSettings.xhr();
                            if (xhrobj.upload) {
                                    xhrobj.upload.addEventListener('progress', function(event) {
                                        var percent = 0;
                                        var position = event.loaded || event.position;
                                        var total = event.total;
                                        if (event.lengthComputable) {
                                            percent = Math.ceil(position / total *100);
                                        }
                                        //Set progress
                                        $('#Progress_Loading').show();
                                      //  status.setProgress(percent);
                                    }, false);
                                }
                            return xhrobj;
                        },
                        url: "fileUpload",
                        type: "POST",
                        contentType:false,
                        processData: false,
                        cache: false,
                        data: formData,

                        success: function(resp){
                           alert("사용자아이디"+
                                 resp);
                       
                           //status.setProgress(100);
                           $.ajax({
                              method : 'get',
                              url : 'changeImage',
                              data : 'empId='+resp,
                              success : function(){
                                 alert("2번째 성공");
                                 $('#Progress_Loading').hide();
                              
                              }
                              
                              
                           })
                           
                           
                           //$("#status1").append("File upload Done<br>");           
                        }
                    }); 
                  
                    status.setAbort(jqXHR);
                }
                 
            });
            
            
        </script>
</head>

<body>
<div class="left-box">
   <div id="fileUpload" class="dragAndDropDiv"><div id="Progress_Loading">
      <!-- 로딩바 -->
      <img src="images/Progress_Loading.gif" /></div>
      </div>
</div>
<div class="right-box">
날짜 <input type="date" readonly="readonly"><br>
사용처<input type="text"><br>

<table>
<tr><td>카테고리<td><td>이름<td><td>수량<td><td>가격<td></tr>
<div class="item">
</div>
</table>

결재수단 <input type="radio" name="group" >Card  <input type="radio" name="group">Cash<br>
영수증 메모<textarea rows="5" cols="20"></textarea><br>
<input type="button" value="전 송"><input type="reset" value="취 소">
</div>
   
   
</body>

</html>