<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* ... (스타일은 생략) ... */
</style>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <div class="page-header">
        <h3 class="fw-bold mb-3">1:1 문의 상세</h3>
        <ul class="breadcrumbs mb-3">
          <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
          <li class="separator"><i class="icon-arrow-right"></i></li>
          <li class="nav-item"><a href="<c:url value='/announcement/onetoone/list'/>">1:1 문의 관리</a></li>
          <li class="separator"><i class="icon-arrow-right"></i></li>
          <li class="nav-item">상세 보기</li>
        </ul>
      </div>

      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="card-title">${request.rTitle} <span class="badge bg-secondary">${request.rType}</span></h4>
          <div>
            <c:if test="${not empty sessionScope.loginAdminIndex}">
              <button class="btn btn-danger btn-sm" onclick="deleteRequest(${request.requestIndex})">문의글 삭제</button>
            </c:if>
            <a href="<c:url value='/announcement/onetoone/list'/>" class="btn btn-secondary btn-sm">목록으로</a>
          </div>
        </div>

        <div class="card-header-status">
          답변 상태:
          <span id="statusBadge"
                class="
                    <c:choose>
                        <c:when test="${request.rStatus eq 'ANSWERED'}">status-answered</c:when>
                        <c:otherwise>status-pending</c:otherwise>
                    </c:choose>
                "
          >
            ${request.rStatus eq 'ANSWERED' ? '답변 완료' : '답변 대기'}
          </span>
        </div>

        <div class="card-body">
          <div class="mb-3 text-muted">
            작성일: <fmt:formatDate value="${request.rCreateAt}" pattern="yyyy-MM-dd HH:mm"/> |
            작성자: 사용자 #${request.userIndex}
            <c:if test="${request.rStatus eq 'ANSWERED'}">
              |
              답변 관리자: 관리자 #${request.adminIndex}
              |
              답변일: <fmt:formatDate value="${request.rUpdateAt}" pattern="yyyy-MM-dd HH:mm"/>
            </c:if>
          </div>
          <div class="content-box p-3 border rounded mb-4">
            <h5>** 문의 내용 **</h5>
            ${request.rContent}
          </div>
        </div>
      </div>

      <c:if test="${not empty sessionScope.loginAdminIndex}">
        <div class="card">
          <div class="card-header"><h5 class="card-title">관리자 답변</h5></div>
          <div class="card-body">
            <div class="reply-box">
              <form id="replyForm">
                <input type="hidden" id="requestIndex" value="${request.requestIndex}">
                <div class="mb-3">
                  <textarea id="rResponse" name="rResponse" class="form-control reply-textarea" rows="8" placeholder="답변 내용을 입력하세요."
                            required>${request.rResponse}</textarea>
                </div>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                  <c:choose>
                    <c:when test="${request.rStatus eq 'ANSWERED'}">
                      <button type="submit" class="btn btn-warning"><i class="fas fa-edit"></i> 답변 수정</button>
                    </c:when>
                    <c:otherwise>
                      <button type="submit" class="btn btn-primary"><i class="fas fa-reply"></i> 답변 등록</button>
                    </c:otherwise>
                  </c:choose>
                </div>
              </form>
            </div>
          </div>
        </div>
      </c:if>

    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  var ctx = '${pageContext.request.contextPath}';
  var requestIndex = document.getElementById('requestIndex')?.value; // null일 수 있음

  // 1:1 문의글 삭제 (관리자 전용)
  function deleteRequest(index) {
    if (!confirm('이 1:1 문의글을 삭제하시겠습니까? (답변 여부와 관계없이 삭제됩니다)')) return;
    // [API 경로] /announcement/one-to-one/{request_index}
    var url = ctx + '/announcement/one-to-one/' + index;
    fetch(url, {
      method: 'DELETE',
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
            .then(res => res.json())
            .then(data => {
              if (data && data.success) {
                alert('1:1 문의글이 삭제되었습니다.');
                location.href = ctx + '/announcement/onetoone/list'; // 목록으로 이동
              } else {
                alert(data.message || '삭제에 실패했습니다.');
              }
            })
            .catch(err => {
              console.error('문의글 삭제 오류:', err);
              alert('삭제 중 오류가 발생했습니다.');
            });
  }

  // 1:1 문의 답변 등록/수정 (관리자 전용)
  var replyForm = document.getElementById('replyForm');
  if (replyForm) { // 폼이 존재할 때만(즉, 관리자일 때만) 이벤트 리스너 추가
    replyForm.addEventListener('submit', function(e) {
      e.preventDefault();

      var responseContent = document.getElementById('rResponse').value.trim();
      if (responseContent.length === 0) {
        alert('답변 내용을 입력하세요.');
        return;
      }

      // [API 경로] /announcement/one-to-one/{request_index}/reply
      var url = ctx + '/announcement/one-to-one/' + requestIndex + '/reply';
      var data = {
        response: responseContent
      };

      fetch(url, {
        method: 'PUT',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify(data)
      })
              .then(res => res.json())
              .then(result => {
                if (result && result.success) {
                  alert(result.message);
                  window.location.reload(); // 성공 시 페이지 새로고침하여 상태 변경 반영
                } else {
                  alert(result.message || '답변 저장에 실패했습니다.');
                }
              })
              .catch(err => {
                console.error('답변 저장 오류:', err);
                alert('답변 저장 중 오류가 발생했습니다.');
              });
    });
  }
</script>
<c:import url="/WEB-INF/views/includes/end.jsp"/>