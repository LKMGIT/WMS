<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
  <div class="col-md-12">
    <div class="card">

      <!-- 헤더 + 검색 폼 -->
      <div class="card-header d-flex align-items-center justify-content-between">
        <h4 class="card-title mb-0">재고 실사 목록</h4>

        <!-- 화면 전용 폼 (fetch로 호출) -->
        <form id="searchForm" class="d-flex gap-2" onsubmit="return false;">
          <input type="number" class="form-control" name="invenIndex" placeholder="재고번호(inven_index)" style="width:200px"/>
          <input type="date" class="form-control" name="fromDate"  style="width:170px"/>
          <input type="date" class="form-control" name="toDate"    style="width:170px"/>

          <!-- 페이지 크기 -->
          <select class="form-select" name="amount" style="width:120px">
            <option value="10">10개</option>
            <option value="20" selected>20개</option>
            <option value="50">50개</option>
            <option value="100">100개</option>
          </select>

          <button type="button" id="btnSearch" class="btn btn-primary">조회</button>
          <button type="button" id="btnReset" class="btn btn-outline-secondary">초기화</button>

          <!-- 신규 등록 버튼 -->
          <button type="button" id="btnOpenCreate" class="btn btn-success">실사 등록</button>
        </form>
      </div>

      <!-- 본문: 테이블 -->
      <div class="card-body">
        <div class="table-responsive">
          <table id="inventoryCountTable" class="display table table-striped table-hover">
            <thead>
            <tr>
              <th>실사번호</th>
              <th>재고번호</th>
              <th>장부수량</th>
              <th>실사수량</th>
              <th>차이(variance)</th>
              <th>실사일자</th>
              <th style="width:130px;">액션</th>
            </tr>
            </thead>
            <tbody id="tbodyCounts">
            <tr><td colspan="7" class="text-center text-muted">조회 결과가 없습니다.</td></tr>
            </tbody>
          </table>
        </div>

        <!-- 페이지네이션 -->
        <nav class="mt-3">
          <ul id="pagination" class="pagination justify-content-center"></ul>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- 등록/수정 모달 -->
<div class="modal fade" id="countModal" tabindex="-1" aria-labelledby="countModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form id="countForm" class="modal-content" onsubmit="return false;">
      <div class="modal-header">
        <h5 class="modal-title" id="countModalLabel">재고 실사</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="countIndex"/>
        <div class="mb-3">
          <label class="form-label" for="invenIndexInput">재고번호(inven_index)</label>
          <input id="invenIndexInput" type="number" class="form-control" required />
        </div>
        <div class="mb-3">
          <label class="form-label" for="invenQtyInput">장부수량(inven_quantity)</label>
          <input id="invenQtyInput" type="number" class="form-control" min="0" required />
        </div>
        <div class="mb-3">
          <label class="form-label" for="actualQtyInput">실사수량(actual_quantity)</label>
          <input id="actualQtyInput" type="number" class="form-control" min="0" required />
        </div>
        <div class="mb-0">
          <label class="form-label" for="updateAtInput">실사일자(count_updateAt)</label>
          <input id="updateAtInput" type="date" class="form-control" required />
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="submit" id="btnSave" class="btn btn-primary">저장</button>
      </div>
    </form>
  </div>
</div>

