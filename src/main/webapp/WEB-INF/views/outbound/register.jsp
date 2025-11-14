<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:20
  To change this template use File |
 Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고 리스트</a></li>

            <li classs="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/request/register">출고 요청</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <form id="registerForm">
                    <input type="hidden" name="user_index" value="${sessionScope.loginUser.id}" />


                    <div class="card-header">
                        <div class="card-title">출고 요청 등록</div>
                    </div>
                    <div class="card-body">


                        <div class="form-group">
                            <label for="item_index">상품 선택</label>
                            <select class="form-select" id="item_index" name="item_index" required>

                                <option value="">상품을 불러오는 중...</option>
                            </select>
                        </div>
                        <div class="form-group">

                            <label for="or_quantity">출고 수량</label>
                            <input type="number" class="form-control" id="or_quantity" name="or_quantity" placeholder="수량을 입력하세요" required>
                        </div>

                        <hr>

                        <h5 class="mb-3">배송 정보</h5>

                        <div class="form-group">
                            <label for="or_name">수취인명</label>

                            <input type="text" class="form-control" id="or_name" name="or_name" placeholder="수취인명을 입력하세요" required>
                        </div>

                        <div class="form-group">
                            <label for="or_phone">수취인 연락처</label>

                            <input type="text" class="form-control" id="or_phone" name="or_phone" placeholder="'-' 없이 숫자만 입력하세요" required>
                        </div>

                        <div class="form-group">

                            <label>배송 주소</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="or_zip_code" name="or_zip_code" placeholder="우편번호" readonly>

                                <button class="btn btn-outline-secondary" type="button" id="findAddressBtn">주소 찾기</button>
                            </div>
                        </div>
                        <div class="form-group">

                            <input type="text" class="form-control" id="or_street_address" name="or_street_address" placeholder="주소" readonly>
                        </div>
                        <div class="form-group">

                            <input type="text" class="form-control" id="or_detailed_address" name="or_detailed_address" placeholder="상세주소 입력">
                        </div>
                        <div class="form-group">
                            <label for="memo">요청 사항 (메모)</label>

                            <textarea class="form-control" id="memo" name="memo" rows="3" placeholder="특이사항을 입력하세요"></textarea>
                        </div>
                    </div>
                    <div class="card-action">

                        <button type="button" id="registerBtn" class="btn btn-primary">저장</button>
                        <a href="${contextPath}/outbound/requests" class="btn btn-danger">취소</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    const contextPath = "${contextPath}";
    // [단순화] MEMBER API 경로만 정의 (USER 전용 페이지)
    // [수정] 백틱(``) 대신 큰따옴표("") 사용
    const API_BASE = "${contextPath}/api/outbound";
    /**
     * 폼 데이터를 JS Object로 변환
     */
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => {
            data[key] = value;
        });
        return data;
    }

    /**
     * [신규] 카카오 주소 API 실행 함수
     */
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = ''; // 주소 변수
                if (data.userSelectedType === 'R') { // 도로명 주소

                    addr = data.roadAddress;
                } else { // 지번 주소
                    addr = data.jibunAddress;
                }

                // [DTO 반영] DTO 속성명(or_zip_code, or_street_address)에 값
                할당
                document.getElementById('or_zip_code').value = data.zonecode;
                document.getElementById("or_street_address").value = addr;
                document.getElementById("or_detailed_address").focus();
            }
        }).open();
    }

    /**
     * [DTO 반영] 상품 목록 로드 (TestInvenDTO 사용 가정)
     * API 예시: /api/inventory/items (별도 컨트롤러 필요)
     */
    async function loadItems() {
        const itemSelect = document.getElementById("item_index");
        try {
            // (API URL은 실제 상품 목록 API로 수정 필요)
            // [수정] 백틱(``) 대신 큰따옴표("") 사용
            const response = await axios.get("${contextPath}/api/inventory/items");
            // TestInvenDTO 속성 사용 (가정)
            const items = response.data;
            // (예: List<TestInvenDTO> 반환)

            itemSelect.innerHTML = '<option value="">상품을 선택하세요</option>';
            items.forEach(item => {
                // (item_name이 없으므로 item_index와 inven_index로 임시 표시)
                // (JSP EL이 없으므로 백틱 유지)
                itemSelect.innerHTML += `<option value="${item.item_index}">상품ID: ${item.item_index} (재고ID: ${item.inven_index})</option>`;
            });
        } catch (error) {
            console.error("Item loading failed:", error);
            itemSelect.innerHTML = '<option value="">상품 로딩에 실패했습니다.</option>';
        }
    }

    // --- 이벤트 리스너 ---

    // 페이지 로드 시
    document.addEventListener("DOMContentLoaded", () => {
        loadItems(); // 상품 목록 로드
        // '주소 찾기' 버튼에 클릭 이벤트 바인딩
        document.getElementById("findAddressBtn").addEventListener("click", execDaumPostcode);
    });
    // 저장 버튼 클릭 시
    document.getElementById("registerBtn").addEventListener("click", function() {
        const data = getFormData("registerForm"); // DTO 속성명(or_name 등)으로 데이터 수집

        // 유효성 검사
        if (!data.item_index || !data.or_quantity || !data.or_name || !data.or_phone || !data.or_street_address) {
            alert("필수 항목(상품, 수량, 수취인명, 연락처, 주소)을 모두 입력하세요.");
            return;
        }


        // [AXIOS]: RestController로 POST 전송 (MEMBER API 사용)
        // [수정] 백틱(``) 대신 문자열 연결(+) 사용
        axios.post(API_BASE + "/request", data, {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                alert("출고 요청이 등록되었습니다.");
                // [수정] 백틱(``) 대신 큰따옴표("") 사용
                location.href = "${contextPath}/outbound/requests"; // [경로 수정] list 페이지로 이동

            })
            .catch(error => {
                console.error("Registration failed:", error);
                alert("등록 실패: " + (error.response?.data?.message || "서버 오류"));
            });
    });
</script>
<%@ include file="../includes/end.jsp" %>