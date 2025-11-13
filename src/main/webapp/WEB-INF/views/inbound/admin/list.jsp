<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="page-inner">

    <div class="page-header">
      <h3 class="fw-bold mb-3">입고 관리</h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item"><a href="<c:url value='/inbound/admin/list'/>">입고 요청 목록</a></li>

      </ul>
    </div>

    <div class="row">
      <div class="col-md-12">

        <div class="card mb-4">
          <div class="card-body">
            <form id="searchForm" onsubmit="event.preventDefault(); loadRequests();">
              <div class="row g-3 align-items-center">

                <div class="col-md-3">
                  <label for="status-select" class="form-label visually-hidden">상태</label>
                  <select name="status" id="status-select" class="form-control">
                    <option value="">전체 상태</option>
                    <option value="PENDING">대기중</option>
                    <option value="APPROVED">승인됨</option>
                    <option value="REJECTED">거부됨</option>
                    <option value="CANCELED">취소됨</option>
                  </select>

                </div>
                <div class="col-md-6">
                  <label for="keyword-input" class="form-label visually-hidden">검색</label>
                  <input type="text" name="keyword" id="keyword-input" class="form-control"
                         placeholder="입고번호 또는 요청자 검색...">
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
                <tbody id="requestsTableBody">
                <tr><td colspan="8" class="text-center py-5 text-muted">입고 요청 내역을 불러옵니다...</td></tr>
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
    loadRequests();
  });
  // JSON 응답 가드
  function expectJson(res, ctx) {
    // 401 → 로그인으로
    if (res.status === 401) {
      location.href = '<c:url value="/login/loginForm"/>' + '?returnUrl=' + encodeURIComponent(location.pathname + location.search);
      throw new Error('UNAUTHORIZED');
    }
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const ct = res.headers.get('content-type') || '';
    if (!ct.includes('application/json')) {
      // 서버가 HTML(로그인/에러 뷰)을 준 상황
      throw new Error('NOT_JSON');
    }
    return res.json();
  }
  // 입고 요청 목록 조회
  function loadRequests() {
    const status  = document.getElementById('status-select').value;
    const keyword = document.getElementById('keyword-input').value;
    let url = '<c:url value="/inbound/admin/request"/>';
    const params = new URLSearchParams();
    if (status)  params.append('status', status);
    if (keyword) params.append('keyword', keyword);
    if (params.toString()) url += '?' + params.toString();
    const tbody = document.getElementById('requestsTableBody');
    tbody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted"><i class="fa fa-spinner fa-spin"></i> 불러오는 중...</td></tr>';
    fetch(url, {
      method: 'GET',
      headers: { 'Accept': 'application/json' },   // ★ JSON 요청 의사 표시
      credentials: 'same-origin'                   // ★ 세션 쿠키 포함
    })
            .then(res => expectJson(res))
            .then(data => {
              console.log('[inbound list]', data);
              displayRequests(data);
            })
            .catch(err => {
              console.error('[loadRequests] error:', err);
              tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4 text-danger">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>';
            });
  }
  // 테이블에 데이터 표시 (기존 그대로 사용)
  function displayRequests(requests) {
    const tbody = document.getElementById('requestsTableBody');
    if (!Array.isArray(requests) || requests.length === 0) {
      tbody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted">입고 요청 내역이 없습니다.</td></tr>';
      return;
    }
    let html = '';
    requests.forEach(item => {
      let statusBadge = '';
      switch(item.approvalStatus) {
        case 'PENDING':  statusBadge = '<span class="badge bg-warning">대기중</span>'; break;
        case 'APPROVED': statusBadge = '<span class="badge bg-success">승인됨</span>'; break;
        case 'REJECTED': statusBadge = '<span class="badge bg-danger">거부됨</span>'; break;
        case 'CANCELED': statusBadge = '<span class="badge bg-secondary">취소됨</span>'; break;
        default:         statusBadge = item.approvalStatus || '-';
      }
      const requestDate = item.inboundRequestDate ? formatDateTime(item.inboundRequestDate) : '-';
      const plannedDate = item.plannedReceiveDate ? formatDate(item.plannedReceiveDate) : '-';
      html += `

        <tr style="cursor:pointer" onclick="location.href='<c:url value="/inbound/admin/detail/"/>\${item.inboundIndex}'">
          <td><strong>#${item.inboundIndex}</strong></td>
          <td>${item.userIndex || '-'}</td>
          <td>${item.inboundRequestQuantity || 0}개</td>
          <td>${requestDate}</td>
          <td>${plannedDate}</td>
          <td>${statusBadge}</td>
          <td>창고 #${item.warehouseIndex || '-'}</td>
          <td>
            <button class="btn btn-sm btn-outline-info"
                    onclick="event.stopPropagation(); location.href='<c:url value="/inbound/admin/detail/"/>\${item.inboundIndex}'">
              <i class="fa fa-eye"></i> 상세
            </button>
          </td>
        </tr>
      `;
    });
    tbody.innerHTML = html;
  }
  // 아래 두 함수는 네가 올린 것 그대로 둬도 됨
  function formatDateTime(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 6) {
        const pad = (n)=>String(n).padStart(2,'0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])} ${pad(dateStr[3])}:${pad(dateStr[4])}`;
      }
      return String(dateStr);
    }
    const y=date.getFullYear(), m=String(date.getMonth()+1).padStart(2,'0'), d=String(date.getDate()).padStart(2,'0');
    const h=String(date.getHours()).padStart(2,'0'), mm=String(date.getMinutes()).padStart(2,'0');
    return `${y}-${m}-${d} ${h}:${mm}`;
  }
  function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 3) {
        const pad = (n)=>String(n).padStart(2,'0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])}`;
      }
      return String(dateStr);
    }
    const y=date.getFullYear(), m=String(date.getMonth()+1).padStart(2,'0'), d=String(date.getDate()).padStart(2,'0');
    return `${y}-${m}-${d}`;
  }
</script>