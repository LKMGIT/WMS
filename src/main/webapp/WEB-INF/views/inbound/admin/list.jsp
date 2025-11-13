<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 템플릿 시작 --%>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* 애니메이션 효과 (기존 유지) */
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

  .fade-in-up {
    animation: fadeInUp 0.6s ease-out;
  }

  /* 통계 카드 스타일 (기존 유지) */
  .stats-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
    overflow: hidden;
  }

  .stats-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
  }

  .stats-card .card-body {
    padding: 1.5rem;
  }

  .stats-icon {
    width: 60px;
    height: 60px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    margin-bottom: 1rem;
  }

  .stats-icon.blue {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }

  .stats-icon.green {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
  }

  .stats-icon.orange {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: white;
  }

  .stats-icon.purple {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    color: white;
  }

  .stats-number {
    font-size: 2rem;
    font-weight: 700;
    color: #2d3748;
    margin: 0.5rem 0;
  }

  .stats-label {
    font-size: 0.875rem;
    color: #718096;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  /* 검색 카드 스타일 (기존 유지) */
  .search-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .search-card .card-body {
    padding: 2rem;
  }

  /* 폼 스타일 개선 (기존 유지) */
  .form-control, .form-select {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.6rem 1rem;
    transition: all 0.3s ease;
  }

  .form-control:focus, .form-select:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .btn-search {
    border-radius: 10px;
    padding: 0.6rem 2rem;
    font-weight: 600;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    transition: all 0.3s ease;
  }

  .btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
  }

  /* 테이블 카드 스타일 (기존 재사용) */
  .table-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .table-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 1.5rem;
  }

  .table-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 600;
  }

  /* 테이블 스타일 개선 (기존 재사용) */
  .modern-table {
    margin: 0;
  }

  .modern-table thead th {
    background-color: #f7fafc;
    color: #4a5568;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1rem;
  }

  .modern-table tbody tr {
    transition: all 0.3s ease;
    border-bottom: 1px solid #e2e8f0;
  }

  .modern-table tbody tr:hover {
    background-color: #f7fafc;
  }

  .modern-table tbody td {
    padding: 1rem;
    vertical-align: middle;
    border: none;
  }

  .modern-table tbody td a {
    color: #667eea;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
  }

  .modern-table tbody td a:hover {
    color: #764ba2;
    text-decoration: underline;
  }

  /* 배지 스타일 개선 (기존 재사용) */
  .badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
  }
  .badge.bg-warning {
    background: linear-gradient(135deg, #f6d365 0%, #fda085 100%) !important;
    color: #fff;
  }
  .badge.bg-success {
    background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%) !important;
    color: #fff;
  }
  .badge.bg-danger {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%) !important;
    color: #fff;
  }
  .badge.bg-secondary {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%) !important;
    color: #fff;
  }

  /* 로딩 스피너 (기존 재사용) */
  .loading-spinner {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 3px solid rgba(102, 126, 234, 0.3);
    border-radius: 50%;
    border-top-color: #667eea;
    animation: spin 1s ease-in-out infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-warehouse" style="color: #667eea;"></i> 입고 요청 목록
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">입고 요청 목록</li>
      </ul>
    </div>

    <div class="row mb-4 fade-in-up" id="statsCards">
      <div class="col-md-3 mb-3">
        <div class="card stats-card">
          <div class="card-body">
            <div class="stats-icon blue">
              <i class="fas fa-boxes"></i>
            </div>
            <div class="stats-number" id="totalCount">-</div>
            <div class="stats-label">전체 요청</div>
          </div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="card stats-card">
          <div class="card-body">
            <div class="stats-icon green">
              <i class="fas fa-check-circle"></i>
            </div>
            <div class="stats-number" id="approvedCount">-</div>
            <div class="stats-label">승인됨</div>
          </div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="card stats-card">
          <div class="card-body">
            <div class="stats-icon orange">
              <i class="fas fa-clock"></i>
            </div>
            <div class="stats-number" id="pendingCount">-</div>
            <div class="stats-label">대기중</div>
          </div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="card stats-card">
          <div class="card-body">
            <div class="stats-icon purple">
              <i class="fas fa-ban"></i>
            </div>
            <div class="stats-number" id="canceledCount">-</div>
            <div class="stats-label">취소됨</div>
          </div>
        </div>
      </div>
    </div>

    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-2">
            <label for="fromDate" class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-calendar-alt" style="color: #667eea;"></i> 요청일자
            </label>
            <input type="date" id="fromDate" name="fromDate" class="form-control">
          </div>
          <div class="col-md-2">
            <label for="toDate" class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-calendar-check" style="color: #667eea;"></i> 종료일자
            </label>
            <input type="date" id="toDate" name="toDate" class="form-control">
          </div>
          <div class="col-md-2">
            <label for="warehouseSelect" class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-warehouse" style="color: #667eea;"></i> 창고
            </label>
            <select id="warehouseSelect" name="warehouseIndex" class="form-select">
              <option value="">전체 창고</option>
              <option value="1">1번 창고</option>
              <option value="2">2번 창고</option>
              <option value="3">3번 창고</option>
            </select>
          </div>
          <div class="col-md-2">
            <label for="statusSelect" class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-flag" style="color: #667eea;"></i> 상태
            </label>
            <select id="statusSelect" name="approvalStatus" class="form-select">
              <option value="">전체 상태</option>
              <option value="APPROVED">승인됨</option>
              <option value="REJECTED">거부됨</option>
              <option value="CANCELED">취소됨</option>
            </select>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-primary btn-search w-100">
              <i class="fas fa-search"></i> 검색
            </button>
          </div>
          <div class="col-md-2">
            <button type="button" class="btn btn-outline-secondary w-100" onclick="resetSearch()" style="border-radius: 10px; font-weight: 600;">
              <i class="fas fa-redo"></i> 초기화
            </button>
          </div>
        </form>
      </div>
    </div>

    <div class="row">

      <div class="col-md-6">
        <div class="card table-card fade-in-up">
          <div class="card-header" style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);">
            <h4 class="card-title mb-0">
              <i class="fas fa-clock"></i> 대기중인 요청 (<span id="pendingCountHeader">0</span>)
            </h4>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table modern-table">
                <thead>
                <tr>
                  <th><i class="fas fa-hashtag"></i> 요청번호</th>
                  <th><i class="fas fa-box"></i> 요청수량</th>
                  <th><i class="fas fa-calendar"></i> 요청일자</th>
                  <th><i class="fas fa-warehouse"></i> 창고</th>
                </tr>
                </thead>
                <tbody id="pendingListTableBody">
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="card table-card fade-in-up">
          <div class="card-header" style="background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);">
            <h4 class="card-title mb-0">
              <i class="fas fa-check-double"></i> 처리된 요청 (<span id="processedCountHeader">0</span>)
            </h4>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table modern-table">
                <thead>
                <tr>
                  <th><i class="fas fa-hashtag"></i> 요청번호</th>
                  <th><i class="fas fa-flag"></i> 상태</th>
                  <th><i class="fas fa-calendar-check"></i> 희망입고일</th>
                  <th><i class="fas fa-warehouse"></i> 창고</th>
                </tr>
                </thead>
                <tbody id="processedListTableBody">
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

    </div> </div>
