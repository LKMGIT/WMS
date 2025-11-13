<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="page-inner">
    <div class="page-header">
      <h3 class="fw-bold mb-3">월별 입고 현황 조회</h3>
      <ul class="breadcrumbs mb-3">
        <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">입고 관리</li>
        <li class="separator"><i class="icon-arrow-right"></i></li>
        <li class="nav-item">월별 현황</li>
      </ul>
    </div>

    <div class="card mb-4">
      <div class="card-body">
        <form id="monthSearchForm" onsubmit="event.preventDefault(); loadMonthStatus();">
          <div class="row g-3 align-items-center">
            <div class="col-auto">
              <label for="year" class="form-label">년도:</label>
              <input type="number" id="year" name="year" class="form-control"
                     value="<%= java.time.Year.now().getValue() %>"
                     min="2000" max="2100" required style="width: 100px;">
            </div>

            <div class="col-auto">
              <label for="month" class="form-label">월:</label>
              <input type="number" id="month" name="month" class="form-control"
                     value="<%= java.time.MonthDay.now().getMonthValue() %>"
                     min="1" max="12" required style="width: 80px;">

            </div>
            <div class="col-auto mt-4">
              <button type="submit" class="btn btn-info">
                <i class="fa fa-search"></i> 조회
              </button>
            </div>

          </div>
        </form>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <h4 class="card-title">월별 현황 결과</h4>
        <p class="card-category mb-0" id="resultSummary">조회 버튼을 눌러주세요.</p>
      </div>
      <div class="card-body">

        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
            <tr>
              <th>입고번호</th>
              <th>요청일</th>
              <th>희망입고일</th>
              <th>승인상태</th>
              <th>요청수량</th>
              <th>상세 개수</th>
              <th>총 입고 수량</th>
              <th>창고</th>
            </tr>
            </thead>
            <tbody id="monthResults">
            <tr><td colspan="8" class="text-center py-4 text-muted">조회 버튼을 눌러주세요.</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
  // 월별 입고 현황 조회
  function loadMonthStatus() {
    const year = document.getElementById('year').value;
    const month = document.getElementById('month').value;
    if (!year || !month) {
      alert('년도와 월을 입력해주세요.');
      return;
    }

    if (month < 1 || month > 12) {
      alert('월은 1부터 12 사이의 값이어야 합니다.');
      return;
    }

    const url = '<c:url value="/inbound/admin/status/month"/>?year=' + year + '&month=' + month;
    // 로딩 표시
    document.getElementById('monthResults').innerHTML =
            '<tr><td colspan="8" class="text-center py-4"><i class="fa fa-spinner fa-spin"></i> 데이터를 불러오는 중...</td></tr>';
    document.getElementById('resultSummary').textContent = '데이터를 불러오는 중...';

    fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })
            .then(response => {
              if (!response.ok) {
                if (response.status === 401) {
                  alert('로그인이 필요합니다.');
                  location.href = '<c:url value="/login/loginForm"/>';
                  throw new Error('Unauthorized');
                }
                throw new Error('서버 오류가 발생했습니다.');
              }
              return response.json();
            })
            .then(data => {
              displayMonthResults(data, year, month);
            })
            .catch(error => {
              console.error('Error:', error);
              document.getElementById('monthResults').innerHTML =
                      '<tr><td colspan="8" class="text-center py-4 text-danger">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>';
              document.getElementById('resultSummary').textContent = '오류가 발생했습니다.';
            });
  }

  // 결과 표시
  function displayMonthResults(results, year, month) {
    const tbody = document.getElementById('monthResults');
    const summary = document.getElementById('resultSummary');

    if (!results || results.length === 0) {
      tbody.innerHTML = '<tr><td colspan="8" class="text-center py-4 text-muted">해당 월에 입고 요청 내역이 없습니다.</td></tr>';
      summary.textContent = year + '년 ' + month + '월 - 결과 없음';
      return;
    }

    // 통계 계산
    let totalRequests = results.length;
    let totalQuantity = 0;
    let totalReceived = 0;

    let html = '';
    results.forEach(item => {
      totalQuantity += item.inboundRequestQuantity || 0;
      totalReceived += item.totalReceivedQuantity || 0;

      // 상태 배지
      let statusBadge = '';
      switch(item.approvalStatus) {
        case 'PENDING':
          statusBadge = '<span class="badge bg-warning">대기중</span>';
          break;
        case 'APPROVED':
          statusBadge = '<span class="badge bg-success">승인됨</span>';
          break;
        case 'REJECTED':
          statusBadge = '<span class="badge bg-danger">거부됨</span>';
          break;
        case 'CANCELED':
          statusBadge = '<span class="badge bg-secondary">취소됨</span>';
          break;
        default:
          statusBadge = item.approvalStatus || '-';
      }

      const requestDate = item.inboundRequestDate ? formatDateTime(item.inboundRequestDate) : '-';
      const plannedDate = item.plannedReceiveDate ? formatDate(item.plannedReceiveDate) : '-';

      html += `
        <tr style="cursor:pointer" onclick="location.href='<c:url value="/inbound/admin/detail/"/>${item.inboundIndex}'">
          <td><strong>#${item.inboundIndex}</strong></td>
          <td>${requestDate}</td>
          <td>${plannedDate}</td>
          <td>${statusBadge}</td>
           <td>${item.inboundRequestQuantity || 0}개</td>
          <td>${item.detailCount || 0}건</td>
          <td>${item.totalReceivedQuantity || 0}개</td>
          <td>창고 #${item.warehouseIndex || '-'}</td>
        </tr>
      `;
    });

    tbody.innerHTML = html;
    summary.textContent = year + '년 ' + month + '월 - 총 ' + totalRequests + '건 | 요청수량: ' +
            totalQuantity + '개 | 입고수량: ' + totalReceived + '개';
  }

  // ▼▼▼ [수정됨] 안정적인 날짜 변환 함수로 교체 ▼▼▼
  function formatDateTime(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 6) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])} ${pad(dateStr[3])}:${pad(dateStr[4])}`;
      }
      return dateStr;
    }
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      if (Array.isArray(dateStr) && dateStr.length >= 3) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${dateStr[0]}-${pad(dateStr[1])}-${pad(dateStr[2])}`;
      }
      return dateStr;
    }
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
  // ▲▲▲ [수정됨] ▲▲▲
</script>

<%-- 템플릿 종료 --%>