<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <h3 class="fw-bold mb-3">공지사항 목록</h3>

      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="card-title">공지 목록</h4>
          <c:if test="${not empty sessionScope.loginAdminId}">
            <a href="<c:url value='/notice/register'/>" class="btn btn-primary btn-sm">
              <i class="fa fa-plus"></i> 공지 등록
            </a>
          </c:if>
        </div>
        <div class="card-body">
          <form action="<c:url value='/anc/notices/list'/>" method="get" class="mb-4">
            <input type="text" name="keyword" placeholder="제목 또는 내용 검색..." class="form-control d-inline-block" style="width: 300px;">
            <button type="submit" class="btn btn-info">검색</button>
          </form>

          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
              <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성일</th>
                <th>관리자</th>
              </tr>
              </thead>
              <tbody>
              <tr><td colspan="4" class="text-center">공지사항 데이터를 불러올 위치</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>