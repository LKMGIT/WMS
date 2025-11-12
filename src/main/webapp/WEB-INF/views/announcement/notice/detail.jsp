<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
    <div class="container">
        <div class="page-inner">

            <h3 class="fw-bold mb-3">공지사항 상세</h3>

            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="card-title">${notice.nTitle}</h4>
                    <div>
                        <c:if test="${not empty sessionScope.loginAdminId}">
                            <a href="<c:url value='/notice/edit/${notice.noticeIndex}'/>" class="btn btn-warning btn-sm">수정</a>
                            <button class="btn btn-danger btn-sm" onclick="deleteNotice(${notice.noticeIndex})">삭제</button>
                        </c:if>
                        <a href="<c:url value='/anc/notices/list'/>" class="btn btn-secondary btn-sm">목록으로</a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="mb-3 text-muted">
                        작성일: <fmt:formatDate value="${notice.nCreateAt}" pattern="yyyy-MM-dd HH:mm"/> |
                        관리자: ${notice.adminIndex}
                    </div>
                    <div class="content-box p-3 border rounded">
                        ${notice.nContent}
                    </div>
                </div>
            </div>

            <script>
                function deleteNotice(index) {
                    if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                        fetch('/anc/admin/notices/' + index, {
                            method: 'DELETE',
                            headers: { 'Content-Type': 'application/json' }
                            // CSRF 토큰 처리가 필요할 수 있습니다.
                        })
                            .then(response => response.json())
                            .then(data => {
                                alert(data.message);
                                if (data.success) {
                                    window.location.href = '/anc/notices/list';
                                }
                            })
                            .catch(error => {
                                console.error('삭제 오류:', error);
                                alert('삭제 중 오류가 발생했습니다.');
                            });
                    }
                }
            </script>

        </div>
    </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>