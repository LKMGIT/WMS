<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:21
  To change this template use File |
 Settings | File Templates.
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

                        <div id="modifyBtnGroup" class="ms-auto" style="display: none;">
                            <button class="btn btn-primary btn-round" data-bs-toggle="modal" data-bs-target="#editQuotationModal">

                                <i class="fa fa-pen"></i> 수정
                            </button>
                        </div>
                    </div>

                </div>
                <div class="card-body">
                    <div class="form-group">
                        <label>제목 (q_title)</label>
                        <input type="text" class="form-control"
                               id="detailQTitle" readonly>
                    </div>
                    <div class="form-group">
                        <label>작성자 (user_name)</label>
                        <input type="text" class="form-control" id="detailUserName" readonly>

                    </div>
                    <div class="form-group">
                        <label>작성일 (created_at)</label>
                        <input type="text" class="form-control" id="detailCreatedAt" readonly>

                    </div>
                    <div class="form-group">
                        <label>창고 유형 (q_type)</label>
                        <input type="text" class="form-control" id="detailQType" readonly>

                    </div>
                    <div class="form-group">
                        <label>예상 물동량 (q_volume)</label>
                        <input type="text" class="form-control" id="detailQVolume" readonly>
                    </div>

                    <div class="form-group">
                        <label>문의 내용 (q_content)</label>
                        <textarea class="form-control" id="detailQContent" rows="5" readonly></textarea>
                    </div>

                </div>
                <div class="card-action">
                    <a href="${contextPath}/quotation/requests" class="btn btn-secondary">목록으로</a>
                </div>
            </div>

            <div class="card">

                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">답변</h4>
                        <div id="answerBtnGroup" class="ms-auto" style="display: none;">

                            <button id="answerModalBtn" class="btn btn-secondary btn-round" data-bs-toggle="modal" data-bs-target="#answerModal">
                                답변 로딩 중...
                            </button>

                        </div>
                    </div>
                </div>
                <div id="answerBody" class="card-body" style="display: none;">
                    <div class="form-group">

                        <label>답변 제목 (qr_title)</label>
                        <input type="text" class="form-control" id="answerQrTitle" readonly>
                    </div>
                    <div class="form-group">
                        <label>답변
                            내용 (qr_content)</label>
                        <textarea class="form-control" id="answerQrContent" rows="3" readonly></textarea>
                    </div>
                    <div class="form-group">
                        <label>답변일 (created_at)</label>

                        <input type="text" class="form-control" id="answerCreatedAt" readonly>
                    </div>
                </div>
            </div>

            <div class="card">

                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">댓글</h4>
                        <div id="newCommentBtnGroup" class="ms-auto" style="display: none;">

                            <button class="btn btn-secondary btn-round" data-bs-toggle="modal" data-bs-target="#newCommentModal">
                                <i class="fa fa-comment"></i> 댓글 작성
                            </button>
                        </div>

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

<div class="modal fade" id="editQuotationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="editQuotationForm">
                <div class="modal-header">
                    <h5 class="modal-title">견적 신청 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>

                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="edit_q_title" class="form-label">제목 (q_title)</label>

                        <input type="text" class="form-control" id="edit_q_title" name="q_title" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit_q_type">창고 유형 (q_type)</label>

                        <select class="form-select" id="edit_q_type" name="q_type" required>
                            <option value="ROOM_TEMPERATURE">상온</option>
                            <option value="LOW_TEMPERATURE">저온</option>
                            <option value="BONDED">보세</option>

                            <option value="OTHER">기타</option>
                        </select>
                    </div>
                    <div class="mb-3">

                        <label for="edit_q_volume" class="form-label">예상 물동량 (q_volume)</label>
                        <input type="number" class="form-control" id="edit_q_volume" name="q_volume">
                    </div>
                    <div class="mb-3">

                        <label for="edit_q_content" class="form-label">내용 (q_content)</label>
                        <textarea class="form-control" id="edit_q_content" name="q_content" rows="5" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">

                    <button type="button" id="deleteQuotationBtn" class="btn btn-danger">삭제</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="updateQuotationBtn" class="btn btn-primary">수정</button>
                </div>
            </form>

        </div>
    </div>
</div>

