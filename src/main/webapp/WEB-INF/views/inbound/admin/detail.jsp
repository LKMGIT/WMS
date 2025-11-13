<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* 애니메이션 */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  .fade-in-up {
    animation: fadeInUp 0.6s ease-out;
  }

  /* 헤더 스타일 */
  .detail-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    padding: 2rem;
    color: white;
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    margin-bottom: 2rem;
    position: relative;
    overflow: hidden;
  }

  .detail-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,165.3C1248,171,1344,149,1392,138.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
    background-size: cover;
    opacity: 0.3;
  }

  .detail-header h2 {
    margin: 0;
    font-weight: 700;
    position: relative;
    z-index: 1;
  }

  .detail-header .status-badge {
    display: inline-block;
    padding: 0.5rem 1.5rem;
    border-radius: 25px;
    background: rgba(255,255,255,0.2);
    backdrop-filter: blur(10px);
    font-weight: 600;
    margin-top: 1rem;
  }

  /* 정보 카드 */
  .info-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
    transition: all 0.3s ease;
    margin-bottom: 2rem;
  }

  .info-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
  }

  .info-card .card-header {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    border: none;
    padding: 1.5rem;
  }

  .info-card .card-header h4 {
    margin: 0;
    color: #2d3748;
    font-weight: 700;
  }

  .info-card .card-body {
    padding: 2rem;
  }

  /* 정보 그리드 */
  .info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
  }

  .info-item {
    padding: 1rem;
    background: linear-gradient(135deg, #f7fafc 0%, #ffffff 100%);
    border-radius: 15px;
    border-left: 4px solid #667eea;
    transition: all 0.3s ease;
  }

  .info-item:hover {
    transform: translateX(5px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
  }

  .info-label {
    font-size: 0.75rem;
    color: #718096;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.5rem;
  }

  .info-value {
    font-size: 1.1rem;
    color: #2d3748;
    font-weight: 700;
  }

  /* 상세 품목 테이블 */
  .detail-table-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
  }

  .detail-table-card .card-header {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    border: none;
    padding: 1.5rem;
  }

  .detail-table-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  .detail-table-card .card-header p {
    color: rgba(255,255,255,0.9);
    margin: 0.5rem 0 0 0;
  }

  .detail-table {
    margin: 0;
  }

  .detail-table thead th {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    color: #2d3748;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1.25rem 1rem;
  }

  .detail-table tbody tr {
    transition: all 0.3s ease;
    border-bottom: 1px solid #e2e8f0;
  }

  .detail-table tbody tr:hover {
    background: linear-gradient(90deg, rgba(240, 147, 251, 0.05) 0%, rgba(240, 147, 251, 0) 100%);
  }

  .detail-table tbody td {
    padding: 1.25rem 1rem;
    vertical-align: middle;
    border: none;
  }

  /* 입력 필드 스타일 */
  .form-control {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.6rem 1rem;
    transition: all 0.3s ease;
  }

  .form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .form-control:disabled, .form-control:read-only {
    background-color: #f7fafc;
    border-color: #cbd5e0;
  }

  /* 버튼 스타일 */
  .btn-modern {
    border-radius: 10px;
    padding: 0.6rem 1.5rem;
    font-weight: 600;
    transition: all 0.3s ease;
    border: none;
  }

  .btn-process {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    color: white;
  }

  .btn-process:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(67, 233, 123, 0.4);
    color: white;
  }

  .btn-approve {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }

  .btn-approve:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    color: white;
  }

  .btn-cancel {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
  }

  .btn-cancel:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(250, 112, 154, 0.4);
    color: white;
  }

  .btn-back {
    background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
    color: #2d3748;
  }

  .btn-back:hover {
    background: linear-gradient(135deg, #cbd5e0 0%, #a0aec0 100%);
    color: #2d3748;
  }

  /* 완료 체크마크 */
  .completed-badge {
    background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 15px;
    font-weight: 600;
    display: inline-block;
  }

  /* 로딩 스피너 */
  .loading-spinner {
    display: inline-block;
    width: 40px;
    height: 40px;
    border: 4px solid rgba(102, 126, 234, 0.2);
    border-radius: 50%;
    border-top-color: #667eea;
    animation: spin 1s ease-in-out infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  /* 진행 상황 */
  .progress {
    height: 30px;
    border-radius: 15px;
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    overflow: visible;
    position: relative;
  }

  .progress-bar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    color: white;
    transition: width 0.6s ease;
  }

  /* 🔥 모달 스타일 */
  .modal-content {
    border-radius: 20px;
    border: none;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
  }

  .modal-header {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
    border-radius: 20px 20px 0 0;
    border: none;
    padding: 1.5rem 2rem;
  }

  .modal-header .btn-close {
    filter: brightness(0) invert(1);
  }

  .modal-body {
    padding: 2rem;
  }

  .modal-footer {
    border-top: none;
    padding: 1rem 2rem 2rem 2rem;
  }

  .btn-modal-confirm {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
    border: none;
    padding: 0.6rem 2rem;
    border-radius: 10px;
    font-weight: 600;
  }

  .btn-modal-confirm:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(250, 112, 154, 0.4);
    color: white;
  }

  .btn-modal-cancel {
    background: #e2e8f0;
    color: #2d3748;
    border: none;
    padding: 0.6rem 2rem;
    border-radius: 10px;
    font-weight: 600;
  }

  .btn-modal-cancel:hover {
    background: #cbd5e0;
  }