<script>
  (function () {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();

    function init() {
      try {
        var ctx = '${pageContext.request.contextPath}';

        // CSRF (있으면 자동 첨부)
        var CSRF = (function () {
          var h = document.querySelector('meta[name="_csrf_header"]');
          var t = document.querySelector('meta[name="_csrf"]');
          return { h: h && h.content, t: t && t.content };
        })();
        function withCsrf(headers) {
          if (CSRF.h && CSRF.t) headers[CSRF.h] = CSRF.t;
          return headers;
        }

        var table = document.getElementById('inventoryCountTable');
        var tbody = document.getElementById('tbodyCounts');
        if (!table || !tbody) return;

        // 모달 & 폼 요소
        var countModalEl = document.getElementById('countModal');
        var countModal = countModalEl ? new bootstrap.Modal(countModalEl) : null;
        var $countIndex = document.getElementById('countIndex');
        var $invenIndex = document.getElementById('invenIndexInput');
        var $invenQty   = document.getElementById('invenQtyInput');
        var $actualQty  = document.getElementById('actualQtyInput');
        var $updateAt   = document.getElementById('updateAtInput');
        var $btnSave    = document.getElementById('btnSave');
        var $countForm  = document.getElementById('countForm');
        var $btnOpenCreate = document.getElementById('btnOpenCreate');

        // 쿼리 파라미터 기본값
        var urlq   = new URLSearchParams(location.search);
        var pageNum = urlq.get('pageNum') || '${cri.pageNum}';
        var amount  = urlq.get('amount')  || '${cri.amount}';

        // 최초 로드
        load(pageNum, amount);

        // 조회 버튼
        var btnSearch = document.getElementById('btnSearch');
        if (btnSearch) {
          btnSearch.addEventListener('click', function () {
            var sel = document.querySelector('select[name="amount"]');
            load(1, sel ? sel.value : 20);
          });
        }

        // 초기화 버튼
        var btnReset = document.getElementById('btnReset');
        if (btnReset) {
          btnReset.addEventListener('click', function () {
            history.replaceState(null, '', location.pathname);
            var sel = document.querySelector('select[name="amount"]');
            load(1, sel ? sel.value : 20);
          });
        }

        // 신규 등록 버튼
        $btnOpenCreate && $btnOpenCreate.addEventListener('click', function () {
          $countIndex.value = '';
          $invenIndex.value = '';
          $invenQty.value   = '';
          $actualQty.value  = '';
          $updateAt.value   = '';
          $btnSave.textContent = '신규 저장';
          $btnSave.dataset.mode = 'create';
          countModal && countModal.show();
        });

        function load(pn, am) {
          fetch(ctx + '/inventory/inventory_count_list?format=json'
                  + '&pageNum=' + encodeURIComponent(pn)
                  + '&amount='  + encodeURIComponent(am)
                  + '&_ts=' + Date.now(), // 캐시 무효화
                  { headers: { 'Accept': 'application/json' }, cache: 'no-store', credentials: 'same-origin' })
                  .then(function (res) { if (!res.ok) throw new Error('HTTP ' + res.status); return res.json(); })
                  .then(function (data) {
                    renderRows((data && data.list) ? data.list : []);
                    renderPagination((data && data.page) ? data.page : {startPage:1,endPage:1,prev:false,next:false});
                  })
                  .catch(function (err) {
                    console.error('[InvenCount] load error:', err);
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">데이터 로드 실패</td></tr>';
                  });
        }

        function renderRows(rows) {
          tbody.innerHTML = '';
          if (!rows.length) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">조회 결과가 없습니다.</td></tr>';
            return;
          }
          rows.forEach(function (r) {
            var variance = toInt(r.actualQuantity) - toInt(r.invenQuantity);
            var tr = document.createElement('tr');
            tr.innerHTML =
                    '<td>' + safe(r.countIndex)     + '</td>' +
                    '<td>' + safe(r.invenIndex)     + '</td>' +
                    '<td>' + safe(r.invenQuantity)  + '</td>' +
                    '<td>' + safe(r.actualQuantity) + '</td>' +
                    '<td>' + variance               + '</td>' +
                    '<td>' + fmtDate(safe(r.updateAt)) + '</td>' +
                    '<td class="text-nowrap">' +
                    '<button type="button" class="btn btn-sm btn-outline-primary btn-edit" data-id="' + safe(r.countIndex) + '">수정</button> ' +
                    '<button type="button" class="btn btn-sm btn-outline-danger btn-delete-count" data-id="' + safe(r.countIndex) + '">삭제</button>' +
                    '</td>';
            tbody.appendChild(tr);
          });
        }

        function renderPagination(p) {
          var ul = document.getElementById('pagination');
          if (!ul) return;
          ul.innerHTML = '';

          function makeLi(label, targetPage, disabled, active) {
            var li = document.createElement('li');
            li.className = 'page-item ' + (disabled ? 'disabled ' : '') + (active ? 'active' : '');
            var a = document.createElement('a');
            a.className = 'page-link';
            a.href = 'javascript:void(0)';
            a.textContent = label;
            if (!disabled) a.addEventListener('click', function () {
              var sel = document.querySelector('select[name="amount"]');
              load(targetPage, sel ? sel.value : 20);
            });
            li.appendChild(a);
            return li;
          }

          if (p.prev) ul.appendChild(makeLi('Previous', p.startPage - 1, false, false));
          for (var n = p.startPage; n <= p.endPage; n++) {
            ul.appendChild(makeLi(String(n), n, false, Number(n) === Number('${cri.pageNum}')));
          }
          if (p.next) ul.appendChild(makeLi('Next', p.endPage + 1, false, false));
        }

        function toInt(v) { return (v == null ? 0 : parseInt(v, 10) || 0); }
        function safe(v)  { return (v == null ? '' : v); }
        function fmtDate(v){ return v ? String(v).replace('T',' ') : ''; }

        // ----- 삭제 -----
        document.addEventListener('click', function (e) {
          var btn = e.target.closest('.btn-delete-count');
          if (!btn) return;
          var id = btn.getAttribute('data-id');
          if (!id || !confirm('삭제할까요?')) return;

          fetch(ctx + '/inventory/inventory_count_list/' + encodeURIComponent(id), {
            method: 'DELETE',
            headers: withCsrf({}),
            credentials: 'same-origin'
          }).then(function (res) {
            if (!res.ok) throw new Error('삭제 실패 ' + res.status);
            btn.closest('tr') && btn.closest('tr').remove();
          }).catch(function (err) {
            alert(err.message || '삭제 중 오류');
          });
        });

        // ----- 수정: 행에서 값 읽어 모달로 -----
        function openEditModal(row) {
          var cells = row.children; // 실사번호 | 재고번호 | 장부수량 | 실사수량 | 차이 | 일자 | 액션
          var countIndex  = cells[0].textContent.trim();
          var invenIndex  = cells[1].textContent.trim();
          var invenQty    = cells[2].textContent.trim();
          var actualQty   = cells[3].textContent.trim();
          var updateAtTxt = cells[5].textContent.trim(); // YYYY-MM-DD...

          var dateOnly = updateAtTxt ? updateAtTxt.substring(0, 10) : '';

          $countIndex.value = countIndex;
          $invenIndex.value = invenIndex || '';
          $invenQty.value   = invenQty || 0;
          $actualQty.value  = actualQty || 0;
          $updateAt.value   = dateOnly || '';

          $btnSave.textContent = '수정 저장';
          $btnSave.dataset.mode = 'edit';

          countModal && countModal.show();
        }

        document.addEventListener('click', function (e) {
          var btn = e.target.closest('.btn-edit');
          if (!btn) return;
          var row = btn.closest('tr');
          if (!row) return;
          openEditModal(row);
        });

        // ----- 저장(신규/수정) -----
        $countForm && $countForm.addEventListener('submit', function (e) {
          e.preventDefault();

          var mode = $btnSave.dataset.mode || 'edit';
          var payload = {
            invenIndex:      Number($invenIndex.value),
            invenQuantity:   Number($invenQty.value),
            actualQuantity:  Number($actualQty.value),
            updateAt:        $updateAt.value // YYYY-MM-DD
          };

          if (!payload.invenIndex || payload.invenIndex < 1) { alert('재고번호를 확인하세요.'); return; }
          if (payload.invenQuantity < 0 || payload.actualQuantity < 0) { alert('수량은 0 이상이어야 합니다.'); return; }
          if (!payload.updateAt) { alert('실사일자를 선택하세요.'); return; }

          // 수정
          if (mode === 'edit') {
            var id = $countIndex.value;
            if (!id) { alert('countIndex가 없습니다.'); return; }

            fetch(ctx + '/inventory/inventory_count_list/' + encodeURIComponent(id), {
              method: 'PUT',
              headers: withCsrf({ 'Content-Type': 'application/json', 'Accept': 'application/json' }),
              credentials: 'same-origin',
              body: JSON.stringify(payload)
            })
                    .then(function (res) {
                      if (!res.ok) throw new Error('수정 실패 ' + res.status);
                      return res.json ? res.json() : true;
                    })
                    .then(function () {
                      countModal && countModal.hide();
                      var sel = document.querySelector('select[name="amount"]');
                      load(Number(new URLSearchParams(location.search).get('pageNum') || 1),
                              sel ? sel.value : 20);
                    })
                    .catch(function (err) {
                      alert(err.message || '수정 중 오류');
                    });

            // 신규
          } else if (mode === 'create') {
            fetch(ctx + '/inventory/inventory_count_list', {
              method: 'POST',
              headers: withCsrf({ 'Content-Type': 'application/json', 'Accept': 'application/json' }),
              credentials: 'same-origin',
              body: JSON.stringify(payload)
            })
                    .then(function (res) {
                      if (!res.ok) throw new Error('등록 실패 ' + res.status);
                      return res.json();
                    })
                    .then(function () {
                      countModal && countModal.hide();
                      var sel = document.querySelector('select[name="amount"]');
                      load(1, sel ? sel.value : 20);
                    })
                    .catch(function (err) {
                      alert(err.message || '등록 중 오류');
                    });
          }
        });

      } catch (e) {
        console.error('[InvenCount] init fatal:', e);
      }
    }
  })();
</script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