<div class="modal fade" id="answerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="answerForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="answerModalTitle">답변</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="answer_qr_title" class="form-label">답변 제목 (qr_title)</label>

                        <input type="text" class="form-control" id="answer_qr_title" name="qr_title" required>
                    </div>
                    <div class="mb-3">
                        <label for="answer_qr_content" class="form-label">답변 내용 (qr_content)</label>

                        <textarea class="form-control" id="answer_qr_content" name="qr_content" rows="5" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="deleteAnswerBtn" class="btn btn-danger" style="display: none;">삭제</button>

                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="saveAnswerBtn" class="btn btn-primary">저장</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="newCommentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <form id="newCommentForm">
                <div class="modal-header">
                    <h5 class="modal-title">새 댓글 작성</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label for="new_qc_content" class="form-label">내용 (qc_content)</label>
                        <textarea class="form-control" id="new_qc_content" name="qc_content" rows="3" required></textarea>

                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="saveCommentBtn" class="btn btn-primary">저장</button>
                </div>

            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editCommentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="editCommentForm">
                <div class="modal-header">
                    <h5 class="modal-title">댓글 수정</h5>

                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="qc_index" id="edit_qc_index">
                    <div class="mb-3">

                        <label for="edit_qc_content" class="form-label">내용 (qc_content)</label>
                        <textarea class="form-control" id="edit_qc_content" name="qc_content" rows="3" required></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" id="deleteCommentBtn" class="btn btn-danger">삭제</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="button" id="updateCommentBtn" class="btn btn-primary">수정</button>
                </div>

            </form>
        </div>
    </div>
</div>


