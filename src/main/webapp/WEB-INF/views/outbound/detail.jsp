<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:21
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
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고 리스트</a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고요청 상세</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">출고요청 상세 (요청 번호: <span id="detailOrIndex">...</span>)</h4>

                        <div id="userActionGroup" class="ms-auto" style="display: none;">
                            <a id="modifyBtn" href="#" class="btn btn-primary btn-round">
                                <i class="fa fa-pen"></i> 수정
                            </a>
                            <button type="button" id="deleteOutboundBtn" class="btn btn-danger btn-round ms-2">
                                <i class="fa fa-trash"></i> 삭제
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품 ID (item_index)</label>
                                <input type="text" class="form-control" id="detailItemIndex" readonly>
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
                    <h5 class="mb-3">배송 정보</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인명 (or_name)</label>
                                <input type="text" class="form-control" id="detailOrName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인 연락처 (or_phone)</label>
                                <input type="text" class="form-control" id="detailOrPhone" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>우편번호 (or_zip_code)</label>
                                <input type="text" class="form-control" id="detailOrZipCode" readonly>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>주소 (or_street_address)</label>
                                <input type="text" class="form-control" id="detailOrStreetAddress" readonly>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>상세주소 (or_detailed_address)</label>
                                <input type="text" class="form-control" id="detailOrDetailedAddress" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">요청 상태</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>요청일 (created_at)</label>
                                <input type="text" class="form-control" id="detailCreatedAt" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>승인 상태 (or_approval)</label>
                                <input type="text" class="form-control" id="detailOrApproval" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="rejectDetailGroup" style="display: none;">
                        <label>반려 사유 (reject_detail)</label>
                        <textarea class="form-control" id="detailRejectDetail" rows="3" readonly></textarea>
                    </div>
                </div>
                <div class="card-action">
                    <a href="${contextPath}/outbound/requests" class="btn btn-secondary">목록으로</a>
                </div>
            </div>

            <div id="adminActionCard" class="card" style="display: none;">
                <div class="card-header">
                    <h4 class="card-title">관리자 승인 및 배차</h4>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>배차 상태 (or_dispatch_status):</strong>
                            <span id="dispatchStatusBadge" class="badge bg-warning text-dark">배차 대기</span>
                        </div>
                        <div id="adminBtnGroup">
                            <p>데이터 로드 중...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="approvalModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="approvalForm">
                <div class="modal-header">
                    <h5 class="modal-title">출고 요청 처리</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>이 출고 요청을 승인 또는 반려하시겠습니까?</p>
                    <div class="form-group">
                        <label for="reject_detail">반려 사유 (반려 시 필수 입력)</label>
                        <textarea class="form-control" id="reject_detail" name="reject_detail" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="rejectBtn" class="btn btn-danger" data-approval-status="REJECTED">반려</button>
                    <button type="button" id="approveBtn" class="btn btn-primary" data-approval-status="APPROVED">승인</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="dispatchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">배차 관리</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>데이터를 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>

<script type="text/template" id="dispatchRegisterTemplate">
    <form id="dispatchRegisterForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 등록</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label for="reg_start_point">출발지</label>
                <input type="text" class="form-control" id="reg_start_point" name="start_point" placeholder="예: 제 1 물류센터">
            </div>
            <div class="form-group">
                <label for="reg_end_point">도착지 (자동 완성)</label>
                <input type="text" class="form-control" id="reg_end_point" name="end_point" readonly>
            </div>
            <div class="form-group">
                <label for="reg_vehicleIdSelect">배차 가능 차량</label>
                <select class="form-select" id="reg_vehicleIdSelect" name="vehicle_index" required>
                    <option value="">차량 목록 로딩 중...</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="registerDispatchBtn" class="btn btn-primary">등록</button>
        </div>
    </form>
</script>

<script type="text/template" id="dispatchModifyTemplate">
    <form id="dispatchModifyForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 상세/수정</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label>현재 배차 차량</label>
                <input type="text" id="mod_currentVehicleInfo" class="form-control" readonly>
            </div>
            <div class="form-group">
                <label for="mod_start_point">출발지</label>
                <input type="text" class="form-control" id="mod_start_point" name="start_point">
            </div>
            <div class="form-group">
                <label for="mod_end_point">도착지</label>
                <input type="text" class="form-control" id="mod_end_point" name="end_point" readonly>
            </div>
            <div class="form-group">
                <label for="mod_vehicleIdSelect">차량 변경</label>
                <select class="form-select" id="mod_vehicleIdSelect" name="vehicle_index" required>
                    <option value="">차량 목록 로딩 중...</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" id="deleteDispatchBtn" class="btn btn-danger">배차 삭제</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="modifyDispatchBtn" class="btn btn-primary">수정</button>
        </div>
    </form>
