<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
  @keyframes fadeInUp {
    from { opacity: 0;
      transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0);
    }
  }

  .fade-in-up { animation: fadeInUp 0.6s ease-out;
  }

  /* 폼 카드 */
  .form-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    margin-bottom: 2rem;
  }

  .form-card .card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 2rem;
  }

  .form-card .card-header h4 {
    color: white;
    margin: 0;
    font-weight: 700;
  }

  .form-card .card-body {
    padding: 3rem;
  }

  /* 폼 그룹 */
  .form-group {
    margin-bottom: 2rem;
  }

  .form-label {
    font-weight: 700;
    color: #2d3748;
    margin-bottom: 0.75rem;
    display: block;
  }

  .form-label .required {
    color: #f56565;
    margin-left: 0.25rem;
  }

  .form-control, .form-select {
    border-radius: 10px;
    border: 2px solid #e2e8f0;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;
    font-size: 1rem;
  }

  .form-control:focus, .form-select:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  textarea.form-control {
    min-height: 300px;
    resize: vertical;
    font-family: inherit;
    line-height: 1.6;
  }

  /* 우선순위 선택 */
  .priority-options {
    display: flex;
    gap: 1rem;
  }

  .priority-option {
    flex: 1;
    padding: 1.5rem;
    border: 2px solid #e2e8f0;
    border-radius: 15px;
    cursor: pointer;
    transition: all 0.3s ease;
    text-align: center;
  }

  .priority-option:hover {
    border-color: #667eea;
    background: rgba(102, 126, 234, 0.05);
  }

  .priority-option.selected {
    border-color: #667eea;
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  }

  .priority-option input[type="radio"] {
    display: none;
  }

  .priority-icon {
    font-size: 2rem;
    margin-bottom: 0.5rem;
  }

  .priority-label {
    font-weight: 600;
    color: #2d3748;
  }

  /* 버튼 */
  .btn-modern {
    border-radius: 10px;
    padding: 0.75rem 2rem;
    font-weight: 600;
    transition: all 0.3s ease;
    border: none;
    font-size: 1rem;
  }

  .btn-submit {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }

  .btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    color: white;
  }

  .btn-cancel {
    background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
    color: #2d3748;
  }

  .btn-cancel:hover {
    background: linear-gradient(135deg, #cbd5e0 0%, #a0aec0 100%);
    color: #2d3748;
  }

  .form-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    padding-top: 2rem;
    border-top: 2px solid #e2e8f0;
  }

  /* Helper text */
  .form-text {
    font-size: 0.875rem;
    color: #718096;
    margin-top: 0.5rem;
  }
</style>

