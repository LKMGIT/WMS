<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <h3 class="fw-bold mb-3">1:1 문의 관리 (관리자)</h3>

      <div class="card">
        <div class="card-header"><h4 class="card-title">전체 문의 목록</h4></div>
        <div class="card-body">
          <form action="<c:url value='/anc/admin/one-to-one'/>" method="get" class="mb-4">
            <select name="status" class="form-control d-inline-block" style="width: 150px;">
              <option value="">전체 상태</option>
              <option value="PENDING">답변 대기</option>
              <option value="ANSWERED">답변 완료</option>
            </select>
            <input type="text" name="keyword" placeholder="제목 검색..." class="form-control d-inline-block" style="width: 250px;">
            <button type="submit" class="btn btn-info">조회</button>
          </form>

          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
              <tr>
                <th>번호</th>
                <th>제목</th>
                <th>유형</th>
                <th>작성일</th>
                <th>상태</th>
                <th>액션</th>
              </tr>
              </thead>
              <tbody>
              <tr><td colspan="6" class="text-center">1:1 문의 관리 데이터를 불러올 위치</td></tr>
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