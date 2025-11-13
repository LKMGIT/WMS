<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:19
  순수 목록 조회 전용 (액션 버튼 제거)
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
                    </div>
                </div>
                <div class="card-body">
                    <%-- 🚨 [수정] 검색 폼 구조 통일 (col-md-5, col-md-2 그리드 적용) --%>
                    <div id="searchGroup" class="row g-3 mb-3 align-items-center">
                        <form id="searchForm" class="col-12 d-flex flex-wrap p-0">
                            <%-- 1. 타입/키워드 통합 (col-md-5) --%>
                            <div class="col-md-5 me-2">
                                <div class="input-group">
                                    <select class="form-select" name="type" style="flex-grow: 0.3;">
                                        <option value="U">작성자 ID</option>
                                        <option value="W">작성자 이름</option>
                                    </select>
                                    <input type="text" class="form-control" name="keyword" placeholder="검색어 입력">
                                </div>
                            </div>

                            <%-- 2. 답변 상태 (col-md-2) --%>
                            <div class="col-md-2 me-2">
                                <select class="form-select" id="searchAnsweredStatus" name="qrequest_status">
                                    <option value="">-- 답변 상태 (전체) --</option>
                                    <option value="PENDING">대기중</option>
                                    <option value="ANSWERED">답변완료</option>
                                </select>
                            </div>

                            <%-- 3. 검색 버튼 (col-md-1) --%>
                            <div class="col-md-1">
                                <button class="btn btn-default" type="button" id="searchBtn">검색</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>견적 ID</th>
                                <th>작성자 ID</th>
                                <th>작성자 이름</th>
                                <th>작성일</th>
                                <th>답변 상태</th>
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
    const isAdmin = ${not empty sessionScope.loginAdminIndex};

    // --- [API 경로 설정] ---
    const API = {
        MEMBER: contextPath + "/api/quotation",
        ADMIN: contextPath + "/api/admin/quotation"
    };
    const READ_API_BASE = isAdmin ? API.ADMIN : API.MEMBER;

    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) { return null; }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    async function loadList(page = 1, type = '', keyword = '', qrequest_status = '') {
        const tbody = document.getElementById("quotationTbody");
        tbody.innerHTML = '<tr><td colspan="5" class="text-center">데이터를 불러오는 중입니다...</td></tr>';

        try {
            // qrequest_status 파라미터를 사용하여 API 호출
            const params = new URLSearchParams({
                pageNum: page,
                amount: 10,
                type,
                keyword,
                qrequest_status // 빈 문자열이라도 포함
            });// 빈 문자열일 경우 제외됨

            const listContextQuery = params.toString();

            const request = await axios.get(READ_API_BASE + "/request", { params });

            const { list, pageDTO } = request.data;

            tbody.innerHTML = "";

            if (!list || list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center">견적 신청 내역이 없습니다.</td></tr>';
                renderPagination(pageDTO, loadList, { type, keyword, qrequest_status });
                return;
            }

            list.forEach(item => {
                // 🚨 [수정] 상태값 반전 오류 수정: ANSWERED 일 때 완료 배지 출력
                const answeredBadge = item.qrequest_status === 'ANSWERED'
                    ? '<span class="badge bg-primary">답변 완료</span>'
                    : '<span class="badge bg-warning text-dark">대기중</span>';

                // DTO 필드: updated_at 사용
                const regDate = formatDateTime(item.updated_at);

                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";
                tr.onclick = () => {
                    // [경로 수정] 상세 페이지 이동 시 쿼리스트링 추가
                    location.href = contextPath + "/quotation/request/" + item.qrequest_index + '?' + listContextQuery;
                };

                // 🚨 [수정] DTO 필드명에 맞게 데이터 매핑
                tr.innerHTML =
                    '<td>' + item.qrequest_index + '</td>' +
                    '<td>' + item.user_index + '</td>' +
                    '<td>' + item.qrequest_name + '</td>' +
                    '<td>' + regDate + '</td>' +
                    '<td>' + answeredBadge + '</td>';
                tbody.appendChild(tr);
            });

            // [JS 렌더링]: 페이지네이션 생성
            renderPagination(pageDTO, loadList, { type, keyword, qrequest_status });

        } catch (error) {
            console.error("List loading failed:", error);
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>';
        }
    }

    /**
     * 페이지네이션 렌더링 함수
     */
    function renderPagination(pageDTO, loadFn, searchParams) {
        const paginationUl = document.getElementById("quotationPagination");
        paginationUl.innerHTML = "";

        // 🚨 [수정] cri 속성 체크 추가
        if (!pageDTO || !pageDTO.cri) return;

        let paginationHtml = '<ul class="pagination">';
        const { cri, startPage, endPage, prev, next } = pageDTO; // cri로 destructuring

        // '이전' 버튼
        if (prev) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (startPage - 1) + '">Previous</a></li>';
        }

        // 페이지 번호
        for (let i = startPage; i <= endPage; i++) {
            // 🚨 [수정] cri.pageNum 사용
            const activeClass = (cri.pageNum == i) ? 'active' : '';

            paginationHtml += '<li class="page-item ' + activeClass + '">' +
                '  <a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>';
        }

        // '다음' 버튼
        if (next) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (endPage + 1) + '">Next</a></li>';
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        // [연결]: 동적으로 생성된 페이지 번호에 클릭 이벤트 바인딩
        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;

                // [수정] 검색 조건 유지하며 페이지 이동
                loadFn(pageNum, searchParams.type, searchParams.keyword, searchParams.qrequest_status);
            });
        });
    }

    // 페이지 로드 시 초기 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        // [수정] 초기 검색 조건 읽기
        const form = document.getElementById("searchForm");
        const initialType = form.elements.type.value;
        const initialKeyword = form.elements.keyword.value;
        const initialStatus = document.getElementById("searchAnsweredStatus").value;

        loadList(1, initialType, initialKeyword, initialStatus);
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        const form = document.getElementById("searchForm");
        const type = form.elements.type.value;
        const keyword = form.elements.keyword.value;
        const status = document.getElementById("searchAnsweredStatus").value;
        loadList(1, type, keyword, status); // 검색 시 1페이지로
    });
</script>
<%@ include file="../includes/end.jsp" %>