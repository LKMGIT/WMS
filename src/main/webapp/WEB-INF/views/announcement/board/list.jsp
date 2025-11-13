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

  .stats-card.green {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    color: white;
  }

  .stats-card.blue {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: white;
  }

  .stats-card.orange {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    color: white;
  }

  .stats-card.purple {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
    border-color: #43e97b;
    box-shadow: 0 0 0 3px rgba(67, 233, 123, 0.1);
  }

  .btn-search {
    border-radius: 10px;
    padding: 0.6rem 2rem;
    font-weight: 600;
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    border: none;
    color: white;
    transition: all 0.3s ease;
  }

  .btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(67, 233, 123, 0.4);
    color: white;
  }

  /* 게시판 테이블 */
  .board-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    overflow: hidden;
  }

  .board-card .card-header {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    border: none;
    padding: 1.5rem;
  }

  .board-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  .board-table {
    margin: 0;
  }

  .board-table thead th {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    color: #2d3748;
    font-weight: 700;
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.5px;
    border: none;
    padding: 1.25rem 1rem;
  }

  .board-table tbody tr {
    transition: all 0.3s ease;
    border-bottom: 1px solid #e2e8f0;
    cursor: pointer;
  }

  .board-table tbody tr:hover {
    background: linear-gradient(90deg, rgba(67, 233, 123, 0.05) 0%, rgba(67, 233, 123, 0) 100%);
    transform: translateX(5px);
  }

  .board-table tbody td {
    padding: 1.25rem 1rem;
    vertical-align: middle;
    border: none;
  }

  .board-title {
    font-weight: 600;
    color: #2d3748;
  }

  .board-title:hover {
    color: #43e97b;
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

  .comment-count {
    display: inline-block;
    padding: 0.2rem 0.6rem;
    border-radius: 10px;
    font-size: 0.75rem;
    font-weight: 600;
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
    margin-left: 0.5rem;
  }

  .views-badge {
    color: #718096;
    font-size: 0.875rem;
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
    color: #43e97b;
    font-weight: 600;
    padding: 0.5rem 1rem;
    transition: all 0.3s ease;
  }

  .pagination .page-item .page-link:hover {
    background-color: #43e97b;
    color: white;
    border-color: #43e97b;
  }

  .pagination .page-item.active .page-link {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    border-color: #43e97b;
  }

  .loading-spinner {
    display: inline-block;
    width: 40px;
    height: 40px;
    border: 4px solid rgba(67, 233, 123, 0.2);
    border-radius: 50%;
    border-top-color: #43e97b;
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
        <i class="fas fa-comments" style="color: #43e97b;"></i> 문의 게시판
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">문의 게시판</li>
      </ul>
    </div>

    <!-- 통계 -->
    <div class="row mb-4 fade-in-up">
      <div class="col-md-3 mb-3">
        <div class="stats-card green">
          <i class="fas fa-list stats-icon"></i>
          <div class="stats-value" id="totalCount">0</div>
          <div class="stats-label">전체 게시글</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card blue">
          <i class="fas fa-box stats-icon"></i>
          <div class="stats-value" id="inboundCount">0</div>
          <div class="stats-label">입고 문의</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card orange">
          <i class="fas fa-truck stats-icon"></i>
          <div class="stats-value" id="deliveryCount">0</div>
          <div class="stats-label">배송 문의</div>
        </div>
      </div>
      <div class="col-md-3 mb-3">
        <div class="stats-card purple">
          <i class="fas fa-desktop stats-icon"></i>
          <div class="stats-value" id="systemCount">0</div>
          <div class="stats-label">시스템 문의</div>
        </div>
      </div>
    </div>

    <!-- 검색 -->
    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-3">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-tag" style="color: #43e97b;"></i> 문의 유형
            </label>
            <select id="typeSelect" class="form-select">
              <option value="">전체</option>
              <option value="입고관련">입고 관련</option>
              <option value="배송관련">배송 관련</option>
              <option value="시스템">시스템</option>
              <option value="계정">계정</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-search" style="color: #43e97b;"></i> 검색어
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

    <!-- 게시판 -->
    <div class="card board-card fade-in-up">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list-alt"></i> 게시글 목록</h4>
          <span id="listSummary" style="color: rgba(255,255,255,0.9);">총 0건</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table board-table">
            <thead>
            <tr>
              <th style="width: 10%;"><i class="fas fa-hashtag"></i> 번호</th>
              <th style="width: 15%;"><i class="fas fa-tag"></i> 유형</th>
              <th><i class="fas fa-file-alt"></i> 제목</th>
              <th style="width: 12%;"><i class="fas fa-user"></i> 작성자</th>
              <th style="width: 10%;"><i class="fas fa-eye"></i> 조회수</th>
              <th style="width: 10%;"><i class="fas fa-calendar"></i> 작성일</th>
              <th style="width: 8%;"><i class="fas fa-cog"></i> 관리</th>
            </tr>
            </thead>
            <tbody id="boardListBody">
            <tr>
              <td colspan="7" class="text-center py-5">
                <div class="loading-spinner"></div>
                <p class="mt-3 text-muted">게시글을 불러오는 중입니다...</p>
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

    function formatDate(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      if (!isNaN(d.getTime())) {
        var pad = function(n) { return String(n).padStart(2,'0'); };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
      }
      return String(dateStr);
    }

    function loadBoards(page) {
      if (page == undefined) page = 1;
      var tbody = $('boardListBody');
      tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">게시글을 불러오는 중입니다...</p></td></tr>';

      var keyword = $('keyword').value;
      var type = $('typeSelect').value;
      var url = ctx + '/announcement/board/list?keyword=' + encodeURIComponent(keyword) + '&type=' + encodeURIComponent(type) + '&page=' + page;

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
                displayBoards(data);
                updateStats(data);
              })
              .catch(function(err) {
                console.error('[loadBoards] error:', err);
                tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">게시글을 불러오는 중 오류가 발생했습니다.</p></td></tr>';
              });
    }

    function displayBoards(data) {
      var tbody = $('boardListBody');
      var list = data.list || data;

      if (!Array.isArray(list) || list.length == 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 게시글이 없습니다.</p></td></tr>';
        $('listSummary').textContent = '총 0건';
        return;
      }

      var html = '';
      list.forEach(function(board) {
        var boardIndex = board.boardIndex || board.board_index;
        var title = board.bTitle || board.b_title || '제목 없음';
        var type = board.bType || board.b_type || '-';
        var views = board.bViews || board.b_views || 0;
        var createAt = board.bCreateAt || board.b_create_at;
        var userIndex = board.userIndex || board.user_index || '-';
        var commentCount = (board.comments && board.comments.length) || 0;

        html += '<tr onclick="goToDetail(' + boardIndex + ')">';
        html += '<td><strong>' + safeHtml(boardIndex) + '</strong></td>';
        html += '<td><span class="type-badge">' + safeHtml(type) + '</span></td>';
        html += '<td class="board-title">' + safeHtml(title);
        if (commentCount > 0) {
          html += '<span class="comment-count"><i class="fas fa-comment"></i> ' + commentCount + '</span>';
        }
        html += '</td>';
        html += '<td>사용자 #' + safeHtml(userIndex) + '</td>';
        html += '<td><span class="views-badge"><i class="fas fa-eye"></i> ' + views + '</span></td>';
        html += '<td>' + formatDate(createAt) + '</td>';
        html += '<td><button class="btn btn-delete" onclick="deleteBoard(event, ' + boardIndex + ')"><i class="fas fa-trash"></i></button></td>';
        html += '</tr>';
      });

      tbody.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    function updateStats(data) {
      var list = data.list || data;
      var total = Array.isArray(list) ? list.length : 0;
      var inbound = 0, delivery = 0, system = 0;

      if (Array.isArray(list)) {
        list.forEach(function(board) {
          var type = board.bType || board.b_type || '';
          if (type.indexOf('입고') >= 0) inbound++;
          if (type.indexOf('배송') >= 0) delivery++;
          if (type.indexOf('시스템') >= 0) system++;
        });
      }

      $('totalCount').textContent = total;
      $('inboundCount').textContent = inbound;
      $('deliveryCount').textContent = delivery;
      $('systemCount').textContent = system;
    }

    window.goToDetail = function(boardIndex) {
      location.href = ctx + '/announcement/board/detail/' + boardIndex;
    };

    window.deleteBoard = function(e, boardIndex) {
      e.stopPropagation();
      if (!confirm('이 게시글을 삭제하시겠습니까?')) return;

      var url = ctx + '/announcement/board/' + boardIndex;

      fetch(url, {
        method: 'DELETE',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) { return res.json(); })
              .then(function(data) {
                if (data && data.success) {
                  alert('게시글이 삭제되었습니다.');
                  loadBoards(1);
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
      $('typeSelect').value = '';
      loadBoards(1);
    };

    document.addEventListener('DOMContentLoaded', function () {
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadBoards(1);
      });

      loadBoards(1);
    });
  })();
</script>
