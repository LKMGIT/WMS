<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* ... (스타일은 생략) ... */
  .fade-in-up { animation: fadeInUp 0.6s ease-out; }
  .table-notice th { background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%); }
  .notice-title-important { font-weight: 700; color: #f56565; }
  .notice-title:hover { color: #667eea; }
  .priority-badge-important { background: linear-gradient(135deg, #f56565 0%, #ed8936 100%); color: white; }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-bullhorn" style="color: #667eea;"></i> 공지사항 관리
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">공지사항 관리</li>
      </ul>
    </div>

    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-5">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-search" style="color: #667eea;"></i> 검색어
            </label>
            <input type="text" id="keyword" class="form-control" placeholder="제목/내용으로 검색">
          </div>
          <div class="col-md-3">
            <button type="submit" class="btn btn-search w-100" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
              <i class="fas fa-search"></i> 검색
            </button>
          </div>
          <div class="col-md-2">
            <button type="button" class="btn btn-outline-secondary w-100" onclick="resetSearch()" style="border-radius: 10px; font-weight: 600;">
              <i class="fas fa-redo"></i> 초기화
            </button>
          </div>
          <c:if test="${not empty sessionScope.loginAdminIndex}">
            <div class="col-md-2">
              <button type="button" class="btn btn-primary w-100" onclick="goToForm()" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); border: none;">
                <i class="fas fa-plus"></i> 등록
              </button>
            </div>
          </c:if>
        </form>
      </div>
    </div>

    <div class="card board-card fade-in-up">
      <div class="card-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list-alt"></i> 공지사항 목록</h4>
          <span id="listSummary" style="color: rgba(255,255,255,0.9);">총 0건</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table board-table table-notice">
            <thead>
            <tr>
              <th style="width: 10%;"><i class="fas fa-hashtag"></i> 번호</th>
              <th style="width: 15%;"><i class="fas fa-star"></i> 중요도</th>
              <th><i class="fas fa-file-alt"></i> 제목</th>
              <th style="width: 15%;"><i class="fas fa-user"></i> 작성자</th>
              <th style="width: 15%;"><i class="fas fa-calendar"></i> 작성일</th>
              <th style="width: 10%;"><i class="fas fa-cog"></i> 관리</th>
            </tr>
            </thead>
            <tbody id="noticeListBody">
            <tr>
              <td colspan="6" class="text-center py-5">
                <div class="loading-spinner"></div>
                <p class="mt-3 text-muted">공지사항을 불러오는 중입니다...</p>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer bg-white" style="border-top: 1px solid #e2e8f0; padding: 1.5rem;">
      </div>
    </div>

  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var $ = function(id) { return document.getElementById(id); };
    // [수정됨] 관리자 여부 변수 추가
    var isAdmin = '${not empty sessionScope.loginAdminIndex}' === 'true';

    function formatDate(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      var pad = function(n) { return String(n).padStart(2,'0'); };
      return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
    }

    // 공지사항 목록 조회
    window.loadNotices = function() {
      var tbody = $('noticeListBody');
      tbody.innerHTML = '<tr><td colspan="6" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">공지사항을 불러오는 중입니다...</p></td></tr>';

      var keyword = $('keyword').value;
      var url = ctx + '/announcement/notices?keyword=' + encodeURIComponent(keyword);

      fetch(url, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(res => {
                if (res.ok) return res.json();
                return Promise.reject(new Error('HTTP ' + res.status));
              })
              .then(data => {
                displayNotices(data);
              })
              .catch(err => {
                console.error('[loadNotices] error:', err);
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">목록을 불러오는 중 오류가 발생했습니다.</p></td></tr>';
              });
    }

    // 목록 화면에 표시
    function displayNotices(list) {
      var tbody = $('noticeListBody');
      if (!Array.isArray(list) || list.length == 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 공지사항이 없습니다.</p></td></tr>';
        $('listSummary').textContent = '총 0건';
        return;
      }

      var html = '';
      list.forEach(function(notice) {
        var isImportant = notice.nPriority === 1;
        var priorityText = isImportant ? '중요' : '일반';
        var priorityClass = isImportant ? 'priority-badge-important' : 'type-badge';
        var titleClass = isImportant ? 'notice-title-important' : 'notice-title';

        html += '<tr>';
        html += '<td><strong>' + notice.noticeIndex + '</strong></td>';
        html += '<td><span class="' + priorityClass + '">' + priorityText + '</span></td>';
        html += '<td class="' + titleClass + '" onclick="goToDetail(' + notice.noticeIndex + ')">' + notice.nTitle + '</td>';
        html += '<td>관리자 #' + notice.adminIndex + '</td>';
        html += '<td>' + formatDate(notice.nCreateAt) + '</td>';

        // [수정됨] 관리자일 경우에만 버튼을 생성
        if (isAdmin) {
          html += '<td>';
          html += '<button class="btn btn-sm btn-warning me-2" onclick="goToEdit(event, ' + notice.noticeIndex + ')"><i class="fas fa-edit"></i></button>';
          html += '<button class="btn btn-sm btn-delete" onclick="deleteNotice(event, ' + notice.noticeIndex + ')"><i class="fas fa-trash"></i></button>';
          html += '</td>';
        } else {
          html += '<td>-</td>'; // 관리자가 아니면 - 표시
        }

        html += '</tr>';
      });

      tbody.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    // 공지사항 등록 화면으로 이동
    window.goToForm = function() {
      location.href = ctx + '/announcement/notice/form';
    };

    // 공지사항 상세 화면으로 이동 (공용)
    window.goToDetail = function(noticeIndex) {
      location.href = ctx + '/announcement/notices/detail/' + noticeIndex;
    };

    // 공지사항 수정 화면으로 이동 (관리자)
    window.goToEdit = function(e, noticeIndex) {
      e.stopPropagation();
      location.href = ctx + '/announcement/notice/form?noticeIndex=' + noticeIndex;
    };

    // 공지사항 삭제 (관리자)
    window.deleteNotice = function(e, noticeIndex) {
      e.stopPropagation(); // 행 클릭 이벤트 방지
      if (!confirm('이 공지사항을 삭제하시겠습니까?')) return;
      var url = ctx + '/announcement/notice/' + noticeIndex;
      fetch(url, {
        method: 'DELETE',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(res => res.json())
              .then(data => {
                if (data && data.success) {
                  alert('공지사항이 삭제되었습니다.');
                  loadNotices();
                } else {
                  alert(data.message || '삭제에 실패했습니다.');
                }
              })
              .catch(err => {
                console.error(err);
                alert('삭제 중 오류가 발생했습니다.');
              });
    };

    window.resetSearch = function() {
      $('keyword').value = '';
      loadNotices();
    };

    document.addEventListener('DOMContentLoaded', function () {
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadNotices();
      });

      loadNotices();
    });
  })();
</script>