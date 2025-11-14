<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<%@ include file="../includes/header.jsp" %>

<form method="post" action="${pageContext.request.contextPath}/warehouse/${warehouse.WIndex}/update">

    <div class="row">
        <div class="col-md-8">
            <div class="card h-100">
                <div class="card-header">
                    <h4 class="card-title mb-0">창고 수정</h4>
                </div>

                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <tbody>

                        <tr>
                            <th style="width:200px;">창고번호</th>
                            <td>${warehouse.WIndex}</td>
                        </tr>

                        <tr>
                            <th>창고이름</th>
                            <td>
                                <input type="text" name="wName" class="form-control"
                                       value="${warehouse.WName}" required>
                            </td>
                        </tr>

                        <tr>
                            <th>창고코드</th>
                            <td>
                                <input type="text" name="wCode" class="form-control"
                                       value="${warehouse.WCode}" readonly>
                            </td>
                        </tr>

                        <tr>
                            <th>창고크기</th>
                            <td>
                                <input type="number" name="wSize" class="form-control"
                                       value="${warehouse.WSize}" readonly>
                            </td>
                        </tr>

                        <!-- 주소검색 sample5 버전 적용 -->
                        <tr>
                            <th>주소</th>
                            <td class="d-flex gap-2">
                                <input type="text" name="wAddress" id="wAddress"
                                       class="form-control" style="flex:1;"
                                       value="${warehouse.WAddress}"
                                       placeholder="주소" readonly required>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-bold"
                                        onclick="sample5_execDaumPostcode()">주소 검색</button>
                            </td>
                        </tr>

                        <tr>
                            <th>우편번호</th>
                            <td>
                                <input type="text" name="wZipcode" id="wZipcode"
                                       value="${warehouse.WZipcode}"
                                       class="form-control" readonly>
                            </td>
                        </tr>

                        <tr>
                            <th>상태</th>
                            <td>
                                <select name="wStatus" class="form-select">
                                    <option value="NORMAL"     ${warehouse.WStatus == 'NORMAL' ? 'selected' : ''}>정상</option>
                                    <option value="INSPECTION" ${warehouse.WStatus == 'INSPECTION' ? 'selected' : ''}>점검</option>
                                </select>
                            </td>
                        </tr>

                        </tbody>
                    </table>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <button type="button" class="btn btn-primary px-4 py-2 fw-bold"
                                onclick="updateWarehouse()">저장</button>

                        <button type="button" class="btn btn-danger px-4 py-2 fw-bold"
                                data-bs-toggle="modal" data-bs-target="#deleteModal">
                            삭제
                        </button>

                        <a href="${pageContext.request.contextPath}/warehouse/${warehouse.WIndex}"
                           class="btn btn-outline-secondary px-4 py-2 fw-bold">취소</a>
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
</form>

<!--  Daum 주소검색 중앙 모달 -->
<div id="daumPostLayer"
     style="display:none; position:fixed; overflow:hidden; z-index:9999;
            top:50%; left:50%; transform:translate(-50%, -50%);
            width:400px; height:500px; border:1px solid #ccc;
            background:#fff; border-radius:10px;
            box-shadow:0 0 20px rgba(0,0,0,0.3);">

    <!-- 취소 버튼 -->
    <button onclick="closeDaumPostLayer()"
            class="btn btn-outline-secondary px-4 py-2 fw-bold"
            style="position:absolute; bottom:5px; right:5px; z-index:10000; border:none; background:none; font-size:20px;">
        취소
    </button>

</div>

<!--  삭제 확인 모달 -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">창고 삭제</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <p>정말 이 창고를 삭제하시겠습니까?</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-danger" onclick="removeWarehouse()">예</button>
                <button type="button" class="btn btn-outline-secondary px-4 py-2 fw-bold" data-bs-dismiss="modal">아니오</button>
            </div>

        </div>
    </div>
</div>

<script>
    // JSP 세션 값 → JS 변수에 주입
    const role = '${fn:escapeXml(sessionScope.loginAdminRole)}';
