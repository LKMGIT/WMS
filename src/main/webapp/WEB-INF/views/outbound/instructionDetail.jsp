<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:24
  To change this template use File | Settings | File Templates.
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
            <li class="nav-item"><a href="${contextPath}/instructions">출고 지시서 목록</a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고지시서 상세</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">출고지시서 상세 (지시서 번호: <span id="detailSiIndex">...</span>)</div>
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
                <div class="card-action">
                    <a href="${contextPath}/instructions" class="btn btn-secondary">목록으로</a>
                </div>
            </div>

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

<div class="modal fade" id="waybillModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">운송장 정보 (번호: <span id="modalWaybillId">...</span>)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <div class="form-group">
                    <label>택배사 (driver_name)</label>
                    <input type="text" class="form-control" id="modalDriverName" readonly>
                </div>
                <div class="form-group">
                    <label>차량 번호 (vehicle_id)</label>
                    <input type="text" class="form-control" id="modalVehicleId" readonly>
                </div>
                <div class="form-group">
                    <label>배송 상태 (waybill_status)</label>
                    <input type="text" class="form-control" id="modalWaybillStatus" readonly>
                </div>

                <div class="mt-3">
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
    let currentSiIndex = null; // 지시서 ID (si_index)

    // [단순화] ADMIN API 경로만 정의 (ADMIN 전용 페이지)
    const API_BASE = `${contextPath}/api/admin/outbound`;

    // --- [핵심] 페이지 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        // [경로 수정] URL 쿼리 파라미터가 아닌 경로 변수에서 ID를 가져와야 할 수도 있습니다.
        // OutboundViewController가 "/instruction/{si_index}" 이므로,
        // 이 페이지로 넘어오기 전 URL에서 ID를 추출하거나,
        // 여기서는 JSP가 렌더링될 때 서버로부터 ID를 받아오는 것으로 가정합니다.
        // 예: const id = "${si_index}"; (컨트롤러가 Model에 si_index를 전달했다면)

        // 일단 URL 쿼리 파라미터(id=...)로 ID를 가져오는 것으로 유지합니다.
        const id = urlParams.get("id");

        if (!id) {
            alert("잘못된 접근입니다. (지시서 ID 없음)");
            location.href = `${contextPath}/instructions`;
            return;
        }
        currentSiIndex = id;
        loadPageData(id);
    });

    /**
     * 지시서 상세 및 운송장 정보를 병렬로 로드합니다.
     * @param {string} id - 지시서 ID (si_index)
     */
    async function loadPageData(id) {
        try {
            // [API 경로 수정] 컨트롤러 경로(/instruction/{id}) 반영
            const instructionPromise = axios.get(`${API_BASE}/instruction/${id}`);

            // [API 경로 수정] 컨트롤러 경로(/waybill/{si_index}) 반영
            const waybillPromise = axios.get(`${API_BASE}/waybill/${id}`).catch(e => null);

            const [instructionRes, waybillRes] = await Promise.all([instructionPromise, waybillPromise]);

            // --- 1. 상세 정보 렌더링 (DTO 속성 반영) ---
            const instruction = instructionRes.data; // ShippingInstructionDetailDTO
            document.getElementById("detailSiIndex").textContent = instruction.si_index;
            document.getElementById("detailItemName").value = instruction.item_name;
            document.getElementById("detailOrQuantity").value = instruction.or_quantity;
            document.getElementById("detailWarehouseIndex").value = instruction.warehouse_index;
            document.getElementById("detailSectionIndex").value = instruction.section_index;
            document.getElementById("detailApprovedAt").value = new Date(instruction.approved_at).toLocaleString("ko-KR");
            document.getElementById("detailSiWaybillStatus").value = instruction.si_waybill_status;

            // --- 2. 운송장 UI 렌더링 ---
            const waybill = waybillRes ? waybillRes.data : null; // WaybillDetailDTO
            renderWaybillUI(instruction.si_waybill_status, waybill);

        } catch (error) {
            console.error("Page loading failed:", error);
            alert("데이터 로딩에 실패했습니다.");
            document.getElementById("waybillContainer").innerHTML = `<p class="text-danger">데이터 로딩 실패</p>`;
        }
    }

    /**
     * 상태와 운송장 유무에 따라 운송장 UI를 동적 렌더링
     * @param {string} status - 지시서의 운송장 상태 (si_waybill_status)
     * @param {object} waybill - 운송장 상세 정보 (있거나 null)
     */
    function renderWaybillUI(status, waybill) {
        const container = document.getElementById("waybillContainer");

        if (waybill) {
            // [렌더링 1]: 운송장 있음 -> 조회 버튼 렌더링
            container.innerHTML = `
                <div class="form-group">
                    <label>운송장 번호 (waybill_id)</label>
                    <input type="text" class="form-control" value="${waybill.waybill_id}" readonly>
                </div>
                <button type="button" id="showWaybillModalBtn" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#waybillModal">
                    운송장 조회 (QR)
                </button>
            `;

            // [신규] 모달이 열릴 때 구글 차트 API로 QR코드 생성 이벤트 바인딩
            document.getElementById("showWaybillModalBtn").addEventListener("click", () => {
                // [DTO 반영] 모달 내부 필드 채우기 (WaybillDetailDTO 기준)
                document.getElementById("modalWaybillId").textContent = waybill.waybill_id;
                document.getElementById("modalDriverName").value = waybill.driver_name;
                document.getElementById("modalVehicleId").value = waybill.vehicle_id;
                document.getElementById("modalWaybillStatus").value = waybill.waybill_status;

                // QR 코드 생성 (Google Chart API 사용)
                const qrDiv = document.getElementById("qrcode");
                qrDiv.innerHTML = ""; // 기존 QR 삭제

                // QR에 담을 URL (운송장 ID 사용)
                const trackingUrl = `https://track.example.com/${waybill.waybill_id}`; // (실제 배송추적 URL로 변경)
                const googleQrUrl = `https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=${encodeURIComponent(trackingUrl)}&choe=UTF-8`;

                // <img> 태그 생성 및 삽입
                const qrImg = document.createElement("img");
                qrImg.src = googleQrUrl;
                qrImg.alt = "QR Code";
                qrImg.width = 150;
                qrImg.height = 150;
                qrDiv.appendChild(qrImg);
            });

        } else if (status === 'PENDING') {
            // [렌더링 2]: 운송장 없음 + 상태가 PENDING -> 등록 폼 렌더링
            container.innerHTML = `
                <form id="waybillRegisterForm">
                    <div class="form-group">
                        <label>운송장을 등록하시겠습니까?</label>
                        <p class="text-muted">등록 버튼 클릭 시, 연결된 배차 정보로 운송장이 자동 생성됩니다.</p>
                    </div>
                    <button type="button" id="registerWaybillBtn" class="btn btn-primary">운송장 등록</button>
                </form>
            `;

            // [AXIOS]: 등록 버튼 이벤트 바인딩 (ADMIN API_BASE 사용)
            document.getElementById("registerWaybillBtn").addEventListener("click", function() {
                // [DTO 반영] WaybillDTO는 si_index만 필요
                const data = {
                    si_index: currentSiIndex
                };

                // [API 경로 수정] 컨트롤러 경로(/waybill) 반영
                axios.post(`${API_BASE}/waybill`, data, {
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
            container.innerHTML = `<p>운송장 처리가 이미 완료되었습니다. (상태: ${status})</p>`;
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>