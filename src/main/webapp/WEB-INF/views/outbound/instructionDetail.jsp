<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-11
  Time: 오후 5:00
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- [중요] 뷰 컨트롤러가 Model에 "si_index"를 전달해야 함 --%>
<c:set var="si_index" value="${si_index}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/instructions">출고 지시서 목록</a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고지시서 상세</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">출고지시서 상세 (지시서 번호:
                        <span id="detailSiIndex">...</span>)
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품명 (item_name)</label>
                                <input type="text" class="form-control" id="detailItemName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>출고 수량 (or_quantity)</label>
                                <input type="text" class="form-control" id="detailOrQuantity" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">출고 위치 정보</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>창고 ID (warehouse_index)</label>
                                <input type="text" class="form-control" id="detailWarehouseIndex" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>구역 ID (section_index)</label>
                                <input type="text" class="form-control" id="detailSectionIndex" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">지시 상태</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>승인일 (approved_at)</label>
                                <input type="text" class="form-control" id="detailApprovedAt" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>운송장 상태 (si_waybill_status)</label>
                                <input type="text" class="form-control" id="detailSiWaybillStatus" readonly>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-action d-flex justify-content-between">
                    <a href="${contextPath}/outbound/instructions" class="btn btn-secondary">목록으로</a>
                    <div>
                        <%-- [신규] 이전/다음 버튼 영역 (ShippingInstructionDetailDTO 기반) --%>
                        <a href="#" id="prevBtn" class="btn btn-outline-primary disabled">
                            <i class="fa fa-arrow-left"></i> 이전
                        </a>
                        <a href="#" id="nextBtn" class="btn btn-outline-primary ms-2 disabled">
                            다음 <i class="fa fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <%-- 운송장 관리 카드 --%>
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">운송장 관리</h4>
                </div>
                <div id="waybillContainer" class="card-body">
                    <p>운송장 정보를 불러오는 중입니다...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- 운송장 조회 모달 (WaybillDetailDTO 필드 확장 반영) --%>
