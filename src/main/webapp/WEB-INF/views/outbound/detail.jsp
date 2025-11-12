<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-11
  Time: 오후 4:35
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- [중요] 뷰 컨트롤러가 Model에 "or_index"를 전달해야 함 --%>
<c:set var="or_index" value="${or_index}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고요청 리스트</a></li>
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

                        <%-- [수정] 사용자 및 관리자 버튼 컨테이너 --%>
                        <div class="ms-auto">
                            <%-- [사용자] 수정/삭제 버튼 --%>
                            <div id="userActionGroup" class="d-inline-block d-none">
                                <a id="modifyBtn" href="#" class="btn btn-primary btn-round"><i class="fa fa-pen"></i> 수정</a>
                                <button type="button" id="deleteOutboundBtn" class="btn btn-danger btn-round ms-2"><i class="fa fa-trash"></i> 삭제</button>
                            </div>

                            <%-- [신규] [관리자] 승인/반려 버튼 영역 --%>
                            <div id="adminApprovalGroup" class="d-inline-block d-none">
                                <%-- JS가 동적으로 버튼을 채웁니다 --%>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품 ID</label>
                                <input type="text" class="form-control" id="detailItemIndex" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>상품 이름</label>
                                <input type="text" class="form-control" id="detailItemName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>출고 수량</label>
                                <input type="text" class="form-control" id="detailOrQuantity" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">배송 정보</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인명</label>
                                <input type="text" class="form-control" id="detailOrName" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수취인 연락처</label>
                                <input type="text" class="form-control" id="detailOrPhone" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>수취인 우편번호</label>
                                <input type="text" class="form-control" id="detailOrZipCode" readonly>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>수취인 주소</label>
                                <input type="text" class="form-control" id="detailOrStreetAddress" readonly>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>수취인 상세주소</label>
                                <input type="text" class="form-control" id="detailOrDetailedAddress" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h5 class="mb-3">요청 상태</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>요청일</label>
                                <input type="text" class="form-control" id="detailCreatedAt" readonly>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>최근수정일</label>
                                <input type="text" class="form-control" id="detailUpdatedAt" readonly>
                            </div>
                        </div>

                        <%-- [수정] 배차 상태 (input-group으로 변경) --%>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>배차 상태</label>
                                <div class="input-group" id="dispatchActionGroup">
                                    <input type="text" class="form-control" id="detailOrDispatchStatus" readonly>
                                    <%-- JS가 동적으로 버튼을 추가합니다 --%>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>출고승인 상태</label>
                                <input type="text" class="form-control" id="detailOrApproval" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="form-group d-none" id="rejectDetailGroup">
                        <label>반려 사유</label>
                        <textarea class="form-control" id="detailRejectDetail" rows="3" readonly></textarea>
                    </div>
                </div>

                <%-- [신규] 이전/다음 버튼 포함 --%>
                <div class="card-action d-flex justify-content-between">
                    <a href="${contextPath}/outbound/requests" class="btn btn-secondary">목록으로</a>
                    <div>
                        <a href="#" id="prevBtn" class="btn btn-outline-primary disabled">
                            <i class="fa fa-arrow-left"></i> 이전
                        </a>
                        <a href="#" id="nextBtn" class="btn btn-outline-primary ms-2 disabled">
                            다음 <i class="fa fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- [관리자] 승인/반려 모달 --%>
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
                </div>
            </form>
        </div>
    </div>
</div>

<%-- [관리자] 배차 등록/수정 모달 --%>
<div class="modal fade" id="dispatchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <%-- 모달 내용은 JS 템플릿으로 동적 생성됨 --%>
            <div class="modal-body">
                <p>데이터를 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>

<%-- [관리자] 배차 등록 템플릿 --%>
<script type="text/template" id="dispatchRegisterTemplate">
    <form id="dispatchRegisterForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 등록</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label for="reg_start_point">출발지</label>
                <input type="text" class="form-control" id="reg_start_point" name="start_point" placeholder="예: 제 1 물류센터" value="제 1 물류센터" readonly>
            </div>
            <div class="form-group">
                <label for="reg_end_point">도착지</label>
                <input type="text" class="form-control" id="reg_end_point" name="end_point" readonly>
            </div>
            <div class="form-group">
                <label for="reg_vehicleIdSelect">배차 가능 차량</label>
                <select class="form-select" id="reg_vehicleIdSelect" name="vehicle_index" required>
                    <option value="">차량 목록 로딩 중...</option>
                </select>
            </div>
            <div class="form-group">
                <input type="hidden" class="form-control" id="reg_or_index" name="or_index" value="">
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="registerDispatchBtn" class="btn btn-primary">등록</button>
        </div>
    </form>
