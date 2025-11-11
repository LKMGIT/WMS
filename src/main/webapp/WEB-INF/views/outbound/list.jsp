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
            <li class="nav-item"><a href="${contextPath}/outbound/requests">출고 리스트</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">출고 리스트</h4>

                        <c:if test="${sessionScope.loginUser.userType == 'USER'}">
                            <a href="${contextPath}/outbound/request/register" class="btn btn-primary btn-round ms-auto">
                                <i class="fa fa-plus"></i>
                                출고 요청
                            </a>
                        </c:if>

                        <c:if test="${sessionScope.loginUser.userType == 'ADMIN'}">
                            <a href="${contextPath}/instructions" class="btn btn-secondary btn-round ms-auto">
                                <i class="fa fa-file-invoice"></i>
                                출고 지시서 목록
                            </a>
                        </c:if>
                    </div>
                </div>
                <div class="card-body">
                    <div id="searchGroup" class="row g-3 justify-content-center mb-3 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <select class="form-select" id="searchType" style="flex-grow: 0.3;">
                                    <option value="I">상품ID (item_index)</option>
                                    <option value="U">요청자ID (user_index)</option>
                                </select>
                                <input type="text" class="form-control" id="searchKeyword" placeholder="검색어 입력">
                            </div>
                        </div>

                        <div class="col-md-2">
                            <select class="form-select" id="searchApprovalStatus">
                                <option value="">-- 승인 상태 (전체) --</option>
                                <option value="PENDING">대기중</option>
                                <option value="APPROVED">승인됨</option>
                                <option value="REJECTED">거부됨</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <select class="form-select" id="searchDispatchStatus">
                                <option value="">-- 배차 상태 (전체) --</option>
                                <option value="PENDING">대기중</option>
                                <option value="APPROVED">완료</option>
                            </select>
                        </div>

                        <div class="col-md-1">
                            <button class="btn btn-default" type="button" id="searchBtn">검색</button>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>요청 ID (or_index)</th>
                                <th>상품 ID (item_index)</th>
                                <th>요청자 ID (user_index)</th>
                                <th>수취인명 (or_name)</th>
                                <th>요청수량 (or_quantity)</th>
                                <th>요청일 (created_at)</th>
                                <th>승인 상태 (or_approval)</th>
                            </tr>
                            </thead>
                            <tbody id="outboundTbody">
                            <tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>
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

<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 (세션 정보) ---
    const contextPath = "${contextPath}";
    <%--const loginUserType = "${sessionScope.loginUser.userType}"; // 'ADMIN' or 'USER'--%>

    <%--// --- [API 경로 설정] -----%>
    <%--const API = {--%>
    <%--    MEMBER: `${contextPath}/api/outbound`,--%>
    <%--    ADMIN: `${contextPath}/api/admin/outbound`--%>
    <%--};--%>

    <%--// [권한 분기] '읽기' (GET) API 경로는 권한에 따라 분기합니다.--%>
    <%--const READ_API_BASE = loginUserType === 'ADMIN' ? API.ADMIN : API.MEMBER;--%>

    /**
     * [수정] LocalDateTime 배열을 JavaScript Date 객체로 변환
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * [수정] 날짜 배열을 포맷팅된 문자열로 반환
     */
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleDateString("ko-KR") : "N/A";
    }

    /**
     * [수정] 현재 검색 조건들을 객체로 가져옵니다.
     * @returns {object}
     */
    function getSearchParams() {
        const type = document.getElementById("searchType").value;
        const keyword = document.getElementById("searchKeyword").value;
        const approval_status = document.getElementById("searchApprovalStatus").value;
        const dispatch_status = document.getElementById("searchDispatchStatus").value;

        return { type, keyword, approval_status, dispatch_status };
    }

    /**
     * [수정] 목록 데이터 로드 함수 (searchParams 객체 사용)
     * @param {number} page - 요청할 페이지 번호
     * @param {object} searchParams - 검색 조건 객체
     */
    async function loadList(page = 1, searchParams = {}) {
        const tbody = document.getElementById('outboundTbody');
        tbody.innerHTML = `<tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>`;

        try {
            // [API 경로 수정]: 컨트롤러 매핑인 /request 추가
            // [파라미터 수정]: Criteria(page) + OutboundSearchDTO(searchParams)
            const params = new URLSearchParams({
                page,
                amount: 10,
                ...searchParams // type, keyword, approval_status, dispatch_status 포함
            });

            // const response = await axios.get(`${READ_API_BASE}/request`, { params });
            const response = await axios.get(`${contextPath}/api/admin/outbound/request`, { params });
            // API 응답: { list: [OutboundRequestDTO, ...], pageDTO: {...} }
            const { list, pageDTO } = response.data;

            tbody.innerHTML = ''; // tbody 초기화

            if (!list || list.length === 0) {
                tbody.innerHTML = `<tr><td colspan="7" class="text-center">출고 요청 내역이 없습니다.</td></tr>`;
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
                const created_at = item.created_at;
                const or_approval = item.or_approval;

                let statusBadge = `<span class="badge bg-secondary">${or_approval}</span>`;
                if (or_approval === 'COMPLETED' || item.or_approval === 'APPROVED') {
                    statusBadge = `<span class="badge bg-primary">${or_approval}</span>`;
                } else if (or_approval === 'PENDING') {
                    statusBadge = `<span class="badge bg-warning text-dark">PENDING</span>`;
                } else if (or_approval === 'REJECTED') {
                    statusBadge = `<span class="badge bg-danger">${or_approval}</span>`;
                }

                // [날짜 수정] DTO의 LocalDateTime (created_at) 사용
                const regDate = formatDateTime(created_at);

                const tr = document.createElement('tr');
                tr.style.cursor = 'pointer';
                tr.onclick = () => {
                    // [경로 수정] OutboundViewController.java 매핑 경로
                    location.href = `${contextPath}/outbound/request/${or_index}`;
                };

                console.log('or_index:', or_index);
                console.log('item_index:', item_index);
                console.log('user_index:', user_index);
                console.log('or_name:', or_name);
                console.log('or_quantity:', or_quantity);
                console.log('regDate:', regDate);
                console.log('statusBadge:', statusBadge);

                // [DTO 반영] DTO 속성: or_index, item_index, user_index, or_name, or_quantity, created_at, or_approval
                tr.innerHTML = `
                    <td>${or_index}</td>
                    <td>${item_index}</td>
                    <td>${user_index}</td>
                    <td>${or_name}</td>
                    <td>${or_quantity}</td>
                    <td>${regDate}</td>
                    <td>${statusBadge}</td>
                `;
                tbody.appendChild(tr);
            });

            // [JS 렌더링]: 페이지네이션 생성
            renderPagination(pageDTO, loadList, searchParams);

        } catch (error) {
            console.error("List loading failed:", error);
            tbody.innerHTML = `<tr><td colspan="7" class="text-center text-danger">목록 로딩에 실패했습니다. (Mapper.xml 수정 확인)</td></tr>`;
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

        if (!pageDTO) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;

        // '이전' 버튼
        if (prev) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${startPage - 1}">Previous</a></li>`;
        }

        // 페이지 번호
        for (let i = startPage; i <= endPage; i++) {
            paginationHtml += `
                <li class="page-item ${criteria.pageNum == i ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>
            `;
        }

        // '다음' 버튼
        if (next) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${endPage + 1}">Next</a></li>`;
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

    // 페이지 로드 시 1페이지 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        loadList(1, getSearchParams());
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        loadList(1, getSearchParams()); // 검색 시 1페이지로
    });
</script>
<%@ include file="../includes/end.jsp" %>
