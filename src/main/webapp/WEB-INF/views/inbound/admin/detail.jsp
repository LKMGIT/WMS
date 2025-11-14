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

  @keyframes fadeIn {
    from { opacity: 0;
    }
    to { opacity: 1; }
  }

  .fade-in-up {
    animation: fadeInUp 0.6s ease-out;
  }

  /* 헤더 스타일 */
  .detail-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    padding: 2rem;
    color: white;
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    margin-bottom: 2rem;
    position: relative;
    overflow: hidden;
  }

  .detail-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff" fill-opacity="0.1" d="M0,96L48,122.7C96,149,192,203,288,208C384,213,480,171,576,149.3C672,128,768,128,864,154.7C960,181,1056,235,1152,240C1248,245,1344,203,1392,181.3L1440,160L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z"></path></svg>') no-repeat center bottom;
    background-size: cover;
    opacity: 0.2;
    z-index: 1;
  }

  .header-content {
    position: relative;
    z-index: 2;
  }

  .header-icon {
    font-size: 3rem;
    margin-right: 1.5rem;
  }

  /* 목록 스타일 */
  .detail-table th {
    background-color: #f8f9fa;
    color: #495057;
    font-weight: 600;
  }

  .detail-table .form-control {
    max-width: 150px;
    display: inline-block;
  }

  .data-highlight {
    font-weight: 700;
    color: #4CAF50;
    /* Green */
  }

  .status-badge {
    padding: .35em .65em;
    border-radius: .35rem;
    font-size: 75%;
    font-weight: 700;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
  }

  /* 🔥 [수정] 상태별 색상 명확히 구분 */
  .status-PENDING { background-color: #ffc107; color: #343a40; } /* 승인 대기 (노랑) */
  .status-APPROVED { background-color: #28a745; color: white; } /* 승인 완료 (초록) */
  .status-REJECTED { background-color: #dc3545; color: white; } /* 승인 거부 (빨강) */
  .status-CANCELED { background-color: #6c757d; color: white; } /* 요청 취소 (회색) */

</style>

<div class="container py-5 fade-in-up">

  <div class="row">
    <div class="col-12">
      <div class="d-flex align-items-center mb-4">
        <i class="fas fa-warehouse header-icon"></i>
        <h1 class="mb-0">입고 요청 상세 내역</h1>
      </div>
    </div>
  </div>

  <%-- 개요 카드 --%>
  <div class="detail-header mb-5">
    <div class="header-content">
      <div class="row">
        <div class="col-md-3">



          <p class="mb-1 text-light"><strong>요청 번호</strong></p>
          <h4 id="inboundIndexDisplay" class="text-white">...</h4>
        </div>
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>아이템 번호</strong></p>
          <h4 id="itemIndexDisplay" class="text-white">...</h4>
        </div>
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>요청 수량</strong></p>



          <h4 id="requestQuantityDisplay" class="text-white">...</h4>
        </div>
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>승인 상태</strong></p>
          <h4 id="approvalStatusDisplay" class="text-white">...</h4>
        </div>
      </div>
      <div class="row mt-3">
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>희망 입고일</strong></p>
          <h5 id="plannedReceiveDateDisplay"



              class="text-white">...</h5>
        </div>
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>요청 일시</strong></p>
          <h5 id="inboundRequestDateDisplay" class="text-white">...</h5>
        </div>
        <div class="col-md-3">
          <p class="mb-1 text-light"><strong>창고 번호</strong></p>
          <h5 id="warehouseIndexDisplay" class="text-white">...</h5>



        </div>

        <div class="col-md-3" id="approveDateSection" style="display: none;">
          <p class="mb-1 text-light"><strong>승인 일시</strong></p>
          <h5 id="approveDateDisplay" class="text-white">...</h5>
        </div>
      </div>
    </div>
  </div>

  <%-- 상세 내역 테이블 --%>
  <div class="card shadow-sm border-0 fade-in-up" style="animation-delay: 0.1s;">
    <div class="card-header bg-white py-3 border-bottom-0">
      <h5 class="mb-0">입고 처리 상세 항목 (단일 처리)</h5>



    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover mb-0 detail-table">
          <thead>
          <tr>
            <th scope="col" style="width: 10%;">상세번호</th>
            <th scope="col" style="width: 20%;">배정 구역</th>
            <th scope="col" style="width: 25%;">실제 입고 수량</th>


            <th scope="col" style="width: 20%;">처리 일시</th>
            <th scope="col" style="width: 25%;">관리</th>

          </tr>
          </thead>
          <tbody id="detailListTableBody">
          <%-- 데이터가 로드될 위치 --%>
          <tr><td colspan="5" class="text-center py-5">상세 내역을 불러오는 중...</td></tr>
          </tbody>


        </table>
      </div>
    </div>
  </div>

  <%-- 관리 버튼 섹션 (구역 선택 요소 포함) --%>
  <div id="adminActionSection" class="mt-4 fade-in-up" style="animation-delay: 0.2s;
    display: none;">
    <div class="row align-items-center">
      <div class="col-md-4">
        <div class="input-group">
          <span class="input-group-text" style="font-weight: 600;"><i class="fas fa-map-marker-alt me-2"></i> 구역 선택</span>
          <select id="sectionSelectForApproval" class="form-select" disabled>
            <option value="">(창고 정보 로드 후 활성화)</option>
          </select>
        </div>
      </div>


      <div class="col-md-8 text-end">
        <button type="button" class="btn btn-danger me-2" onclick="cancelRequest()">
          <i class="fas fa-times-circle me-1"></i> 요청 취소
        </button>
        <button type="button" class="btn btn-success" onclick="approveRequest()">
          <i class="fas fa-check-circle me-1"></i> 요청 승인 </button>
      </div>
    </div>
  </div>

</div>

<script>
  var ctx = '${pageContext.request.contextPath}';
  var currentRequestData = null;

  // 🔥 [복원/기존] 유틸리티 함수: LocalDateTime 배열을 'YYYY-MM-DD HH:mm:ss'

  // 형태로 포맷팅 (시간 포함)
  function formatLocalDateTime(dateTimeArray) {
    if (!Array.isArray(dateTimeArray) ||
            dateTimeArray.length < 5) {
      return 'N/A';
    }
    var pad = function(n) { return String(n).padStart(2, '0');
    };
    // [년, 월, 일, 시, 분] 배열을 'YYYY-MM-DD HH:mm' 형식으로 조합 (초도 있다면 포함)
    var datePart = dateTimeArray[0] + '-' + pad(dateTimeArray[1]) + '-' + pad(dateTimeArray[2]);
    var timePart = pad(dateTimeArray[3]) + ':' + pad(dateTimeArray[4]);
    // 초(second)가 있다면 추가 (index 5)
    if (dateTimeArray.length > 5) {
      timePart += ':' + pad(dateTimeArray[5]);
    }
    return datePart + ' ' + timePart;
  }

  // 🔥 [신규] 유틸리티 함수: LocalDateTime 배열을 'YYYY-MM-DD' 형태로 포맷팅 (날짜만)
  function formatDateOnly(dateTimeArray) {
    if (!Array.isArray(dateTimeArray) ||
            dateTimeArray.length < 3) {
      return 'N/A';
    }
    var pad = function(n) { return String(n).padStart(2, '0');
    };
    // [년, 월, 일] 배열을 'YYYY-MM-DD' 형식으로 조합 (날짜만)
    var datePart = dateTimeArray[0] + '-' + pad(dateTimeArray[1]) + '-' + pad(dateTimeArray[2]);
    return datePart;
  }

  // 창고 번호에 따른 구역 목 데이터
  function getSectionListByWarehouse(warehouseIndex) {
    var sections = [];
    if (warehouseIndex) {
      for (var i = 1; i <= 5; i++) {
        // 구역 인덱스: [창고번호][구역번호] 형태로 가정, 예를 들어 101, 102...
        var sectionIndex = Number(String(warehouseIndex) + String(i).padStart(2, '0'));
        sections.push({
          index: sectionIndex,
          name: '구역 ' + sectionIndex + ' (W' + warehouseIndex + ')'
        });
      }
    }
    return sections;
  }

  // 유틸리티 함수: 상태 뱃지 생성
  function
  getStatusBadge(status) {
    if (!status) return 'N/A';
    // 🔥 [수정] 텍스트를 명확하게 구분
    var statusMap = {
      'PENDING': { text: '승인 대기', class: 'status-PENDING' },
      'APPROVED': { text: '승인 완료', class: 'status-APPROVED' },
      'REJECTED': { text: '승인 거부', class: 'status-REJECTED' },
      'CANCELED': { text: '요청 취소', class: 'status-CANCELED' }
    };
    var info = statusMap[status] || { text: status, class: 'bg-secondary' };
    return '<span class="status-badge ' + info.class + '">' + info.text +
            '</span>';
  }

  // 데이터 표시 함수: 개요
  function displayRequestOverview(data) {
    currentRequestData = data;
    $('inboundIndexDisplay').textContent = data.inboundIndex;
    $('itemIndexDisplay').textContent = data.itemIndex || data.item_index; // DTO 변경 반영
    $('requestQuantityDisplay').textContent = data.inboundRequestQuantity + ' 개';
    $('approvalStatusDisplay').innerHTML = getStatusBadge(data.approvalStatus);

    // 🔥 [수정] 희망 입고일 (plannedReceiveDate) 처리: 날짜만 표시 (formatDateOnly 사용)
    $('plannedReceiveDateDisplay').textContent = formatDateOnly(data.plannedReceiveDate);
    // 🔥 [기존 유지] 요청 일시 (inboundRequestDate) 처리: 시간까지 표시 (formatLocalDateTime 사용)
    $('inboundRequestDateDisplay').textContent = formatLocalDateTime(data.inboundRequestDate);
    $('warehouseIndexDisplay').textContent = data.warehouseIndex || '미지정';

    // 구역 선택 드롭다운 업데이트
    var sectionSelect = $('sectionSelectForApproval');
    sectionSelect.innerHTML = '<option value="">-- 구역 선택 --</option>'; // 기본 옵션
    if (data.warehouseIndex && data.approvalStatus === 'PENDING') {
      var sections = getSectionListByWarehouse(data.warehouseIndex);
      sections.forEach(function(section) {
        var option = document.createElement('option');
        option.value = section.index;
        option.textContent = section.name;
        sectionSelect.appendChild(option);
      });
      sectionSelect.disabled = false; // 선택 가능하게 활성화
    } else {
      sectionSelect.disabled = true;
    }


    if (data.approvalStatus !== 'PENDING') {
      $('adminActionSection').style.display = 'none';
      // 🔥 [기존 유지] 승인 일시 (approveDate) 처리: 시간까지 표시 (formatLocalDateTime 사용)
      var approveDateDisplay = data.approveDate ?
              formatLocalDateTime(data.approveDate) : 'N/A';
      $('approveDateDisplay').textContent = approveDateDisplay;
      $('approveDateSection').style.display = 'block';
    } else {
      $('adminActionSection').style.display = 'flex';
      // 승인 섹션 표시
      $('approveDateSection').style.display = 'none';
    }
  }

  // 데이터 표시 함수: 상세 리스트
  function displayDetailList(details, approvalStatus) {
    var tbody = $('detailListTableBody');
    tbody.innerHTML = ''; // 초기화

    if (!details || details.length === 0) {
      if (approvalStatus === 'PENDING') {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-info-circle text-info me-2"></i> 요청 승인 시 상세 처리 항목이 1개 생성됩니다.</td></tr>';
      } else {
        // 🔥 [수정] 상세 내역이 없으면 (예: 취소, 거부) 이 메시지를 표시
        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-exclamation-triangle text-danger me-2"></i> 상세 내역이 존재하지 않습니다.</td></tr>';
      }
      return;
    }

    // 상세 내역이 1개만 로드되도록 처리됨
    var rows = details.map(function(detail) {
      var isProcessed = detail.receivedQuantity > 0; // receivedQuantity가 0보다 크면 처리 완료로 간주

      // 🔥 [기존 유지] 처리 일시 (completeDate) 처리: 시간까지 표시 (formatLocalDateTime 사용)
      var completeDateDisplay = detail.completeDate ? formatLocalDateTime(detail.completeDate) : '-';

      var sectionInput = '';
      var quantityInput = '';
      var actions = '';



      if (approvalStatus === 'APPROVED' &&

              !isProcessed) {
        // 승인된 상태에서 미처리된 상세 내역 (수정/입력 가능)

        // 구역은 승인 시 결정되므로, 여기에선 표시만
        sectionInput = '<span class="data-highlight">' + (detail.sectionIndex || '-') + '</span>';

        // 실제 입고 수량 필드
        quantityInput = '<input type="number" class="form-control form-control-sm" id="qty-' + detail.detailIndex +
                '" value="' + (detail.receivedQuantity ||
                        0) + '" min="0">';

        actions =

                '<button class="btn btn-sm btn-primary" onclick="processDetail(' + detail.detailIndex + ', ' + detail.inboundIndex + ')">입고 처리</button>';
      } else if (approvalStatus === 'APPROVED' && isProcessed) {
        // 승인된 상태에서 처리 완료된 상세 내역
        sectionInput = '<span class="data-highlight">' + (detail.sectionIndex || '-') + '</span>';
        quantityInput = '<span class="data-highlight">' + detail.receivedQuantity + ' 개</span>';
        actions = '<button class="btn btn-sm btn-secondary" disabled>처리 완료</button>';
      } else {
        // PENDING 또는 CANCELED, REJECTED 상태
        sectionInput = '-';
        quantityInput = '-';
        actions = '<button class="btn btn-sm btn-secondary" disabled>대기/취소</button>';
      }

      return '<tr>' +
              '<td>' + detail.detailIndex + '</td>' +
              '<td>' + sectionInput + '</td>' +
              '<td>' + quantityInput + '</td>' +
              '<td>' + completeDateDisplay + '</td>' +

              '<td>' +


              actions + '</td>' +
              '</tr>';
    }).join('');
    tbody.innerHTML = rows;
  }

  // 🔥 상세 처리: sectionIndex를 Long 타입으로 변환하여 전송
  window.processDetail = function(detailIndex, inboundIndex) {
    var quantityElement = $('qty-' + detailIndex);
    // 입력값 유효성 검사
    var quantity = quantityElement ? quantityElement.value : null;
    if (quantity == "" || isNaN(Number(quantity)) || Number(quantity) <= 0) {
      return alert("올바른 입고 수량을 입력하세요.");
    }

    // currentRequestData에서 warehouseIndex와 sectionIndex를 가져와 설정
    if (!currentRequestData || !currentRequestData.warehouseIndex) {
      return alert(" 창고 정보를 찾을 수 없습니다. 페이지를 새로고침해주세요.");
    }

    // 현재 상세 내역에서 sectionIndex를 가져옴 (이미 DB에 저장되어 있음)
    var detailInfo = currentRequestData.details.find(d => d.detailIndex === detailIndex);
    if (!detailInfo || !detailInfo.sectionIndex) {
      return alert("배정된 구역 정보를 찾을 수 없습니다. 페이지를 새로고침해주세요.");
    }

    var warehouseIndex = currentRequestData.warehouseIndex;
    var sectionIndex = detailInfo.sectionIndex;
    var detailData = {
      detailIndex: detailIndex,
      inboundIndex: inboundIndex,
      // 🔥 String -> Number() 변환하여 서버의 DTO Long 타입에 맞춤
      sectionIndex: Number(sectionIndex),
      receivedQuantity: Number(quantity),
      warehouseIndex: warehouseIndex
    };
    var url = ctx + '/inbound/admin/detail/process';
    fetch(url, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(detailData)
    })
            .then(function(res) {
              if (res.ok) return res.json();
              return res.json().then(data => {
                return Promise.reject(new



                Error(data.message || '입고 처리 중 알 수 없는 오류 발생'));
              }).catch(() => {
                return Promise.reject(new Error('HTTP ' + res.status + ' 오류'));
              });
            })



            .then(function(data) {

              alert('입고 처리가 성공적으로 완료되었습니다.');
              loadInboundDetail(inboundIndex); // 리스트 새로고침
            })
            .catch(function(err) {
              console.error('[processDetail] error:', err);
              alert('입고 처리 중 오류 발생: ' + err.message);

            });
  };
  // 🔥 요청 승인: cancelReason을 Long 타입에 맞게 처리하여 전송
  window.approveRequest = function() {
    var inboundIndex = currentRequestData.inboundIndex;
    if (!currentRequestData || !inboundIndex) {
      return alert("요청 정보가 유효하지 않습니다.");
    }

    // 구역 선택 값 가져오기 로직 복원
    var sectionSelect = $('sectionSelectForApproval');
    var selectedSectionIndex = sectionSelect.value;
    if (!selectedSectionIndex || selectedSectionIndex.trim() === "") {
      return alert("승인할 구역을 반드시 선택해야 합니다.");
    }

    if (!confirm("선택된 구역(" + selectedSectionIndex + ")으로 요청을 승인하고 상세 내역을 1건 생성하시겠습니까?")) {
      return;
    }

    // 🔥 승인 요청 DTO 구성 (서버의 Long.valueOf() 처리에 맞춰 String(Number(..))로 전송)
    var requestDTO = {
      cancelReason: String(Number(selectedSectionIndex))
    };
    var url = ctx + '/inbound/admin/request/' + inboundIndex + '/approve';
    fetch(url, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(requestDTO) // 구역 정보를 담은 DTO 전송
    })
            .then(function(res) {
              if (res.ok) return res.json();
              return res.json().then(data => {
                return Promise.reject(new

                Error(data.message


                        || '승인 처리 중 알 수 없는 오류 발생'));
              }).catch(() => {
                return Promise.reject(new Error('HTTP ' + res.status + ' 오류'));

              });
            })



            .then(function(data) {
              alert(data.message || '요청이 성공적으로 승인되었습니다.');
              loadInboundDetail(inboundIndex);
            })
            .catch(function(err) {
              console.error('[approveRequest] error:', err);

              alert('요청 승인 중 오류 발생: ' + err.message);

            });
  };
  // 요청 취소 (취소 사유 입력)
  window.cancelRequest = function() {
    if (!currentRequestData || !currentRequestData.inboundIndex) {
      return alert("요청 정보가 유효하지 않습니다.");
    }

    var cancelReason = prompt("요청 취소를 진행합니다. 취소 사유를 입력해 주세요:");
    if (!cancelReason || cancelReason.trim() === "") {
      return alert("취소 사유를 입력해야 취소할 수 있습니다.");
    }

    if (!confirm('입고 요청을 취소하시겠습니까? (사유: ' + cancelReason + ')')) {
      return;
    }

    var inboundIndex = currentRequestData.inboundIndex;
    var url = ctx + '/inbound/admin/request/' + inboundIndex + '/cancel';
    fetch(url, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ cancelReason: cancelReason })
    })
            .then(function(res) {
              if (res.ok) return res.json();
              return res.json().then(data => Promise.reject(new Error(data.message || '취소 처리 중 오류 발생')));
            })




            .then(function(data) {
              alert('요청이 성공적으로 취소되었습니다.');
              loadInboundDetail(inboundIndex); // 리스트 새로고침
            })
            .catch(function(err) {
              console.error('[cancelRequest] error:', err);
              alert('요청 취소 중 오류 발생: ' + err.message);
            });
  };
  // 데이터 로드
  function loadInboundDetail(inboundIndex) {
    var url = ctx + '/inbound/admin/request/' + inboundIndex;
    var tbody = $('detailListTableBody');

    console.log('[loadInboundDetail] API 호출 URL:', url);

    fetch(url, {
      method: 'GET',
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
            .then(function(res) {
              console.log('[loadInboundDetail] 응답 상태:', res.status);
              if (res.ok) return res.json();
              return



              Promise.reject(new Error('HTTP ' + res.status));
            })
            .then(function(data) {
              console.log('[loadInboundDetail] 받은 데이터:', data);
              if (!data) throw new Error('EMPTY_DATA');

              displayRequestOverview(data);



              displayDetailList(data.details, data.approvalStatus);

            })
            .catch(function(err) {
              console.error('[loadInboundDetail] error:', err);
              tbody.innerHTML = '<tr><td colspan="5" class="text-center py-5"><i class="fas fa-exclamation-triangle" style="font-size: 2rem; color: #f56565;"></i><p class="mt-3 text-danger">상세 정보를 불러오는 중 오류가 발생했습니다.</p></td></tr>';
            });
  }

  // 초기화
  document.addEventListener('DOMContentLoaded', function () {
    // 간편 셀렉터 함수
    window.$ = function(id) { return document.getElementById(id); };

    try {
      var segs = (location.pathname || '').split('/').filter(Boolean);
      var last = segs[segs.length - 1] || '';
      var inboundIndex = /^[0-9]+$/.test(last) ? last : '';
      loadInboundDetail(inboundIndex);
    } catch (e) {
      console.error('초기화 오류:', e);
      $('detailListTableBody').innerHTML = '<tr><td colspan="5" class="text-center py-5">입고 요청 번호를 확인해주세요.</td></tr>';
    }
  });

</script>

<%-- 템플릿 끝 --%>
<c:import url="/WEB-INF/views/includes/footer.jsp"/>