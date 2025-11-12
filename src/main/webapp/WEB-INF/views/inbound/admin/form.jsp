<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <div class="page-header">
        <h3 class="fw-bold mb-3">입고 목록 조회</h3>
        <ul class="breadcrumbs mb-3">
          <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
          <li class="separator"><i class="icon-arrow-right"></i></li>
          <li class="nav-item">입고 관리</li>
        </ul>
      </div>

      <div class="row">
        <div class="col-md-12">

          <div class="card mb-4">
            <div class="card-body">
              <%-- 관리자 API /inbound/admin/request 를 호출하여 목록을 가져옵니다. --%>
              <form action="<c:url value="/inbound/admin/Form"/>" method="get">
                <div class="row g-3 align-items-center">
                  <div class="col-md-3">
                    <label for="admin-status-select" class="form-label visually-hidden">상태</label>
                    <select name="status" id="admin-status-select" class="form-control">
                      <option value="">전체 상태</option>
                      <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                      <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>승인됨</option>
                      <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>거부됨</option>
                      <option value="CANCELED" ${param.status == 'CANCELED' ? 'selected' : ''}>취소됨</option>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label for="admin-keyword-input" class="form-label visually-hidden">검색</label>
                    <input type="text" name="keyword" id="admin-keyword-input" class="form-control"
                           placeholder="입고번호, 요청자ID, 창고번호 검색..." value="${param.keyword}">
                  </div>
                  <div class="col-md-3">
                    <button type="submit" class="btn btn-info w-100">
                      <i class="fa fa-search"></i> 검색
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <h4 class="card-title">전체 입고 요청 목록</h4>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-hover mt-3">
                  <thead>
                  <tr>
                    <th>입고번호</th>
                    <th>요청자ID</th>
                    <th>요청수량</th>
                    <th>요청일</th>
                    <th>상태</th>
                    <th>창고</th>
                    <th>액션</th>
                  </tr>
                  </thead>
                  <tbody>
                  <%-- 이곳에 관리자가 조회한 목록 데이터를 표시합니다. --%>
                  <tr><td colspan="7" class="text-center py-4 text-muted">입고 요청 내역을 불러옵니다.</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>