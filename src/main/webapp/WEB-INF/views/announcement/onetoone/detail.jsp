<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .fade-in-up { animation: fadeInUp 0.6s ease-out; }

  /* 헤더 */
  .detail-header {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    border-radius: 20px;
    padding: 2.5rem;
    color: white;
    box-shadow: 0 10px 30px rgba(240, 147, 251, 0.3);
    margin-bottom: 2rem;
    position: relative;
    overflow: hidden;
  }

  .detail-header::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
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

  .detail-meta {
    margin-top: 1rem;
    opacity: 0.9;
    position: relative;
    z-index: 1;
    display: flex;
    gap: 2rem;
    flex-wrap: wrap;
  }

  .status-badge {
    display: inline-block;
    padding: 0.5rem 1.5rem;
    border-radius: 25px;
    font-weight: 600;
    margin-top: 1rem;
  }

  .status-pending {
    background: rgba(254, 225, 64, 0.3);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.3);
  }

  .status-answered {
    background: rgba(132, 250, 176, 0.3);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.3);
  }

  /* 문의 내용 카드 */
  .question-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .question-card .card-header {
    background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
    border: none;
    padding: 1.5rem;
  }

  .question-card .card-header h5 {
    margin: 0;
    color: #2d3748;
    font-weight: 700;
  }

  .question-card .card-body {
    padding: 2.5rem;
    line-height: 1.8;
    font-size: 1.05rem;
    color: #2d3748;
    min-height: 150px;
  }

  /* 답변 카드 */
  .answer-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .answer-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 1.5rem;
  }

  .answer-card .card-header h5 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  .answer-card .card-body {
    padding: 2.5rem;
  }

  .answer-display {
    padding: 2rem;
    background: linear-gradient(135deg, #f7fafc 0%, #ffffff 100%);
    border-radius: 15px;
    border-left: 4px solid #667eea;
    line-height: 1.8;
    color: #2d3748;
    min-height: 100px;
  }

  .no-answer {
    text-align: center;
    padding: 3rem;
    color: #a0aec0;
  }

  .no-answer i {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.3;
  }

  /* 답변 폼 */
  .answer-form {
    padding: 2rem;
    background: #f7fafc;
    border-radius: 15px;
  }

  .form-label {
    font-weight: 700;
    color: #2d3748;
    margin-bottom: 0.75rem;
    display: block;
  }

  .form-control {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;
  }

  .form-control:focus {
    border-color: #f093fb;
    box-shadow: 0 0 0 3px rgba(240, 147, 251, 0.1);
  }

  textarea.form-control {
    min-height: 200px;
    resize: vertical;
    font-family: inherit;
    line-height: 1.6;
  }

  /* 정보 카드 */
  .info-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .info-card .card-body {
    padding: 2rem;
  }

  .info-item {
    display: flex;
    justify-content: space-between;
    padding: 1rem;
    border-bottom: 1px solid #e2e8f0;
  }

  .info-item:last-child {
    border-bottom: none;
  }

  .info-label {
    font-weight: 600;
    color: #718096;
  }

  .info-value {
    color: #2d3748;
    font-weight: 600;
  }

  /* 버튼 */
  .btn-modern {
    border-radius: 10px;
    padding: 0.75rem 2rem;
    font-weight: 600;
    transition: all 0.3s ease;
    border: none;
  }

  .btn-answer {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
  }

  .btn-answer:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(240, 147, 251, 0.4);
    color: white;
  }

  .btn-delete {
    background: linear-gradient(135deg, #f56565 0%, #ed8936 100%);
    color: white;
  }

  .btn-delete:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(245, 101, 101, 0.4);
    color: white;
  }

  .btn-list {
    background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
    color: #2d3748;
  }

  .btn-list:hover {
    background: linear-gradient(135deg, #cbd5e0 0%, #a0aec0 100%);
    color: #2d3748;
  }

  .loading-spinner {
    width: 60px;
    height: 60px;
    border: 6px solid rgba(240, 147, 251, 0.2);
    border-radius: 50%;
    border-top-color: #f093fb;
    animation: spin 1s ease-in-out infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  .form-actions {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
    padding-top: 1rem;
  }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item"><a href="<c:url value='/announcement/onetoone/list'/>">1:1 문의 관리</a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">상세보기</li>
      </ul>
    </div>

    <!-- 헤더 -->
    <div class="detail-header fade-in-up" id="requestHeader">
      <h2><i class="fas fa-question-circle"></i> <span id="requestTitle">로딩 중...</span></h2>
      <div class="detail-meta">
        <span><i class="fas fa-user"></i> <span id="requestUser">-</span></span>
        <span><i class="fas fa-calendar"></i> <span id="requestDate">-</span></span>
        <span><i class="fas fa-tag"></i> <span id="requestType">-</span></span>
      </div>
      <div id="statusBadge"></div>
    </div>

    <!-- 문의 내용 -->
    <div class="card question-card fade-in-up">
      <div class="card-header">
        <h5><i class="fas fa-file-alt"></i> 문의 내용</h5>
      </div>
      <div class="card-body" id="questionContent">
        <div class="text-center py-5">
          <div class="loading-spinner"></div>
          <p class="mt-3 text-muted">내용을 불러오는 중입니다...</p>
        </div>
      </div>
    </div>

    <!-- 답변 -->
    <div class="card answer-card fade-in-up">
      <div class="card-header">
        <h5><i class="fas fa-reply"></i> 관리자 답변</h5>
      </div>
      <div class="card-body">
        <div id="answerDisplay">
          <div class="no-answer">
            <i class="fas fa-comment-slash"></i>
            <p>아직 답변이 등록되지 않았습니다.</p>
          </div>
        </div>

        <!-- 답변 폼 -->
        <div class="answer-form mt-3" id="answerFormContainer">
          <form id="answerForm">
            <div class="mb-3">
              <label class="form-label">
                <i class="fas fa-pen"></i> 답변 내용
              </label>
              <textarea class="form-control" id="answerContent" placeholder="답변 내용을 입력하세요" required></textarea>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-modern btn-answer">
                <i class="fas fa-paper-plane"></i> <span id="submitBtnText">답변 등록</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 정보 -->
    <div class="card info-card fade-in-up">
      <div class="card-body">
        <div class="info-item">
          <div class="info-label"><i class="fas fa-calendar-plus"></i> 문의일</div>
          <div class="info-value" id="createDate">-</div>
        </div>
        <div class="info-item">
          <div class="info-label"><i class="fas fa-calendar-check"></i> 수정일</div>
          <div class="info-value" id="updateDate">-</div>
        </div>
        <div class="info-item">
          <div class="info-label"><i class="fas fa-flag"></i> 답변 상태</div>
          <div class="info-value" id="statusText">-</div>
        </div>
      </div>
    </div>

    <!-- 버튼 -->
    <div class="text-center mb-4">
      <button class="btn btn-modern btn-delete" onclick="deleteRequest()">
        <i class="fas fa-trash"></i> 문의 삭제
      </button>
      <button class="btn btn-modern btn-list" onclick="goToList()">
        <i class="fas fa-list"></i> 목록으로
      </button>
    </div>

  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var currentRequestIndex = '';
    var hasAnswer = false;

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

    function loadRequestDetail(requestIndex) {
      if (!requestIndex || isNaN(Number(requestIndex))) {
        alert('잘못된 문의 번호입니다.');
        goToList();
        return;
      }

      currentRequestIndex = requestIndex;
      var url = ctx + '/announcement/onetoone/' + requestIndex;

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
                displayRequest(data);
              })
              .catch(function(err) {
                console.error('[loadRequestDetail] error:', err);
                alert('문의를 불러오는 중 오류가 발생했습니다.');
                goToList();
              });
    }

    function displayRequest(request) {
      var title = request.rTitle || request.r_title || '제목 없음';
      var content = request.rContent || request.r_content || '내용 없음';
      var response = request.rResponse || request.r_response;
      var status = request.rStatus || request.r_status || 'PENDING';
      var type = request.rType || request.r_type || '-';
      var createAt = request.rCreateAt || request.r_create_at;
      var updateAt = request.rUpdateAt || request.r_update_at;
      var userIndex = request.userIndex || request.user_index || '-';

      $('requestTitle').textContent = title;
      $('requestUser').textContent = '사용자 #' + userIndex;
      $('requestDate').textContent = formatDateTime(createAt);
      $('requestType').textContent = type;
      $('questionContent').innerHTML = '<div style="white-space: pre-wrap;">' + safeHtml(content) + '</div>';

      $('createDate').textContent = formatDateTime(createAt);
      $('updateDate').textContent = updateAt ? formatDateTime(updateAt) : '-';
      $('statusText').textContent = status == 'ANSWERED' ? '답변완료' : '답변대기';

      if (status == 'ANSWERED') {
        $('statusBadge').innerHTML = '<span class="status-badge status-answered"><i class="fas fa-check-circle"></i> 답변완료</span>';
      } else {
        $('statusBadge').innerHTML = '<span class="status-badge status-pending"><i class="fas fa-clock"></i> 답변대기</span>';
      }

      // 답변 표시
      if (response && response.trim() != '') {
        hasAnswer = true;
        $('answerDisplay').innerHTML = '<div class="answer-display">' + safeHtml(response) + '</div>';
        $('answerContent').value = response;
        $('submitBtnText').textContent = '답변 수정';
      } else {
        hasAnswer = false;
        $('answerDisplay').innerHTML = '<div class="no-answer"><i class="fas fa-comment-slash"></i><p>아직 답변이 등록되지 않았습니다.</p></div>';
        $('answerContent').value = '';
        $('submitBtnText').textContent = '답변 등록';
      }
    }

    function submitAnswer(e) {
      e.preventDefault();

      var response = $('answerContent').value.trim();
      if (!response) {
        alert('답변 내용을 입력하세요.');
        return;
      }

      var url = ctx + '/announcement/onetoone/' + currentRequestIndex + '/reply';
      var data = {
        requestIndex: parseInt(currentRequestIndex),
        rResponse: response
      };

      fetch(url, {
        method: 'PUT',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify(data)
      })
              .then(function(res) { return res.json(); })
              .then(function(result) {
                if (result && result.success) {
                  alert(hasAnswer ? '답변이 수정되었습니다.' : '답변이 등록되었습니다.');
                  loadRequestDetail(currentRequestIndex);
                } else {
                  alert(result.message || '답변 저장에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('답변 저장 중 오류가 발생했습니다.');
              });
    }

    window.deleteRequest = function() {
      if (!currentRequestIndex) {
        alert('잘못된 접근입니다.');
        return;
      }

      if (!confirm('이 문의를 삭제하시겠습니까?')) return;

      var url = ctx + '/announcement/onetoone/' + currentRequestIndex;

      fetch(url, {
        method: 'DELETE',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
              .then(function(res) { return res.json(); })
              .then(function(data) {
                if (data && data.success) {
                  alert('문의가 삭제되었습니다.');
                  goToList();
                } else {
                  alert(data.message || '삭제에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('삭제 중 오류가 발생했습니다.');
              });
    };

    window.goToList = function() {
      location.href = ctx + '/announcement/onetoone/list';
    };

    document.addEventListener('DOMContentLoaded', function () {
      try {
        var segs = (location.pathname || '').split('/').filter(Boolean);
        var last = segs[segs.length - 1] || '';
        var requestIndex = /^[0-9]+$/.test(last) ? last : '';

        if (requestIndex) {
          loadRequestDetail(requestIndex);
        } else {
          alert('문의 번호가 없습니다.');
          goToList();
        }
      } catch (e) {
        console.error('[init] error:', e);
        goToList();
      }

      $('answerForm').addEventListener('submit', submitAnswer);
    });
  })();
</script>
