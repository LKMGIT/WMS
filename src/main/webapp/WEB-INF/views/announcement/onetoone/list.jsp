<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .fade-in-up { animation: fadeInUp 0.6s ease-out; }

  /* 통계 카드 */
  .stats-card {
    border: none;
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }

  .stats-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
    pointer-events: none;
  }

  .stats-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
  }

  .stats-card.pink {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
  }

  .stats-card.cyan {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: white;
  }

  .stats-card.green {
    background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
    color: white;
  }

  .stats-card.orange {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
  }

  .stats-icon {
    font-size: 3rem;
    opacity: 0.3;
    position: absolute;
    right: 1.5rem;
    top: 1.5rem;
  }

  .stats-value {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
  }

  .stats-label {
    font-size: 1rem;
    opacity: 0.9;
    font-weight: 500;
  }

  /* 검색 카드 */
  .search-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .search-card .card-body { padding: 2rem; }

  .form-control, .form-select {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.6rem 1rem;
    transition: all 0.3s ease;
  }

  .form-control:focus, .form-select:focus {
    border-color: #f093fb;
    box-shadow: 0 0 0 3px rgba(240, 147, 251, 0.1);
  }

  .btn-search {
    border-radius: 10px;
    padding: 0.6rem 2rem;
    font-weight: 600;
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    border: none;
    color: white;
    transition: all 0.3s ease;
  }

  .btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(240, 147, 251, 0.4);
    color: white;
  }

  /* 문의 테이블 */
  .request-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
  }

  .request-card .card-header {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    border: none;
    padding: 1.5rem;
  }

  .request-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  .request-table {
    margin: 0;
  }

  .request-table thead th {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    color: #2d3748;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1.25rem 1rem;
  }

  .request-table tbody tr {
    transition: all 0.3s ease;
    border-bottom: 1px solid #e2e8f0;
    cursor: pointer;
  }

  .request-table tbody tr:hover {
    background: linear-gradient(90deg, rgba(240, 147, 251, 0.05) 0%, rgba(240, 147, 251, 0) 100%);
    transform: translateX(5px);
  }

  .request-table tbody td {
    padding: 1.25rem 1rem;
    vertical-align: middle;
    border: none;
  }

  .request-title {
    font-weight: 600;
    color: #2d3748;
  }

  .request-title:hover {
    color: #f093fb;
  }

  .status-badge {
    display: inline-block;
    padding: 0.4rem 1rem;
    border-radius: 15px;
    font-size: 0.75rem;
    font-weight: 600;
  }

  .status-pending {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
  }

  .status-answered {
    background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
    color: white;
  }

  .type-badge {
    display: inline-block;
    padding: 0.3rem 0.8rem;
    border-radius: 15px;
    font-size: 0.75rem;
    font-weight: 600;
    background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
    color: #4a5568;
  }

  .btn-delete {
    padding: 0.4rem 0.8rem;
    border-radius: 8px;
    font-size: 0.75rem;
    font-weight: 600;
    background: linear-gradient(135deg, #f56565 0%, #ed8936 100%);
    color: white;
    border: none;
    transition: all 0.3s ease;
  }

  .btn-delete:hover {
    transform: translateY(-2px);
    box-shadow: 0 3px 10px rgba(245, 101, 101, 0.4);
  }

  /* 페이징 */
  .pagination {
    gap: 0.5rem;
  }

  .pagination .page-item .page-link {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    color: #f093fb;
    font-weight: 600;
    padding: 0.5rem 1rem;
    transition: all 0.3s ease;
  }

  .pagination .page-item .page-link:hover {
    background-color: #f093fb;
    color: white;
    border-color: #f093fb;
  }

  .pagination .page-item.active .page-link {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    border-color: #f093fb;
  }

  .loading-spinner {
    display: inline-block;
    width: 40px;
    height: 40px;
    border: 4px solid rgba(240, 147, 251, 0.2);
    border-radius: 50%;
    border-top-color: #f093fb;
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
        <i class="fas fa-headset" style="color: #f093fb;"></i> 1:1 문의 관리
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">1:1 문의 관리</li>
      </ul>
    </div>

    <!-- 통계 -->
    <div class="row mb-4 fade-in-up">
      <div class="col-md-3 mb-3">
        <div class="stats-card pink">
          <i class="fas fa-envelope stats-icon"></i>
          <div class="stats-value" id="totalCount">0</div>
          <div class="stats-label">전체 문의</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card orange">
          <i class="fas fa-clock stats-icon"></i>
          <div class="stats-value" id="pendingCount">0</div>
          <div class="stats-label">답변 대기</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card green">
          <i class="fas fa-check-circle stats-icon"></i>
          <div class="stats-value" id="answeredCount">0</div>
          <div class="stats-label">답변 완료</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card cyan">
          <i class="fas fa-chart-line stats-icon"></i>
          <div class="stats-value" id="responseRate">0%</div>
          <div class="stats-label">답변률</div>
        </div>
      </div>
    </div>

    <!-- 검색 -->
    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-3">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-filter" style="color: #f093fb;"></i> 답변 상태
            </label>
            <select id="statusSelect" class="form-select">
              <option value="">전체</option>
              <option value="PENDING">답변 대기</option>
              <option value="ANSWERED">답변 완료</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-search" style="color: #f093fb;"></i> 검색어
            </label>
            <input type="text" id="keyword" class="form-control" placeholder="제목으로 검색">
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-search w-100">
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

    <!-- 문의 목록 -->
    <div class="card request-card fade-in-up">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list-alt"></i> 문의 목록</h4>
          <span id="listSummary" style="color: rgba(255,255,255,0.9);">총 0건</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table request-table">
            <thead>
            <tr>
              <th style="width: 8%;"><i class="fas fa-hashtag"></i> 번호</th>
              <th style="width: 10%;"><i class="fas fa-flag"></i> 상태</th>
              <th style="width: 12%;"><i class="fas fa-tag"></i> 유형</th>
              <th><i class="fas fa-file-alt"></i> 제목</th>
              <th style="width: 10%;"><i class="fas fa-user"></i> 작성자</th>
              <th style="width: 12%;"><i class="fas fa-calendar"></i> 작성일</th>
              <th style="width: 8%;"><i class="fas fa-cog"></i> 관리</th>
            </tr>
            </thead>
            <tbody id="requestListBody">
            <tr>
              <td colspan="7" class="text-center py-5">
                <div class="loading-spinner"></div>
                <p class="mt-3 text-muted">문의를 불러오는 중입니다...</p>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer bg-white" style="border-top: 1px solid #e2e8f0; padding: 1.5rem;">
        <div id="paginationArea"></div>
      </div>
    </div>

  </div>
</div>

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

    function formatDateTime(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
      }
      return String(dateStr);
    }

    function loadRequests(page) {
      if (page == undefined) page = 1;
      var tbody = $('requestListBody');
      tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">문의를 불러오는 중입니다...</p></td></tr>';

      var keyword = $('keyword').value;
      var status = $('statusSelect').value;
      var url = ctx + '/announcement/onetoone/list?keyword=' + encodeURIComponent(keyword) + '&status=' + encodeURIComponent(status) + '&page=' + page;

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
                displayRequests(data);
                updateStats(data);
              })
              .catch(function(err) {
                console.error('[loadRequests] error:', err);
                tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">문의를 불러오는 중 오류가 발생했습니다.</p></td></tr>';
              });
    }

    function displayRequests(data) {
      var tbody = $('requestListBody');
      var list = data.list || data;

      if (!Array.isArray(list) || list.length == 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 문의가 없습니다.</p></td></tr>';
        $('listSummary').textContent = '총 0건';
        return;
      }

      var html = '';
      list.forEach(function(req) {
        var requestIndex = req.requestIndex || req.request_index;
        var title = req.rTitle || req.r_title || '제목 없음';
        var status = req.rStatus || req.r_status || 'PENDING';
        var type = req.rType || req.r_type || '-';
        var createAt = req.rCreateAt || req.r_create_at;
        var userIndex = req.userIndex || req.user_index || '-';

        var statusBadge = status == 'ANSWERED' ?
                '<span class="status-badge status-answered"><i class="fas fa-check-circle"></i> 답변완료</span>' :
                '<span class="status-badge status-pending"><i class="fas fa-clock"></i> 답변대기</span>';

        html += '<tr onclick="goToDetail(' + requestIndex + ')">';
        html += '<td><strong>' + safeHtml(requestIndex) + '</strong></td>';
        html += '<td>' + statusBadge + '</td>';
        html += '<td><span class="type-badge">' + safeHtml(type) + '</span></td>';
        html += '<td class="request-title">' + safeHtml(title) + '</td>';
        html += '<td>사용자 #' + safeHtml(userIndex) + '</td>';
        html += '<td>' + formatDateTime(createAt) + '</td>';
        html += '<td><button class="btn btn-delete" onclick="deleteRequest(event, ' + requestIndex + ')"><i class="fas fa-trash"></i></button></td>';
        html += '</tr>';
      });

      tbody.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    function updateStats(data) {
      var list = data.list || data;
      var total = Array.isArray(list) ? list.length : 0;
      var pending = 0, answered = 0;

      if (Array.isArray(list)) {
        list.forEach(function(req) {
          var status = req.rStatus || req.r_status;
          if (status == 'PENDING') pending++;
          if (status == 'ANSWERED') answered++;
        });
      }

      var rate = total > 0 ? Math.round((answered / total) * 100) : 0;

      $('totalCount').textContent = total;
      $('pendingCount').textContent = pending;
      $('answeredCount').textContent = answered;
      $('responseRate').textContent = rate + '%';
    }

    window.goToDetail = function(requestIndex) {
      location.href = ctx + '/announcement/onetoone/detail/' + requestIndex;
    };

    window.deleteRequest = function(e, requestIndex) {
      e.stopPropagation();
      if (!confirm('이 문의를 삭제하시겠습니까?')) return;

      var url = ctx + '/announcement/onetoone/' + requestIndex;

      fetch(url, {
        method: 'DELETE',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) { return res.json(); })
              .then(function(data) {
                if (data && data.success) {
                  alert('문의가 삭제되었습니다.');
                  loadRequests(1);
                } else {
                  alert(data.message || '삭제에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('삭제 중 오류가 발생했습니다.');
              });
    };

    window.resetSearch = function() {
      $('keyword').value = '';
      $('statusSelect').value = '';
      loadRequests(1);
    };

    document.addEventListener('DOMContentLoaded', function () {
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadRequests(1);
      });

      loadRequests(1);
    });
  })();
</script>
