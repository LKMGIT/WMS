<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">창고조회</h4>

                <form method="get" action="${pageContext.request.contextPath}/warehouse/list" class="d-flex gap-2">
                    <!-- 필터 조건 검색 -->
                    <input type="text"
                           class="form-control"
                           name="keyword"
                           placeholder="검색"
                           value="${fn:escapeXml(param.keyword)}"
                           style="width:200px"/>

                    <!-- 필터 선택(드롭다운) -->
                    <select class="form-select" name="typeStr" style="width:160px">
                        <option value=""         ${empty param.typeStr ? 'selected':''}>전체</option>
                        <option value="name" ${param.typeStr == 'name' ? 'selected':''}>창고이름</option>
                        <option value="code" ${param.typeStr == 'code' ? 'selected':''}>창고코드</option>
                        <option value="location" ${param.typeStr == 'location' ? 'selected':''}>소재지</option>
                    </select>


                    <button type="submit" class="btn btn-primary">조회</button>

                    <!-- 옵션: 빠른 초기화 -->
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/warehouse/list">초기화</a>

                    <!-- 페이지 크기 유지 -->
                    <input type="hidden" name="amount" value="${cri.amount}"/>
                </form>
            </div>


            <div class="card-body">
                <div class="table-responsive">
                    <table id="basic-datatables" class="display table table-striped table-hover">
                        <thead>
                        <tr>
                            <th>창고번호</th>
                            <th>창고이름</th>
                            <th>창고코드</th>
                            <th>창고주소</th>
                            <th>창고상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="warehouse" items="${warehouses}">
                            <tr>
                                <td><c:out value="${warehouse.WIndex}"/></td>
                                <td><c:out value="${warehouse.WName}"/></td>
                                <td><c:out value="${warehouse.WCode}"/></td>
                                <td><c:out value="${warehouse.WAddress}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${warehouse.WStatus == 'NORMAL'}">정상</c:when>
                                        <c:when test="${warehouse.WStatus == 'INSPECTION'}">점검</c:when>
                                        <c:otherwise><c:out value="${warehouse.WStatus}"/></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션(필요 시 조건부로 노출) -->
                <c:if test="${not empty pageMaker}">
                    <ul class="pagination justify-content-center mt-3">
                        <c:if test="${pageMaker.prev}">
                            <li class="page-item">
                                <a class="page-link" href="?pageNum=${pageMaker.startPage - 1}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">Previous</a>
                            </li>
                        </c:if>

                        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
                            <li class="page-item ${cri.pageNum == num ? 'active':''}">
                                <a class="page-link" href="?pageNum=${num}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">${num}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="page-item">
                                <a class="page-link" href="?pageNum=${pageMaker.endPage + 1}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>


            </div>
        </div>
    </div>
</div>

<div class="mt-4">
    <h4>창고 위치</h4>
    <div id="map" style="width:100%; height:600px; margin-top:10px;"></div>
</div>

<script>
    const warehouseList = [
        <c:forEach var="warehouse" items="${warehouses}">
        {
            name: "${fn:escapeXml(warehouse.WName)}",
            address: "${fn:escapeXml(warehouse.WAddress)}",
            status: "${warehouse.WStatus}"
        },
        </c:forEach>
    ];
</script>
<script>
    var mapContainer = document.getElementById('map'),
        mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 8
        };

    // 지도 생성
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 지오코더
    var geocoder = new kakao.maps.services.Geocoder();

    // 마커 범위 자동조절용 bounds
    var bounds = new kakao.maps.LatLngBounds();

    // 리스트의 모든 주소로 마커 찍기
    warehouseList.forEach(function (warehouse) {

        if (!warehouse.address) return;

        geocoder.addressSearch(warehouse.address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {

                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                console.log("warehouseList:", warehouseList);
                // 마커 생성
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                // 인포 윈도우 추가
                var infowindow = new kakao.maps.InfoWindow({
                    content: `
                    <div style="
                        padding:8px;
                        font-size:13px;
                        font-weight:bold;
                        white-space:nowrap;
                    ">
                        ${warehouse.name}
                    </div>`
                });

                // 마우스 클릭시 인포 윈도우 생성
                kakao.maps.event.addListener(marker, 'click', function () {
                    infowindow.open(map, marker);
                });

                kakao.maps.event.addListener(marker, 'mouseout', function () {
                    infowindow.close();
                });

                // 지도 bounds 확장
                bounds.extend(coords);

                // 모든 마커가 보이도록 지도 범위 재설정
                map.setBounds(bounds);
            }
        });
    });
</script>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-notify/0.2.0/js/bootstrap-notify.min.js"></script>

<%@ include file="../includes/end.jsp" %>
