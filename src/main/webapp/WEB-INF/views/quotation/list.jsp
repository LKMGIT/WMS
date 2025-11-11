<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">견적 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/quotation/requests">견적 리스트</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">견적신청 목록</h4>

                        <c:if test="${sessionScope.loginUser.userType == 'USER'}">
                            <a href="${contextPath}/qoutation/request/register" class="btn btn-primary btn-round ms-auto">
                                <i class="fa fa-plus"></i>
                                견적 신청
                            </a>
                        </c:if>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row g-3 justify-content-center mb-3">
                        <form id="searchForm" class="input-group">
                            <div class="col-auto">
                                <select class="form-select" name="type">
                                    <option value="T">제목 (q_title)</option>
                                    <option value="C">내용 (q_content)</option>
                                    <option value="W">작성자 (user_name)</option>
                                </select>
                            </div>
                            <div class="col-5">
                                <input type="text" class="form-control" name="keyword" placeholder="검색어 입력">
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-default" type="button" id="searchBtn">검색</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>견적 ID (q_index)</th>
                                <th>제목 (q_title)</th>
                                <th>작성자 (user_name)</th>
                                <th>작성일 (created_at)</th>
                                <th>답변 상태 (q_response)</th>
                            </tr>
                            </thead>
                            <tbody id="quotationTbody">
                            <tr><td colspan="5" class="text-center">데이터를 불러오는 중입니다...</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div id="quotationPagination" class="mt-3 d-flex justify-content-center">
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
    // UserDTO 참고
    const loginUserType = "${sessionScope.loginUser.userType}"; // 'ADMIN' or 'USER'

    // --- [API 경로 설정] ---
    const API = {
        // QuotationMemberController
        MEMBER: `${contextPath}/api/quotation`,
        // QuotationAdminController
        ADMIN: `${contextPath}/api/admin/quotation`
    };

    // [권한 분기] '읽기' (GET) API 경로는 권한에 따라 분기합니다.
    const READ_API_BASE = loginUserType === 'ADMIN' ? API.ADMIN : API.MEMBER;

    /**
     * 목록 데이터 로드 함수
     * @param {number} page - 요청할 페이지 번호
     * @param {string} type - 검색 타입
     * @param {string} keyword - 검색 키워드
     */
    async function loadList(page = 1, type = '', keyword = '') {
        const tbody = document.getElementById("quotationTbody");
        tbody.innerHTML = `<tr><td colspan="5" class="text-center">데이터를 불러오는 중입니다...</td></tr>`;

        try {
            // [API 경로 수정]: 컨트롤러 매핑인 /request 추가
            // [파라미터 수정]: Criteria + QuotationSearchDTO
            const params = new URLSearchParams({ page, amount: 10, type, keyword });

            const response = await axios.get(`${READ_API_BASE}/request`, { params });
            // API 응답: { list: [QuotationDetailDTO, ...], pageDTO: {...} } (가정)
            const { list, pageDTO } = response.data;

            tbody.innerHTML = ""; // tbody 초기화

            if (!list || list.length === 0) {
                tbody.innerHTML = `<tr><td colspan="5" class="text-center">견적 신청 내역이 없습니다.</td></tr>`;
                renderPagination(pageDTO, loadList); // 페이징은 렌더링
                return;
            }

            // [JS 렌더링]: DTO 속성(q_title 등)에 맞춰 렌더링
            list.forEach(item => {
                // DTO 속성: q_response (EnumStatus)
                const answeredBadge = item.q_response === 'COMPLETED'
                    ? `<span class="badge bg-primary">답변 완료</span>`
                    : `<span class="badge bg-light text-dark">답변 대기</span>`;

                // DTO 속성: created_at (LocalDateTime)
                const regDate = new Date(item.created_at).toLocaleDateString("ko-KR");

                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";
                tr.onclick = () => {
                    // [경로 수정] OutboundViewController.java 매핑 경로
                    location.href = `${contextPath}/quotation/request/${item.q_index}`;
                };

                // [DTO 반영] DTO 속성: q_index, q_title, user_name, created_at, q_response
                tr.innerHTML = `
                    <td>${item.q_index}</td>
                    <td>${item.q_title}</td>
                    <td>${item.user_name}</td>
                    <td>${regDate}</td>
                    <td>${answeredBadge}</td>
                `;
                tbody.appendChild(tr);
            });

            // [JS 렌더링]: 페이지네이션 생성
            renderPagination(pageDTO, loadList);

        } catch (error) {
            console.error("List loading failed:", error);
            tbody.innerHTML = `<tr><td colspan="5" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>`;
        }
    }

    /**
     * 페이지네이션 렌더링 함수
     * @param {object} pageDTO - 페이지 정보
     * @param {function} loadFn - 페이지 클릭 시 호출할 함수 (loadList)
     */
    function renderPagination(pageDTO, loadFn) {
        const paginationUl = document.getElementById("quotationPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;
        const { type, keyword } = criteria; //

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

                // 검색 조건 가져오기
                const form = document.getElementById("searchForm");
                const currentType = form.type.value;
                const currentKeyword = form.keyword.value;

                loadFn(pageNum, currentType, currentKeyword); // 검색 조건 유지하며 페이지 이동
            });
        });
    }

    // 페이지 로드 시 1페이지 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        loadList(1);
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        const form = document.getElementById("searchForm");
        const type = form.type.value;
        const keyword = form.keyword.value;
        loadList(1, type, keyword); // 검색 시 1페이지로
    });
</script>
<%@ include file="../includes/end.jsp" %>