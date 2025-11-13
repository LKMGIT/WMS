<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:21
  순수 상세 조회 전용 (액션 버튼 및 모달 제거)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%-- [중요] 뷰 컨트롤러가 Model에 "q_index"를 전달해야 함 --%>
<c:set var="qrequest_index" value="${qrequest_index}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">견적 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a id="listBreadcrumb" href="${contextPath}/quotation/requests">견적 리스트</a></li>

            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">견적신청 상세</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">견적신청 상세 (견적 ID: <span id="detailQIndex">...</span>)</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label>작성자 ID</label>
                        <input type="text" class="form-control" id="detailUserIndex" readonly>
                    </div>
                    <div class="form-group">
                        <label>작성자 이름</label>
                        <input type="text" class="form-control" id="detailQrName" readonly>
                    </div>
                    <div class="form-group">
                        <label>작성일</label>
                        <input type="text" class="form-control" id="detailUpdatedAt" readonly>
                    </div>
                    <div class="form-group">
                        <label>문의 내용</label>
                        <textarea class="form-control" id="detailQContent" rows="5" readonly></textarea>
                    </div>
                    <input type="hidden" class="form-control" id="detailQrequestStatus" readonly>
                </div>
                <div class="card-action d-flex justify-content-between">
                    <a href="${contextPath}/quotation/requests" class="btn btn-secondary">목록으로</a>
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

            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">답변</h4>
                    </div>
                </div>
                <div id="answerBody" class="card-body d-none">
                    <input type="hidden" class="form-control" id="answerQresponseIndex" readonly>
                    <div class="form-group">
                        <label>관리자 ID</label>
                        <input type="text" class="form-control" id="answerAdminIndex" readonly>
                    </div>
                    <div class="form-group">
                        <label>답변 내용</label>
                        <textarea class="form-control" id="answerQrContent" rows="3" readonly></textarea>
                    </div>
                    <div class="form-group">
                        <label>답변일</label>
                        <input type="text" class="form-control" id="answerRespondedAt" readonly>
                    </div>
                </div>
            </div>

            <%-- 댓글 영역 --%>
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">댓글</h4>
                    </div>
                </div>
                <div class="card-body">
                    <div id="commentListGroup">
                        <p class="text-center">댓글을 불러오는 중입니다...</p>
                    </div>
                    <div id="commentPagination" class="mt-3 d-flex justify-content-center">
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
    const isAdmin = "${not empty sessionScope.loginAdminrIndex}";
    const loginUserId = "${sessionScope.loginUserIndex}";

    // --- JS 전역 변수 ---
    let currentQuotationId = null; // q_index
    let currentListContext = null; // 목록 복귀 시 사용할 쿼리스트링

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

    document.addEventListener("DOMContentLoaded", function() {
        const id = "${qrequest_index}";
        currentListContext = window.location.search;

        if (!id || isNaN(id)) {
            alert("잘못된 접근입니다. (견적 ID 없음)");
            location.href = contextPath + "/quotation/requests";
            return;
        }

        currentQuotationId = id;

        const backToListBtn = document.getElementById("backToListBtn");
        const listBreadcrumb = document.getElementById("listBreadcrumb");
        if (backToListBtn) {
            backToListBtn.href = contextPath + "/quotation/requests" + currentListContext;
        }
        if (listBreadcrumb) {
            listBreadcrumb.href = contextPath + "/quotation/requests" + currentListContext;
        }
        loadPageData(id);
    });

    /**
     * 페이지에 필요한 견적 상세, 답변 정보를 병렬로 로드합니다.
     * @param {string} id - 견적 ID (q_index)
     */
    async function loadPageData(id) {
        try {
            const listContextQuery = currentListContext;

            const quotationPromise = axios.get(READ_API_BASE + "/request/" + id + listContextQuery);

            const [quotationRes] = await Promise.all([quotationPromise]);

            const quotation = quotationRes.data;
            const prevId = quotation.previousPostIndex;
            const nextId = quotation.nextPostIndex;

            document.getElementById("detailQIndex").textContent = quotation.qrequest_index;
            document.getElementById("detailUserIndex").value = quotation.user_index || 'N/A';
            document.getElementById("detailQrName").value = quotation.qrequest_name;
            document.getElementById("detailUpdatedAt").value = formatDateTime(quotation.updated_at);
            document.getElementById("detailQrequestStatus").value = quotation.qrequest_status;
            document.getElementById("detailQContent").value = quotation.qrequest_detail;

            if (quotation.qrequest_status === 'ANSWERED') {
                document.getElementById("answerQresponseIndex").value = quotation.qresponse_index;
                document.getElementById("answerAdminIndex").value = quotation.admin_index;
                document.getElementById("answerQrContent").value = quotation.qresponse_detail;
                document.getElementById("answerRespondedAt").value = formatDateTime(quotation.responded_at);
                document.getElementById("answerBody").classList.remove("d-none");
            }

            renderPrevNext(prevId, nextId, listContextQuery);
            loadComments(id, 1);
        } catch (error) {
            console.error("Page loading failed:", error);
            alert("데이터를 불러오는 데 실패했습니다. 목록으로 돌아갑니다.");
            location.href = contextPath + "/quotation/requests";
        }
    }

    /**
     * 댓글 목록 로드 및 렌더링
     * @param {string} quotationId - 견적 ID (q_index)
     * @param {number} page - 페이지 번호
     */
    async function loadComments(quotationId, pageNum) {
        const commentListGroup = document.getElementById("commentListGroup");
        try {
            const params = new URLSearchParams({ pageNum, amount: 5 });
            const response = await axios.get(READ_API_BASE + "/comment/" + quotationId, { params });
            const { list, pageDTO } = response.data;

            commentListGroup.innerHTML = ""; // 목록 초기화

            if (list && list.length > 0) {
                const listUl = document.createElement("ul");
                listUl.className = "list-group list-group-flush";

                list.forEach(comment => { // QuotationCommentDTO
                    const li = document.createElement("li");
                    li.className = "list-group-item d-flex justify-content-between align-items-start";

                    // [수정] 날짜 포맷팅: formatDateTime 함수 사용
                    const regDate = formatDateTime(comment.updated_at);

                    // [수정] 문자열 연결(+)을 사용하여 li.innerHTML 생성
                    li.innerHTML =
                        '<div class="ms-2 me-auto">' +
                        '  <div class="fw-bold">' + comment.writer_type + '</div>' +
                        '  <p class="mb-0" style="white-space: pre-wrap;">' + comment.qcomment_detail + '</p>' +
                        '  <small class="text-muted">' + regDate + '</small>' +
                        '</div>';
                    // 🚨 [제거] 수정 버튼 제거
                    listUl.appendChild(li);
                });
                commentListGroup.appendChild(listUl);

            } else {
                commentListGroup.innerHTML = "<p class='text-center text-muted'>작성된 댓글이 없습니다.</p>";
            }

            // [JS 렌더링]: 댓글 페이지네이션
            renderCommentPagination(pageDTO, loadComments);
        } catch (error) {
            console.error("Comments loading failed:", error);
            commentListGroup.innerHTML = "<p class='text-center text-danger'>댓글 로딩 중 오류가 발생했습니다.</p>";
        }
    }

    function renderPrevNext(prevId, nextId, listContextQuery) {
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        if (prevId) {
            prevBtn.href = contextPath + "/quotation/request/" + prevId + listContextQuery;
            prevBtn.classList.remove("disabled");
        } else {
            prevBtn.href = "#";
            prevBtn.classList.add("disabled");
        }

        if (nextId) {
            nextBtn.href = contextPath + "/quotation/request/" + nextId + listContextQuery;
            nextBtn.classList.remove("disabled");
        } else {
            nextBtn.href = "#";
            nextBtn.classList.add("disabled");
        }
    }

    /**
     * 댓글용 페이지네이션 렌더링 함수
     */
    function renderCommentPagination(pageDTO, loadFn) {
        const paginationUl = document.getElementById("commentPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO || pageDTO.total <= pageDTO.cri.amount) return;

        let paginationHtml = '<ul class="pagination">';
        const { cri, startPage, endPage, prev, next } = pageDTO;

        if (prev) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (startPage - 1) + '">Previous</a></li>';
        }
        for (let i = startPage; i <= endPage; i++) {
            const activeClass = (cri.pageNum == i) ? 'active' : '';

            paginationHtml += '<li class="page-item ' + activeClass + '">' +
                '  <a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>';
        }
        if (next) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (endPage + 1) + '">Next</a></li>';
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        // [연결]: 페이지 번호 클릭 이벤트
        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;
                loadFn(currentQuotationId, pageNum);
            });
        });
    }

    // 🚨 [제거] bindModalEvents 함수 제거
</script>
<%@ include file="../includes/end.jsp" %>