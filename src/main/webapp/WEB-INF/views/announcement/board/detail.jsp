<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <h3 class="fw-bold mb-3">게시글 상세</h3>

      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="card-title">${board.bTitle} <span class="badge bg-secondary">${board.bType}</span></h4>
          <div>
            <c:if test="${not empty sessionScope.loginAdminIndex}">
              <button class="btn btn-danger btn-sm" onclick="deleteBoard(${board.boardIndex})">삭제</button>
            </c:if>
            <a href="<c:url value='/announcement/board/list'/>" class="btn btn-secondary btn-sm">목록으로</a>
          </div>
        </div>
        <div class="card-body">
          <div class="mb-3 text-muted">
            작성일: <fmt:formatDate value="${board.bCreateAt}" pattern="yyyy-MM-dd HH:mm"/> |
            조회수: ${board.bViews} | 작성자: ${board.userIndex}
          </div>
          <div class="content-box p-3 border rounded">
            ${board.bContent}
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header"><h5 class="card-title">댓글 (${fn:length(board.comments)})</h5></div>
        <div class="card-body">

          <ul class="list-group mb-4">
            <c:forEach items="${board.comments}" var="comment">
              <li class="list-group-item d-flex justify-content-between align-items-start">
                <div class="ms-2 me-auto">
                  <div class="fw-bold">
                    <c:choose>
                      <c:when test="${comment.adminIndex != null}">[관리자]</c:when>
                      <c:otherwise>[사용자 ${comment.userIndex}]</c:otherwise>
                    </c:choose>
                  </div>
                    ${comment.cContent}
                  <small class="text-muted ms-3"><fmt:formatDate value="${comment.cCreateAt}" pattern="yyyy-MM-dd HH:mm"/></small>
                </div>
                <c:if test="${not empty sessionScope.loginAdminIndex}">
                  <button class="btn btn-sm btn-danger" onclick="deleteComment(${comment.commentIndex})">삭제</button>
                </c:if>
              </li>
            </c:forEach>
          </ul>

          <c:if test="${not empty sessionScope.loginAdminIndex}">
            <form id="commentForm">
              <input type="hidden" name="boardIndex" value="${board.boardIndex}">
              <div class="d-flex">
                <textarea id="cContentInput" name="cContent" class="form-control me-2" rows="2" placeholder="댓글을 입력하세요."
                          required></textarea>
                <button type="submit" class="btn btn-primary" style="width: 100px;">등록</button>
              </div>
            </form>
          </c:if>
        </div>
      </div>

      <script>
        var ctx = '${pageContext.request.contextPath}';
        var boardIndex = ${board.boardIndex}; // 현재 게시글 인덱스

        // 게시글 삭제 (관리자 전용)
        function deleteBoard(index) {
          if (confirm('게시글을 삭제하시겠습니까?')) {
            var url = ctx + '/announcement/board/' + index;
            fetch(url, {
              method: 'DELETE',
              headers: { 'Accept': 'application/json' },
              credentials: 'same-origin'
            })
                    .then(res => res.json())
                    .then(data => {
                      if (data && data.success) {
                        alert('게시글이 삭제되었습니다.');
                        location.href = ctx + '/announcement/board/list'; // 목록으로 이동
                      } else {
                        alert(data.message || '게시글 삭제에 실패했습니다.');
                      }
                    })
                    .catch(err => {
                      console.error('게시글 삭제 오류:', err);
                      alert('게시글 삭제 중 오류가 발생했습니다.');
                    });
          }
        }

        // 댓글 삭제 (관리자 전용)
        function deleteComment(index) {
          if (confirm('댓글을 삭제하시겠습니까?')) {
            var url = ctx + '/announcement/board/comments/' + index;
            fetch(url, {
              method: 'DELETE',
              headers: { 'Accept': 'application/json' },
              credentials: 'same-origin'
            })
                    .then(res => res.json())
                    .then(data => {
                      if (data && data.success) {
                        alert('댓글이 삭제되었습니다.');
                        window.location.reload(); // 페이지 새로고침
                      } else {
                        alert(data.message || '댓글 삭제에 실패했습니다.');
                      }
                    })
                    .catch(err => {
                      console.error('댓글 삭제 오류:', err);
                      alert('댓글 삭제 중 오류가 발생했습니다.');
                    });
          }
        }

        // 댓글 등록 (관리자 전용)
        document.getElementById('commentForm')?.addEventListener('submit', function(e) {
          e.preventDefault();

          var content = document.getElementById('cContentInput').value.trim();
          if (content.length === 0) {
            alert('댓글 내용을 입력하세요.');
            return;
          }

          var url = ctx + '/announcement/board/' + boardIndex + '/comments';
          var data = {
            cContent: content
          };

          fetch(url, {
            method: 'POST',
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
                      alert('댓글이 등록되었습니다.');
                      window.location.reload(); // 페이지 새로고침
                    } else {
                      alert(result.message || '댓글 등록에 실패했습니다.');
                    }
                  })
                  .catch(err => {
                    console.error('댓글 등록 오류:', err);
                    alert('댓글 등록 중 오류가 발생했습니다.');
                  });
        });
      </script>

    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>