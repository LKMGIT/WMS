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

            <li classs="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/qoutation/request/register">견적 신청</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <form id="registerForm">
                    <input type="hidden" name="user_index" value="${sessionScope.loginUser.id}" />


                    <div class="card-header">
                        <div class="card-title">견적신청 등록</div>
                    </div>
                    <div class="card-body">

                        <div class="form-group">
                            <label for="q_title">제목</label>
                            <input type="text" class="form-control" id="q_title" name="q_title" placeholder="제목을 입력하세요" required>
                        </div>

                        <div class="form-group">
                            <label for="q_type">창고 유형</label>
                            <select class="form-select" id="q_type" name="q_type" required>

                                <option value="">유형을 선택하세요</option>
                                <option value="ROOM_TEMPERATURE">상온</option>
                                <option value="LOW_TEMPERATURE">저온</option>

                                <option value="BONDED">보세</option>
                                <option value="OTHER">기타</option>
                            </select>

                        </div>
                        <div class="form-group">
                            <label for="q_volume">예상 물동량 (CBM)</label>
                            <input type="number" class="form-control" id="q_volume" name="q_volume" placeholder="예상 물동량을 CBM 단위로 입력하세요">

                        </div>
                        <div class="form-group">
                            <label for="q_content">문의 내용</label>

                            <textarea class="form-control" id="q_content" name="q_content" rows="5" placeholder="문의하실 내용을 입력하세요" required></textarea>
                        </div>
                    </div>
                    <div class="card-action">

                        <button type="button" id="registerBtn" class="btn btn-primary">저장</button>
                        <a href="${contextPath}/quotation/requests" class="btn btn-danger">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>

    const contextPath = "${contextPath}";

    // [단순화] MEMBER API 경로만 정의 (USER 전용 페이지)
    // [수정] 백틱(``) 대신 큰따옴표("") 사용
    const API_BASE = "${contextPath}/api/quotation";
    /**
     * 폼 데이터를 JS Object로 변환
     * @param {string} formId
     * @returns {object}
     */
    function getFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        const data = {};
        formData.forEach((value, key) => {
            data[key] = value;
        });
        return data;
    }

    // 저장 버튼 클릭 이벤트
    document.getElementById("registerBtn").addEventListener("click", function() {
        // [DTO 반영] QuotationRequestDTO
        const data = getFormData("registerForm");

        // 유효성 검사
        if (!data.q_title || !data.q_content || !data.q_type) {
            alert("제목, 창고 유형, 문의 내용은 필수입니다.");
            return;
        }


        // [AXIOS]: RestController로 POST 전송 (MEMBER API 사용)
        // [API 경로 수정] /request 추가
        // [수정] 백틱(``) 대신 문자열 연결(+) 사용
        axios.post(API_BASE + "/request", data, {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(response => {
                alert("견적 신청이 등록되었습니다.");

                // [경로 수정]: 목록 페이지로 이동
                // [수정] 백틱(``) 대신 큰따옴표("") 사용
                location.href = "${contextPath}/quotation/requests";
            })
            .catch(error => {
                console.error("Registration failed:", error);
                alert("등록 실패: " + (error.response?.data?.message || "서버 오류"));

            });
    });
</script>
<%@ include file="../includes/end.jsp" %>