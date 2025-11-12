<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <h3 class="fw-bold mb-3">게시글 상세</h3>

      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="card-title">${board.bTitle} <span class="badge bg-secondary">${board.bType}</span></h4>
          <div>
            <c:if test="${not empty sessionScope.loginAdminId}">
              <button class="btn btn-danger btn-sm" onclick="deleteBoard(${board.boardIndex})">삭제</button>
            </c:if>
            <a href="<c:url value='/anc/board/list'/>" class="btn btn-secondary btn-sm">목록으로</a>
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
                <c:if test="${not empty sessionScope.loginAdminId}">
                  <button class="btn btn-sm btn-danger" onclick="deleteComment(${comment.commentIndex})">삭제</button>
                </c:if>
              </li>
            </c:forEach>
          </ul>

          <c:if test="${not empty sessionScope.loginAdminId}">
            <form id="commentForm">
              <input type="hidden" name="boardIndex" value="${board.boardIndex}">
              <div class="d-flex">
                <textarea name="cContent" class="form-control me-2" rows="2" placeholder="댓글을 입력하세요." required></textarea>
                <button type="submit" class="btn btn-primary" style="width: 100px;">등록</button>
              </div>
            </form>
          </c:if>
        </div>
      </div>

      <script>
        // 게시글 삭제 (관리자 전용)
        function deleteBoard(index) {
          if (confirm('게시글을 삭제하시겠습니까?')) {
            // ... /anc/admin/board/{board_index} API 호출 로직 ...
          }
        }

        // 댓글 삭제 (관리자 전용)
        function deleteComment(index) {
          if (confirm('댓글을 삭제하시겠습니까?')) {
            // ... /anc/admin/board/comments/{comment_index} API 호출 로직 ...
          }
        }

        // 댓글 등록 (관리자 전용)
        document.getElementById('commentForm')?.addEventListener('submit', function(e) {
          e.preventDefault();
          // ... /anc/admin/board/{board_index}/comments API 호출 로직 ...
        });
      </script>

    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>