</style>

<div class="container-fluid p-4 fade-in-up">
  <div class="container">

    <%-- 헤더 --%>
    <div class="detail-header">
      <h2>
        <i class="fas fa-box-open"></i>
        입고 요청 상세
        <span id="headerInboundIndex">#0</span>
      </h2>
      <div class="status-badge" id="headerStatusBadge">
        <i class="fas fa-clock"></i> 대기중
      </div>
    </div>

    <%-- 요청 개요 카드 --%>
    <div class="card info-card">
      <div class="card-header">
        <h4><i class="fas fa-info-circle"></i> 요청 개요</h4>
      </div>
      <div class="card-body">
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label"><i class="fas fa-hashtag"></i> 입고 번호</div>
            <div class="info-value" id="req-inboundIndex">#0</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-user"></i> 요청자</div>
            <div class="info-value" id="req-userIndex">-</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-warehouse"></i> 창고</div>
            <div class="info-value" id="req-warehouseIndex">#0</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-box"></i> 요청 수량</div>
            <div class="info-value" id="req-inboundRequestQuantity">0 개</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-calendar-check"></i> 희망 입고일</div>
            <div class="info-value" id="req-plannedReceiveDate">-</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-clock"></i> 요청 일시</div>
            <div class="info-value" id="req-inboundRequestDate">-</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-flag"></i> 승인 상태</div>
            <div class="info-value" id="req-approvalStatus">-</div>
          </div>
          <div class="info-item">
            <div class="info-label"><i class="fas fa-check-circle"></i> 승인 일시</div>
            <div class="info-value" id="req-approveDate">-</div>
          </div>
        </div>

        <%-- 취소 사유 (CANCELED 상태일 때만 표시) --%>
        <div class="mt-4" id="cancelReasonSection" style="display: none;">
          <div class="alert alert-warning" style="border-radius: 15px; border-left: 4px solid #f6d365;">
            <strong><i class="fas fa-exclamation-triangle"></i> 취소 사유:</strong>
            <span id="req-cancelReason">-</span>
          </div>
        </div>
      </div>
    </div>

    <%-- 처리 진행 상황 --%>
    <div class="card info-card">
      <div class="card-header">
        <h4><i class="fas fa-tasks"></i> 처리 진행 상황</h4>
      </div>
      <div class="card-body">
        <div class="progress">
          <div class="progress-bar" role="progressbar" id="progressBar" style="width: 0%">
            <span id="progressText">0/0 완료</span>
          </div>
        </div>
      </div>
    </div>

    <%-- 상세 품목 목록 --%>
    <div class="card detail-table-card">
      <div class="card-header">
        <h4><i class="fas fa-clipboard-list"></i> 상세 품목 목록</h4>
        <p id="detailSummary">총 0건의 상세 품목이 있습니다.</p>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table detail-table">
            <thead>
            <tr>
              <th><i class="fas fa-hashtag"></i> 번호</th>
              <th><i class="fas fa-map-marker-alt"></i> 입고 위치</th>
              <th><i class="fas fa-box"></i> 입고 수량</th>
              <th><i class="fas fa-calendar-check"></i> 입고 일시</th>
              <th><i class="fas fa-cog"></i> 처리</th>
            </tr>
            </thead>
            <tbody id="inboundDetailTableBody">
            <tr>
              <td colspan="5" class="text-center py-5">
                <div class="loading-spinner" style="margin: 0 auto;"></div>
                <p class="mt-3 text-muted">상세 정보 로딩 중...</p>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <%-- 액션 버튼 --%>
    <div class="text-end mt-4 mb-5" id="requestActions">
      <button class="btn btn-modern btn-back" onclick="history.back()">
        <i class="fas fa-arrow-left"></i> 목록으로
      </button>
    </div>

  </div>