</script>

<%-- [수정] 배차 수정 템플릿 (출발지 readonly 설정 및 확장 DTO 필드 반영) --%>
<script type="text/template" id="dispatchModifyTemplate">
    <form id="dispatchModifyForm">
        <div class="modal-header">
            <h5 class="modal-title">배차 조회</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="hidden_dispatch_index" name="dispatch_index">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label>현재 배차 차량</label>
                        <input type="text" id="mod_currentVehicleInfo" class="form-control" readonly>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>출고요청번호</label>
                        <input type="text" id="mod_orIndex" name="or_index" class="form-control" readonly>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>차량 유형</label>
                        <input type="text" id="mod_vehicleType" class="form-control" readonly>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>배차 일시</label>
                        <input type="text" id="mod_dispatchDate" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <hr>
            <div class="form-group">
                <label for="mod_start_point">출발지</label>
                <input type="text" class="form-control" id="mod_start_point" name="start_point" readonly>
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
            <hr>
        </div>
        <div class="modal-footer">
            <button type="button" id="enableEditBtn" class="btn btn-warning">수정</button>
            <button type="button" id="deleteDispatchBtn" class="btn btn-danger d-none">삭제</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            <button type="button" id="modifyDispatchBtn" class="btn btn-primary d-none">수정</button>
        </div>
    </form>
