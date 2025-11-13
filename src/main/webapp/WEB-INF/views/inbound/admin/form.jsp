<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="page-inner">

    <div class="page-header">
      <h3 class="fw-bold mb-3">입고 상세 목록 (입고된 목록)</h3>
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
            <%-- 관리자 API /inbound/admin/details 를 호출합니다. --%>
            <form id="adminSearchForm" onsubmit="event.preventDefault(); loadAdminDetails();">
              <div class="row g-3 align-items-center">
                <div class="col-md-3">
                  <label for="admin-status-select" class="form-label visually-hidden">상태</label>
                  <select name="status" id="admin-status-select" class="form-control">
                    <option value="">전체 상태</option>
                    <option value="COMPLETED">입고 완료</option>
                    <option value="PENDING_RECEIPT">입고 대기</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="admin-keyword-input" class="form-label visually-hidden">검색</label>
                  <input type="text" name="keyword" id="admin-keyword-input" class="form-control"
                         placeholder="요청번호, 입고번호, QR코드, 구역번호 검색...">
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
            <h4 class="card-title">입고 상세 품목 목록</h4>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-hover mt-3">
                <thead>
                <tr>
                  <th>상세 번호</th>
                  <th>입고 번호</th>
                  <th>요청 번호</th>
                  <th>QR 코드</th>
                  <th>실 입고 수량</th>
                  <th>입고 일시</th>
                  <th>창고/구역</th>
                  <th>상태</th>
                  <th>액션</th>
                </tr>
                </thead>
                <tbody id="adminDetailsTableBody">
                <tr><td colspan="9" class="text-center py-4 text-muted">입고 상세 내역을 불러옵니다.</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  // 페이지 로드 시 자동으로 목록 조회
  document.addEventListener('DOMContentLoaded', function() {
    loadAdminDetails();
  });

  // 관리자 입고 (상세) 목록 조회
  function loadAdminDetails() {
    const status = document.getElementById('admin-status-select').value;
    const keyword = document.getElementById('admin-keyword-input').value;

    // API 엔드포인트를 /inbound/admin/details 로 변경
    let url = '<c:url value="/inbound/admin/details"/>';
    const params = new URLSearchParams();

    if (status) params.append('status', status);
    if (keyword) params.append('keyword', keyword);

    if (params.toString()) {
      url += '?' + params.toString();
    }

    const tbody = document.getElementById('adminDetailsTableBody');
    tbody.innerHTML = '<tr><td colspan="9" class="text-center py-4"><i class="fa fa-spinner fa-spin"></i> 데이터를 불러오는 중...</td></tr>';

    fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })
            .then(response => {
              if (!response.ok) {
                if (response.status === 401) {
                  alert('로그인이 필요합니다.');
                  location.href = '<c:url value="/login/loginForm"/>';
                  throw new Error('Unauthorized');
                }
                throw new Error('서버 오류가 발생했습니다.');
              }

              return response.json();
            })
            .then(data => {
              displayAdminDetails(data);
            })
            .catch(error => {
              console.error('Error:', error);
              tbody.innerHTML = '<tr><td colspan="9" class="text-center py-4 text-danger">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>';
            });
  }

  // 테이블에 데이터 표시 (상세 DTO 기준)
  function displayAdminDetails(details) {
    const tbody = document.getElementById('adminDetailsTableBody');
    if (!details || details.length === 0) {
      tbody.innerHTML = '<tr><td colspan="9" class="text-center py-4 text-muted">입고 상세 내역이 없습니다.</td></tr>';
      return;
    }

    let html = '';
    details.forEach(item => {
      // 상태 배지
      let statusBadge = '';
      let completeDate = '-';

      if(item.completeDate) {
        statusBadge = '<span class="badge bg-success">입고 완료</span>';
        completeDate = formatDateTime(item.completeDate);
      } else {
        statusBadge = '<span class="badge bg-warning">입고 대기</span>';
      }

      const qrCodeDisplay = item.qrCode ? `<code>${item.qrCode}</code>` : '<span class="text-muted">미지정</span>';

      const detailViewUrl = '<c:url value="/inbound/admin/detail/"/>' + item.inboundIndex;

      html += `
        <tr style="cursor:pointer" onclick="location.href='${detailViewUrl}'">
          <td><strong>#${item.detailIndex}</strong></td>
          <td>#${item.inboundIndex}</td>
          <td>#${item.requestIndex}</td>
          <td>${qrCodeDisplay}</td>
          <td>${item.receivedQuantity || 0} 개</td>
          <td>${completeDate}</td>
          <td>창고 ${item.warehouse_index} / 구역 ${item.section_index || '-'}</td>
          <td>${statusBadge}</td>
          <td>
            <button class="btn btn-sm btn-outline-info"
                    onclick="event.stopPropagation(); location.href='${detailViewUrl}'">
              <i class="fa fa-eye"></i> 요청 상세
            </button>
          </td>
        </tr>
      `;
    });

    tbody.innerHTML = html;
  }

  // ▼▼▼ [수정됨] 안정적인 날짜 변환 함수로 교체 ▼▼▼
  function formatDateTime(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 6) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])} ${pad(dateStr[3])}:${pad(dateStr[4])}`;
      }
      return dateStr;
    }
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 3) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])}`;
      }
      return dateStr;
    }
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
  // ▲▲▲ [수정됨] ▲▲▲
</script>

<%-- 템플릿 종료 --%>