<div class="container">
  <div class="page-inner">

    <div class="page-header fade-in-up">
      <h3 class="fw-bold mb-3" style="color: #2d3748;">
        <i class="fas fa-edit" style="color: #667eea;"></i> <span id="pageTitle">공지사항 등록</span>
      </h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item"><a href="<c:url value='/announcement/notice/list'/>">공지사항</a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>

        <li class="nav-item" id="breadcrumbTitle">등록</li>
      </ul>
    </div>

    <div class="card form-card fade-in-up">
      <div class="card-header">
        <h4><i class="fas fa-file-alt"></i> 공지사항 정보</h4>
      </div>
      <div class="card-body">
        <form id="noticeForm">
          <input type="hidden" id="noticeIndex" name="noticeIndex">

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-heading"></i> 제목
              <span class="required">*</span>
            </label>
            <input type="text" class="form-control" id="nTitle" name="nTitle"
                   placeholder="공지사항 제목을 입력하세요" required>

            <div class="form-text">
              <i class="fas fa-info-circle"></i> 명확하고 간결한 제목을 작성해주세요.
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-flag"></i> 중요도
              <span class="required">*</span>
            </label>

            <div class="priority-options">
              <label class="priority-option selected" id="priority-0">
                <input type="radio" name="nPriority" value="0" checked>
                <div class="priority-icon">📋</div>
                <div class="priority-label">일반</div>
              </label>

              <label class="priority-option" id="priority-1">
                <input type="radio" name="nPriority" value="1">
                <div class="priority-icon">⭐</div>
                <div class="priority-label">중요</div>
              </label>
            </div>
            <div class="form-text">

              <i class="fas fa-info-circle"></i> 중요 공지는 목록 상단에 표시됩니다.
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-align-left"></i> 내용
              <span class="required">*</span>
            </label>

            <textarea class="form-control" id="nContent" name="nContent"
                      placeholder="공지사항 내용을 입력하세요" required></textarea>
            <div class="form-text">
              <i class="fas fa-info-circle"></i> 상세한 공지 내용을 작성해주세요.
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn btn-modern btn-submit">
              <i class="fas fa-save"></i> <span id="submitBtnText">등록하기</span>
            </button>
            <button type="button" class="btn btn-modern btn-cancel" onclick="goBack()">

              <i class="fas fa-times"></i> 취소
            </button>
          </div>
        </form>
      </div>
    </div>

  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var isEditMode = false;
    var currentNoticeIndex = null;

    var $ = function(id) { return document.getElementById(id); };

    function initPrioritySelection() {

      var options = document.querySelectorAll('.priority-option');
      options.forEach(function(option) {
        option.addEventListener('click', function() {
          options.forEach(function(opt) {
            opt.classList.remove('selected');
          });
          this.classList.add('selected');
          var radio = this.querySelector('input[type="radio"]');
          if (radio) radio.checked = true;
        });
      });
    }

    function loadNoticeForEdit(noticeIndex) {
      // [수정] 상세 조회 API 호출 경로: /announcement/notices/{notice_index}
      var url = ctx + '/announcement/notices/' + noticeIndex;
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
                fillFormWithData(data);
              })
              .catch(function(err) {
                console.error('[loadNoticeForEdit] error:', err);

                alert('공지사항 정보를 불러오는 중 오류가 발생했습니다.');
                goBack();
              });
    }

    function fillFormWithData(notice) {
      $('noticeIndex').value = notice.noticeIndex || notice.notice_index;
      $('nTitle').value = notice.nTitle || notice.n_title || '';
      $('nContent').value = notice.nContent || notice.n_content || '';

      var priority = notice.nPriority ||
              notice.n_priority || 0;
      var radios = document.querySelectorAll('input[name="nPriority"]');
      radios.forEach(function(radio) {
        if (radio.value == priority) {
          radio.checked = true;
          var parentLabel = radio.closest('.priority-option');
          if (parentLabel) {
            document.querySelectorAll('.priority-option').forEach(function(opt) {
              opt.classList.remove('selected');
            });

            parentLabel.classList.add('selected');
          }
        }
      });
    }

    function submitForm(e) {
      e.preventDefault();

      var noticeIndex = $('noticeIndex').value;
      var nTitle = $('nTitle').value.trim();
      var nContent = $('nContent').value.trim();
      var nPriority = document.querySelector('input[name="nPriority"]:checked').value;
      if (!nTitle) {
        alert('제목을 입력하세요.');
        $('nTitle').focus();
        return;
      }

      if (!nContent) {
        alert('내용을 입력하세요.');
        $('nContent').focus();
        return;
      }

      var data = {
        nTitle: nTitle,
        nContent: nContent,
        nPriority: parseInt(nPriority)
      };

      var url, method;
      if (isEditMode && noticeIndex) {
        // [수정]: PUT 요청 경로: /announcement/notice/{noticeIndex}
        url = ctx + '/announcement/notice/' + noticeIndex;
        method = 'PUT';
      } else {
        // [수정]: POST 요청 경로: /announcement/notice
        url = ctx + '/announcement/notice';
        method = 'POST';
      }

      fetch(url, {
        method: method,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify(data)
      })
              .then(function(res) { return res.json();
              })
              .then(function(result) {
                if (result && result.success) {
                  alert(isEditMode ? '공지사항이 수정되었습니다.' : '공지사항이 등록되었습니다.');
                  location.href = ctx + '/announcement/notice/list';
                } else {

                  alert(result.message || '저장에 실패했습니다.');
                }
              })
              .catch(function(err) {
                console.error(err);
                alert('저장 중 오류가 발생했습니다.');
              });
    }

    window.goBack = function() {
      if (confirm('작성 중인 내용이 있습니다. 취소하시겠습니까?')) {
        location.href = ctx + '/announcement/notice/list';
      }
    };

    document.addEventListener('DOMContentLoaded', function () {
      initPrioritySelection();

      var urlParams = new URLSearchParams(window.location.search);
      var noticeIndex = urlParams.get('noticeIndex');

      if (noticeIndex && /^[0-9]+$/.test(noticeIndex)) {
        isEditMode = true;
        currentNoticeIndex = noticeIndex;
        $('pageTitle').textContent = '공지사항 수정';
        $('breadcrumbTitle').textContent = '수정';
        $('submitBtnText').textContent = '수정하기';

        loadNoticeForEdit(noticeIndex);
      }

      $('noticeForm').addEventListener('submit', submitForm);
    });
  })();
</script>