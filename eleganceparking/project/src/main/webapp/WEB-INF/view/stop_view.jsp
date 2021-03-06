<%@ page contentType="text/html;charset=utf-8" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

<html>
<head>
  
  <title>Stop</title>  
   
  <!-- style, css 시작 --> 
  <link rel='stylesheet' href='./source/css/style.css' type='text/css' media='all'/>  
  
  <style>
  
    .logo{ width:400px; }
    .headerButton{ float:right; margin-left:15px; margin-bottom:5px; width:120px; }
    .mapButton{ float:right; margin-left:15px; margin-top:5px; width:140px; }
    .stopcentericon{ position:relative; text-align:center; }
    
    #loginbutton { margin-top:3px; width:90px  }
    #joinbutton { margin-top:3px; width:90px; }   
     
    @media screen and (min-width:400px) { .img{ width:300px} 
    .parkingicon { text-align:center } .stopicon { text-align:center }
    .loginicon{text-align:right}
    .joinicon{text-align:right}   
    }
    
    @media screen and (min-width:800px) { .img{ width:400px} 
    .parkingicon { float:left; margin-left:30px; }
    .stopicon { display:inline-block; float:right; margin-right:30px; }
    .mom {display:-webkit-box; -webkit-box-orient:horizontal; float:right;}
    .loginicon { margin-left:10px; -webkit-box-ordinal-group:1;}
    .joinicon { margin-left:10px; -webkit-box-ordinal-group:2;}         
    }
        
    .w3-content{margin-left:auto;margin-right:auto;max-width:980px;}
    .w3-modal{z-index:3;display:none;padding-top:100px;position:fixed;left:0;top:0;width:100%;height:100%;overflow:auto;background-color:rgb(0,0,0);background-color:rgba(0,0,0,0.4)}
    .w3-modal-content{margin:auto;background-color:#fff;position:relative;padding:0;outline:0;width:600px}
    
    @media (max-width:600px){.w3-modal-content{margin:0 10px;width:auto!important}.w3-modal{padding-top:30px}
    .w3-dropdown-hover.w3-mobile .w3-dropdown-content,.w3-dropdown-click.w3-mobile .w3-dropdown-content{position:relative}  
    .w3-hide-small{display:none!important}.w3-mobile{display:block;width:100%!important}.w3-bar-item.w3-mobile,.w3-dropdown-hover.w3-mobile,.w3-dropdown-click.w3-mobile{text-align:center}
    .w3-dropdown-hover.w3-mobile,.w3-dropdown-hover.w3-mobile .w3-btn,.w3-dropdown-hover.w3-mobile .w3-button,.w3-dropdown-click.w3-mobile,.w3-dropdown-click.w3-mobile .w3-btn,.w3-dropdown-click.w3-mobile .w3-button{width:100%}} 
    @media (max-width:768px){.w3-modal-content{width:500px}.w3-modal{padding-top:50px}}
    @media (min-width:993px){.w3-modal-content{width:900px}.w3-hide-large{display:none!important}.w3-sidebar.w3-collapse{display:block!important}}       
  
    #xbutton { float:right; margin-right:10px; margin-top:5px; }
    #closebutton { float:right; }
    #infonote { padding-left:40px; padding-top:10px; }
            
  </style>
  <!-- style, css 끝 -->
  
  <script>
    function userLogout() { location.href = "logout.do" }
  </script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src ="./source/js/getPosition.js"></script>
  <script src ="./source/js/non_user_alert.js"></script>
  <script src ="./source/js/default_map.js"></script>
  <script src ="./source/js/stop_view.js"></script>
  <script src ="./source/js/polygon_create.js"></script>  
  <script>  
  $(document).ready(function() {
	  $("#ShowAll").on("click",function(){
		  
          var positions = [];
          
          <c:forEach var="lots" items="${RPlots}">
          positions.push({content:'<div>${lots.rpnum}<br>${lots.rpplacenm}<br>운영시간: ${lots.operday}</div>', latlng: new kakao.maps.LatLng(${lots.latitude}, ${lots.longitude})})
          </c:forEach>
          
          for (var i = 0; i < positions.length; i ++) {
          
              var marker = new kakao.maps.Marker({
                  map: map, 
                  position: positions[i].latlng // 마커의 위치
                  
              });
          
          
              var infowindow = new kakao.maps.InfoWindow({
                  content: positions[i].content // 인포윈도우에 표시할 내용
              });
          
              kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
              kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
          };
          
 
		  
	  });
	  
	  $("#DayShow").on("click",function(){
		  
          var positions = [];
          
          <c:forEach var="lots" items="${RPlots}">
          <c:if test="${lots.operday eq '야간'}">
          positions.push({content:'<div>${lots.rpnum}<br>${lots.rpplacenm}<br>거주자(주간 무료)</div>', latlng: new kakao.maps.LatLng(${lots.latitude}, ${lots.longitude})})
          </c:if>
          </c:forEach>
          
          for (var i = 0; i < positions.length; i ++) {
          
              var marker = new kakao.maps.Marker({
                  map: map, 
                  position: positions[i].latlng // 마커의 위치
                  
              });
          
          
              var infowindow = new kakao.maps.InfoWindow({
                  content: positions[i].content // 인포윈도우에 표시할 내용
              });
          
          
              kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
              kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
              kakao.maps.event.addListener(marker, 'click', function() {
          		
          	    var lat = marker.getPosition().getLat();
          	    var lng = marker.getPosition().getLng();
          	    var email = "<c:out value='${user.useremail}'/>";
          	    
          	    var fav = {
          	    	favlat : lat,
          	    	favlng : lng,
          	    	usermail : email
          	    };
          	    
          	    $.ajaxSettings.traditional = true;
          	    $.ajax({
          	        type: "POST",
          	        url : "<c:url value='/MyFavLo.do' />",
          	        data : JSON.stringify(fav),
          	        contentType : "application/json",
          	        dataType : "json",
          	        success : function(data){
          	            alert("성공");
          	        },error : function(request,status,error){
          	            //Ajax 실패시
          	      	  alert("처리에 실패하였습니다.\ncode:"+request.status+"\n"+"error:"+error);
          	         
          	        }
          	    });

          		});     
 
          }
	  	
	  });	  
	  
	  $("#NightShow").on("click",function(){
          var positions = [];
          <c:forEach var="lots" items="${RPlots}">
          <c:if test="${lots.operday eq '주간'}">
          positions.push({content:'<div>${lots.rpnum}<br>${lots.rpplacenm}<br>거주자(야간 무료)</div>', latlng: new kakao.maps.LatLng(${lots.latitude}, ${lots.longitude})})
          </c:if>
          </c:forEach>
          for (var i = 0; i < positions.length; i ++) {
              var marker = new kakao.maps.Marker({
                  map: map, 
                  position: positions[i].latlng // 마커의 위치
                  
              });
              var infowindow = new kakao.maps.InfoWindow({
                  content: positions[i].content // 인포윈도우에 표시할 내용
              });
          
              kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
              kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
              kakao.maps.event.addListener(marker, 'click', function() {
          		
          	    var lat = marker.getPosition().getLat();
          	    var lng = marker.getPosition().getLng();
          	    var email = "<c:out value='${user.useremail}'/>";
          	    
          	    var fav = {
          	    	favlat : lat,
          	    	favlng : lng,
          	    	usermail : email
          	    };
          	    
          	    $.ajaxSettings.traditional = true;
          	    $.ajax({
          	        type: "POST",
          	        url : "<c:url value='/MyFavLo.do' />",
          	        data : JSON.stringify(fav),
          	        contentType : "application/json",
          	        dataType : "json",
          	        success : function(data){
          	            alert("성공");
          	        },error : function(request,status,error){
          	      	  alert("처리에 실패하였습니다.\ncode:"+request.status+"\n"+"error:"+error);       	         
          	        }
          	    });
          });         
	  }
   });
	  
	  
      function makeOverListener(map, marker, infowindow) {
          return function() {
              infowindow.open(map, marker);
          }
      }
      
      function makeOutListener(infowindow) {
          return function() { infowindow.close(); 
          };
      }

		
		$("#MyParkPs").on("click",function(){
			alert("주차 위치를 클릭해주세요")	
			var center = map.getCenter();
			
		var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
			imageSize = new daum.maps.Size(24, 35); 

		var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize);
			
			var marker = new kakao.maps.Marker({ 
				position: center,
				image : markerImage
			}); 
			marker.setMap(map); 
			
			kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
			    
			    // 클릭한 위도, 경도 정보를 가져옵니다 
			    var latlng = mouseEvent.latLng; 
			    
			    // 마커 위치를 클릭한 위치로 옮깁니다
			    marker.setPosition(latlng);		    
			    
			});
			
		var iwContent = '<div style="padding:5px;">주차위치!</div>'
		iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다

		// 인포윈도우를 생성합니다
		var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent,
		    removable : iwRemoveable
		});
		
		kakao.maps.event.addListener(marker, 'click', function() {
		      // 마커 위에 인포윈도우를 표시합니다
		      infowindow.open(map, marker);  
		      var lat = marker.getPosition().getLat();
		      var lng = marker.getPosition().getLng();
		      var email = "<c:out value='${user.useremail}'/>";
		      
		      
		      let point = {
		    		  usermail : email,
		    		  parklat : lat,
		    		  parklng : lng
		      }
		      
		      
		      $.ajaxSettings.traditional = true;
		      $.ajax({
		          type: "POST",
		          url : "<c:url value='/MyParkLo.do' />",
		          data : JSON.stringify(point),
		          contentType : "application/json",
		          dataType : "json",
		          success : function(data){
		              alert("저장 성공");
		          },error : function(request,status,error){
		              //Ajax 실패시
		        	  alert("처리에 실패하였습니다.\ncode:"+request.status+"\n"+"error:"+error);
		           
		          }
		      });

		});
		});
  }); 