<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // --- JSTL 변수 (세션 정보) ---
    const contextPath = "${contextPath}";
    // UserDTO 참고
    const loginUserId = "${sessionScope.loginUser.id}";
    const loginUserType = "${sessionScope.loginUser.userType}";
    // 'ADMIN' or 'USER'

    // --- JS 전역 변수 ---
    let currentQuotationId = null;
    // q_index
    let currentAnswerId = null; // qr_index

    // --- [API 경로 설정] ---
    // [수정] 백틱(``) 대신 큰따옴표("") 사용
    const API = {
        // QuotationMemberController
        MEMBER: "${contextPath}/api/quotation",
        // QuotationAdminController
        ADMIN: "${contextPath}/api/admin/quotation"
    };
    // [권한 분기] '읽기' (GET) API 경로는 권한에 따라 분기
    const READ_API_BASE = loginUserType === 'ADMIN' ?
        API.ADMIN : API.MEMBER;

    // [권한 분기] '쓰기' (POST, PUT, DELETE) API 경로는 권한에 따라 분기
    const WRITE_API_BASE = loginUserType === 'ADMIN' ?
        API.ADMIN : API.MEMBER;


    // --- 부트스트랩 모달 인스턴스 (JS로 제어) ---
    const editQuotationModal = new bootstrap.Modal(document.getElementById('editQuotationModal'));
    const answerModal = new bootstrap.Modal(document.getElementById('answerModal'));
    const newCommentModal = new bootstrap.Modal(document.getElementById('newCommentModal'));
    const editCommentModal = new bootstrap.Modal(document.getElementById('editCommentModal'));
    // --- (공통) 폼 데이터 -> JS Object 변환 함수 ---
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => { data[key] = value; });
        return data;
    }

    // --- [핵심] 페이지 로드 시 모든 데이터 로드 ---
    document.addEventListener("DOMContentLoaded", function() {
        // [경로 수정] OutboundViewController.java의 경로 변수명(qrequest_index)을 사용해야 함
        // 이 페이지는 /quotation/request/{qrequest_index}로 열립니다.
        // URL에서 ID를 추출 (JSP는 URL의 {qrequest_index} 값을 직접 알 수 없음)
        const pathSegments = window.location.pathname.split('/');
        const id = pathSegments[pathSegments.length - 1];

        if (!id ||
            isNaN(id)) {
            alert("잘못된 접근입니다. (견적 ID 없음)");
            // [수정] 백틱(``) 대신 큰따옴표("") 사용
            location.href = "${contextPath}/quotation/requests";
            return;
        }

        currentQuotationId = id;
        loadPageData(id);
    });
    /**
     * 페이지에 필요한 견적 상세, 답변 정보를 병렬로 로드합니다.
     * @param {string} id - 견적 ID (q_index)
     */
    async function loadPageData(id) {
        try {
            // [API 경로 수정]: 컨트롤러 경로(/request/{id}) 반영
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const quotationPromise = axios.get(READ_API_BASE + "/request/" + id);
            // [API 경로 수정]: 컨트롤러 경로(/response/{id}) 반영
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const answerPromise = axios.get(READ_API_BASE + "/response/" + id).catch(e => null);
            // 답변 없으면 null

            // --- 모든 요청이 완료될 때까지 대기 ---
            const [quotationRes, answerRes] = await Promise.all([quotationPromise, answerPromise]);
            // --- 1. 상세 정보 렌더링 (DTO 속성 반영) ---
            const quotation = quotationRes.data;
            // QuotationDetailDTO
            document.getElementById("detailQIndex").textContent = quotation.q_index;
            document.getElementById("detailQTitle").value = quotation.q_title;
            document.getElementById("detailUserName").value = quotation.user_name;
            document.getElementById("detailCreatedAt").value = new Date(quotation.created_at).toLocaleString("ko-KR");
            document.getElementById("detailQType").value = quotation.q_type;
            document.getElementById("detailQVolume").value = quotation.q_volume + " CBM";
            document.getElementById("detailQContent").value = quotation.q_content;
            // --- 2. 답변 정보 렌더링 (DTO 속성 반영) ---
            const answer = answerRes ?
                answerRes.data : null; // QuotationResponseDTO
            if (answer) {
                currentAnswerId = answer.qr_index;
                // DTO 속성: qr_index
                document.getElementById("answerQrTitle").value = answer.qr_title;
                document.getElementById("answerQrContent").value = answer.qr_content;
                document.getElementById("answerCreatedAt").value = new Date(answer.created_at).toLocaleString("ko-KR");
                document.getElementById("answerBody").style.display = "block";
            }

            // --- 3. 댓글 목록 로드 ---
            // [API 경로 수정] 컨트롤러 경로(/comment/{id}) 반영
            loadComments(id, 1);
            // --- 4. 권한에 따른 버튼/폼 렌더링 ---
            renderDynamicUI(quotation, answer);
            // --- 5. 모달 폼 이벤트 바인딩 ---
            bindModalEvents();
        } catch (error) {
            console.error("Page loading failed:", error);
            alert("데이터를 불러오는 데 실패했습니다. 목록으로 돌아갑니다.");
            // [수정] 백틱(``) 대신 큰따옴표("") 사용
            location.href = "${contextPath}/quotation/requests";
        }
    }

    /**
     * 권한과 데이터 상태에 따라 동적 UI (버튼, 모달 폼) 렌더링
     * @param {object} quotation - 견적 상세 정보
     * @param {object} answer - 답변 정보 (있거나 null)
     */
    function renderDynamicUI(quotation, answer) {
        // 1. 견적 수정 버튼 (관리자 또는 본인) [DTO 속성: user_index]
        if (loginUserType === 'ADMIN' ||
            loginUserId === String(quotation.user_index)) {
            document.getElementById("modifyBtnGroup").style.display = "block";
            // [DTO 반영] 수정 모달 내부 폼에도 값 미리 채우기
            document.getElementById("edit_q_title").value = quotation.q_title;
            document.getElementById("edit_q_type").value = quotation.q_type;
            document.getElementById("edit_q_volume").value = quotation.q_volume;
            document.getElementById("edit_q_content").value = quotation.q_content;
        }

        // 2. 관리자 답변 버튼 (관리자만)
        if (loginUserType === 'ADMIN') {
            document.getElementById("answerBtnGroup").style.display = "block";
            const answerModalBtn = document.getElementById("answerModalBtn");
            const answerFormTitle = document.getElementById("answer_qr_title");
            const answerFormContent = document.getElementById("answer_qr_content");
            const deleteAnswerBtn = document.getElementById("deleteAnswerBtn");
            const answerModalTitle = document.getElementById("answerModalTitle");
            if (answer) {
                // 답변 수정
                answerModalBtn.textContent = "답변 수정";
                answerModalTitle.textContent = "답변 수정";
                answerFormTitle.value = answer.qr_title; // DTO 속성: qr_title
                answerFormContent.value = answer.qr_content;
                // DTO 속성: qr_content
                deleteAnswerBtn.style.display = "inline-block";
                // 삭제 버튼 표시
            } else {
                // 답변 등록
                answerModalBtn.textContent = "답변 등록";
                answerModalTitle.textContent = "답변 등록";
                deleteAnswerBtn.style.display = "none"; // 삭제 버튼 숨김
            }
        }

        // 3. 댓글 작성 버튼 (로그인한 모든 사용자)
        if (loginUserId) {
            document.getElementById("newCommentBtnGroup").style.display = "block";
        }
    }

    /**
     * [신규] LocalDateTime 배열을 JavaScript Date 객체로 변환
     * @param {array} arr (예: [2025, 11, 11, 12, 58, 30])
     * @returns {Date}
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) {
            return new Date();
            // 기본값 또는 에러 처리
        }
        // new Date(year, monthIndex(0-11), day, hours, minutes, seconds)
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 댓글 목록 로드 및 렌더링
     * @param {string} quotationId - 견적 ID (q_index)
     * @param {number} page - 페이지 번호
     */
    async function loadComments(quotationId, page) {
        const commentListGroup = document.getElementById("commentListGroup");
        try {
            // [API 경로 수정]: 컨트롤러 경로(/comment/{id}) 반영
            const params = new URLSearchParams({ page, amount: 5 });
            // 댓글 5개씩
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const response = await axios.get(READ_API_BASE + "/comment/" + quotationId, { params });
            const { list, pageDTO } = response.data; // API 응답: { list: [QuotationCommentDTO, ...], pageDTO: {...} }

            commentListGroup.innerHTML = "";
            // 목록 초기화

            if (list && list.length > 0) {
                const listUl = document.createElement("ul");
                listUl.className = "list-group list-group-flush";

                list.forEach(comment => { // [DTO 반영] QuotationCommentDTO
                    const li = document.createElement("li");
                    li.className = "list-group-item d-flex justify-content-between align-items-start";

                    let editBtnHtml = "";

                    // [권한] 관리자이거나 본인 댓글일 경우 (DTO 속성: user_index)
                    if (loginUserType === 'ADMIN' || loginUserId === String(comment.user_index)) {
                        // (JS 변수만 있으므로 백틱 유지)
                        editBtnHtml = `
                            <button class="btn btn-sm btn-link edit-comment-btn"

                                 data-comment-id="${comment.qc_index}"
                                    data-comment-content="${comment.qc_content}">
                                수정

                             </button>
                        `;
                    }

                    // [수정] 날짜 포맷팅: parseLocalDateTime 함수 사용

                    // DTO 속성: created_at
                    const regDate = parseLocalDateTime(comment.created_at).toLocaleString("ko-KR");
                    // DTO 속성: qc_writer, qc_content
                    // (JS 변수만 있으므로 백틱 유지)
                    li.innerHTML = `
                        <div class="ms-2 me-auto">
                            <div class="fw-bold">${comment.qc_writer}</div>

           <p class="mb-0" style="white-space: pre-wrap;">${comment.qc_content}</p>
                            <small class="text-muted">${regDate}</small>
                        </div>
                        ${editBtnHtml}

           `;
                    listUl.appendChild(li);
                });
                commentListGroup.appendChild(listUl);
                // [연결] 동적으로 생성된 '수정' 버튼에 모달 열기 이벤트 바인딩
                document.querySelectorAll(".edit-comment-btn").forEach(btn => {
                    btn.addEventListener("click", function() {
                        // [DTO 반영] DTO 속성: qc_index, qc_content

                        document.getElementById("edit_qc_index").value = this.dataset.commentId;
                        document.getElementById("edit_qc_content").value = this.dataset.commentContent;
                        editCommentModal.show();
                    });
                });
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

    /**
     * 댓글용 페이지네이션 렌더링 함수
     * @param {object} pageDTO - 페이지 정보
     * @param {function} loadFn - 페이지 클릭 시 호출할 함수 (loadComments)
     */
    function renderCommentPagination(pageDTO, loadFn) {
        const paginationUl = document.getElementById("commentPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO || pageDTO.total <= pageDTO.criteria.amount) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;
        if (prev) {
            // (JS 변수만 있으므로 백틱 유지)
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${startPage - 1}">Previous</a></li>`;
        }
        for (let i = startPage; i <= endPage; i++) {
            // (JS 변수만 있으므로 백틱 유지)
            paginationHtml += `
                <li class="page-item ${criteria.pageNum == i ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>

             `;
        }
        if (next) {
            // (JS 변수만 있으므로 백틱 유지)
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${endPage + 1}">Next</a></li>`;
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

    /**
     * [AXIOS] 모든 모달 내부 버튼에 이벤트 리스너 바인딩
     */
    function bindModalEvents() {

        // --- 1. 견적 수정/삭제 ---
        document.getElementById("updateQuotationBtn").addEventListener("click", function() {
            const data = getFormData("editQuotationForm");

            // [API 경로 수정]: WRITE_API_BASE + /request/{id}
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.put(WRITE_API_BASE + "/request/" + currentQuotationId, data,
                { headers: { 'Content-Type': 'application/json' } })
                .then(response => {
                    alert("견적이 수정되었습니다.");
                    location.reload(); // 페이지 새로고침
                })

                .catch(error => alert("수정 실패: " + (error.response?.data?.message || "서버 오류")));
        });
        document.getElementById("deleteQuotationBtn").addEventListener("click", function() {
            if (!confirm("정말로 이 견적을 삭제하시겠습니까? 답변과 댓글도 모두 삭제됩니다.")) return;

            // [API 경로 수정]: WRITE_API_BASE + /request/{id}
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.delete(WRITE_API_BASE + "/request/" + currentQuotationId)
                .then(response => {
                    alert("삭제되었습니다.");

                    // [수정] 백틱(``) 대신 큰따옴표("") 사용
                    location.href = "${contextPath}/quotation/requests"; // 목록 페이지로 이동
                })
                .catch(error => alert("삭제 실패: " + (error.response?.data?.message || "서버 오류")));
        });
        // --- 2. 답변 등록/수정/삭제 (Admin 전용이므로 API.ADMIN 사용) ---
        const ADMIN_API_BASE = API.ADMIN;
        // 답변 관련은 무조건 Admin API

        document.getElementById("saveAnswerBtn").addEventListener("click", function() {
            const data = getFormData("answerForm");
            // [DTO 반영] QuotationResponseDTO에는 q_index가 필요함
            data.q_index = currentQuotationId;
            data.admin_index = loginUserId; // (임시 - 세션의 admin ID 사용 필요)

            // currentAnswerId가 있으면 수정(PUT), 없으면
            등록(POST)
            // [API 경로 수정]: /response
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            const request = currentAnswerId
                ? axios.put(ADMIN_API_BASE + "/response/" + currentAnswerId, data, { headers: { 'Content-Type': 'application/json' } })
                : axios.post(ADMIN_API_BASE + "/response", data, { headers: { 'Content-Type': 'application/json' } });

            request.then(response => {

                alert("답변이 처리되었습니다.");
                location.reload(); // 페이지 새로고침
            })
                .catch(error => alert("답변 처리 실패: " + (error.response?.data?.message || "서버 오류")));
        });
        document.getElementById("deleteAnswerBtn").addEventListener("click", function() {
            if (!confirm("답변을 삭제하시겠습니까?")) return;

            // [API 경로 수정]: /response/{id}
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.delete(ADMIN_API_BASE + "/response/" + currentAnswerId)
                .then(response => {
                    alert("답변이 삭제되었습니다.");

                    location.reload(); // 페이지 새로고침
                })
                .catch(error => alert("답변 삭제 실패: " + (error.response?.data?.message || "서버 오류")));
        });
        // --- 3. 댓글 등록 (Member/Admin 공용 WRITE_API_BASE 사용) ---
        document.getElementById("saveCommentBtn").addEventListener("click", function() {
            const data = getFormData("newCommentForm");
            if (!data.qc_content) {
                alert("댓글 내용을 입력하세요.");
                return;
            }


            // [DTO 반영] QuotationCommentDTO 속성 추가
            data.q_index = currentQuotationId;
            data.user_index = loginUserId;
            // data.qc_writer = ... (세션의 사용자 이름)

            // [API 경로 수정]: /comment
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.post(WRITE_API_BASE + "/comment", data, {

                headers: { 'Content-Type': 'application/json' }
            })
                .then(response => {
                    document.getElementById("newCommentForm").reset();
                    newCommentModal.hide();
                    loadComments(currentQuotationId, 1); //
                })
                .catch(error => alert("댓글 등록 실패: " + (error.response?.data?.message ||
                    "서버 오류")));
        });

        // --- 4. 댓글 수정/삭제 (Member/Admin 공용 WRITE_API_BASE 사용) ---
        document.getElementById("updateCommentBtn").addEventListener("click", function() {
            const data = getFormData("editCommentForm"); // qc_index(id), qc_content 포함

            // [API 경로 수정]: /comment/{id}
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.put(WRITE_API_BASE + "/comment/" + data.qc_index, data, {
                headers: { 'Content-Type': 'application/json' }

            })
                .then(response => {
                    editCommentModal.hide();
                    loadComments(currentQuotationId, 1);
                })
                .catch(error => alert("댓글 수정 실패"));

        });

        document.getElementById("deleteCommentBtn").addEventListener("click", function() {
            if (!confirm("댓글을 삭제하시겠습니까?")) return;

            const commentId = document.getElementById("edit_qc_index").value;
            // [API 경로 수정]: /comment/{id}
            // [수정] 백틱(``) 대신 문자열 연결(+) 사용
            axios.delete(WRITE_API_BASE + "/comment/" + commentId)
                .then(response => {

                    editCommentModal.hide();
                    loadComments(currentQuotationId, 1);
                })
                .catch(error => alert("댓글 삭제 실패"));
        });
    }

</script>
<%@ include file="../includes/end.jsp" %>