<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="main-panel">
  <div class="container">
    <div class="page-inner">
      <h3 class="fw-bold mb-3">기간별 입고 현황 조회</h3>

      <div class="card mb-4">
        <div class="card-body">
          <form id="periodSearchForm">
            <div class="row g-3 align-items-center">
              <div class="col-auto">
                <label for="startDate" class="form-label">시작일:</label>
                <input type="date" id="startDate" name="startDate" class="form-control" required>
              </div>
              <div class="col-auto">
                <label for="endDate" class="form-label">종료일:</label>
                <input type="date" id="endDate" name="endDate" class="form-control" required>
              </div>
              <div class="col-auto mt-4">
                <button type="submit" class="btn btn-info">조회</button>
              </div>
            </div>
          </form>
        </div>
      </div>

      <div class="card">
        <div class="card-header"><h4 class="card-title">기간별 현황 결과</h4></div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-hover">
              <thead>
              <tr>
                <th>요청번호</th>
                <th>요청일</th>
                <th>승인상태</th>
                <th>상세 개수</th>
                <th>총 입고 수량</th>
              </tr>
              </thead>
              <tbody id="periodResults">
              <tr><td colspan="5" class="text-center">조회 버튼을 눌러주세요.</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <script>
        // 여기에 /inbound/admin/status/period API를 호출하는 JavaScript 코드를 작성합니다.
        // form submit 시 해당 API를 호출하고 결과를 #periodResults에 뿌려줍니다.
      </script>
    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>
<c:import url="/WEB-INF/views/includes/end.jsp"/>