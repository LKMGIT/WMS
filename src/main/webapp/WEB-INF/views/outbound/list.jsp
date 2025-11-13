<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:17
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
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고요청 리스트</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">출고요청 리스트</h4>

                        <c:choose>
                            <%-- 1. 관리자(loginAdminId)가 우선순위를 가짐 --%>
                            <c:when test="${not empty sessionScope.loginAdminIndex}">
                                <div id="adminBulkActionGroup" class="ms-auto d-flex">
                                    <button class="btn btn-primary btn-round ms-2" type="button" id="bulkApproveBtn">
                                        <i class="fa fa-check"></i> 출고 승인
                                    </button>
                                    <button class="btn btn-info btn-round ms-2" type="button" id="bulkDispatchBtn">
                                        <i class="fa fa-truck"></i> 배차 등록
                                    </button>
                                    <a href="${contextPath}/outbound/instructions" class="btn btn-secondary btn-round ms-2">
                                        <i class="fa fa-file-invoice"></i> 출고 지시서 목록
                                    </a>
                                </div>
                            </c:when>

                            <%-- 2. 관리자가 아닐 경우, 사용자(loginUserId)인지 확인 --%>
                            <c:when test="${not empty sessionScope.loginUserIndex}">
                                <a href="${contextPath}/outbound/request/register" class="btn btn-primary btn-round ms-auto">
                                    <i class="fa fa-plus"></i>
                                    출고 요청
                                </a>
                            </c:when>

                            <%-- 3. (Optional) 둘 다 아닐 경우 (비로그인) - 아무것도 표시 안 함 --%>
                            <c:otherwise>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card-body">
                    <div id="searchGroup" class="row g-3 mb-3 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <select class="form-select" id="searchType" style="flex-grow: 0.3;">
                                    <option value="I">상품ID</option>
                                    <option value="U">요청자ID</option>
                                </select>
                                <input type="text" class="form-control" id="searchKeyword" placeholder="검색어 입력">
                            </div>
                        </div>

                        <div class="col-md-2">
                            <select class="form-select" id="searchDispatchStatus">
                                <option value="">-- 배차 상태 (전체) --</option>
                                <option value="PENDING">대기중</option>
                                <option value="APPROVED">완료</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <select class="form-select" id="searchApprovalStatus">
                                <option value="">-- 승인 상태 (전체) --</option>
                                <option value="PENDING">대기중</option>
                                <option value="APPROVED">승인됨</option>
                                <option value="REJECTED">거부됨</option>
                            </select>
                        </div>

                        <div class="col-md-1">
                            <button class="btn btn-outline-secondary" type="button" id="searchBtn">검색</button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <th><input class="form-check-input" type="checkbox" id="checkAll"></th>
                                <th>요청 ID</th>
                                <th>상품 ID</th>
                                <th>요청자 ID</th>
                                <th>수취인명</th>
                                <th>요청수량</th>
                                <th>요청일</th>
                                <th>배차 상태</th>
                                <th>출고승인 상태</th>
                            </tr>
                            </thead>
                            <tbody id="outboundTbody">
                            <tr><td colspan="9" class="text-center">데이터를 불러오는 중입니다...</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div id="outboundPagination" class="mt-3 d-flex justify-content-center">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- [신규] 배차 등록 모달 (list.jsp 전용) --%>
