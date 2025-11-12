<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>
<c:if test="${not empty accessDenied}">
    <script>
        alert("${accessDenied}");
    </script>
</c:if>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">창고 조회</h4>

                <form method="get" action="${pageContext.request.contextPath}/warehouse/list"
                      class="d-flex gap-2" onsubmit="return checkSearch()">

                    <!-- 검색조건 선택 -->
                    <select class="form-select" name="typeStr" style="width:160px">
                        <option value=""         ${empty param.typeStr ? 'selected':''}>선택</option>
                        <option value="name"     ${param.typeStr == 'name' ? 'selected':''}>창고이름</option>
                        <option value="code"     ${param.typeStr == 'code' ? 'selected':''}>창고코드</option>
                        <option value="location" ${param.typeStr == 'location' ? 'selected':''}>소재지</option>
                    </select>

                    <!-- 검색 입력 -->
                    <input type="text" id="keywordInput" class="form-control"
                           name="keyword"
                           value="${fn:escapeXml(param.keyword)}"
                           style="width:200px"/>

                    <button type="submit" class="btn btn-primary">조회</button>

                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/warehouse/list">초기화</a>

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
                            <th> </th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="warehouse" items="${warehouses}">
                            <tr>
                                <td>${warehouse.WIndex}</td>
                                <td>${warehouse.WName}</td>
                                <td>${warehouse.WCode}</td>
                                <td>${warehouse.WAddress}</td>

                                <td>
                                    <a href="${pageContext.request.contextPath}/warehouse/${warehouse.WIndex}"
                                       class="btn btn-sm btn-primary">상세보기</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>

                    </table>
                </div>

                <!--  페이지네이션 -->
                <c:if test="${not empty pageMaker}">
                    <ul class="pagination justify-content-center mt-3">
                        <c:if test="${pageMaker.prev}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.startPage - 1}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">
                                    Previous
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
                            <li class="page-item ${cri.pageNum == num ? 'active' : ''}">
                                <a class="page-link"
                                   href="?pageNum=${num}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">
                                        ${num}
                                </a>
                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.endPage + 1}&amount=${cri.amount}&typeStr=${selectedTypeStr}&keyword=${fn:escapeXml(selectedKeyword)}">
                                    Next
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>

            </div>
        </div>
    </div>
</div>

<!--  지도 영역 -->
<div class="row mt-4">
    <div class="col-md-12">
        <div class="card">

            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">창고 위치</h4>
            </div>

            <div class="card-body">
                <div id="map" style="width:100%; height:500px; border-radius:10px;"></div>
            </div>

        </div>
    </div>
</div>

<%--검색필터가 선택일 때, 입력 불가--%>
<script>
    function toggleKeyword() {
        const type = document.querySelector("select[name='typeStr']").value;
        const keywordInput = document.getElementById("keywordInput");

        if (type === "") {
            keywordInput.value = "";
            keywordInput.disabled = true;
            keywordInput.placeholder = "검색 조건을 선택하세요";
        } else {
            keywordInput.disabled = false;
            keywordInput.placeholder = "검색어 입력";
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        const selectEl = document.querySelector("select[name='typeStr']");
        const keywordInput = document.getElementById("keywordInput");

        toggleKeyword();

        selectEl.addEventListener("change", toggleKeyword);
    });
</script>

<%--검색어 확인 : 비어있으면 alert--%>
<script>
    function checkSearch() {
        const keyword = document.querySelector("input[name='keyword']").value.trim();

        if (keyword === "") {
            alert("검색어를 입력하세요.");
            return false;
        }
        return true;
    }
</script>

<!--  warehouseList JS 배열 -->
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

<!--  카카오 지도 API -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 8
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();
    var bounds = new kakao.maps.LatLngBounds();


    let completed = 0;
    const total = warehouseList.length;
    warehouseList.forEach(function (warehouse) {

        if (!warehouse.address) return;

        geocoder.addressSearch(warehouse.address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {

                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:6px;font-size:13px;font-weight:bold;white-space:nowrap;">'
                        + warehouse.name +
                        '</div>'
                });

                var isOpen = false; // 인포윈도우 열림 여부 플래그

                kakao.maps.event.addListener(marker, 'click', function () {
                    if (isOpen) {
                        infowindow.close();
                        isOpen = false;
                    } else {
                        infowindow.open(map, marker);
                        isOpen = true;
                    }
                });


                bounds.extend(coords);
                map.setBounds(bounds);
            }
        });
    });
</script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>