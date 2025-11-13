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

  @keyframes slideInRight {
    from {
      opacity: 0;
      transform: translateX(30px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }

  .fade-in-up {
    animation: fadeInUp 0.6s ease-out;
  }

  .slide-in-right {
    animation: slideInRight 0.6s ease-out;
  }

  /* 통계 요약 카드 */
  .summary-card {
    border: none;
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }

  .summary-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
    pointer-events: none;
  }

  .summary-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
  }

  .summary-card.purple {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }

  .summary-card.pink {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
  }

  .summary-card.blue {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: white;
  }

  .summary-card.green {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    color: white;
  }

  .summary-icon {
    font-size: 3rem;
    opacity: 0.3;
    position: absolute;
    right: 1.5rem;
    top: 1.5rem;
  }

  .summary-value {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
  }

  .summary-label {
    font-size: 1rem;
    opacity: 0.9;
    font-weight: 500;
  }

  /* 통계 카드 */
  .stats-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
    transition: all 0.3s ease;
  }

  .stats-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
  }

  .stats-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 1.5rem;
    position: relative;
    overflow: hidden;
  }

  .stats-card .card-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,165.3C1248,171,1344,149,1392,138.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
    background-size: cover;
    opacity: 0.5;
  }

  .stats-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
    position: relative;
    z-index: 1;
  }

  .stats-card .card-body {
    padding: 2rem;
  }

  /* 폼 스타일 */
  .stats-form {
    background: #f8f9fa;
    border-radius: 15px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
  }

  .form-control, .form-select {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.6rem 1rem;
    transition: all 0.3s ease;
  }

  .form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .btn-stats {
    border-radius: 10px;
    padding: 0.6rem 2rem;
    font-weight: 600;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    color: white;
    transition: all 0.3s ease;
  }

  .btn-stats:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    color: white;
  }

  /* 테이블 스타일 */
  .stats-table {
    margin: 0;
  }

  .stats-table thead th {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    color: #2d3748;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1rem;
  }

  .stats-table tbody tr {
    transition: all 0.2s ease;
    border-bottom: 1px solid #e2e8f0;
  }

  .stats-table tbody tr:hover {
    background: linear-gradient(90deg, rgba(102, 126, 234, 0.05) 0%, rgba(102, 126, 234, 0) 100%);
    transform: translateX(5px);
  }

  .stats-table tbody td {
    padding: 1rem;
    vertical-align: middle;
    border: none;
    font-weight: 500;
  }

  /* 데이터 강조 */
  .data-highlight {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    font-weight: 700;
    font-size: 1.1rem;
  }

  /* 로딩 상태 */
  .loading-state {
    text-align: center;
    padding: 3rem;
    color: #718096;
  }

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

  /* 빈 상태 */
  .empty-state {
    text-align: center;
    padding: 3rem;
    color: #a0aec0;
  }

  .empty-state i {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.3;
  }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-chart-line" style="color: #667eea;"></i> 입고 현황 통계
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item"><a href="<c:url value='/inbound/admin/list'/>">입고 요청 목록</a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">통계</li>
      </ul>
    </div>

    <%-- 통계 요약 카드 --%>
    <div class="row mb-4 fade-in-up">
      <div class="col-md-3 mb-3">
        <div class="summary-card purple">
          <i class="fas fa-file-invoice summary-icon"></i>
          <div class="summary-value" id="summaryTotal">-</div>
          <div class="summary-label">총 요청 건수</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="summary-card pink">
          <i class="fas fa-boxes summary-icon"></i>
          <div class="summary-value" id="summaryQuantity">-</div>
          <div class="summary-label">총 요청 수량</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="summary-card blue">
          <i class="fas fa-chart-pie summary-icon"></i>
          <div class="summary-value" id="summaryAverage">-</div>
          <div class="summary-label">평균 요청 수량</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="summary-card green">
          <i class="fas fa-check-double summary-icon"></i>
          <div class="summary-value" id="summaryApproved">-</div>
          <div class="summary-label">승인률</div>
        </div>
      </div>
    </div>

    <div class="row">
      <%-- 기간별 현황 --%>
      <div class="col-md-6 mb-4">
        <div class="card stats-card fade-in-up">
          <div class="card-header">
            <h4 class="card-title">
              <i class="fas fa-calendar-week"></i> 기간별 현황
            </h4>
          </div>
          <div class="card-body">
            <form id="periodForm" class="stats-form">
              <div class="row g-3 align-items-center">
                <div class="col-md-5">
                  <label class="form-label" style="font-weight: 600; font-size: 0.875rem;">
                    <i class="fas fa-calendar-alt" style="color: #667eea;"></i> 시작일
                  </label>
                  <input type="date" id="fromDate" class="form-control" required>
                </div>
                <div class="col-md-5">
                  <label class="form-label" style="font-weight: 600; font-size: 0.875rem;">
                    <i class="fas fa-calendar-check" style="color: #667eea;"></i> 종료일
                  </label>
                  <input type="date" id="toDate" class="form-control" required>
                </div>
                <div class="col-md-2">
                  <button type="submit" class="btn btn-stats w-100 mt-4">
                    <i class="fas fa-search"></i>
                  </button>
                </div>
              </div>
            </form>

            <div class="table-responsive">
              <table class="table stats-table">
                <thead>
                <tr>
                  <th><i class="fas fa-calendar"></i> 날짜</th>
                  <th><i class="fas fa-flag"></i> 상태</th>
                  <th><i class="fas fa-hashtag"></i> 건수</th>
                  <th><i class="fas fa-box"></i> 수량</th>
                </tr>
                </thead>
                <tbody id="periodStatsBody">
                <tr>
                  <td colspan="4" class="loading-state">
                    <div class="loading-spinner"></div>
                    <p class="mt-3">기간을 선택하고 조회하세요</p>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <%-- 월별 현황 --%>
      <div class="col-md-6 mb-4">
        <div class="card stats-card slide-in-right">
          <div class="card-header">
            <h4 class="card-title">
              <i class="fas fa-calendar-alt"></i> 월별 현황
            </h4>
          </div>
          <div class="card-body">
            <form id="monthForm" class="stats-form">
              <div class="row g-3 align-items-center">
                <div class="col-md-4">
                  <label class="form-label" style="font-weight: 600; font-size: 0.875rem;">
                    <i class="fas fa-calendar" style="color: #667eea;"></i> 연도
                  </label>
                  <input type="number" id="year" class="form-control" min="2000" max="2099" required>
                </div>
                <div class="col-md-4">
                  <label class="form-label" style="font-weight: 600; font-size: 0.875rem;">
                    <i class="fas fa-calendar-day" style="color: #667eea;"></i> 월
                  </label>
                  <input type="number" id="month" class="form-control" min="1" max="12" required>
                </div>
                <div class="col-md-4">
                  <button type="submit" class="btn btn-stats w-100 mt-4">
                    <i class="fas fa-search"></i> 조회
                  </button>
                </div>
              </div>
            </form>

            <div class="table-responsive">
              <table class="table stats-table">
                <thead>
                <tr>
                  <th><i class="fas fa-flag"></i> 상태</th>
                  <th><i class="fas fa-hashtag"></i> 건수</th>
                  <th><i class="fas fa-box"></i> 수량</th>
                </tr>
                </thead>
                <tbody id="monthStatsBody">
                <tr>
                  <td colspan="3" class="loading-state">
                    <div class="loading-spinner"></div>
                    <p class="mt-3">연도와 월을 선택하고 조회하세요</p>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
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
    var $ = function(id) { return document.getElementById(id); };
    var safeHtml = function(s) {
      var str = (s != null && s != undefined) ? String(s) : '';
      return str.replace(/[&<>"']/g, function(m) {
        var map = {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'};
        return map[m];
      });
    };

    // 상태 배지
    function getStatusBadge(status) {
      var badges = {
        'PENDING': '<span class="badge" style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); color: white; padding: 0.4rem 0.8rem; border-radius: 15px; font-weight: 600;"><i class="fas fa-clock"></i> 대기중</span>',
        'APPROVED': '<span class="badge" style="background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%); color: white; padding: 0.4rem 0.8rem; border-radius: 15px; font-weight: 600;"><i class="fas fa-check-circle"></i> 승인됨</span>',
        'REJECTED': '<span class="badge" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white; padding: 0.4rem 0.8rem; border-radius: 15px; font-weight: 600;"><i class="fas fa-times-circle"></i> 거부됨</span>',
        'CANCELED': '<span class="badge" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); color: white; padding: 0.4rem 0.8rem; border-radius: 15px; font-weight: 600;"><i class="fas fa-ban"></i> 취소됨</span>'
      };
      return badges[status] || safeHtml(status || '-');
    }

    // 통계 요약 업데이트
    function updateSummary(periodData, monthData) {
      var totalCount = 0;
      var totalQty = 0;
      var approvedCount = 0;

      var allData = (periodData || []).concat(monthData || []);

      allData.forEach(function(item) {
        var count = parseInt(item.detailCount || item.detail_count || 0);
        var qty = parseInt(item.totalReceivedQuantity || item.total_received_quantity || 0);
        totalCount += count;
        totalQty += qty;

        if ((item.approvalStatus || item.approval_status) == 'APPROVED') {
          approvedCount += count;
        }
      });

      var avgQty = totalCount > 0 ? Math.round(totalQty / totalCount) : 0;
      var approvalRate = totalCount > 0 ? Math.round((approvedCount / totalCount) * 100) : 0;

      $('summaryTotal').textContent = totalCount.toLocaleString();
      $('summaryQuantity').textContent = totalQty.toLocaleString();
      $('summaryAverage').textContent = avgQty.toLocaleString();
      $('summaryApproved').textContent = approvalRate + '%';
    }

    // 통계 데이터 로드
    function loadStats() {
      var tbodyPeriod = $('periodStatsBody');
      var tbodyMonth = $('monthStatsBody');

      var params = new URLSearchParams({
        fromDate: $('fromDate').value,
        toDate: $('toDate').value,
        year: $('year').value,
        month: $('month').value
      });

      tbodyPeriod.innerHTML = '<tr><td colspan="4" class="loading-state"><div class="loading-spinner"></div><p class="mt-3">데이터를 불러오는 중...</p></td></tr>';
      tbodyMonth.innerHTML = '<tr><td colspan="3" class="loading-state"><div class="loading-spinner"></div><p class="mt-3">데이터를 불러오는 중...</p></td></tr>';

      var url = ctx + '/inbound/admin/stats/data?' + params.toString();

      fetch(url, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) {
                if (res.ok) return res.json();
                return Promise.reject(new Error('HTTP ' + res.status));
              })
              .then(function(data) {
                displayStatsTable(tbodyPeriod, data.periodList, ['date', 'status', 'count', 'qty']);
                displayStatsTable(tbodyMonth, data.monthList, ['status', 'count', 'qty']);
                updateSummary(data.periodList, data.monthList);
              })
              .catch(function(err) {
                console.error('[loadStats] error:', err);
                tbodyPeriod.innerHTML = '<tr><td colspan="4" class="empty-state"><i class="fas fa-exclamation-circle"></i><p>데이터를 불러올 수 없습니다</p></td></tr>';
                tbodyMonth.innerHTML = '<tr><td colspan="3" class="empty-state"><i class="fas fa-exclamation-circle"></i><p>데이터를 불러올 수 없습니다</p></td></tr>';
              });
    }

    // 통계 테이블 렌더링
    function displayStatsTable(tbody, list, columns) {
      if (!Array.isArray(list) || list.length == 0) {
        tbody.innerHTML = '<tr><td colspan="' + columns.length + '" class="empty-state"><i class="fas fa-inbox"></i><p>데이터가 없습니다</p></td></tr>';
        return;
      }

      var rows = list.map(function(stat) {
        var html = '<tr>';

        if (columns.indexOf('date') >= 0) {
          html += '<td><strong>' + safeHtml(stat.inboundRequestDate || stat.inbound_request_date || '-') + '</strong></td>';
        }
        if (columns.indexOf('status') >= 0) {
          html += '<td>' + getStatusBadge(stat.approvalStatus || stat.approval_status) + '</td>';
        }
        if (columns.indexOf('count') >= 0) {
          html += '<td><span class="data-highlight">' + safeHtml(stat.detailCount || stat.detail_count || 0) + ' 건</span></td>';
        }
        if (columns.indexOf('qty') >= 0) {
          html += '<td><span class="data-highlight">' + safeHtml(stat.totalReceivedQuantity || stat.total_received_quantity || 0) + ' 개</span></td>';
        }

        html += '</tr>';
        return html;
      }).join('');

      tbody.innerHTML = rows;
    }

    // 이벤트 리스너
    document.addEventListener('DOMContentLoaded', function () {
      var now = new Date();
      var today = now.toISOString().split('T')[0];
      var weekAgoDate = new Date(now);
      weekAgoDate.setDate(weekAgoDate.getDate() - 7);
      var weekAgo = weekAgoDate.toISOString().split('T')[0];

      $('fromDate').value = weekAgo;
      $('toDate').value = today;
      $('year').value = new Date().getFullYear();
      $('month').value = new Date().getMonth() + 1;

      $('periodForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadStats();
      });

      $('monthForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadStats();
      });

      loadStats();
    });
  })();
</script>