</script>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 (세션 정보) ---
    const contextPath = "${contextPath}";
    // [수정] loginAdminIndex 기준으로 isAdmin 설정
    const isAdmin = ${not empty sessionScope.loginAdminIndex};
    const loginUserId = "${sessionScope.loginUserIndex}";
    // (본인 확인용)

    // --- JS 전역 변수 ---
    let currentOutboundId = null;
    let currentDispatchId = null;
    let currentListContext = null;

    // --- [API 경로 설정] ---
    const API = {
        MEMBER: "${contextPath}/api/outbound",
        ADMIN: "${contextPath}/api/admin/outbound"
    };
    const READ_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;
    const WRITE_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;

    // (공통) 폼 데이터 -> JS Object 변환 함수
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => { data[key] = value; });
        return data;
    }

    // (공통) LocalDateTime 배열 -> Date 객체
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        // JavaScript Date 객체의 month는 0부터 시작하므로 arr[1]에서 1을 뺌
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    // (공통) 날짜 포맷팅
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    // --- [핵심] 페이지 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        // [수정] or_index를 JSTL 변수로 받아서 사용
        const id = "${or_index}";
        currentListContext = window.location.search;

        if (!id || id === "0") {
            alert("잘못된 접근입니다. (출고 ID 없음)");
            location.href = "${contextPath}/outbound/requests";
            return;
        }
        currentOutboundId = id;
        loadPageData(id, currentListContext);
    });

    /**
     * 페이지에 필요한 모든 데이터를 병렬로 로드합니다.
     */
    async function loadPageData(id, listContextQuery) {
        try {
            const outboundPromise = axios.get(READ_API_BASE + "/request/" + id + listContextQuery);
            // 배차 정보는 없을 수 있으므로, 에러 발생 시 null로 처리
            const dispatchPromise = axios.get(READ_API_BASE + "/dispatch/" + id).catch(e => null);

            const [outboundRes, dispatchRes] = await Promise.all([outboundPromise, dispatchPromise]);
            const outbound = outboundRes.data;
            const prevId = outbound.previousPostIndex;
            const nextId = outbound.nextPostIndex;

            if (!outbound || !outbound.or_index) {
                alert("요청 정보를 찾을 수 없습니다.");
                location.href = "${contextPath}/outbound/requests";
                return;
            }

            // [수정] 사용자 보안 체크 (Admin은 User Index를 신경쓰지 않음)
            if (!isAdmin && loginUserId && String(outbound.user_index) !== loginUserId) {
                alert("본인의 요청만 조회할 수 있습니다.");
                location.href = "${contextPath}/outbound/requests";
                return;
            }

            // --- 1. 상세 정보 렌더링 ---
            document.getElementById("detailOrIndex").textContent = outbound.or_index;
            document.getElementById("detailItemIndex").value = outbound.item_index;
            document.getElementById("detailItemName").value = outbound.item_name;
            document.getElementById("detailOrQuantity").value = outbound.or_quantity;
            document.getElementById("detailOrName").value = outbound.or_name;
            document.getElementById("detailOrPhone").value = outbound.or_phone;
            document.getElementById("detailOrZipCode").value = outbound.or_zip_code;
            document.getElementById("detailOrStreetAddress").value = outbound.or_street_address;
            document.getElementById("detailOrDetailedAddress").value = outbound.or_detailed_address;
            document.getElementById("detailCreatedAt").value = formatDateTime(outbound.created_at);
            document.getElementById("detailUpdatedAt").value = formatDateTime(outbound.updated_at);
            document.getElementById("detailOrDispatchStatus").value = outbound.or_dispatch_status;
            document.getElementById("detailOrApproval").value = outbound.or_approval;

            // 반려 사유 표시 (d-none 클래스로 제어 복원)
            const rejectDetailGroup = document.getElementById("rejectDetailGroup");
            if(outbound.or_approval === 'REJECTED') {
                rejectDetailGroup.classList.remove("d-none");
                document.getElementById("detailRejectDetail").value = outbound.reject_detail || 'N/A';
            } else {
                rejectDetailGroup.classList.add("d-none");
            }


            // --- 2. 사용자/관리자 UI 분기 및 동적 버튼 렌더링 ---
            const userActionGroup = document.getElementById("userActionGroup");
            const adminApprovalGroup = document.getElementById("adminApprovalGroup");

            const dispatch = dispatchRes ? dispatchRes.data : null;

            console.log(dispatch);

            if (isAdmin) {
                // ADMIN: 사용자 버튼 숨김, 관리자 액션 로드 (d-none 클래스 복원)
                userActionGroup.classList.add("d-none");
                renderDynamicActions(outbound, dispatch, id);
                bindAdminButtons();
            } else {
                // USER: 관리자 버튼 숨김, 사용자 액션 로드 (조건부) (d-none 클래스 복원)
                adminApprovalGroup.classList.add("d-none");

                // User Security Check: 본인 요청이고 PENDING 상태일 때만 수정/삭제 버튼 표시
                if (loginUserId && String(outbound.user_index) === loginUserId && outbound.or_approval === 'PENDING') {
                    // 조건 충족: 사용자 버튼 표시 (d-none 클래스 복원)
                    userActionGroup.classList.remove("d-none");

                    document.getElementById("modifyBtn").href = contextPath + "/outbound/request/modify/" + id;
                    bindUserButtons();
                } else {
                    // 조건 미충족: 사용자 버튼 숨김
                    userActionGroup.classList.add("d-none");
                }
            }

            // --- 4. 이전/다음 버튼 렌더링 ---
            renderPrevNext(prevId, nextId, listContextQuery);
        } catch (error) {
            console.error("Page loading failed:", error);
            if (error.response && error.response.status === 404) {
                alert("요청 정보를 찾을 수 없습니다.");
            } else {
                alert("데이터를 불러오는 데 실패했습니다. 목록으로 돌아갑니다.");
            }
            location.href = contextPath + "/outbound/requests";
        }
    }

    /**
     * 이전/다음 버튼 렌더링
     */
    function renderPrevNext(prevId, nextId, listContextQuery) {
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        if (prevId) {
            prevBtn.href = contextPath + "/outbound/request/" + prevId + listContextQuery;
            prevBtn.classList.remove("disabled");
        } else {
            prevBtn.href = "#";
            prevBtn.classList.add("disabled");
        }

        if (nextId) {
            nextBtn.href = contextPath + "/outbound/request/" + nextId + listContextQuery;
            nextBtn.classList.remove("disabled");
        } else {
            nextBtn.href = "#";
            nextBtn.classList.add("disabled");
        }
    }

    /**
     * [AXIOS] 사용자 버튼 이벤트 바인딩 (삭제 버튼)
     */
    function bindUserButtons() {
        const deleteBtn = document.getElementById("deleteOutboundBtn");
        if (deleteBtn) {
            deleteBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 출고 요청을 삭제하시겠습니까? (운송장 등록 전까지 가능)")) return;
                axios.put(WRITE_API_BASE + "/request/" + currentOutboundId + ":delete")
                    .then(response => {
                        alert("삭제되었습니다.");
                        location.href = contextPath + "/outbound/requests"; // 목록으로 이동
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }

    /**
     * [신규] 관리자 버튼 및 모달 UI를 동적으로 렌더링 (요청사항 반영)
     */
    function renderDynamicActions(outbound, dispatch, or_index) {

        const approvalStatus = outbound.or_approval;
        const dispatchStatus = outbound.or_dispatch_status;
        const isDispatched = (dispatchStatus === 'APPROVED' && dispatch);

        // Dispatch Index 저장 (수정/삭제 시 사용)
        if (isDispatched) {
            currentDispatchId = dispatch.dispatch_index;
        }

        // --- 1. 헤더 승인/반려 버튼 (adminApprovalGroup) ---
        const headerGroup = document.getElementById("adminApprovalGroup");
        // 승인/반려 상태가 PENDING일 때만 버튼 표시
        if (approvalStatus === 'PENDING') {
            // 배차가 등록되어야 승인 버튼 활성화 (isDispatched 사용)
            const approveDisabled = !isDispatched;
            const approveTitle = approveDisabled ? 'title="배차가 등록되어야 승인할 수 있습니다."' : '';

            // 문자열 연결 연산자(+) 사용으로 복원
            headerGroup.innerHTML =
                '<button type="button" id="rejectModalBtn" class="btn btn-danger btn-round" data-bs-toggle="modal" data-bs-target="#approvalModal">' +
                '    <i class="fa fa-times"></i> 반려' +
                '</button>' +
                '<button type="button" id="directApproveBtn" class="btn btn-primary btn-round ms-2"' +
                (approveDisabled ? ' disabled' : '') + ' ' + approveTitle + '>' +
                '    <i class="fa fa-check"></i> 승인' +
                '</button>';

            headerGroup.classList.remove("d-none"); // d-none 클래스 제어 복원

        } else {
            // 승인/반려 완료 상태면 버튼 그룹 숨김
            headerGroup.classList.add("d-none"); // d-none 클래스 제어 복원
        }


        // --- 2. 배차 상태 입력창 버튼 (dispatchActionGroup) ---
        const dispatchGroup = document.getElementById("dispatchActionGroup");
        // 기존 텍스트 입력 필드는 유지하고 버튼만 동적으로 추가
        dispatchGroup.querySelector('#detailOrDispatchStatus').value = dispatchStatus;

        // 🚨 주의: 기존에 JS가 추가한 버튼/텍스트 노드가 남아있을 수 있으므로, .input-group-text 요소를 모두 삭제 후 추가
        dispatchGroup.querySelectorAll('.input-group-text').forEach(el => el.remove());

        if (approvalStatus === 'REJECTED') {
            dispatchGroup.insertAdjacentHTML('beforeend',
                '<span class="input-group-text bg-danger text-white">반려됨</span>');
        } else if (approvalStatus === 'APPROVED' && isDispatched) {
            // 출고 승인 완료: 배차 조회만 가능 (수정/삭제 불가)
            dispatchGroup.insertAdjacentHTML('beforeend',
                '<button class="btn btn-info input-group-text" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 조회</button>');
        } else if (isDispatched) {
            // 배차는 완료되었으나 승인 대기: 배차 조회/수정/삭제 가능
            dispatchGroup.insertAdjacentHTML('beforeend',
                '<button class="btn btn-info input-group-text" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 조회</button>');
        } else if (dispatchStatus === 'PENDING') {
            // 배차 대기 중: 배차 등록 가능
            dispatchGroup.insertAdjacentHTML('beforeend',
                '<button class="btn btn-primary input-group-text" data-bs-toggle="modal" data-bs-target="#dispatchModal">배차 등록</button>');
        } else {
            dispatchGroup.insertAdjacentHTML('beforeend',
                '<span class="input-group-text bg-warning text-dark">배차 대기</span>');
        }


        // --- 3. 배차 모달 템플릿 렌더링 ---
        const modalContent = document.querySelector("#dispatchModal .modal-content");
        const endPointAddress = document.getElementById("detailOrStreetAddress").value
            + ' ' + document.getElementById("detailOrDetailedAddress").value;

        if (isDispatched || (dispatchStatus === 'PENDING' && approvalStatus !== 'REJECTED')) {
            if (isDispatched) {
                // VIEW/MODIFY MODE
                modalContent.innerHTML = document.getElementById("dispatchModifyTemplate").innerHTML;

                // DTO 필드 반영
                const vehicleInfo = dispatch.vehicle_id + ' (' + dispatch.driver_name + ')';
                modalContent.querySelector("#mod_currentVehicleInfo").value = vehicleInfo;
                modalContent.querySelector("#mod_orIndex").value = dispatch.or_index || 'N/A';
                modalContent.querySelector("#mod_vehicleType").value = dispatch.vehicle_type || 'N/A';
                modalContent.querySelector("#mod_dispatchDate").value = (formatDateTime(dispatch.dispatch_date) || 'N/A');
                modalContent.querySelector("#mod_start_point").value = dispatch.start_point;
                modalContent.querySelector("#mod_end_point").value = dispatch.end_point;
                modalContent.querySelector("#hidden_dispatch_index").value = currentDispatchId;


                const selectEl = modalContent.querySelector("#mod_vehicleIdSelect");
                populateVehicleSelect(selectEl, or_index, dispatch.vehicle_index);

                // [요청 반영] 출발지는 고정되어야 하므로, 활성화 목록에서 제외
                modalContent.querySelectorAll('#mod_vehicleIdSelect')
                    .forEach(f => f.disabled = true);

                // 버튼 제어
                const enableEditBtn = modalContent.querySelector("#enableEditBtn");
                const deleteBtn = modalContent.querySelector("#deleteDispatchBtn");
                const modifyBtn = modalContent.querySelector("#modifyDispatchBtn");

                if(approvalStatus === 'APPROVED') {
                    // 승인됨: 관리자도 조회만 가능 (d-none 클래스 복원)
                    if(enableEditBtn) enableEditBtn.classList.add('d-none');
                    if(deleteBtn) deleteBtn.classList.add('d-none');
                    if(modifyBtn) modifyBtn.classList.add('d-none');

                } else {
                    // PENDING: 수정 버튼 표시 (d-none 클래스 복원)
                    if(enableEditBtn) enableEditBtn.classList.remove('d-none');
                    if(deleteBtn) deleteBtn.classList.add('d-none'); // 초기 숨김
                    if(modifyBtn) modifyBtn.classList.add('d-none'); // 초기 숨김
                }

            } else {
                // REGISTER MODE
                modalContent.innerHTML = document.getElementById("dispatchRegisterTemplate").innerHTML;
                // or_index, 도착지 주소 설정
                modalContent.querySelector("#reg_or_index").value = or_index;
                modalContent.querySelector("#reg_end_point").value = endPointAddress;

                const selectEl = modalContent.querySelector("#reg_vehicleIdSelect");
                populateVehicleSelect(selectEl, or_index);
            }
        } else {
            modalContent.innerHTML = '<div class="modal-body"><p>현재 배차 작업을 수행할 수 없습니다. (반려되었거나 등록 가능한 상태가 아님)</p></div>';
        }
    }

    /**
     * [API 수정] 배차 모달의 차량 <select> 목록을 채움 (API 비동기 호출)
     */
    async function populateVehicleSelect(selectElement, or_index, selectedVehicleId = null) {
        if (!selectElement) return;
        selectElement.innerHTML = '<option value="">차량 목록 로딩 중...</option>';

        try {
            const response = await axios.get(API.ADMIN + "/dispatch/available/" + or_index);
            const vehicles = response.data;

            let optionsHtml = '<option value="">차량을 선택하세요</option>';
            // 백틱(`) 대신 문자열 연결(+) 사용으로 복원
            vehicles.forEach(v => {
                const selected = (selectedVehicleId && v.vehicle_index == selectedVehicleId) ? "selected" : "";
                optionsHtml += '<option value="' + v.vehicle_index + '" ' + selected + '>' +
                    v.vehicle_id + ' (' + v.driver_name + ' / ' + v.vehicle_type + ') - 잔여 용량: ' + v.vehicle_volume +
                    '</option>';
            });
            selectElement.innerHTML = optionsHtml;
        } catch (error) {
            console.error("Failed to load available vehicles for " + or_index, error);
            selectElement.innerHTML = '<option value="">차량 로드 실패</option>';
        }
    }

    /**
     * [AXIOS] 관리자 버튼 이벤트 바인딩 (동적 생성 후 호출)
     */
    function bindAdminButtons() {

        // 1. [UX 수정] 직접 승인 버튼 이벤트 (모달 없이 바로 실행)
        const directApproveBtn = document.getElementById("directApproveBtn");
        if (directApproveBtn) {
            directApproveBtn.addEventListener("click", function() {
                // 버튼이 disabled 상태면 경고
                if(this.disabled) {
                    alert("배차가 등록되어야 승인할 수 있습니다.");
                    return;
                }

                if (!confirm("정말로 이 요청을 승인하시겠습니까? (출고 지시서가 자동 생성되며, 재고가 차감됩니다)")) return;

                const data = {
                    or_index: currentOutboundId,
                    or_approval: "APPROVED",
                    reject_detail: null // 승인이므로 반려 사유는 null
                };

                // API 호출 로직 (직접 승인)
                axios.put(API.ADMIN + "/request/" + data.or_index + "/approval", data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("승인이 완료되었습니다. 출고 지시서가 생성되었습니다.");
                        location.reload();
                    })
                    .catch(error => {
                        alert("승인 실패: " + (error.response?.data?.message || "서버 오류"));
                        console.error(error);
                    });
            });
        }

        // 2. [UX 수정] 반려 모달 내부 버튼 이벤트 (반려만 처리)
        const rejectBtn = document.getElementById("rejectBtn");
        const handleReject = () => {
            const status = 'REJECTED';
            const rejectDetail = document.getElementById("reject_detail").value;
            if (!rejectDetail || rejectDetail.trim() === "") {
                alert("반려 시 사유를 반드시 입력해야 합니다.");
                return;
            }
            if (!confirm(`정말로 이 요청을 '반려' 하시겠습니까?`)) return;

            const data = {
                or_index: currentOutboundId,
                or_approval: status,
                reject_detail: rejectDetail
            };

            // API 호출 로직 (반려)
            axios.put(API.ADMIN + "/request/" + data.or_index + "/reject", data, { headers: { 'Content-Type': 'application/json' } })
                .then(response => {
                    alert("반려 처리가 완료되었습니다.");
                    location.reload();
                })
                .catch(error => alert("처리 실패: " + (error.response?.data?.message || "서버 오류")));
        };

        if (rejectBtn) {
            // 모달 닫기 버튼은 제외하고 반려 버튼만 이벤트 바인딩
            rejectBtn.addEventListener("click", handleReject);
        }

        // 3. 배차 수정 모드 활성화 (수정 버튼 클릭)
        const enableEditBtn = document.getElementById("enableEditBtn");
        if (enableEditBtn) {
            enableEditBtn.addEventListener("click", function() {
                // 폼 필드 활성화: 차량 선택만 활성화 (출발지는 readonly 유지)
                document.querySelectorAll('#dispatchModifyForm #mod_vehicleIdSelect')
                    .forEach(f => f.disabled = false);

                // '수정 완료' 및 '배차 삭제' 버튼 표시 (d-none 클래스 복원)
                document.getElementById("modifyDispatchBtn").classList.remove('d-none');
                document.getElementById("deleteDispatchBtn").classList.remove('d-none');

                // '수정 모드 활성화' 버튼 숨김 (d-none 클래스 복원)
                this.classList.add('d-none');
            });
        }

        // 4. 배차 등록
        const registerDispatchBtn = document.getElementById("registerDispatchBtn");
        if (registerDispatchBtn) {
            registerDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchRegisterForm");
                data.or_index = currentOutboundId;
                if (!data.vehicle_index) {
                    alert("차량을 선택하세요.");
                    return;
                }
                axios.post(API.ADMIN + "/dispatch", data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 등록되었습니다.");
                        // 모달 닫고 페이지 리로드
                        $('#dispatchModal').modal('hide');
                        location.reload();
                    })
                    .catch(error => alert("등록 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 5. 배차 수정 (완료)
        const modifyDispatchBtn = document.getElementById("modifyDispatchBtn");
        if (modifyDispatchBtn) {
            modifyDispatchBtn.addEventListener("click", function() {
                const data = getFormData("dispatchModifyForm");
                // PUT 요청 시 PathVariable에 dispatch_index를 사용
                axios.put(API.ADMIN + "/dispatch/" + currentDispatchId, data, { headers: { 'Content-Type': 'application/json' } })
                    .then(response => {
                        alert("배차 수정되었습니다.");
                        // 모달 닫고 페이지 리로드
                        $('#dispatchModal').modal('hide');
                        location.reload();
                    })
                    .catch(error => alert("수정 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }

        // 6. 배차 삭제 (취소)
        const deleteDispatchBtn = document.getElementById("deleteDispatchBtn");
        if (deleteDispatchBtn) {
            deleteDispatchBtn.addEventListener("click", function() {
                if (!confirm("정말로 이 배차를 삭제(취소)하시겠습니까? (출고 승인 전까지 가능)")) return;
                // PUT 요청 시 PathVariable에 dispatch_index를 사용
                axios.put(API.ADMIN + "/dispatch/" + currentDispatchId + ":delete")
                    .then(response => {
                        alert("배차 삭제(취소)되었습니다.");
                        // 모달 닫고 페이지 리로드
                        $('#dispatchModal').modal('hide');
                        location.reload();
                    })
                    .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
            });
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>