</div>

<%-- 🔥 취소 사유 입력 모달 --%>
<div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="cancelModalLabel">
          <i class="fas fa-ban"></i> 입고 요청 취소
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="cancelReasonInput" class="form-label" style="font-weight: 600;">
            <i class="fas fa-comment-alt"></i> 취소 사유를 입력해주세요
          </label>
          <textarea
                  class="form-control"
                  id="cancelReasonInput"
                  rows="4"
                  placeholder="예: 재고 부족, 발주 오류, 계획 변경 등"
                  maxlength="255"
          ></textarea>
          <small class="text-muted">최대 255자까지 입력 가능합니다.</small>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
          <i class="fas fa-times"></i> 닫기
        </button>
        <button type="button" class="btn btn-modal-confirm" onclick="confirmCancel()">
          <i class="fas fa-check"></i> 취소 확정
        </button>
      </div>
    </div>
  </div>
</div>

<%-- 템플릿 끝 --%>
<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<%-- JavaScript --%>
<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var currentInboundIndex = null;
    var $ = function(id) { return document.getElementById(id); };
    var safeHtml = function(s) {
      var str = (s != null && s != undefined) ? String(s) : '';
      return str.replace(/[&<>"']/g, function(m) {
        var map = {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'};
        return map[m];
      });
    };

    // 날짜 포매터
    function formatDateTime(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
      }
      if (Array.isArray(dateStr)) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return dateStr[0] + '-' + pad(dateStr[1]) + '-' + pad(dateStr[2]) + ' ' + pad(dateStr[3] || 0) + ':' + pad(dateStr[4] || 0);
      }
      return String(dateStr);
    }

    function formatDate(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
      }
      if (Array.isArray(dateStr)) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return dateStr[0] + '-' + pad(dateStr[1]) + '-' + pad(dateStr[2]);
      }
      return String(dateStr);
    }

    function getStatusBadge(status) {
      var badges = {
        'PENDING': '<i class="fas fa-clock"></i> 대기중',
        'APPROVED': '<i class="fas fa-check-circle"></i> 승인됨',
        'REJECTED': '<i class="fas fa-times-circle"></i> 거부됨',
        'CANCELED': '<i class="fas fa-ban"></i> 취소됨'
      };
      return badges[status] || safeHtml(status || '-');
    }

    // 요청 개요 렌더링
    function displayRequestOverview(data) {
      console.log('[displayRequestOverview] 데이터 수신:', data);
      $('req-inboundIndex').textContent = '#' + (data.inboundIndex || '-');
      $('req-userIndex').textContent = data.userIndex || '-';
      $('req-warehouseIndex').textContent = '#' + (data.warehouseIndex || '-');
      $('req-inboundRequestQuantity').textContent = (data.inboundRequestQuantity || 0) + ' 개';
      $('req-plannedReceiveDate').textContent = formatDate(data.plannedReceiveDate);
      $('req-inboundRequestDate').textContent = formatDateTime(data.inboundRequestDate);
      $('req-approvalStatus').innerHTML = getStatusBadge(data.approvalStatus);
      $('req-approveDate').textContent = data.approveDate ? formatDateTime(data.approveDate) : '-';

      // 취소 사유 표시
      if (data.approvalStatus === 'CANCELED' && data.cancelReason) {
        $('req-cancelReason').textContent = data.cancelReason;
        $('cancelReasonSection').style.display = 'block';
      } else {
        $('cancelReasonSection').style.display = 'none';
      }

      $('headerInboundIndex').textContent = '#' + (data.inboundIndex || '-');
      $('headerStatusBadge').innerHTML = getStatusBadge(data.approvalStatus);

      console.log('[displayRequestOverview] updateActionButtons 호출 직전');
      updateActionButtons(data);
      console.log('[displayRequestOverview] updateActionButtons 호출 완료');
    }

    // 상세 품목 목록 렌더링
    function displayDetailList(details, requestStatus) {
      var tbody = $('inboundDetailTableBody');
      var summary = $('detailSummary');

      if (!Array.isArray(details) || details.length == 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 상세 품목이 없습니다.</p></td></tr>';
        summary.textContent = '총 0건의 상세 품목이 있습니다.';
        return;
      }

      var isEditable = function(detail) {
        return (requestStatus == 'APPROVED' && !detail.completeDate);
      };

      var completedCount = 0;
      details.forEach(function(d) {
        if (d.completeDate) completedCount++;
      });

      var rows = details.map(function(detail) {
        var cdt = detail.completeDate ? formatDateTime(detail.completeDate) : '-';
        var completed = !isEditable(detail);
        var readonlyAttr = completed ? 'readonly' : '';

        var html = '<tr>';
        html += '<td><strong style="color: #667eea;">#' + safeHtml(detail.detailIndex) + '</strong></td>';
        html += '<td>';
        html += '<span class="badge bg-light text-dark me-2"><i class="fas fa-warehouse"></i> ' + safeHtml(detail.warehouse_index) + '번</span>';
        html += '<input type="text" class="form-control d-inline-block" style="width: 150px;" ';
        html += 'id="section-' + detail.detailIndex + '" ';
        html += 'value="' + safeHtml(detail.section_index) + '" ';
        html += 'placeholder="A-01-01" ' + readonlyAttr + '>';
        html += '</td>';
        html += '<td>';
        html += '<input type="number" class="form-control d-inline-block" style="width: 100px;" ';
        html += 'id="qty-' + detail.detailIndex + '" ';
        html += 'value="' + safeHtml(detail.receivedQuantity) + '" ';
        html += 'min="0" ' + readonlyAttr + '> <span style="color: #718096;">개</span>';
        html += '</td>';
        html += '<td>' + (completed ? '<span class="completed-badge"><i class="fas fa-check"></i>' + cdt + '</span>' : '<span class="text-muted">미처리</span>') + '</td>';
        html += '<td>';
        if (!completed) {
          html += '<button class="btn btn-modern btn-process btn-sm" onclick="processDetail(' + detail.detailIndex + ', ' + detail.inboundIndex + ')">';
          html += '<i class="fas fa-check"></i> 처리';
          html += '</button>';
        } else {
          html += '<span class="text-success"><i class="fas fa-check-circle"></i> 완료</span>';
        }
        html += '</td>';
        html += '</tr>';
        return html;
      }).join('');

      tbody.innerHTML = rows;
      summary.textContent = '총 ' + details.length + '건의 상세 품목이 있습니다.';

      // 프로그레스 업데이트
      var progress = details.length > 0 ? (completedCount / details.length) * 100 : 0;
      $('progressBar').style.width = progress + '%';
      $('progressText').textContent = completedCount + '/' + details.length + ' 완료';
    }

    // 액션 버튼
    function updateActionButtons(data) {
      console.log('[updateActionButtons] data:', data);
      console.log('[updateActionButtons] approvalStatus:', data.approvalStatus);

      var area = $('requestActions');
      if (!area) {
        console.error('[updateActionButtons] requestActions 요소를 찾을 수 없습니다!');
        return;
      }

      var html = '';
      // PENDING 상태일 때 승인/취소 버튼 표시
      if (data.approvalStatus == 'PENDING') {
        console.log('[updateActionButtons] PENDING 상태 - 승인/취소 버튼 생성');
        html += '<button class="btn btn-modern btn-approve me-2" onclick="approveRequest(' + (Number(data.inboundIndex) || 0) + ')">';
        html += '<i class="fas fa-check"></i> 요청 승인';
        html += '</button>';
        html += '<button class="btn btn-modern btn-cancel me-2" onclick="showCancelModal(' + (Number(data.inboundIndex) || 0) + ')">';
        html += '<i class="fas fa-ban"></i> 요청 취소';
        html += '</button>';
      } else {
        console.log('[updateActionButtons] 상태:', data.approvalStatus, '- 승인/취소 버튼 숨김');
      }

      // 목록으로 버튼은 항상 표시
      html += '<button class="btn btn-modern btn-back" onclick="history.back()"><i class="fas fa-arrow-left"></i> 목록으로</button>';
      console.log('[updateActionButtons] 생성된 HTML:', html);
      area.innerHTML = html;
    }

    // 요청 승인
    window.approveRequest = function(inboundIndex) {
      if (!inboundIndex) return alert('잘못된 요청 번호입니다.');
      if (!confirm('이 입고 요청을 승인하시겠습니까?')) return;

      var url = ctx + '/inbound/admin/request/' + encodeURIComponent(inboundIndex) + '/approve';
      fetch(url, {
        method: 'PUT',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) { return res.json(); })
              .then(function(d) {
                if (d && d.success) {
                  alert(d.message || '승인이 완료되었습니다.');
                  loadInboundDetail(inboundIndex);
                } else {
                  alert((d && d.message) || '승인에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('승인 처리 중 오류가 발생했습니다.');
              });
    };

    // 🔥 취소 모달 표시
    window.showCancelModal = function(inboundIndex) {
      if (!inboundIndex) return alert('잘못된 요청 번호입니다.');
      currentInboundIndex = inboundIndex;
      $('cancelReasonInput').value = '';
      var modal = new bootstrap.Modal($('cancelModal'));
      modal.show();
    };

    // 🔥 취소 확정
    window.confirmCancel = function() {
      var cancelReason = $('cancelReasonInput').value.trim();
      if (!cancelReason) {
        alert('취소 사유를 입력해주세요.');
        return;
      }

      var url = ctx + '/inbound/admin/request/' + encodeURIComponent(currentInboundIndex) + '/cancel';
      fetch(url, {
        method: 'PUT',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({ cancelReason: cancelReason })
      })
              .then(function(res) { return res.json(); })
              .then(function(d) {
                if (d && d.success) {
                  alert(d.message || '요청이 취소되었습니다.');
                  bootstrap.Modal.getInstance($('cancelModal')).hide();
                  loadInboundDetail(currentInboundIndex);
                } else {
                  alert((d && d.message) || '취소 처리에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('취소 처리 중 오류가 발생했습니다.');
              });
    };

    // 상세 처리
    window.processDetail = function(detailIndex, inboundIndex) {
      var section = $('section-' + detailIndex).value;
      var quantity = $('qty-' + detailIndex).value;

      if (!section || section.trim() == "") {
        return alert("입고 위치(구역)를 입력하세요.");
      }
      if (quantity == "" || isNaN(Number(quantity)) || Number(quantity) < 0) {
        return alert("올바른 입고 수량을 입력하세요.");
      }

      var detailData = {
        detailIndex: detailIndex,
        inboundIndex: inboundIndex,
        section_index: section,
        receivedQuantity: Number(quantity)
      };

      var url = ctx + '/inbound/admin/detail/process';
      fetch(url, {
        method: 'PUT',
        headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(detailData)
      })
              .then(function(res) { return res.json(); })
              .then(function(d) {
                if (d && d.success) {
                  alert(d.message || '입고 처리가 완료되었습니다.');
                  loadInboundDetail(inboundIndex);
                } else {
                  alert((d && d.message) || '처리 중 오류가 발생했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('입고 처리 API 호출 중 오류가 발생했습니다.');
              });
    };

    // 메인 데이터 로드
    function loadInboundDetail(inboundIndex) {
      console.log('[loadInboundDetail] 시작 - inboundIndex:', inboundIndex);
      var tbody = $('inboundDetailTableBody');
      tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><div class="loading-spinner" style="margin: 0 auto;"></div><p class="mt-3 text-muted">상세 정보 로딩 중...</p></td></tr>';

      if (!inboundIndex || isNaN(Number(inboundIndex))) {
        console.error('[loadInboundDetail] 잘못된 inboundIndex:', inboundIndex);
        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 2rem; color: #f56565;"></i><p class="mt-3 text-danger">올바른 요청 번호를 찾을 수 없습니다.</p></td></tr>';
        return;
      }

      currentInboundIndex = inboundIndex;
      var url = ctx + '/inbound/admin/request/' + encodeURIComponent(inboundIndex);
      console.log('[loadInboundDetail] API 호출 URL:', url);

      fetch(url, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) {
                console.log('[loadInboundDetail] 응답 상태:', res.status);
                if (res.ok) return res.json();
                return Promise.reject(new Error('HTTP ' + res.status));
              })
              .then(function(data) {
                console.log('[loadInboundDetail] 받은 데이터:', data);
                if (!data) throw new Error('EMPTY_DATA');

                displayRequestOverview(data);
                displayDetailList(data.details, data.approvalStatus);
              })
              .catch(function(err) {
                console.error('[loadInboundDetail] error:', err);
                tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 2rem; color: #f56565;"></i><p class="mt-3 text-danger">상세 정보를 불러오는 중 오류가 발생했습니다.</p></td></tr>';
              });
    }

    // 초기화
    document.addEventListener('DOMContentLoaded', function () {
      try {
        var segs = (location.pathname || '').split('/').filter(Boolean);
        var last = segs[segs.length - 1] || '';
        var inboundIndex = /^[0-9]+$/.test(last) ? last : '';
        loadInboundDetail(inboundIndex);
      } catch (e) {
        console.error('[init] error:', e);
      }
    });
  })();
</script>