<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-8">
        <div class="card h-100">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">${warehouse.WName}</h4>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <tbody>

                        <tr><th style="width:200px;">창고번호</th><td>${warehouse.WIndex}</td></tr>
                        <tr><th>창고코드</th><td>${warehouse.WCode}</td></tr>
                        <tr><th>창고크기</th><td>${warehouse.WSize}</td></tr>
                        <tr><th>주소</th><td>${warehouse.WAddress}</td></tr>
                        <tr><th>우편번호</th><td>${warehouse.WZipcode}</td></tr>
                        <tr><th>등록일</th><td>${warehouse.WCreatedAt}</td></tr>
                        <tr><th>수정일</th><td>${warehouse.WUpdatedAt}</td></tr>

                        <tr>
                            <th>상태</th>
                            <td>
                                <c:choose>
                                    <c:when test="${warehouse.WStatus == 'NORMAL'}">정상</c:when>
                                    <c:when test="${warehouse.WStatus == 'INSPECTION'}">점검</c:when>
                                    <c:otherwise>${warehouse.WStatus}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-3">
                    <c:if test="${sessionScope.loginAdminRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/warehouse/${warehouse.WIndex}/update"
                           class="btn btn-primary px-3 py-2 fw-bold">
                            수정
                        </a>
                    </c:if>

                    <c:if test="${sessionScope.loginAdminRole != 'ADMIN'}">
                        <button type="button" class="btn btn-primary px-3 py-2 fw-bold"
                                onclick="alert('접근 권한이 없습니다.')">
                            수정
                        </button>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/warehouse/list"
                       class="btn btn-outline-secondary px-3 py-2 fw-bold">목록</a>
                </div>
            </div>

        </div>
    </div>


    <div class="col-md-4">
        <div class="card h-100">
            <div class="card-header">
                <h4 class="mb-0">창고 위치</h4>
            </div>

            <div class="card-body d-flex align-items-stretch">
                <div id="map" style="width:100%; height:100%; border-radius:10px;"></div>
            </div>
        </div>
    </div>
</div>

<!-- 지도 스크립트는 HTML 아래에 배치하는 것이 정석 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 4
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();

    const address = "${fn:escapeXml(warehouse.WAddress)}";

    if (address) {
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {

                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                var infowindow = new kakao.maps.InfoWindow({
                    content:
                        `<div style="padding:6px;font-size:12px;font-weight:bold;">
                            ${fn:escapeXml(warehouse.WName)}
                        </div>`
                });

                infowindow.open(map, marker);
                map.setCenter(coords);
            }
        });
    }
</script>

<%@ include file="../includes/footer.jsp" %>