</script> 
</head>


<!-- body 시작 -->
<body class="home page page-template page-template-template-portfolio page-template-template-portfolio-php">

  <div id="page">
    <div class="container">  
    
    <!-- header 시작 -->		
    <header id="masthead" class="site-header">
 
      <c:if test='${empty user}'>
       <div class="mom">
        <div class='loginicon'>
          <form action="./login.do" method="post">          
        	 <a>아이디 : </a><input type="text" name="useremail" size="15" maxlength="30"/>
        	 <a>비밀번호 : </a><input type="password" name="userpwd" size="15" maxlength="12"/>
        	 <input type="submit" id="loginbutton" value="로그인" />
           </form>
        </div>
        <div class='joinicon'>  
          <a href="./join.do"><input type="button" id='joinbutton' value="회원가입"></a>
        </div>   
       </div>
      </c:if>

	  <c:if test='${not empty user}'>
		<div style='text-align:right'>
    		${user.username}님 로그인 중 &nbsp;&nbsp;
    		<input type="submit" id="logout" onClick="userLogout()" value="로그아웃" />
		</div>
	 </c:if> 
      
      <br>
      <br>
      <br>
      <br> 

    <!-- 제목 시작 -->            
    <div class="site-branding">
      <a href="./main.do"><img src="./source/img/logo.jpg" class="logo" /></a>
      <br>
      <h2 class="site-description"><a>위치기반 &nbsp;&nbsp;&nbsp;주차장 / 주정차 &nbsp;&nbsp;&nbsp;정보</a></h2>
    </div>
    <!-- 제목 끝 -->
        
    <!-- 네비, nav 시작 -->    
      <nav id="site-navigation" class="main-navigation">        
          <div class="menu-container">
            <ul id="menu-1" class="menu">               
              <li><a href="./parking.do"><img src="./source/img/parking.png" width="45px"/>&nbsp;&nbsp;</a></li>
              <li><a href="./stop.do"><img src="./source/img/stop.png" width="45px"/></a>&nbsp;&nbsp;</a></li>
              <li><a onclick="document.getElementById('info').style.display='block'"><img src="./source/img/information.png" width="45px"/>&nbsp;&nbsp;</a></li>                
              <li><a href="./notice.do"><img src="./source/img/notice.png" width="45px"/></a></li>                
            </ul>
           </div>
      </nav>
      <!-- 네비, nav 끝 --> 
      
      
      <!-- 이용안내 시작 -->
  <div id="info" class="w3-modal">
    
    <div class="w3-modal-content w3-animate-top w3-card-4">
      <header class="w3-container w3-teal w3-center w3-padding-32"> 
        <span onclick="document.getElementById('info').style.display='none'" 
              class="w3-button" id="xbutton">&times;</span>
      </header>
      
      <div class="w3-container" >
      
        <div id="infonote">          
          <h3>이용 안내</h3>
          <p>&nbsp;</p>
          <h4>본 프로젝트는 </h4>
          <h4>오픈API를 활용하여 주차장 및 주정차 정보를 제공하는 웹페이지이며</h4>
          <h4>누구나 자유롭게 사용가능합니다.</h4>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <h4>공공데이터 활용 현황</h4>
          <p>&nbsp;</p>
          <p>주차장 정보</p>
          <p>주정차 금지(지정)구역</p>  
          <p>불법주정차 단속현황</p>
          <p>거주자우선 주차정보</p>         
          <p>&nbsp;</p>
          <p>&nbsp;</p>
        </div>
        
       <button class="w3-button w3-red w3-section" onclick="document.getElementById('info').style.display='none'" id="closebutton" > Close <i class="fa fa-remove"></i></button>       
      </div>
    </div>
    
  </div>
  <!-- 이용안내 시작 끝 -->      
  
  <!-- 이용안내 함수 -->    
  <script>  
  var modal = document.getElementById('info');
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  } 
  </script>
             
  </header>
  <!-- header 끝 -->    
   
      
  <!-- Main Content 시작 -->     
  <div id="content" class="site-content">
    <div id="primary" class="content-area column full">
      <main id="main" class="site-main">
             
        <!-- article 시작 -->    
        <article id="post-39" class="post-39 page type-page status-publish hentry">
         
          <!-- centericon 시작 -->        
          <div class="stopcentericon">
            <a><img src="./source/img/stop.png" width="150px"/></a>
          </div>
          <!-- centericon 끝 -->
             
          <br>    
          
          <!-- 위 button 시작 -->     
          <div class="headerButtondiv">   
          <!-- 로그인을 하지 않은 상태라면, 경고창이 뜨도록 -->
			<c:if test='${empty user}'>			
				<input type="button"class="headerButton" onclick="non_user();" value="즐겨 찾기">
				<input type="button" class="headerButton"onclick="non_user();" value="주차 위치">			
			</c:if>
			
            <c:if test='${not empty user}'>     
				<a href=./parking.do><input type="button" class="headerButton" value="즐겨 찾기"></a>
				<input id="MyParkPs" type="button" class="headerButton" value="주차 위치">		
	        </c:if>
	        
            <input type="button" class="headerButton" onclick="getPosition()"value="내 위치">    
          </div>
          <!-- 위 button 끝 -->
          
          <!-- map 시작 -->            
          <div class="entry-content">             
            <div id="map" style="width:100%;height:500px;"></div>  
            
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0f4f915f91717b8e6f20f6b1f4018f2a"></script>
            
            <script>
            
            var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = {
		        center: new kakao.maps.LatLng(35.162307, 128.985956), // 지도의 중심좌표
		        level: 6, // 지도의 확대 레벨
		        mapTypeId : kakao.maps.MapTypeId.ROADMAP // 지도종류
		    }; 

		// 지도를 생성한다 
		var map = new kakao.maps.Map(mapContainer, mapOption); 

		// 지도에 확대 축소 컨트롤을 생성한다
		var zoomControl = new kakao.maps.ZoomControl();

		// 지도의 우측에 확대 축소 컨트롤을 추가한다
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);		



          </script>         
             
         <div class="stopmapButton"> 
          <input type="button" class="mapButton" onclick="polygonCreate()" value="주정차 위반현황">          
          <input type="button" class="mapButton" onclick="NoPark()"value="주정차 금지구역">
          <input id="ShowAll" type="button" class="mapButton" value="모두 보기">
          <input id="NightShow" type="button" class="mapButton" value="주정차 야간가능">
          <input id="DayShow" type="button" class="mapButton" value="주정차 주간가능">
         </div>  
                  
          </div>
          <!-- map 끝 -->          
       
          
        </article>        
      </main>     
    </div>
  </div>
  <!-- Main Content 끝 -->    
  
      <br>
      <br>             
            
  </div>
 
  
            
  <!-- footer 시작 -->  
  <footer id="colophon" class="site-footer">
    <div class="container">
      <div class="site-info">
        <br>
        <h3 style="font-family:'';color: #ccc;font-weight:300;text-align: center;margin-bottom:0;margin-top:0;line-height:1.4;font-size: 20px;">코.하.친 (코딩하는친구들)</h3><br>
        <a>Training for the 4th Industrial Revolution.</a><br>
        <a>Open API를 활용한 빅데이터 전처리·시각화(B반), </a>
        <a>2019</a>
      </div>
    </div>
  </footer>
  <!-- footer 끝 --> 

</div>  

</body>
</html>