<div class="modal fade" id="listDispatchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="listDispatchForm">
                <%-- 배차 등록 API에 필요한 or_index --%>
                <input type="hidden" id="list_dispatch_or_index" name="or_index">

                <div class="modal-header">
                    <h5 class="modal-title">배차 등록 (요청 ID: <span id="list_dispatch_or_index_span"></span>)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="list_dispatch_start_point">출발지</label>
                        <input type="text" class="form-control" id="list_dispatch_start_point" name="start_point" placeholder="예: 제 1 물류센터" value="제 1 물류센터">
                    </div>
                    <div class="form-group">
                        <label for="list_dispatch_end_point">도착지 (자동 완성)</label>
                        <%-- 도착지 주소 (DTO의 or_street_address에서 자동 완성됨) --%>
                        <input type="text" class="form-control" id="list_dispatch_end_point" name="end_point" readonly>
                    </div>
                    <div class="form-group">
                        <label for="list_dispatch_vehicleSelect">배차 가능 차량</label>
                        <%-- 차량 목록 (API로 동적 로드됨) --%>
                        <select class="form-select" id="list_dispatch_vehicleSelect" name="vehicle_index" required>
                            <option value="">차량 목록 로딩 중...</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="registerDispatchFromListBtn" class="btn btn-primary">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // JSTL 변수
    const contextPath = "${contextPath}";

    const isAdmin = ${not empty sessionScope.loginAdminIndex};

    // [권한 분기] API 경로는 권한에 따라 분기
    const API = {
        // MEMBER: `\${contextPath}/api/outbound`,
        // ADMIN: `\${contextPath}/api/admin/outbound`
        MEMBER: "${contextPath}/api/outbound",
        ADMIN: "${contextPath}/api/admin/outbound"
    };

    // [수정] EL 불리언(boolean)은 따옴표 없이 사용해야 합니다.
    const READ_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;

    let lisDispatchModal = null;

    // LocalDateTime 배열을 JavaScript Date 객체로 변환
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    // 날짜 배열을 포맷팅된 문자열로 반환
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleDateString("ko-KR") : "N/A";
    }

    // 폼 데이터 -> JS Object
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => { data[key] = value; });
        return data;
    }

    // [수정] 현재 검색 조건들을 객체로 가져옴
    function getSearchParams() {
        const type = document.getElementById("searchType").value;
        const keyword = document.getElementById("searchKeyword").value;
        const dispatch_status = document.getElementById("searchDispatchStatus").value;
        const approval_status = document.getElementById("searchApprovalStatus").value;
        return { type, keyword, approval_status, dispatch_status };
    }

    /**
     * [수정] 목록 데이터 로드 함수 (searchParams 객체 사용)
     * @param {number} page - 요청할 페이지 번호
     * @param {object} searchParams - 검색 조건 객체
     */
    async function loadList(page = 1, searchParams = {}) {
        const tbody = document.getElementById('outboundTbody');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>';

        try {
            // 검색 조건 및 페이징
            const params = new URLSearchParams({
                pageNum: page,
                amount: 10,
                ...searchParams // type, keyword, approval_status, dispatch_status 포함
            });

            // 데이터 가져오기
            const response = await axios.get(READ_API_BASE + "/request", { params });

            // API 응답: { list: [OutboundRequestDTO, ...], pageDTO: {...} }
            const { list, pageDTO } = response.data;

            const listContextQuery = params.toString();

            tbody.innerHTML = ''; // tbody 초기화

            if (!list || list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center">출고 요청 내역이 없습니다.</td></tr>';
                renderPagination(pageDTO, loadList, searchParams); // 페이징은 렌더링
                return;
            }

            // [JS 렌더링]: DTO 속성(item.or_name 등)에 맞춰 렌더링
            list.forEach(item => {
                const or_index = item.or_index;
                const item_index = item.item_index;
                const user_index = item.user_index;
                const or_name = item.or_name;
                const or_quantity = item.or_quantity;
                const updated_at = item.updated_at;
                const or_dispatch_status = item.or_dispatch_status;
                const or_approval = item.or_approval;
                const or_street_address = item.or_street_address;
                const or_detailed_address = item.or_detailed_address;

                let statusBadge1 = '<span class="badge bg-secondary">' + or_dispatch_status + '</span>';
                if (or_dispatch_status === 'COMPLETED' || or_dispatch_status === 'APPROVED') {
                    statusBadge1 = '<span class="badge bg-primary">' + or_dispatch_status + '</span>';
                } else if (or_dispatch_status === 'PENDING') {
                    statusBadge1 = '<span class="badge bg-warning text-dark">PENDING</span>';
                }

                // [JS 수정] 백틱(``) 대신 문자열 연결(+) 사용
                let statusBadge2 = '<span class="badge bg-secondary">' + or_approval + '</span>';
                if (or_approval === 'COMPLETED' || item.or_approval === 'APPROVED') {
                    statusBadge2 = '<span class="badge bg-primary">' + or_approval + '</span>';
                } else if (or_approval === 'PENDING') {
                    statusBadge2 = '<span class="badge bg-warning text-dark">PENDING</span>';
                } else if (or_approval === 'REJECTED') {
                    statusBadge2 = '<span class="badge bg-danger">' + or_approval + '</span>';
                }

                // [날짜 수정] DTO의 LocalDateTime (created_at) 사용
                const regDate = formatDateTime(updated_at);

                const tr = document.createElement('tr');
                tr.style.cursor = 'pointer';
                tr.onclick = (e) => {
                    if (e.target.type === 'checkbox') {
                        e.stopPropagation();
                        return;
                    }
                    // [경로 수정] OutboundViewController.java 매핑 경로
                    location.href = contextPath + '/outbound/request/' + or_index + '?' + listContextQuery;
                };

                const td0 = document.createElement('td');
                td0.innerHTML = '<input class="form-check-input check-item" type="checkbox" ' +
                    'data-id="' + or_index + '" ' +
                    'data-approval-status="' + or_approval + '" ' +
                    'data-dispatch-status="' + or_dispatch_status + '" ' +
                    'data-end-point="' + or_street_address + " " + or_detailed_address + '">';
                tr.appendChild(td0);
                const td1 = document.createElement('td');
                td1.innerText = or_index;
                tr.appendChild(td1);
                const td2 = document.createElement('td');
                td2.innerText = item_index;
                tr.appendChild(td2);
                const td3 = document.createElement('td');
                td3.innerText = user_index;
                tr.appendChild(td3);
                const td4 = document.createElement('td');
                td4.innerText = or_name;
                tr.appendChild(td4);
                const td5 = document.createElement('td');
                td5.innerText = or_quantity;
                tr.appendChild(td5);
                const td6 = document.createElement('td');
                td6.innerText = regDate;
                tr.appendChild(td6);
                const td7 = document.createElement('td');
                td7.innerHTML = statusBadge1;
                tr.appendChild(td7);
                const td8 = document.createElement('td');
                td8.innerHTML = statusBadge2;
                tr.appendChild(td8);

                tbody.appendChild(tr);
            });

            // [JS 렌더링]: 페이지네이션 생성
            renderPagination(pageDTO, loadList, searchParams);

        } catch (error) {
            console.error("List loading failed:", error);
            tbody.innerHTML = '<tr><td colspan="9" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>';
        }
    }

    /**
     * [수정] 페이지네이션 렌더링 함수 (searchParams 유지)
     * @param {object} pageDTO
     * @param {function} loadFn
     * @param {object} searchParams - 현재 검색 조건
     */
    function renderPagination(pageDTO, loadFn, searchParams) {
        const paginationUl = document.getElementById("outboundPagination");
        paginationUl.innerHTML = "";

        console.log(pageDTO);
        console.log(pageDTO.cri);

        if (!pageDTO || !pageDTO.cri) {
            console.log("페이지네이션 데이터가 없거나 불완전합니다. (pageDTO or pageDTO.criteria is null)");
            return;
        }

        let paginationHtml = '<ul class="pagination">';
        const { cri, startPage, endPage, prev, next } = pageDTO;

        // '이전' 버튼
        if (prev) {
            // [!!! 핵심 수정 2 !!!] 백틱(`) 대신 '+' 연산자 사용
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (startPage - 1) + '">이전</a></li>';
        }

        // 페이지 번호
        for (let i = startPage; i <= endPage; i++) {
            // [!!! 핵심 수정 2 !!!] 백틱(`) 대신 '+' 연산자 사용
            const activeClass = (cri.pageNum == i) ? 'active' : '';

            paginationHtml += '<li class="page-item ' + activeClass + '">' +
                '  <a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>';
        }

        // '다음' 버튼
        if (next) {
            // [!!! 핵심 수정 2 !!!] 백틱(`) 대신 '+' 연산자 사용
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (endPage + 1) + '">다음</a></li>';
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        // [연결]: 동적으로 생성된 페이지 번호에 클릭 이벤트 바인딩
        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;

                // [수정] loadFn 호출 시 현재 searchParams를 그대로 전달
                loadFn(pageNum, searchParams);
            });
        });
    }

    /**
     * 배차 가능 차량 목록 로드 (모달 띄울 때 호출)
     * @param {string} or_index - 배차할 주문 ID
     */
    async function loadAvailableVehicles(or_index) {
        const selectElement = document.getElementById("list_dispatch_vehicleSelect");
        selectElement.innerHTML = '<option value="">차량 목록 로딩 중...</option>';

        try {
            // API: GET /api/admin/outbound/vehicles
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const response = await axios.get(API.ADMIN + "/dispatch/available/" + or_index);
            const vehicles = response.data; // List<AvailableDispatchDTO>

            let optionsHtml = '<option value="">차량을 선택하세요</option>';
            vehicles.forEach(v => {
                // (JS 변수만 있으므로 백틱 유지)
                optionsHtml += '<option value="' + v.vehicle_index + '">' + v.vehicle_id + '( ' + v.driver_name + '/ "' + v.vehicle_type + ' )</option>';
            });
            selectElement.innerHTML = optionsHtml;

        } catch(error) {
            console.error("Vehicle list loading failed:", error);
            selectElement.innerHTML = '<option value="">차량 로드 실패</option>';
        }
    }

    /**
     * 목록 페이지의 '배차 등록' 모달 내부 버튼 이벤트 바인딩
     */
    function bindListDispatchModalEvents() {
        // 모달의 '등록' 버튼 클릭 시
        document.getElementById("registerDispatchFromListBtn").addEventListener("click", async () => {
            const data = getFormData("listDispatchForm"); // or_index, start_point, end_point, vehicle_index

            if (!data.vehicle_index) {
                alert("차량을 선택하세요.");
                return;
            }

            if (!confirm("다음 정보로 배차를 등록하시겠습니까?\n- 요청ID: " + data.or_index + "\n- 차량ID: " + data.vehicle_index)) {
                return;
            }

            try {
                // API: POST /api/admin/outbound/dispatch
                // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                await axios.post(API.ADMIN + "/dispatch", data, {
                    headers: { 'Content-Type': 'application/json' }
                });

                alert("배차 등록되었습니다.");
                listDispatchModal.hide(); // 모달 닫기
                loadList(1, getSearchParams()); // 목록 새로고침
                document.getElementById("checkAll").checked = false; // 전체선택 해제

            } catch(error) {
                alert("배차 등록 실패: " + (error.response?.data?.message || "서버 오류"));
            }
        });
    }

    // 페이지 로드 시 1페이지 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        loadList(1, getSearchParams());

        if (isAdmin) {
            listDispatchModal = new bootstrap.Modal(document.getElementById('listDispatchModal'))
            bindAdminButtonEvents();
            bindListDispatchModalEvents();
        }
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        loadList(1, getSearchParams()); // 검색 시 1페이지로
    });

    function bindAdminButtonEvents() {
        // --- 1. 전체 선택 체크박스 ---
        const checkAll = document.getElementById("checkAll");
        if(checkAll) {
            checkAll.addEventListener("click", function() {
                const isChecked = this.checked;
                document.querySelectorAll(".check-item").forEach(cb => {
                    cb.checked = isChecked;
                });
            });
        }

        // --- 2. 일괄 승인 버튼 ---
        const bulkApproveBtn = document.getElementById("bulkApproveBtn");
        if(bulkApproveBtn) {
            bulkApproveBtn.addEventListener("click", async () => {
                const checkedItems = document.querySelectorAll(".check-item:checked");
                if (checkedItems.length === 0) {
                    alert("승인할 항목을 선택하세요.");
                    return;
                }

                // [Constraint 2] '승인 대기' 상태이고 '배차 완료' 상태인 항목만 필터링
                const itemsToApprove = [];
                let invalidItemFound = false;

                checkedItems.forEach(cb => {
                    const id = cb.dataset.id;
                    const approval = cb.dataset.approvalStatus;
                    const dispatch = cb.dataset.dispatchStatus;

                    // '승인 대기' 및 '배차 완료' 상태인 것만 승인 목록에 추가
                    if (approval === 'PENDING' && (dispatch === 'COMPLETED' || dispatch === 'APPROVED')) {
                        itemsToApprove.push(id);
                    } else {
                        invalidItemFound = true;
                    }
                });

                // [Constraint 2] 유효하지 않은 항목이 하나라도 선택된 경우 경고
                if (invalidItemFound) {
                    alert("선택된 항목 중 승인할 수 없는 건이 포함되어 있습니다.\n('승인 대기' + '배차 완료' 상태인 항목만 승인 가능합니다.)");
                    return;
                }

                if (itemsToApprove.length === 0) {
                    alert("승인 가능한 항목이 없습니다.");
                    return;
                }

                if (!confirm("선택한 " + itemsToApprove.length + "건을 일괄 승인하시겠습니까?")) {
                    return;
                }

                let successCount = 0;
                let failCount = 0;

                // (로딩 스피너 등을 여기서 켜주면 좋습니다)

                for (const id of itemsToApprove) {
                    try {
                        // [가정] detail.jsp의 승인 로직을 따름.
                        // PUT /api/admin/outbound/request/approval
                        // body: { or_index: id, or_approval: "APPROVED" }
                        // (만약 API가 PUT /api/admin/outbound/request/{id}/approval 형태라면 아래 코드를 수정해야 합니다.)

                        const data = {
                            or_index: id,
                            or_approval: "APPROVED"
                            // admin_index 등은 컨트롤러에서 세션으로 처리한다고 가정
                        };

                        // [수정] 백틱(``) 대신 문자열 연결(+) 사용
                        await axios.put(API.ADMIN + "/request/" + data.or_index + "/approval", data, {
                            headers: {'Content-Type': 'application/json'}
                        });

                        successCount++;

                    } catch (error) {
                        console.error("ID " + id + " 승인 실패:", error);
                        failCount++;
                    }
                }
                alert("일괄 승인 처리 완료\n성공: " + successCount + "건\n실패: " + failCount + "건");
                loadList(1, getSearchParams()); // 목록 새로고침
                if(checkAll) checkAll.checked = false; // 전체 선택 해제
            });
        }

        // --- 3. 일괄 배차 버튼 (모달 띄우기) ---
        const bulkDispatchBtn = document.getElementById("bulkDispatchBtn");
        if(bulkDispatchBtn) {
            bulkDispatchBtn.addEventListener("click", () => {
                const checkedItems = document.querySelectorAll(".check-item:checked");

                // [Constraint 1] 1개만 선택했는지 검사
                if (checkedItems.length > 1) {
                    alert("배차 등록은 한 번에 하나씩만 선택하여 진행할 수 있습니다.");
                    return;
                }
                if (checkedItems.length === 0) {
                    alert("배차할 항목을 1개 선택하세요.");
                    return;
                }

                // 선택한 항목(item)의 상태 검사
                const item = checkedItems[0];
                const id = item.dataset.id;
                const approval = item.dataset.approvalStatus;
                const dispatch = item.dataset.dispatchStatus;

                // [!!! 중요 !!!] DTO에 주소가 포함되어 있는지 확인
                const endPoint = item.dataset.endPoint;
                if (!endPoint || endPoint === '') {
                    alert("오류: 도착지 주소 정보가 없습니다.\n(백엔드 DTO에 'or_street_address'가 포함되어야 합니다.)");
                    return;
                }

                // [핵심] 모든 검사 통과 -> 모달에 정보 채우기 및 띄우기

                // 1. 모달 폼 내부에 or_index와 end_point 값 채우기
                document.getElementById("list_dispatch_or_index").value = id;
                document.getElementById("list_dispatch_or_index_span").textContent = id;
                document.getElementById("list_dispatch_end_point").value = endPoint;

                // 2. 배차 가능 차량 목록 API 호출 (비동기)
                loadAvailableVehicles(id);

                // 3. 모달 띄우기
                listDispatchModal.show();
            });
        }
    }
</script>
<%@ include file="../includes/end.jsp" %>