<div class="modal fade" id="waybillModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">운송장 정보 (번호: <span id="modalWaybillId">...</span>)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>운송 상태 (waybill_status)</label>
                            <input type="text" class="form-control" id="modalWaybillStatus" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>등록일 (created_at)</label>
                            <input type="text" class="form-control" id="modalCreatedAt" readonly>
                        </div>
                    </div>
                </div>
                <hr>
                <h5 class="mb-3">배송 정보 (출고지)</h5>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>출고 창고 주소</label>
                            <input type="text" class="form-control" id="modalWarehouseAddress" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>출고 창고 우편번호</label>
                            <input type="text" class="form-control" id="modalWarehouseZipCode" readonly>
                        </div>
                    </div>
                </div>
                <h5 class="mb-3 mt-3">배송 정보 (도착지)</h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>도착지 우편번호</label>
                            <input type="text" class="form-control" id="modalOrZipCode" readonly>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label>도착지 주소</label>
                            <input type="text" class="form-control" id="modalOrStreetAddress" readonly>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="form-group">
                            <label>도착지 상세 주소</label>
                            <input type="text" class="form-control" id="modalOrDetailedAddress" readonly>
                        </div>
                    </div>
                </div>
                <hr>
                <h5 class="mb-3">운송 차량 정보</h5>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>운전자명 (driver_name)</label>
                            <input type="text" class="form-control" id="modalDriverName" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>운전자 연락처</label>
                            <input type="text" class="form-control" id="modalDriverPhone" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>차량 번호 (vehicle_id)</label>
                            <input type="text" class="form-control" id="modalVehicleId" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>차량 유형</label>
                            <input type="text" class="form-control" id="modalVehicleType" readonly>
                        </div>
                    </div>
                </div>

                <div class="mt-4 text-center">
                    <label>배송 추적 QR 코드</label>
                    <div id="qrcode" class="mt-2 d-flex justify-content-center">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 ---
    const contextPath = "${contextPath}";
    // --- JS 전역 변수 ---
    let currentSiIndex = null;
    let currentListContext = null;

    // [단순화] ADMIN API 경로만 정의 (ADMIN 전용 페이지)
    const API_BASE = "${contextPath}/api/admin/outbound";

    // --- [핵심] 페이지 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        const id = "${si_index}";
        currentListContext = window.location.search;

        if (!id || id === "0") {
            alert("잘못된 접근입니다. (지시서 ID 없음)");
            location.href = "${contextPath}/outbound/instructions";
            return;
        }
        currentSiIndex = id;
        loadPageData(id, currentListContext);
    });

    /**
     * LocalDateTime 배열을 JavaScript Date 객체로 변환
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        // JS Date 객체의 month는 0부터 시작하므로 arr[1]에서 1을 뺌
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 날짜 포맷팅
     */
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    /**
     * 지시서 상세 및 운송장 정보를 병렬로 로드합니다.
     * @param {string} id - 지시서 ID (si_index)
     * @param {string} listContextQuery - 목록 검색 조건 쿼리스트링
     */
    async function loadPageData(id, listContextQuery) {
        try {
            // [수정] 문자열 연결(+) 사용
            const instructionPromise = axios.get(API_BASE + "/instruction/" + id + listContextQuery);
            const waybillPromise = axios.get(API_BASE + "/waybill/" + id).catch(e => null);

            const [instructionRes, waybillRes] = await Promise.all([instructionPromise, waybillPromise]);

            const instruction = instructionRes.data; // ShippingInstructionDetailDTO

            // --- 1. 상세 정보 렌더링 (DTO 속성 반영) ---
            document.getElementById("detailSiIndex").textContent = instruction.si_index;
            document.getElementById("detailItemName").value = instruction.item_name;
            document.getElementById("detailOrQuantity").value = instruction.or_quantity;
            document.getElementById("detailWarehouseIndex").value = instruction.warehouse_index;
            document.getElementById("detailSectionIndex").value = instruction.section_index;
            document.getElementById("detailApprovedAt").value = formatDateTime(instruction.approved_at);
            document.getElementById("detailSiWaybillStatus").value = instruction.si_waybill_status;

            // --- 2. 이전/다음 버튼 렌더링 ---
            renderPrevNext(instruction.previousPostIndex, instruction.nextPostIndex, listContextQuery);

            // --- 3. 운송장 UI 렌더링 ---
            const waybill = waybillRes ? waybillRes.data : null; // WaybillDetailDTO
            renderWaybillUI(instruction.si_waybill_status, waybill);

        } catch (error) {
            console.error("Page loading failed:", error);
            alert("데이터 로딩에 실패했습니다.");
            document.getElementById("waybillContainer").innerHTML = '<p class="text-danger">데이터 로딩 실패</p>';
        }
    }

    /**
     * 이전/다음 버튼 렌더링
     */
    function renderPrevNext(prevId, nextId, listContextQuery) {
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        const baseURL = contextPath + "/outbound/instruction/";

        if (prevId) {
            prevBtn.href = baseURL + prevId + listContextQuery;
            prevBtn.classList.remove("disabled");
        } else {
            prevBtn.href = "#";
            prevBtn.classList.add("disabled");
        }

        if (nextId) {
            nextBtn.href = baseURL + nextId + listContextQuery;
            nextBtn.classList.remove("disabled");
        } else {
            nextBtn.href = "#";
            nextBtn.classList.add("disabled");
        }
    }

    /**
     * 상태와 운송장 유무에 따라 운송장 UI를 동적 렌더링
     * @param {string} status - 지시서의 운송장 상태 (si_waybill_status)
     * @param {object} waybill - 운송장 상세 정보 (WaybillDetailDTO | null)
     */
    function renderWaybillUI(status, waybill) {
        const container = document.getElementById("waybillContainer");

        if (waybill) {
            // [렌더링 1]: 운송장 있음 -> 조회 버튼 렌더링 (문자열 연결로 복원)
            const waybillHtml =
                '<div class="form-group">' +
                '    <label>운송장 번호 (waybill_id)</label>' +
                '    <input type="text" class="form-control" value="' + waybill.waybill_id + '" readonly>' +
                '</div>' +
                '<button type="button" id="showWaybillModalBtn" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#waybillModal">' +
                '    운송장 상세 조회' +
                '</button>';
            container.innerHTML = waybillHtml;

            // 모달이 열릴 때 운송장 상세 정보 및 QR코드 생성 이벤트 바인딩
            document.getElementById("showWaybillModalBtn").addEventListener("click", () => {
                // --- 모달 내부 필드 채우기 (WaybillDetailDTO 기준) ---
                document.getElementById("modalWaybillId").textContent = waybill.waybill_id;
                document.getElementById("modalWaybillStatus").value = waybill.waybill_status;
                document.getElementById("modalCreatedAt").value = formatDateTime(waybill.created_at);

                // 출고지 정보
                document.getElementById("modalWarehouseAddress").value = waybill.warehouse_address;
                document.getElementById("modalWarehouseZipCode").value = waybill.warehouse_zip_code;

                // 도착지 정보
                document.getElementById("modalOrZipCode").value = waybill.or_zip_code;
                document.getElementById("modalOrStreetAddress").value = waybill.or_street_address;
                document.getElementById("modalOrDetailedAddress").value = waybill.or_detailed_address;

                // 운송 차량 정보
                document.getElementById("modalDriverName").value = waybill.driver_name;
                document.getElementById("modalDriverPhone").value = waybill.driver_phone;
                document.getElementById("modalVehicleId").value = waybill.vehicle_id;
                document.getElementById("modalVehicleType").value = waybill.vehicle_type;

                // QR 코드 생성 (Google Chart API 사용)
                const qrDiv = document.getElementById("qrcode");
                qrDiv.innerHTML = ""; // 기존 QR 삭제

                const trackingUrl = "https://track.example.com/" + waybill.waybill_id; // (실제 배송추적 URL로 변경)
                const googleQrUrl = "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=" + encodeURIComponent(trackingUrl) + "&choe=UTF-8";
                const qrImg = document.createElement("img");
                qrImg.src = googleQrUrl;
                qrImg.alt = "QR Code";
                qrImg.width = 150;
                qrImg.height = 150;
                qrDiv.appendChild(qrImg);
            });
        } else if (status === 'PENDING') {
            // [렌더링 2]: 운송장 없음 + 상태가 PENDING -> 등록 폼 렌더링
            const registerHtml =
                '<form id="waybillRegisterForm">' +
                '    <div class="form-group">' +
                '        <label>운송장을 등록하시겠습니까?</label>' +
                '        <p class="text-muted">등록 버튼 클릭 시, 연결된 배차 정보로 운송장이 자동 생성됩니다.</p>' +
                '    </div>' +
                '    <button type="button" id="registerWaybillBtn" class="btn btn-primary">운송장 등록</button>' +
                '</form>';
            container.innerHTML = registerHtml;

            // 등록 버튼 이벤트 바인딩
            document.getElementById("registerWaybillBtn").addEventListener("click", function() {
                const data = {
                    si_index: currentSiIndex
                };

                axios.post(API_BASE + "/waybill", data, {
                    headers: { 'Content-Type': 'application/json' }
                })
                    .then(response => {
                        alert("운송장이 등록되었습니다.");
                        location.reload(); // 페이지 새로고침
                    })
                    .catch(error => alert("등록 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        } else {
            // [렌더링 3]: 그 외 상태 (이미 완료됨)
            container.innerHTML = '<p>운송장 처리가 이미 완료되었거나 등록할 수 없는 상태입니다. (상태: ' + status + ')</p>';
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>