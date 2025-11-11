<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="row">
  <div class="col-md-12">
    <div class="card">

      <!-- 헤더 + 검색 폼 -->
      <div class="card-header d-flex align-items-center justify-content-between">
        <h4 class="card-title mb-0">재고 조회</h4>

        <!-- GET /inventory/inventory_list -->
        <form method="get" action="${ctx}/inventory/inventory_list" class="d-flex gap-2">
          <!-- 카테고리 -->
          <select class="form-select" name="category" style="width:180px">
            <option value="" ${empty selectedCategory ? 'selected' : ''}>카테고리(전체)</option>
            <option value="HEALTH"  ${selectedCategory == 'HEALTH'  ? 'selected' : ''}>HEALTH</option>
            <option value="BEAUTY"  ${selectedCategory == 'BEAUTY'  ? 'selected' : ''}>BEAUTY</option>
            <option value="PERFUME" ${selectedCategory == 'PERFUME' ? 'selected' : ''}>PERFUME</option>
            <option value="CARE"    ${selectedCategory == 'CARE'    ? 'selected' : ''}>CARE</option>
            <option value="FOOD"    ${selectedCategory == 'FOOD'    ? 'selected' : ''}>FOOD</option>
          </select>

          <!-- 창고 -->
          <input type="number"
                 class="form-control"
                 name="warehouseIndex"
                 placeholder="창고번호"
                 value="${fn:escapeXml(selectedWarehouseIndex)}"
                 style="width:140px"/>

          <!-- 구역 (필드명: sectionIndex 로 통일) -->
          <input type="number"
                 class="form-control"
                 name="sectionIndex"
                 placeholder="구역번호"
                 value="${fn:escapeXml(selectedSectionIndex)}"
                 style="width:140px"/>

          <!-- 품명 부분검색 -->
          <input type="text"
                 class="form-control"
                 name="itemName"
                 placeholder="품명 검색"
                 value="${fn:escapeXml(searchedItemName)}"
                 style="width:220px"/>

          <button type="submit" class="btn btn-primary">적용</button>

          <!-- 초기화 -->
          <a class="btn btn-outline-secondary" href="${ctx}/inventory/inventory_list">초기화</a>

          <!-- 페이지 크기 유지 -->
          <input type="hidden" name="amount" value="${cri.amount}"/>
        </form>
      </div>

      <!-- 본문: 테이블 -->
      <div class="card-body">
        <div class="table-responsive">
          <table id="basic-datatables" class="display table table-striped table-hover">
            <thead>
            <tr>
              <th>재고번호</th>
              <th>품목번호</th>
              <th>품명</th>
              <th>카테고리</th>
              <th>수량</th>
              <th>입고일</th>
              <th>출고일</th>
              <th>창고번호</th>
              <th>구역번호</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty inventories}">
                <c:forEach var="inv" items="${inventories}">
                  <tr>
                    <td><c:out value="${inv.invenIndex}"/></td>
                    <td><c:out value="${inv.itemIndex}"/></td>
                    <td><c:out value="${inv.itemName}"/></td>
                    <td><c:out value="${inv.itemCategory}"/></td>
                    <td><c:out value="${inv.invenQuantity}"/></td>

                    <!-- LocalDateTime은 raw 출력 또는 substring -->
                    <td><c:out value="${fn:substring(inv.inboundDate,0,19)}"/></td>
                    <td><c:out value="${fn:substring(inv.shippingDate,0,19)}"/></td>

                    <td><c:out value="${inv.warehouseIndex}"/></td>
                    <td><c:out value="${inv.sectionIndex}"/></td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="9" class="text-center text-muted">검색 결과가 없습니다.</td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>

        <!-- 페이지네이션 -->
        <c:if test="${not empty pageMaker}">
          <ul class="pagination justify-content-center mt-3">
            <c:if test="${pageMaker.prev}">
              <li class="page-item">
                <a class="page-link"
                   href="?pageNum=${pageMaker.startPage - 1}
                           &amount=${cri.amount}
                           &category=${fn:escapeXml(selectedCategory)}
                           &warehouseIndex=${fn:escapeXml(selectedWarehouseIndex)}
                           &sectionIndex=${fn:escapeXml(selectedSectionIndex)}
                           &itemName=${fn:escapeXml(searchedItemName)}">Previous</a>
              </li>
            </c:if>

            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
              <li class="page-item ${cri.pageNum == num ? 'active' : ''}">
                <a class="page-link"
                   href="?pageNum=${num}
                           &amount=${cri.amount}
                           &category=${fn:escapeXml(selectedCategory)}
                           &warehouseIndex=${fn:escapeXml(selectedWarehouseIndex)}
                           &sectionIndex=${fn:escapeXml(selectedSectionIndex)}
                           &itemName=${fn:escapeXml(searchedItemName)}">${num}</a>
              </li>
            </c:forEach>

            <c:if test="${pageMaker.next}">
              <li class="page-item">
                <a class="page-link"
                   href="?pageNum=${pageMaker.endPage + 1}
                           &amount=${cri.amount}
                           &category=${fn:escapeXml(selectedCategory)}
                           &warehouseIndex=${fn:escapeXml(selectedWarehouseIndex)}
                           &sectionIndex=${fn:escapeXml(selectedSectionIndex)}
                           &itemName=${fn:escapeXml(searchedItemName)}">Next</a>
              </li>
            </c:if>
          </ul>
        </c:if>

      </div>
    </div>
  </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
