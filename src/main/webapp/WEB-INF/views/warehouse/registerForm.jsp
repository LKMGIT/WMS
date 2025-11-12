<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<%@ include file="../includes/header.jsp" %>

<form id="registerForm">

    <div class="row">
        <div class="col-md-8">
            <div class="card h-100">
                <div class="card-header">
                    <h4 class="card-title mb-0">창고 등록</h4>
                </div>

                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <tbody>

                        <tr>
                            <th>창고이름</th>
                            <td><input type="text" name="wName" class="form-control" placeholder="창고 이름 입력" required></td>
                        </tr>

                        <tr>
                            <th>창고크기</th>
                            <td><input type="number" name="wSize" class="form-control" placeholder="예: 1000" required></td>
                        </tr>

                        <tr>
                            <th>소재지</th>
                            <td><input type="text" name="wLocation" class="form-control" readonly></td>
                        </tr>

                        <tr>
                            <th>주소</th>
                            <td class="d-flex gap-2">
                                <input type="text" name="wAddress" id="wAddress"
                                       class="form-control" style="flex:1;"
                                       placeholder="주소" readonly required>
                                <button type="button" class="btn btn-primary px-4 py-2 fw-bold"
                                        onclick="sample5_execDaumPostcode()">주소 검색</button>
                            </td>
                        </tr>

                        <tr>
                            <th>우편번호</th>
                            <td><input type="text" name="wZipcode" id="wZipcode" class="form-control" readonly></td>
                        </tr>

                        </tbody>
                    </table>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <button type="button" class="btn btn-primary px-4 py-2 fw-bold" onclick="registerWarehouse()">등록</button>
                        <a href="${pageContext.request.contextPath}/warehouse/list"
                           class="btn btn-outline-secondary px-4 py-2 fw-bold">취소</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header"><h4 class="mb-0">창고 위치</h4></div>
                <div class="card-body d-flex align-items-stretch">
                    <div id="map" style="width:100%; height:100%; border-radius:10px;"></div>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- 주소검색 -->
<div id="daumPostLayer"
     style="display:none; position:fixed; overflow:hidden; z-index:9999;
            top:50%; left:50%; transform:translate(-50%, -50%);
            width:400px; height:500px; border:1px solid #ccc;
            background:#fff; border-radius:10px;
            box-shadow:0 0 20px rgba(0,0,0,0.3);">

    <button onclick="closeDaumPostLayer()"
            class="btn btn-outline-secondary px-4 py-2 fw-bold"
            style="position:absolute; bottom:5px; right:5px; z-index:10000; border:none; background:none; font-size:20px;">
        취소
    </button>
</div>

<!-- 지도 + 주소검색 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = { center: new kakao.maps.LatLng(37.537187, 127.005476), level: 4 };
    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();
    var marker = new kakao.maps.Marker({ map: map, position: map.getCenter() });
    var elementLayer = document.getElementById('daumPostLayer');

    function sample5_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('wAddress').value = data.address;
                document.getElementById('wZipcode').value = data.zonecode;

                const region = data.sido || data.address.split(' ')[0];
                document.querySelector("input[name='wLocation']").value = region;

                elementLayer.style.display = 'none';
                geocoder.addressSearch(data.address, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var coords = new kakao.maps.LatLng(results[0].y, results[0].x);
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

    function closeDaumPostLayer() {
        elementLayer.style.display = 'none';
    }
</script>

<!--axios POST 등록 -->
<script>
    function registerWarehouse() {
        const data = {
            wName: document.querySelector("input[name='wName']").value,
            wSize: document.querySelector("input[name='wSize']").value,
            wLocation: document.querySelector("input[name='wLocation']").value,
            wAddress: document.querySelector("input[name='wAddress']").value,
            wZipcode: document.querySelector("input[name='wZipcode']").value
        };

        axios.post("/api/warehouse", data)
            .then(() => {
                alert("창고 등록 완료");
                window.location.href = "/warehouse/list";
            })
            .catch(error => {
                if (error.response && error.response.status === 400) {
                    alert(error.response.data);
                } else {
                    alert("서버 오류 발생");
                    console.error(error);
                }
            });
    }
</script>

<%@ include file="../includes/footer.jsp" %>