</div>

<%-- 템플릿 끝 --%>
<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var $ = function(id) { return document.getElementById(id); };
    var safeHtml = function(s) {
      var str = (s != null && s != undefined) ? String(s) : '';
      return str.replace(/[&<>"']/g, function(m) {
        var map = {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'};
        return map[m];
      });
    };

    // [수정] 비동기 통신 결과를 저장할 변수
    var totals = {
      pending: -1,
      processed: -1,
      approved: -1,
      canceled: -1,
      all: -1
    };

    // 날짜/시간 포매터
    function formatDateTime(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (Array.isArray(dateStr)) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return dateStr[0] + '-' + pad(dateStr[1]) + '-' + pad(dateStr[2]) + ' ' + pad(dateStr[3] || 0) + ':' + pad(dateStr[4] || 0);
      }
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
      }
      return String(dateStr);
    }

    // 날짜 포매터
    function formatDate(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (Array.isArray(dateStr)) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return dateStr[0] + '-' + pad(dateStr[1]) + '-' + pad(dateStr[2]);
      }
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
      }
      return String(dateStr);
    }

    // 상태 배지 포매터
    function getStatusBadge(status) {
      var badges = {
        'APPROVED': '<span class="badge bg-success"><i class="fas fa-check-circle"></i> 승인됨</span>',
        'REJECTED': '<span class="badge bg-danger"><i class="fas fa-times-circle"></i> 거부됨</span>',
        'CANCELED': '<span class="badge bg-secondary"><i class="fas fa-ban"></i> 취소됨</span>'
      };
      return badges[status] || safeHtml(status || '-');
    }

    // [신규] API 호출 (카운트만 가져오는 용도)
    function fetchCount(statusQuery, totalKey) {
      var params = new URLSearchParams({ size: 1 }); // 데이터 1개만 요청 (count만 필요)

      if(statusQuery) {
        params.set('approvalStatus', statusQuery);
      }
      // statusQuery가 없으면 '전체' (approvalStatus 파라미터 없음)

      var url = ctx + '/inbound/admin/requests?' + params.toString();

      fetch(url, { method: 'GET', headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
              .then(res => res.json())
              .then(data => {
                totals[totalKey] = data.total || 0;
                updateTopCards(); // 카운트가 도착할 때마다 업데이트 시도
              })
              .catch(err => {
                console.error('Error fetching count for ' + totalKey, err);
                totals[totalKey] = 0; // 에러 시 0으로
                updateTopCards();
              });
    }

    // [신규] 상단 통계 카드 업데이트
    // 5개의 API 호출이 모두 완료되어야 정확한 값이 나옴
    function updateTopCards() {
      if(totals.pending > -1) {
        $('pendingCount').textContent = totals.pending;
      }
      if(totals.approved > -1) {
        $('approvedCount').textContent = totals.approved;
      }
      if(totals.canceled > -1) {
        $('canceledCount').textContent = totals.canceled;
      }
      // '전체 요청'은 '대기중'과 '처리됨'의 합계로 표시
      if (totals.pending > -1 && totals.processed > -1) {
        $('totalCount').textContent = totals.pending + totals.processed;
      }
      // (참고: totals.all 은 '전체 DB' 카운트로, pending+processed와 같아야 함)
    }

    // API 호출 및 테이블 렌더링 공통 함수
    function fetchAndRenderList(tbodyId, apiUrl, renderFunction, callback) {
      var tbody = $(tbodyId);
      tbody.innerHTML = '<tr><td colspan="4" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">데이터 로딩 중...</p></td></tr>';

      fetch(apiUrl, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) {
                if (res.ok) return res.json();
                return Promise.reject(new Error('HTTP ' + res.status));
              })
              .then(function(data) {
                var list = data.list;
                var total = data.total || 0;

                if (!Array.isArray(list) || list.length === 0) {
                  tbody.innerHTML = '<tr><td colspan="4" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 2rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">데이터가 없습니다.</p></td></tr>';
                } else {
                  tbody.innerHTML = list.map(renderFunction).join('');
                }

                if (callback) callback(total); // 콜백으로 총 개수 전달
              })
              .catch(function(err) {
                console.error('Error loading list for ' + tbodyId + ':', err);
                tbody.innerHTML = '<tr><td colspan="4" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 2rem; color: #f56565;"></i><p class="mt-3 text-danger">오류 발생</p></td></tr>';
                if (callback) callback(0); // 에러 시 0
              });
    }

    // '대기중' 목록 렌더링 함수
    function renderPendingRow(req) {
      var detailUrl = ctx + '/inbound/admin/detail/' + (req.inboundIndex || '-');
      var requestQty = req.inboundRequestQuantity || 0;
      var requestDate = req.inboundRequestDate || '-';
      var warehouseIdx = req.warehouseIndex || '-';

      return '<tr>' +
              '<td><a href="' + detailUrl + '"><i class="fas fa-file-alt"></i> #' + safeHtml(req.inboundIndex) + '</a></td>' +
              '<td><strong>' + safeHtml(requestQty) + '</strong> 개</td>' +
              '<td>' + formatDateTime(requestDate) + '</td>' +
              '<td><span class="badge bg-light text-dark"><i class="fas fa-warehouse"></i> ' + safeHtml(warehouseIdx) + '</span></td>' +
              '</tr>';
    }

    // '처리됨' 목록 렌더링 함수
    function renderProcessedRow(req) {
      var detailUrl = ctx + '/inbound/admin/detail/' + (req.inboundIndex || '-');
      var approvalStat = req.approvalStatus || '-';
      var receiveDate = req.plannedReceiveDate || '-';
      var warehouseIdx = req.warehouseIndex || '-';

      return '<tr>' +
              '<td><a href="' + detailUrl + '"><i class="fas fa-file-alt"></i> #' + safeHtml(req.inboundIndex) + '</a></td>' +
              '<td>' + getStatusBadge(approvalStat) + '</td>' +
              '<td>' + formatDate(receiveDate) + '</td>' +
              '<td><span class="badge bg-light text-dark"><i class="fas fa-warehouse"></i> ' + safeHtml(warehouseIdx) + '</span></td>' +
              '</tr>';
    }

    // '대기중' 목록 로드 함수 (검색 조건 X)
    function loadPendingList() {
      var pendingApiUrl = ctx + '/inbound/admin/requests?approvalStatus=PENDING&size=10';
      fetchAndRenderList('pendingListTableBody', pendingApiUrl, renderPendingRow, function(total) {
        $('pendingCountHeader').textContent = total;
        // [수정] '대기중' 카드는 DB 전체 카운트(totals.pending)를 쓰므로 여기선 업데이트 안 함
      });
    }

    // '처리된' 목록 로드 함수 (검색 조건 O)
    function loadProcessedList() {
      var fromDate = $('fromDate').value;
      var toDate = $('toDate').value;
      var warehouseIndex = $('warehouseSelect').value;
      var approvalStatus = $('statusSelect').value;

      var params = new URLSearchParams({
        size: 10,
        fromDate: fromDate,
        toDate: toDate,
        warehouseIndex: warehouseIndex,
        approvalStatus: approvalStatus || 'PROCESSED' // 값이 없으면 'PROCESSED'
      });

      var processedApiUrl = ctx + '/inbound/admin/requests?' + params.toString();

      fetchAndRenderList('processedListTableBody', processedApiUrl, renderProcessedRow, function(total) {
        $('processedCountHeader').textContent = total;
        // [수정] 상단 통계 카드는 이 함수의 검색 결과와 무관하므로 업데이트 로직 제거
      });
    }

    // [수정] 검색 초기화
    window.resetSearch = function() {
      $('fromDate').value = '';
      $('toDate').value = '';
      $('warehouseSelect').value = '';
      $('statusSelect').value = ''; // '전체 상태'

      loadProcessedList();
      // 처리된 목록만 검색 조건으로 새로고침
    };

    // [수정] 이벤트 리스너
    document.addEventListener('DOMContentLoaded', function () {

      // [신규] 페이지 로드 시, 4개의 통계 카드용 카운트를 별도로 조회
      fetchCount('PENDING', 'pending');
      fetchCount('APPROVED', 'approved');
      fetchCount('CANCELED', 'canceled');
      fetchCount('PROCESSED', 'processed');
      // fetchCount(null, 'all'); // (옵션) '전체'도 필요시

      // [수정] '검색' 버튼은 '처리된 목록'만 새로고침
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadProcessedList();
      });

      // [수정] 페이지 첫 로드 시, 두 목록을 각각 로드
      loadPendingList();   // '대기중' 목록 (검색과 무관)
      loadProcessedList(); // '처리된' 목록 (기본 조건)
    });
  })();
</script>