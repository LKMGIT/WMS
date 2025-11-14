<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
    /* ... (스타일은 생략) ... */
    .content-box {
        min-height: 200px;
        line-height: 1.6;
        white-space: pre-wrap; /* 내용의 줄바꿈을 유지 */
    }
</style>

<div class="main-panel">
    <div class="container">
        <div class="page-inner">

            <div class="page-header">
                <h3 class="fw-bold mb-3">공지사항 상세</h3>
                <ul class="breadcrumbs mb-3">
                    <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
                    <li class="separator"><i class="icon-arrow-right"></i></li>
                    <li class="nav-item"><a href="<c:url value='/announcement/notice/list'/>">공지사항 관리</a></li>
                    <li class="separator"><i class="icon-arrow-right"></i></li>
                    <li class="nav-item">상세 보기</li>
                </ul>
            </div>

            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="card-title">${notice.nTitle}</h4>
                    <div>
                        <c:if test="${not empty sessionScope.loginAdminIndex}">
                            <button class="btn btn-warning btn-sm me-2" onclick="goToEdit(${notice.noticeIndex})"><i class="fas fa-edit"></i> 수정</button>
                            <button class="btn btn-danger btn-sm" onclick="deleteNotice(${notice.noticeIndex})"><i class="fas fa-trash"></i> 삭제</button>
                        </c:if>
                        <a href="<c:url value='/announcement/notice/list'/>" class="btn btn-secondary btn-sm">목록으로</a>
                    </div>
                </div>

                <div class="card-header-priority">
                    중요도:
                    <span class="${notice.nPriority eq 1 ? 'priority-important' : 'priority-normal'}">
                        ${notice.nPriority eq 1 ? '⭐ 중요 공지' : '📋 일반 공지'}
                    </span>
                </div>

                <div class="card-body">
                    <div class="mb-3 text-muted">
                        작성일: <fmt:formatDate value="${notice.nCreateAt}" pattern="yyyy-MM-dd HH:mm"/> |
                        수정일: <fmt:formatDate value="${notice.nUpdateAt}" pattern="yyyy-MM-dd HH:mm"/> |
                        작성 관리자: #${notice.adminIndex}
                    </div>
                    <div class="content-box p-3 border rounded">
                        ${notice.nContent}
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
    var ctx = '${pageContext.request.contextPath}';
    var noticeIndex = ${notice.noticeIndex};

    // 공지사항 수정 화면으로 이동 (관리자)
    function goToEdit(index) {
        location.href = ctx + '/announcement/notice/form?noticeIndex=' + index;
    }

    // 공지사항 삭제 (관리자 전용)
    function deleteNotice(index) {
        if (!confirm('이 공지사항을 삭제하시겠습니까?')) return;
        var url = ctx + '/announcement/notice/' + index;
        fetch(url, {
            method: 'DELETE',
            headers: { 'Accept': 'application/json' },
            credentials: 'same-origin'
        })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    alert('공지사항이 삭제되었습니다.');
                    location.href = ctx + '/announcement/notice/list'; // 목록으로 이동
                } else {
                    alert(data.message || '삭제에 실패했습니다.');
                }
            })
            .catch(err => {
                console.error('공지사항 삭제 오류:', err);
                alert('삭제 중 오류가 발생했습니다.');
            });
    }
</script>
<c:import url="/WEB-INF/views/includes/end.jsp"/>