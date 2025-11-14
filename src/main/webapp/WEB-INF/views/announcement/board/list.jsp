<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* ... (스타일 코드는 이전과 동일) ... */
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
          <div class="stats-label">시스템/계정 문의</div>
        </div>
      </div>
    </div>

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


    window.loadBoards = function(page) {
      if (page == undefined) page = 1;
      var tbody = $('boardListBody');
      tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">게시글을 불러오는 중입니다...</p></td></tr>';

      var keyword = $('keyword').value;
      var type = $('typeSelect').value;
      var url = ctx + '/announcement/board?keyword=' + encodeURIComponent(keyword) + '&type=' + encodeURIComponent(type) + '&page=' + page;
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
                console.error('[loadBoards] error:',
                        err);
                tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">게시글을 불러오는 중 오류가 발생했습니다.</p></td></tr>';
              });
    }

    function displayBoards(data) {
      var tbody = $('boardListBody');
      var list = data.list || data;
      // [수정됨] 'loginAdminId' -> 'loginAdminIndex'
      var isAdmin = '${not empty sessionScope.loginAdminIndex}' === 'true';
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
        html += '<td>';
        if (isAdmin) {
          html += '<button class="btn btn-delete" onclick="deleteBoard(event, ' + boardIndex + ')"><i class="fas fa-trash"></i></button>';
        } else {
          html += '-';
        }
        html += '</td>';
        html += '</tr>';
      });

      tbody.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    function updateStats(data) {
      var list = data.list ||
              data;
      var total = Array.isArray(list) ? list.length : 0;
      var inbound = 0, delivery = 0, system = 0, account = 0;
      if (Array.isArray(list)) {
        list.forEach(function(board) {
          var type = board.bType || board.b_type || '';
          if (type.indexOf('입고') >= 0) inbound++;
          if (type.indexOf('배송') >= 0) delivery++;
          if (type.indexOf('시스템') >= 0) system++;
          if (type.indexOf('계정') >= 0) account++;
        });
      }

      $('totalCount').textContent = total;
      $('inboundCount').textContent = inbound;
      $('deliveryCount').textContent = delivery;
      $('systemCount').textContent = system + account;
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