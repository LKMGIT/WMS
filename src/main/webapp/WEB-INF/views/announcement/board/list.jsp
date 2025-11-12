<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <h3 class="fw-bold mb-3">문의 게시판</h3>

      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h4 class="card-title">게시글 목록</h4>
          <%-- <a href="<c:url value='/board/register'/>" class="btn btn-primary btn-sm">글쓰기</a> --%>
        </div>
        <div class="card-body">
          <form action="<c:url value='/anc/board/list'/>" method="get" class="mb-4">
            <select name="type" class="form-control d-inline-block" style="width: 150px;">
              <option value="">전체 유형</option>
              <option value="입고관련">입고관련</option>
              <option value="배송관련">배송관련</option>
              <option value="시스템">시스템</option>
            </select>
            <input type="text" name="keyword" placeholder="제목 또는 내용 검색..." class="form-control d-inline-block" style="width: 250px;">
            <button type="submit" class="btn btn-info">검색</button>
          </form>

          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
              <tr>
                <th>번호</th>
                <th>유형</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
                <th>작성자</th>
              </tr>
              </thead>
              <tbody>
              <tr><td colspan="6" class="text-center">게시글 데이터를 불러올 위치</td></tr>
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