</script>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 (세션 정보) ---
    const contextPath = "${contextPath}";
    const loginUserId = "${sessionScope.loginUser.id}";
    const loginUserType = "${sessionScope.loginUser.userType}"; // 'ADMIN' or 'USER'

    // --- JS 전역 변수 ---
    let currentOutboundId = null; // or_index
    let currentDispatchId = null; // dispatch_index

    // --- [API 경로 설정] ---
    const API = {
        MEMBER: `${contextPath}/api/outbound`,
        ADMIN: `${contextPath}/api/admin/outbound`
    };

    // [권한 분기] '읽기' (GET) API 경로는 권한에 따라 분기
    const READ_API_BASE = loginUserType === 'ADMIN' ? API.ADMIN : API.MEMBER;

    // [권한 분기] '쓰기' (POST, PUT, DELETE) API 경로는 권한에 따라 분기
    const WRITE_API_BASE = loginUserType === 'ADMIN' ? API.ADMIN : API.MEMBER;

    // (공통) 폼 데이터 -> JS Object 변환 함수
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => { data[key] = value; });
        return data;
    }

    /**
     * [신규] LocalDateTime 배열을 JavaScript Date 객체로 변환
     * @param {array} arr (예: [2025, 11, 11, 12, 58, 30])
     * @returns {Date | null}
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) {
            return null; // 값이 없으면 null 반환
        }
        // new Date(year, monthIndex(0-11), day, hours, minutes, seconds)
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 날짜 배열을 포맷팅된 문자열로 반환
     * @param {array} arr
     * @returns {string}
     */
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    // --- [핵심] 페이지 로드 시 모든 데이터 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        // [경로 수정] OutboundViewController의 경로 변수명(or_index)을 URL에서 추출
        const pathSegments = window.location.pathname.split('/');
        const id = pathSegments[pathSegments.length - 1];

        if (!id || isNaN(id)) {
            alert("잘못된 접근입니다. (출고 ID 없음)");
            location.href = `${contextPath}/outbound/requests`;
            return;
        }
        currentOutboundId = id;
        loadPageData(id);
    });

    /**
     * 페이지에 필요한 모든 데이터를 병렬로 로드합니다.
     * @param {string} id - 출고 요청 ID (or_index)
     */
    async function loadPageData(id) {
        try {
            // [API 경로 수정]: 컨트롤러 경로(/request/{id}) 반영
            const outboundPromise = axios.get(`${READ_API_BASE}/request/${id}`);

            // [API 경로 수정]: 컨트롤러 경로(/dispatch/{or_index}) 반영
            const dispatchPromise = axios.get(`${READ_API_BASE}/dispatch/${id}`).catch(e => null); // 배차 없으면 null

            let vehiclesPromise = null;
            if (loginUserType === 'ADMIN') {
                // [API 경로 수정]: 컨트롤러 경로(/vehicles) 반영
                vehiclesPromise = axios.get(`${API.ADMIN}/vehicles`);
            }

            // --- 모든 요청이 완료될 때까지 대기 ---
            const [outboundRes, dispatchRes, vehiclesRes] = await Promise.all([outboundPromise, dispatchPromise, vehiclesPromise]);

            // --- 1. 상세 정보 렌더링 (DTO 속성 반영) ---
            const outbound = outboundRes.data; // OutboundRequestDetailDTO

            // [날짜 수정] parseLocalDateTime 사용
            document.getElementById("detailOrIndex").textContent = outbound.or_index;
            document.getElementById("detailItemIndex").value = outbound.item_index; // (상품명이 없으므로 ID 표시)
            document.getElementById("detailOrQuantity").value = outbound.or_quantity;
            document.getElementById("detailOrName").value = outbound.or_name;
            document.getElementById("detailOrPhone").value = outbound.or_phone;
            document.getElementById("detailOrZipCode").value = outbound.or_zip_code;
            document.getElementById("detailOrStreetAddress").value = outbound.or_street_address;
            document.getElementById("detailOrDetailedAddress").value = outbound.or_detailed_address;
            document.getElementById("detailCreatedAt").value = formatDateTime(outbound.created_at);
            document.getElementById("detailOrApproval").value = outbound.or_approval;

            // 반려 상태일 경우, 반려 사유 표시
            if(outbound.or_approval === 'REJECTED') {
                document.getElementById("rejectDetailGroup").style.display = "block";
                document.getElementById("detailRejectDetail").value = outbound.reject_detail || 'N/A';
            }

            // --- 2. 사용자 버튼 렌더링 (권한 확인) ---
            // DTO 속성: user_index, or_approval
            if (loginUserType === 'USER' && String(outbound.user_index) === loginUserId && outbound.or_approval === 'PENDING') {
                document.getElementById("userActionGroup").style.display = "flex";
                // [경로 수정] OutboundViewController.java 매핑 경로
                document.getElementById("modifyBtn").href = `${contextPath}/outbound/request/modify/${id}`; // (수정 페이지 경로 예시)
                bindUserButtons();
            }

            // --- 3. 관리자 UI 렌더링 (권한 확인) ---
            if (loginUserType === 'ADMIN') {
                document.getElementById("adminActionCard").style.display = "block";
                const dispatch = dispatchRes ? dispatchRes.data : null; // DispatchDetailDTO
                const vehicles = vehiclesRes ? vehiclesRes.data : []; // List<AvailableDispatchDTO>

                // DTO 속성: or_approval, or_dispatch_status
                renderAdminUI(outbound.or_approval, outbound.or_dispatch_status, dispatch, vehicles);
            }

        } catch (error) {
            console.error("Page loading failed:", error);
            alert("데이터를 불러오는 데 실패했습니다. 목록으로 돌아갑니다.");
            location.href = `${contextPath}/outbound/requests`;
        }
    }

    /**
     * 관리자 버튼 및 모달 UI를 상태에 따라 렌더링
     * @param {string} approvalStatus - 출고 승인 상태 (PENDING, APPROVED)
     * @param {string} dispatchStatus - 출고 배차 상태 (PENDING, COMPLETED)
     * @param {object} dispatch - 배차 정보 (있거나 null)
     * @param {array} vehicles - 배차 가능 차량 목록
     */
    function renderAdminUI(approvalStatus, dispatchStatus, dispatch, vehicles) {
        const adminBtnGroup = document.getElementById("adminBtnGroup");
        const modalContent = document.querySelector("#dispatchModal .modal-content");

        // 도착지 주소 (상세 DTO에서 가져옴)
        const endPointAddress = document.getElementById("detailOrStreetAddress").value;

        // 1. 배차 상태 배지 설정
        if (dispatchStatus === 'COMPLETED' && dispatch) {
            currentDispatchId = dispatch.dispatch_index; // DTO 속성: dispatch_index
            const badge = document.getElementById("dispatchStatusBadge");
            badge.textContent = "배차 완료";
            badge.className = "badge bg-success";
        }

        // 2. 출고 상태에 따른 버튼 설정
        if (approvalStatus === 'PENDING') {
            adminBtnGroup.innerHTML = `<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#approvalModal">승인/반려 처리</button>`;
        } else if (approvalStatus === 'APPROVED' && dispatchStatus === 'PENDING') {
            // 승인됨, 배차 대기 -> 배차 등록/관리 버튼
            adminBtnGroup.innerHTML = `<button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 등록/관리</button>`;
        } else {
            adminBtnGroup.innerHTML = `<button class="btn btn-secondary" disabled>${approvalStatus} / ${dispatchStatus}</button>`;
        }

        // 3. 배차 모달 템플릿 렌더링 (버튼이 활성화 된 경우)
        if(approvalStatus === 'APPROVED') {
            if (dispatch) {
                // 수정 템플릿 삽입
                modalContent.innerHTML = document.getElementById("dispatchModifyTemplate").innerHTML;

                // [수정] querySelector로 모달 내부의 ID 검색
                // DTO 속성: vehicle_id, driver_name
                modalContent.querySelector("#mod_currentVehicleInfo").value = `${dispatch.vehicle_id} (${dispatch.driver_name})`;
                modalContent.querySelector("#mod_start_point").value = dispatch.start_point;
                modalContent.querySelector("#mod_end_point").value = dispatch.end_point;
                const selectEl = modalContent.querySelector("#mod_vehicleIdSelect");
                populateVehicleSelect(selectEl, vehicles, dispatch.vehicle_index); // DTO 속성: vehicle_index
            } else {
                // 등록 템플릿 삽입
                modalContent.innerHTML = document.getElementById("dispatchRegisterTemplate").innerHTML;

                // [수정] querySelector로 모달 내부의 ID 검색
                modalContent.querySelector("#reg_end_point").value = endPointAddress; // 도착지 자동 완성
                const selectEl = modalContent.querySelector("#reg_vehicleIdSelect");
                populateVehicleSelect(selectEl, vehicles);
            }
        }

        // 4. [AXIOS]: 동적으로 생성된 모든 관리자 버튼에 이벤트 바인딩
        bindAdminButtons();
    }

    /**
     * 배차 모달의 차량 <select> 목록을 채웁니다. (수정됨: element를 직접 받음)
     * @param {Element} selectElement - <select> DOM 요소
     * @param {array} vehicles - 차량 목록
     * @param {string|number} [selectedVehicleId] - (선택) 현재 배차된 차량 ID
     */
    function populateVehicleSelect(selectElement, vehicles, selectedVehicleId = null) {
        if (!selectElement) return;

        let optionsHtml = '<option value="">차량을 선택하세요</option>';
        vehicles.forEach(v => {
            // DTO 속성: vehicle_index, vehicle_id, driver_name, vehicle_type
            const selected = (selectedVehicleId && v.vehicle_index == selectedVehicleId) ? "selected" : "";
            optionsHtml += `<option value="${v.vehicle_index}" ${selected}>
                                ${v.vehicle_id} (${v.driver_name} / ${v.vehicle_type})
                           </option>`;
        });
        selectElement.innerHTML = optionsHtml;
    }

    /**
     * [AXIOS] 사용자 버튼 이벤트 바인딩
     */
    function bindUserButtons() {
        const deleteBtn = document.getElementById("deleteOutboundBtn");
        if (deleteBtn) {
            deleteBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 출고 요청을 삭제하시겠습니까?")) return;

                // [API 경로 수정]: 컨트롤러 경로(/request/{id}) 및 WRITE_API_BASE 사용
                axios.delete(`${WRITE_API_BASE}/request/${currentOutboundId}`)
                    .then(response => {
                        alert("삭제되었습니다.");
                        location.href = `${contextPath}/outbound/requests`; // 목록으로 이동
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }

    /**
     * [AXIOS] 관리자 버튼 이벤트 바인딩 (동적 생성 후 호출)
     */
    function bindAdminButtons() {
        // [API 경로 수정]: 모든 호출은 ADMIN 권한의 WRITE_API_BASE(API.ADMIN) 사용

        // 1. 출고 승인/반려 (approvalModal 내부 버튼)
        const approveBtn = document.getElementById("approveBtn");
        const rejectBtn = document.getElementById("rejectBtn");

        const handleApproval = (event) => {
            const status = event.target.dataset.approvalStatus; // 'APPROVED' or 'REJECTED'
            const rejectDetail = document.getElementById("reject_detail").value;

            if (status === 'REJECTED' && !rejectDetail) {
                alert("반려 시 사유를 반드시 입력해야 합니다.");
                return;
            }
            if (!confirm(`정말로 이 요청을 '${status}' 하시겠습니까?`)) return;

            // DTO 속성 반영
            const data = {
                or_index: currentOutboundId,
                or_approval: status,
                reject_detail: rejectDetail
                // admin_index는 컨트롤러에서 세션으로 처리 (가정)
            };

            // [API 경로 수정] /request/approval
            axios.put(`${API.ADMIN}/request/approval`, data, { headers: { 'Content-Type': 'application/json' } })
                .then(response => {
                    alert("처리가 완료되었습니다.");
                    location.reload();
                })
                .catch(error => alert("처리 실패: " + (error.response?.data?.message || "서버 오류")));
        };

        if(approveBtn) approveBtn.addEventListener("click", handleApproval);
        if(rejectBtn) rejectBtn.addEventListener("click", handleApproval);


        // 2. 배차 등록 (dispatchModal 내부 버튼)
        const registerDispatchBtn = document.getElementById("registerDispatchBtn");
        if (registerDispatchBtn) {
            registerDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchRegisterForm");
                // DTO 속성: or_index
                data.or_index = currentOutboundId;

                if (!data.vehicle_index) {
                    alert("차량을 선택하세요.");
                    return;
                }
                // [API 경로 수정] /dispatch
                axios.post(`${API.ADMIN}/dispatch`, data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 등록되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("등록 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 3. 배차 수정 (dispatchModal 내부 버튼)
        const modifyDispatchBtn = document.getElementById("modifyDispatchBtn");
        if (modifyDispatchBtn) {
            modifyDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchModifyForm");
                // [API 경로 수정] /dispatch/{id}
                axios.put(`${API.ADMIN}/dispatch/${currentDispatchId}`, data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 수정되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("수정 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 4. 배차 삭제 (dispatchModal 내부 버튼)
        const deleteDispatchBtn = document.getElementById("deleteDispatchBtn");
        if (deleteDispatchBtn) {
            deleteDispatchBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 배차를 삭제하시겠습니까?")) return;
                // [API 경로 수정] /dispatch/{id}
                axios.delete(`${API.ADMIN}/dispatch/${currentDispatchId}`)
                    .then(response => {
                        alert("배차 삭제되었습니다.");
                        location.reload();
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>
