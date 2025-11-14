<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  /* 스타일은 list.jsp (board)와 동일하다고 가정하고 생략합니다. */
  .fade-in-up { animation: fadeInUp 0.6s ease-out; }
  .table-onetoone th { background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%); }
  .status-pending { color: #dc3545; font-weight: 600; }
  .status-answered { color: #28a745; font-weight: 600; }
  .onetoone-title:hover { color: #4facfe; } /* OneToOne 테마 색상 */
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-headset" style="color: #4facfe;"></i> 1:1 문의 관리
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">1:1 문의 관리</li>
      </ul>
    </div>

    <div class="card search-card fade-in-up">
      <div class="card-body">
        <form id="searchForm" class="row g-3 align-items-end">
          <div class="col-md-3">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-tag" style="color: #4facfe;"></i> 답변 상태
            </label>
            <select id="statusSelect" class="form-select">
              <option value="">전체</option>
              <option value="PENDING">답변 대기</option>
              <option value="ANSWERED">답변 완료</option>
            </select>
          </div>
          <div class="col-md-5">
            <label class="form-label" style="font-weight: 600; color: #4a5568;">
              <i class="fas fa-search" style="color: #4facfe;"></i> 검색어
            </label>
            <input type="text" id="keyword" class="form-control" placeholder="제목/내용으로 검색">
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-search w-100" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); border: none;">
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
      <div class="card-header" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <h4><i class="fas fa-list-alt"></i> 1:1 문의 목록</h4>
          <span id="listSummary" style="color: rgba(255,255,255,0.9);">총 0건</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table board-table table-onetoone">
            <thead>
            <tr>
              <th style="width: 8%;"><i class="fas fa-hashtag"></i> 번호 </th>
              <th style="width: 12%;"><i class="fas fa-info-circle"></i> 상태</th>
              <th style="width: 15%;"><i class="fas fa-tag"></i> 유형</th>
              <th><i class="fas fa-file-alt"></i> 제목</th>
              <th style="width: 12%;"><i class="fas fa-user"></i> 작성자</th>
              <th style="width: 12%;"><i class="fas fa-calendar"></i> 작성일</th>
              <th style="width: 12%;"><i class="fas fa-cog"></i> 관리자</th>
            </tr>
            </thead>
            <tbody id="requestListBody">
            <tr>
              <td colspan="7" class="text-center py-5">
                <div class="loading-spinner"></div>
                <p class="mt-3 text-muted">1:1 문의를 불러오는 중입니다...</p>
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

    function formatDate(dateStr) {
      if (!dateStr) return '-';
      var d = new Date(dateStr);
      var pad = function(n) { return String(n).padStart(2,'0'); };
      return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
    }

    // 1:1 문의 목록 조회 (관리자 전용)
    window.loadRequests = function() {
      var tbody = $('requestListBody');
      tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><div class="loading-spinner"></div><p class="mt-3 text-muted">1:1 문의를 불러오는 중입니다...</p></td></tr>';

      var keyword = $('keyword').value;
      var status = $('statusSelect').value;

      // [API 경로] /announcement/one-to-one/list
      var url = ctx + '/announcement/one-to-one/list?keyword=' + encodeURIComponent(keyword) + '&status=' + encodeURIComponent(status);

      fetch(url, {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(res => {
                if (res.ok) return res.json();
                if (res.status === 401) {
                  return Promise.reject(new Error('관리자 권한이 필요합니다.'));
                }
                return Promise.reject(new Error('HTTP ' + res.status));
              })
              .then(data => {
                displayRequests(data);
              })
              .catch(err => {
                console.error('[loadRequests] error:', err);
                tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #f56565;"></i><p class="mt-3 text-danger">문의 목록을 불러오는 중 오류가 발생했습니다. (' + err.message + ')</p></td></tr>';
              });
    }

    // 목록 화면에 표시
    function displayRequests(list) {
      var tbody = $('requestListBody');
      if (!Array.isArray(list) || list.length == 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5"><i class="fas fa-inbox" style="font-size: 3rem; color: #cbd5e0;"></i><p class="mt-3 text-muted">등록된 1:1 문의가 없습니다.</p></td></tr>';
        $('listSummary').textContent = '총 0건';
        return;
      }

      var html = '';
      list.forEach(function(request) {
        var isAnswered = request.rStatus === 'ANSWERED';
        var statusText = isAnswered ? '완료' : '대기';
        var statusClass = isAnswered ? 'status-answered' : 'status-pending';
        var adminDisplay = isAnswered ? '관리자 #' + request.adminIndex : '-';

        html += '<tr onclick="goToDetail(' + request.requestIndex + ')">';
        html += '<td><strong>' + request.requestIndex + '</strong></td>';
        html += '<td><span class="' + statusClass + '">' + statusText + '</span></td>';
        html += '<td>' + request.rType + '</td>';
        html += '<td class="onetoone-title">' + request.rTitle + '</td>';
        html += '<td>사용자 #' + request.userIndex + '</td>';
        html += '<td>' + formatDate(request.rCreateAt) + '</td>';
        html += '<td>' + adminDisplay + '</td>';
        html += '</tr>';
      });

      tbody.innerHTML = html;
      $('listSummary').textContent = '총 ' + list.length + '건';
    }

    // 상세 화면으로 이동 (관리자)
    window.goToDetail = function(requestIndex) {
      location.href = ctx + '/announcement/onetoone/detail/' + requestIndex;
    };

    window.resetSearch = function() {
      $('keyword').value = '';
      $('statusSelect').value = '';
      loadRequests();
    };

    document.addEventListener('DOMContentLoaded', function () {
      $('searchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        loadRequests();
      });

      loadRequests();
    });
  })();
</script>