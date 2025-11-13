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

  .stats-card.blue {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }

  .stats-card.green {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
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
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .btn-search {
    border-radius: 10px;
    padding: 0.6rem 2rem;
    font-weight: 600;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    color: white;
    transition: all 0.3s ease;
  }

  .btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    color: white;
  }

  /* 공지사항 카드 */
  .notice-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .notice-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 1.5rem;
  }

  .notice-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  /* 공지사항 아이템 */
  .notice-item {
    padding: 1.5rem;
    border-bottom: 1px solid #e2e8f0;
    transition: all 0.3s ease;
    cursor: pointer;
  }

  .notice-item:hover {
    background: linear-gradient(90deg, rgba(102, 126, 234, 0.05) 0%, rgba(102, 126, 234, 0) 100%);
    transform: translateX(5px);
  }

  .notice-item.important {
    background: linear-gradient(135deg, #fff5f5 0%, #ffe5e5 100%);
    border-left: 5px solid #f56565;
  }

  .notice-title {
    font-size: 1.1rem;
    font-weight: 700;
    color: #2d3748;
    margin-bottom: 0.5rem;
  }

  .notice-meta {
    font-size: 0.875rem;
    color: #718096;
    display: flex;
    gap: 1rem;
    align-items: center;
  }

  .priority-badge {
    display: inline-block;
    padding: 0.3rem 0.8rem;
    border-radius: 15px;
    font-size: 0.75rem;
    font-weight: 600;
  }

  .priority-important {
    background: linear-gradient(135deg, #f56565 0%, #ed8936 100%);
    color: white;
  }

  .priority-normal {
    background: #e2e8f0;
    color: #4a5568;
  }

  /* 버튼 */
  .btn-modern {
    border-radius: 10px;
    padding: 0.6rem 1.5rem;
    font-weight: 600;
    transition: all 0.3s ease;
    border: none;
  }

  .btn-create {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    color: white;
  }

  .btn-create:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(67, 233, 123, 0.4);
    color: white;
  }

  /* 로딩 */
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

  /* 페이지네이션 */
  .pagination {
    gap: 0.5rem;
  }

  .pagination .page-item .page-link {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    color: #667eea;
    font-weight: 600;
    padding: 0.5rem 1rem;
    transition: all 0.3s ease;
  }

  .pagination .page-item .page-link:hover {
    background-color: #667eea;
    color: white;
    border-color: #667eea;
    transform: translateY(-2px);
  }

  .pagination .page-item.active .page-link {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-color: #667eea;
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
  }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-bullhorn" style="color: #667eea;"></i> 공지사항
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">공지사항</li>
      </ul>
    </div>

    <!-- 통계 카드 -->
    <div class="row mb-4 fade-in-up">
      <div class="col-md-4 mb-3">
        <div class="stats-card blue">
          <i class="fas fa-bell stats-icon"></i>
          <div class="stats-value" id="totalCount">0</div>
          <div class="stats-label">전체 공지</div>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="stats-card orange">
          <i class="fas fa-exclamation-circle stats-icon"></i>
          <div class="stats-value" id="importantCount">0</div>
          <div class="stats-label">중요 공지</div>
        </div>
      </div>
      <div class="col-md-4 mb-3">
        <div class="stats-card green">
          <i class="fas fa-calendar-check stats-icon"></i>
          <div class="stats-value" id="todayCount">0</div>
          <div class="stats-label">오늘 등록</div>
        </div>
      </div>
    </div>

    <!-- 검색 폼 -->
    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-4">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-search" style="color: #667eea;"></i> 검색어
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
          <div class="col-md-4 text-end">
            <button type="button" class="btn btn-modern btn-create" onclick="goToCreate()">
              <i class="fas fa-plus"></i> 공지사항 등록
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- 공지사항 목록 -->
    <div class="card notice-card fade-in-up">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list"></i> 공지사항 목록</h4>
          <span id="listSummary" style="color: rgba(255,255,255,0.9);">총 0건</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div id="noticeListContainer">
          <div class="text-center py-5">
            <div class="loading-spinner"></div>
            <p class="mt-3 text-muted">공지사항을 불러오는 중입니다...</p>
          </div>
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

    function isToday(dateStr) {
      if (!dateStr) return false;
      var d = new Date(dateStr);
      var today = new Date();
      return d.getFullYear() == today.getFullYear() &&
              d.getMonth() == today.getMonth() &&
              d.getDate() == today.getDate();
    }

    function loadNotices(page) {
      if (page == undefined) page = 1;
      var container = $('noticeListContainer');
      container.innerHTML = '<div class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">공지사항을 불러오는 중입니다...</p></div>';

      var keyword = $('keyword').value;
      var url = ctx + '/announcement/notice/list?keyword=' + encodeURIComponent(keyword) + '&page=' + page;

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
                displayNotices(data);
                updateStats(data);
              })
              .catch(function(err) {
                console.error('[loadNotices] error:', err);
                container.innerHTML = '<div class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">공지사항을 불러오는 중 오류가 발생했습니다.</p></div>';
              });
    }

    function displayNotices(data) {
      var container = $('noticeListContainer');
      var list = data.list || data;

      if (!Array.isArray(list) || list.length == 0) {
        container.innerHTML = '<div class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 공지사항이 없습니다.</p></div>';
        $('listSummary').textContent = '총 0건';
        return;
      }

      var html = '';
      list.forEach(function(notice) {
        var isImportant = notice.nPriority == 1 || notice.n_priority == 1;
        var itemClass = isImportant ? 'notice-item important' : 'notice-item';
        var priorityBadge = isImportant ?
                '<span class="priority-badge priority-important"><i class="fas fa-star"></i> 중요</span>' :
                '<span class="priority-badge priority-normal">일반</span>';

        var noticeIndex = notice.noticeIndex || notice.notice_index;
        var title = notice.nTitle || notice.n_title || '제목 없음';
        var createAt = notice.nCreateAt || notice.n_create_at;

        html += '<div class="' + itemClass + '" onclick="goToDetail(' + noticeIndex + ')">';
        html += '<div class="notice-title">';
        html += priorityBadge + ' ';
        html += safeHtml(title);
        html += '</div>';
        html += '<div class="notice-meta">';
        html += '<span><i class="fas fa-calendar"></i> ' + formatDateTime(createAt) + '</span>';
        html += '<span><i class="fas fa-user-shield"></i> 관리자</span>';
        html += '</div>';
        html += '</div>';
      });

      container.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    function updateStats(data) {
      var list = data.list || data;
      var total = Array.isArray(list) ? list.length : 0;
      var important = 0;
      var today = 0;

      if (Array.isArray(list)) {
        list.forEach(function(notice) {
          if (notice.nPriority == 1 || notice.n_priority == 1) important++;
          if (isToday(notice.nCreateAt || notice.n_create_at)) today++;
        });
      }

      $('totalCount').textContent = total;
      $('importantCount').textContent = important;
      $('todayCount').textContent = today;
    }

    window.goToDetail = function(noticeIndex) {
      location.href = ctx + '/announcement/notice/detail/' + noticeIndex;
    };

    window.goToCreate = function() {
      location.href = ctx + '/announcement/notice/form';
    };

    window.resetSearch = function() {
      $('keyword').value = '';
      loadNotices(1);
    };

    document.addEventListener('DOMContentLoaded', function () {
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadNotices(1);
      });

      loadNotices(1);
    });
  })();
</script>
