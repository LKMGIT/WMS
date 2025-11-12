<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">

      <div class="page-header">
        <h3 class="fw-bold mb-3">입고 관리</h3>
        <ul class="breadcrumbs mb-3">
          <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
          <li class="separator"><i class="icon-arrow-right"></i></li>
          <li class="nav-item"><a href="<c:url value='/inbound/list'/>">입고 요청 목록</a></li>
        </ul>
      </div>

      <div class="row">
        <div class="col-md-12">

          <div class="card mb-4">
            <div class="card-body">
              <form action="<c:url value="list"/>" method="get">
                <div class="row g-3 align-items-center">
                  <div class="col-md-3">
                    <label for="status-select" class="form-label visually-hidden">상태</label>
                    <select name="status" id="status-select" class="form-control">
                      <option value="">전체 상태</option>
                      <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>대기중</option>
                      <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected' : ''}>승인됨</option>
                      <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>거부됨</option>
                      <option value="CANCELED" ${param.status == 'CANCELED' ? 'selected' : ''}>취소됨</option>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label for="keyword-input" class="form-label visually-hidden">검색</label>
                    <input type="text" name="keyword" id="keyword-input" class="form-control"
                           placeholder="입고번호 또는 요청자 검색..." value="${param.keyword}">
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
              <h4 class="card-title">입고 요청 목록</h4>
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
                    <th>희망일</th>
                    <th>상태</th>
                    <th>창고</th>
                    <th>액션</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:choose>
                    <c:when test="${empty list}">
                      <tr>
                        <td colspan="8" class="text-center py-5 text-muted">입고 요청 내역이 없습니다.</td>
                      </tr>
                    </c:when>
                    <c:otherwise>
                      <%-- list 변수는 컨트롤러에서 Model에 담아 전달해야 합니다. --%>
                      <c:forEach items="${list}" var="item">
                        <tr style="cursor:pointer" onclick="location.href='<c:url value="/inbound/detail/${item.inboundIndex}"/>'">
                          <td><strong>#${item.inboundIndex}</strong></td>
                          <td>${item.requestUserId}</td>
                          <td>${item.inboundRequestQuantity}개</td>
                          <td><fmt:formatDate value="${item.inboundRequestDate}" pattern="yyyy-MM-dd"/></td>
                          <td><c:choose><c:when test="${not empty item.plannedReceiveDate}"><fmt:formatDate value="${item.plannedReceiveDate}" pattern="yyyy-MM-dd"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                          <td>
                            <c:choose>
                              <c:when test="${item.approvalStatus == 'PENDING'}"><span class="badge bg-warning">대기중</span></c:when>
                              <c:when test="${item.approvalStatus == 'APPROVED'}"><span class="badge bg-success">승인됨</span></c:when>
                              <c:when test="${item.approvalStatus == 'REJECTED'}"><span class="badge bg-danger">거부됨</span></c:when>
                              <c:when test="${item.approvalStatus == 'CANCELED'}"><span class="badge bg-secondary">취소됨</span></c:when>
                              <c:otherwise>${item.approvalStatus}</c:otherwise>
                            </c:choose>
                          </td>
                          <td>창고 #${item.warehouseIndex}</td>
                          <td>
                            <button class="btn btn-sm btn-outline-info"
                                    onclick="event.stopPropagation(); location.href='<c:url value="/inbound/detail/${item.inboundIndex}"/>'">
                              <i class="fa fa-eye"></i> 상세
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
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