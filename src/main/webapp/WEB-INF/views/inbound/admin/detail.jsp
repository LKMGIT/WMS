<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="page-inner">

    <div class="page-header">
      <h3 class="fw-bold mb-3">입고 요청 상세 (ID: <span id="inboundIndexDisplay">로딩 중...</span>)</h3>
      <ul class="breadcrumbs mb-3">

        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item"><a href="<c:url value='/inbound/admin/list'/>">입고 요청 목록</a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">상세 보기</li>
      </ul>
    </div>

    <div class="row">
      <div class="col-md-12">

        <div class="card">
          <div class="card-header">
            <h4 class="card-title">요청 개요</h4>
          </div>

          <div class="card-body">
            <div class="row g-3">
              <div class="col-md-4"><p><strong>요청 번호:</strong> <span id="req-inboundIndex"></span></p></div>

              <div class="col-md-4"><p><strong>요청자 ID:</strong> <span id="req-userIndex"></span></p></div>
              <div class="col-md-4"><p><strong>창고 번호:</strong> <span id="req-warehouseIndex"></span></p></div>

              <div class="col-md-4"><p><strong>요청 수량:</strong> <span id="req-inboundRequestQuantity"></span>개</p></div>

              <div class="col-md-4"><p><strong>희망 입고일:</strong> <span id="req-plannedReceiveDate"></span></p></div>
              <div class="col-md-4"><p><strong>요청일:</strong> <span id="req-inboundRequestDate"></span></p></div>

              <div class="col-md-4"><p><strong>승인 상태:</strong> <span id="req-approvalStatus"></span></p></div>

              <div class="col-md-4"><p><strong>승인 일시:</strong> <span id="req-approveDate">-</span></p></div>
              <div class="col-md-4"><p><strong>취소 사유:</strong> <span id="req-cancelReason">-</span></p></div>
            </div>

          </div>
          <div class="card-footer text-end" id="requestActions">
            <button class="btn btn-secondary" onclick="history.back()"><i class="fa fa-arrow-left"></i> 목록으로</button>
          </div>
        </div>

        <div class="card mt-4">
          <div class="card-header">
            <h4 class="card-title">상세 품목 목록</h4>
            <p class="card-category" id="detailSummary">총 0건의 상세 품목이 있습니다.</p>

          </div>
          <div class="card-body">
            <div class="table-responsive">

              <table class="table table-striped table-hover">
                <thead>
                <tr>

                  <th>상세 번호</th>
                  <th>QR 코드</th>
                  <th>요청 번호</th>

                  <th>입고 수량</th>
                  <th>입고 일시</th>

                  <th>액션</th>
                </tr>
                </thead>

                <tbody id="inboundDetailTableBody">
                <tr><td colspan="6" class="text-center py-4 text-muted">상세 품목을 불러옵니다.</td></tr>

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
  (function () {
    // ----- 공통: 컨텍스트 경로 -----
    const ctx = '${pageContext.request.contextPath}';
    // ----- DOM 유틸 -----
    const $ = (id) => document.getElementById(id);
    const safeHtml = (s) => String(s ?? '').replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
    // ----- 날짜 포매터 (에러 방지형) -----
    function formatDateTime(dateStr) {
      if (!dateStr) return '-';
      const d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        const pad = (n)=>String(n).padStart(2,'0');
        return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
      }
      if (Array.isArray(dateStr)) {
        const pad = (n)=>String(n).padStart(2,'0');
        const [Y,M,DD,hh=0,mm=0] = dateStr;
        return `${Y}-${pad(M)}-${pad(DD)} ${pad(hh)}:${pad(mm)}`;
      }
      return String(dateStr);
    }
    function formatDate(dateStr) {
      if (!dateStr) return '-';
      const d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        const pad = (n)=>String(n).padStart(2,'0');
        return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
      }
      if (Array.isArray(dateStr)) {
        const pad = (n)=>String(n).padStart(2,'0');
        const [Y,M,DD] = dateStr;
        return `${Y}-${pad(M)}-${pad(DD)}`;
      }
      return String(dateStr);
    }
    function getStatusBadge(status) {
      switch (status) {
        case 'PENDING':  return '<span class="badge bg-warning">대기중</span>';
        case 'APPROVED': return '<span class="badge bg-success">승인됨</span>';
        case 'REJECTED': return '<span class="badge bg-danger">거부됨</span>';
        case 'CANCELED': return '<span class="badge bg-secondary">취소됨</span>';
        default:         return safeHtml(status || '-');
      }
    }
    function displayRequestOverview(data) {
      $('req-inboundIndex').textContent = '#' + (data.inboundIndex ?? '-');
      $('req-userIndex').textContent = data.userIndex ?? '-';
      $('req-warehouseIndex').textContent = '#' + (data.warehouseIndex ?? '-');
      $('req-inboundRequestQuantity').textContent = data.inboundRequestQuantity ?? 0;
      $('req-plannedReceiveDate').textContent = formatDate(data.plannedReceiveDate);
      $('req-inboundRequestDate').textContent = formatDateTime(data.inboundRequestDate);
      $('req-approvalStatus').innerHTML = getStatusBadge(data.approvalStatus);
      $('req-approveDate').textContent = data.approveDate ? formatDateTime(data.approveDate) : '-';
      $('req-cancelReason').textContent = data.cancelReason ?? '-';
      updateActionButtons(data);
    }
    function displayDetailList(details) {
      const tbody = $('inboundDetailTableBody');
      const summary = $('detailSummary');
      if (!Array.isArray(details) || details.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted">등록된 상세 품목이 없습니다. (총 0건)</td></tr>';
        summary.textContent = '총 0건의 상세 품목이 있습니다.';
        return;
      }
      const rows = details.map(detail => {
        const qr = detail.qrCode ? `<code>${safeHtml(detail.qrCode)}</code>` : '<span class="text-danger">미지정</span>';
        const qty = (detail.receivedQuantity ?? '-') + (detail.receivedQuantity!=null ? '개':'');
        const cdt = detail.completeDate ? formatDateTime(detail.completeDate) : '-';
        return `
        <tr>
          <td>#${safeHtml(detail.detailIndex)}</td>
          <td>${qr}</td>
          <td>#${safeHtml(detail.requestIndex)}</td>
          <td>${safeHtml(qty)}</td>
          <td>${safeHtml(cdt)}</td>
          <td>
            <button class="btn btn-sm btn-warning" title="위치 지정/수정"
                    onclick="event.stopPropagation(); alert('위치 지정 기능 준비 중 (Detail Index: ${safeHtml(detail.detailIndex)})')">
              <i class="fa fa-map-marker-alt"></i> 위치
            </button>
          </td>
        </tr>`;
      }).join('');
      tbody.innerHTML = rows;
      summary.textContent = `총 ${details.length}건의 상세 품목이 있습니다.`;
    }
    function updateActionButtons(data) {
      const area = $('requestActions');
      let html = '';
      if (data.approvalStatus === 'PENDING') {
        html += `
        <button class="btn btn-success me-2" onclick="approveRequest(${Number(data.inboundIndex) || 0})">
          <i class="fa fa-check"></i> 요청 승인
        </button>`;
      }
      html += `<button class="btn btn-secondary" onclick="history.back()"><i class="fa fa-arrow-left"></i> 목록으로</button>`;
      area.innerHTML = html;
    }
    window.approveRequest = function(inboundIndex) {
      if (!inboundIndex) return alert('잘못된 요청 번호입니다.');
      if (!confirm('이 입고 요청을 승인하시겠습니까?')) return;
      fetch(`${ctx}/inbound/admin/request/${encodeURIComponent(inboundIndex)}/approve`, {
        method: 'PUT',
        headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' },
        credentials: 'same-origin'
      })
              .then(res => res.headers.get('content-type')?.includes('application/json') ? res.json() : Promise.reject(new Error('API가 JSON을 반환하지 않습니다.')))
              .then(d => {
                if (d?.success) {
                  console.log(d.message || '승인이 완료되었습니다.');
                  loadInboundDetail(inboundIndex);
                } else {
                  alert(d?.message || '승인에 실패했습니다.');
                }
              })
              .catch(err => {
                console.error(err);
                alert('승인 처리 중 오류가 발생했습니다.');
              });
    };
    function loadInboundDetail(inboundIndex) {
      const tbody = $('inboundDetailTableBody');
      $('inboundIndexDisplay').textContent = inboundIndex || '-';
      tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted"><i class="fa fa-spinner fa-spin"></i> 상세 정보 로딩 중...</td></tr>';
      if (!inboundIndex || isNaN(Number(inboundIndex))) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-danger">URL에서 올바른 요청 번호를 찾을 수 없습니다.</td></tr>';
        return;
      }
      const url = `${ctx}/inbound/admin/request/${encodeURIComponent(inboundIndex)}`;
      fetch(url, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(res => {
                const ct = res.headers.get('content-type') || '';
                if (res.status === 401) {
                  location.href = `${ctx}/login/loginForm?returnUrl=${encodeURIComponent(location.pathname)}`;
                  throw new Error('401');
                }
                if (!res.ok) throw new Error(`HTTP ${res.status}`);
                if (!ct.includes('application/json')) throw new Error('NOT_JSON');
                return res.json();
              })
              .then(data => {
                if (!data) throw new Error('EMPTY_DATA');
                displayRequestOverview(data);
                displayDetailList(data.details);
              })
              .catch(err => {
                console.error('[loadInboundDetail] error:', err);
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-danger">상세 정보를 불러오는 중 오류가 발생했습니다.</td></tr>';
                $('inboundIndexDisplay').textContent = '오류';
              });
    }
    document.addEventListener('DOMContentLoaded', function () {
      try {
        // URL 마지막 세그먼트에서 번호 추출 (뒤에 슬래시가 있어도 처리)
        const segs = (location.pathname || '').split('/').filter(Boolean);
        const last = segs[segs.length - 1] || '';
        const inboundIndex = /^[0-9]+$/.test(last) ? last : '';
        $('inboundIndexDisplay').textContent = inboundIndex || '-';
        loadInboundDetail(inboundIndex);
      } catch (e) {
        console.error('[init] error:', e);
      }
    });
  })();
</script>