</script>


<!--  지도 + 주소검색 + 수정 + 삭제 스크립트 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

<script>
    var mapContainer = document.getElementById('map');

    var mapOption = {
        center: new kakao.maps.LatLng(37.537187, 127.005476),
        level: 4
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();

    var marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(37.537187, 127.005476)
    });

    // 인포 윈도우
    var infowindow = new kakao.maps.InfoWindow({
        content: `<div style="padding:6px;font-size:12px;font-weight:bold;">
                    ${fn:escapeXml(warehouse.WName)}
                  </div>`
    });
    infowindow.open(map, marker);

    var elementLayer = document.getElementById('daumPostLayer');

    function sample5_execDaumPostcode() {

        new daum.Postcode({
            oncomplete: function(data) {

                document.getElementById('wAddress').value = data.address;
                document.getElementById('wZipcode').value = data.zonecode;

                elementLayer.style.display = 'none';

                geocoder.addressSearch(data.address, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var result = results[0];
                        var coords = new kakao.maps.LatLng(result.y, result.x);

                        map.setCenter(coords);
                        marker.setPosition(coords);
                    }
                });
            },

            width: '100%',
            height: '100%'
        }).embed(elementLayer);

        elementLayer.style.display = 'block';
    }

    function updateMap(address) {
        const role = '${fn:escapeXml(sessionScope.loginAdminRole)}';

        if (role !== 'ADMIN') {
            alert('접근 권한이 없습니다.');
            return;
        }

        if (!address) return;
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {

                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                marker.setPosition(coords);

                map.setCenter(coords);

                // 인포윈도우 다시 표시
                infowindow.open(map, marker);
            }
        });
    }

    window.onload = function() {
        updateMap("${fn:escapeXml(warehouse.WAddress)}");
    }
</script>

<script>
    function updateWarehouse() {
        const role = '${fn:escapeXml(sessionScope.loginAdminRole)}';

        if (role !== 'ADMIN') {
            alert('접근 권한이 없습니다.');
            return;
        }

        const id = "${warehouse.WIndex}";
        const wName = document.querySelector("input[name='wName']").value.trim();
        const wAddress = document.querySelector("input[name='wAddress']").value.trim();
        const wZipcode = document.querySelector("input[name='wZipcode']").value.trim();
        const wStatus = document.querySelector("select[name='wStatus']").value;

        if (!wName) {
            alert("창고 이름을 입력해주세요.");
            document.querySelector("input[name='wName']").focus();
            return;
        }
        if (!wAddress) {
            alert("주소를 입력해주세요.");
            return;
        }
        if (!wZipcode) {
            alert("우편번호를 입력해주세요.");
            return;
        }

        const data = { wName, wAddress, wZipcode, wStatus };

        axios.put(`/api/warehouse/${id}`, data)
            .then(() => {
                alert("창고 수정 완료");
                window.location.href = `/warehouse/${id}`;
            })
            .catch(error => {
                alert("창고 수정 실패");
                console.error(error);
            });
    }
</script>

<script>
    function removeWarehouse() {
        const role = '${fn:escapeXml(sessionScope.loginAdminRole)}';

        if (role !== 'ADMIN') {
            alert('접근 권한이 없습니다.');
            return;
        }

        const id = "${warehouse.WIndex}";

        axios.delete(`/api/warehouse/${id}`, {
            headers: {
                "Content-Type": "application/json"
            }
        })
            .then(response => {

                const modal = bootstrap.Modal.getInstance(document.getElementById('deleteModal'));
                modal.hide();

                alert("창고 삭제 완료");
                window.location.href = "/warehouse/list";
            })
            .catch(error => {
                alert("창고 삭제 실패");
                console.error(error);
            });
    }
</script>

<script>
    function closeDaumPostLayer() {
        elementLayer.style.display = 'none';
    }
</script>

<%@ include file="../includes/footer.jsp" %>
