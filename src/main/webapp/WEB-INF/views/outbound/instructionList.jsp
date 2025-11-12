<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:18
  To change this template use File |
  Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="../includes/header.jsp" %>

<div class="page-inner">
    <div class="page-header">
        <h3 class="fw-bold mb-3">출고 관리</h3>
        <ul class="breadcrumbs mb-3">
            <li class="nav-home"><a href="${contextPath}/"><i class="icon-home"></i></a></li>
            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="#">출고 관리</a></li>

            <li class="separator"><i class="icon-arrow-right"></i></li>
            <li class="nav-item"><a href="${contextPath}/outbound/instructions">출고 지시서 목록</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <%-- [신규] 관리자 버튼 추가 --%>
                    <div class="d-flex align-items-center">
                        <div class="card-title">출고 지시서 목록</div>
                        <div class="ms-auto">
                            <button class="btn btn-primary btn-round" type="button" id="bulkRegisterWaybillBtn">
                                <i class="fa fa-truck"></i> 선택 운송장 등록
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row g-3 justify-content-center mb-3">
                        <form id="searchForm" class="input-group">
                            <%-- [수정] 검색 UI를 input-group 내부에 배치 --%>
                            <div class="col-auto">
                                <select class="form-select" name="type">
                                    <option value="I">상품명 (item_name)</option>
                                    <option value="W">창고ID (warehouse_index)</option>
                                    <option value="S">운송장상태 (si_waybill_status)</option>
                                </select>
                            </div>
                            <div class="col-5">
                                <input type="text" class="form-control" name="keyword" placeholder="검색어 입력">
                            </div>
                            <div class="col-auto">
                                <button class="btn btn-default" type="button" id="searchBtn">검색</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="display table table-striped table-hover">
                            <thead>
                            <tr>
                                <%-- [신규] 체크박스 헤더 --%>
                                <th><input class="form-check-input" type="checkbox" id="checkAll"></th>
                                <th>지시서 ID (si_index)</th>
                                <th>상품명 (item_name)</th>
                                <th>수량 (or_quantity)</th>
                                <th>창고 ID (warehouse_index)</th>
                                <th>승인일 (approved_at)</th>
                                <th>운송장 상태 (si_waybill_status)</th>
                            </tr>
                            </thead>
                            <tbody id="instructionTbody">
                            <%-- [수정] colspan="7" --%>
                            <tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div id="instructionPagination" class="mt-3 d-flex justify-content-center"></div>

                    <div class="mt-3 text-end">
                        <a href="${contextPath}/outbound/requests" class="btn btn-secondary">
                            출고 요청 목록
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    const contextPath = "${contextPath}";
    // [단순화] ADMIN API 경로만 정의 (ADMIN 전용 페이지)
    const API_BASE = "${contextPath}/api/admin/outbound";

    /**
     * LocalDateTime 배열을 JavaScript Date 객체로 변환
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) {
            return null;
        }
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 날짜 포맷팅 (toLocaleString 사용)
     */
    function formatDateTime(arr) {
        const dateObj = parseLocalDateTime(arr);
        return dateObj ? dateObj.toLocaleString("ko-KR") : "N/A";
    }

    /**
     * 지시서 목록 로드 함수
     */
    async function loadInstructionList(page = 1, type = '', keyword = '') {
        const tbody = document.getElementById("instructionTbody");
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">데이터를 불러오는 중입니다...</td></tr>';

        try {
            const params = new URLSearchParams({ page, amount: 10, type, keyword });
            const response = await axios.get(API_BASE + "/instruction", { params });

            const { list, pageDTO } = response.data;
            const listContextQuery = params.toString();

            tbody.innerHTML = ""; // tbody 초기화

            if (!list || list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">출고 지시 내역이 없습니다.</td></tr>';
                renderPagination(pageDTO, loadInstructionList, { type, keyword });
                return;
            }

            list.forEach(item => {
                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";

                // 목록 행 클릭 이벤트 바인딩
                tr.onclick = (e) => {
                    // 체크박스 클릭 시 상세페이지 이동 방지
                    if (e.target.type === 'checkbox') {
                        e.stopPropagation();
                        return;
                    }

                    // 현재 검색 조건이 담긴 listContextQuery를 URL에 추가하여 상세 페이지로 이동
                    // 예: /outbound/instruction/1?page=1&amount=10&type=T&keyword=test
                    location.href = contextPath + "/outbound/instruction/" + item.si_index + '?' + listContextQuery;
                };

                // 날짜 포맷팅
                const approvedDateStr = formatDateTime(item.approved_at);

                const status = item.si_waybill_status;
                let statusBadge = status;
                if (status === 'APPROVED') {
                    statusBadge = '<span class="badge bg-primary">등록 완료</span>';
                } else if (status === 'PENDING') {
                    statusBadge = '<span class="badge bg-warning text-dark">대기중</span>';
                }

                // [수정] 문자열 연결(+)을 사용하여 tr.innerHTML 생성
                tr.innerHTML =
                    '<td><input class="form-check-input check-item" type="checkbox" ' +
                    'data-id="' + item.si_index + '" ' +
                    'data-status="' + status + '"></td>' +
                    '<td>' + item.si_index + '</td>' +
                    '<td>' + item.item_name + '</td>' +
                    '<td>' + item.or_quantity + '</td>' +
                    '<td>' + item.warehouse_index + '</td>' +
                    '<td>' + approvedDateStr + '</td>' +
                    '<td>' + statusBadge + '</td>';
                tbody.appendChild(tr);
            });

            // 페이지네이션 생성
            renderPagination(pageDTO, loadInstructionList, { type, keyword });

        } catch (error) {
            console.error("Instruction List loading failed:", error);
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>';
        }
    }

    /**
     * 페이지네이션 렌더링 함수 (searchParams 객체 사용)
     */
    function renderPagination(pageDTO, loadFn, searchParams) {
        const paginationUl = document.getElementById("instructionPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO || !pageDTO.criteria) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;

        // '이전' 버튼 (문자열 연결로 복원)
        if (prev) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (startPage - 1) + '">이전</a></li>';
        }

        // 페이지 번호 (문자열 연결로 복원)
        for (let i = startPage; i <= endPage; i++) {
            const activeClass = (criteria.pageNum == i) ? 'active' : '';

            paginationHtml += '<li class="page-item ' + activeClass + '">' +
                '  <a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>';
        }

        // '다음' 버튼 (문자열 연결로 복원)
        if (next) {
            paginationHtml += '<li class="page-item"><a class="page-link" href="#" data-page="' + (endPage + 1) + '">다음</a></li>';
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        // [연결]: 동적으로 생성된 페이지 번호에 클릭 이벤트 바인딩
        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;
                loadFn(pageNum, searchParams.type, searchParams.keyword);
            });
        });
    }

    /**
     * 관리자 버튼 이벤트 바인딩
     */
    function bindAdminButtons() {
        // 1. 전체 선택 체크박스
        document.getElementById("checkAll").addEventListener("click", function() {
            const isChecked = this.checked;
            document.querySelectorAll(".check-item").forEach(cb => cb.checked = isChecked);
        });

        // 2. 일괄 운송장 등록
        document.getElementById("bulkRegisterWaybillBtn").addEventListener("click", async () => {
            const checkedItems = document.querySelectorAll(".check-item:checked");
            if (checkedItems.length === 0) {
                alert("운송장을 등록할 항목을 선택하세요.");
                return;
            }

            const itemsToRegister = [];
            let invalidItemFound = false;

            checkedItems.forEach(cb => {
                const id = cb.dataset.id;
                const status = cb.dataset.status;

                if (status === 'PENDING') {
                    itemsToRegister.push(id);
                } else {
                    invalidItemFound = true;
                }
            });

            if (invalidItemFound) {
                alert("선택된 항목 중 이미 운송장이 등록된 건이 포함되어 있습니다.\n('PENDING' 상태인 항목만 등록 가능합니다.)");
                return;
            }
            if (itemsToRegister.length === 0) {
                alert("운송장을 등록할 항목이 없습니다.");
                return;
            }

            if (!confirm("선택한 " + itemsToRegister.length + "건의 운송장을 등록하시겠습니까?")) return;
            let successCount = 0;
            let failCount = 0;

            for (const id of itemsToRegister) {
                try {
                    const data = { si_index: id };
                    await axios.post(API_BASE + "/waybill", data, {
                        headers: {'Content-Type': 'application/json'}
                    });
                    successCount++;
                } catch (error) {
                    console.error("ID " + id + " 운송장 등록 실패:", error);
                    failCount++;
                }
            }
            alert("운송장 등록 처리 완료\n성공: " + successCount + "건\n실패: " + failCount + "건");

            const form = document.getElementById("searchForm");
            loadInstructionList(1, form.type.value, form.keyword.value); // 목록 새로고침
            document.getElementById("checkAll").checked = false;
        });
    }

    document.addEventListener("DOMContentLoaded", () => {
        // 폼에서 초기 검색 조건을 읽어와서 목록 로드
        const form = document.getElementById("searchForm");
        const initialType = form.type ? form.type.value : '';
        const initialKeyword = form.keyword ? form.keyword.value : '';

        // URL에서 page 파라미터를 읽어와서 초기 페이지 설정 (선택 사항)
        const urlParams = new URLSearchParams(window.location.search);
        const initialPage = urlParams.get('page') ? parseInt(urlParams.get('page')) : 1;

        loadInstructionList(initialPage, initialType, initialKeyword);
        bindAdminButtons();
    });

    // 검색 버튼 이벤트 수정 (검색 시 1페이지로 이동)
    document.getElementById("searchBtn").addEventListener("click", () => {
        const form = document.getElementById("searchForm");
        const type = form.type.value;
        const keyword = form.keyword.value;
        loadInstructionList(1, type, keyword); // 검색 시 무조건 1페이지로 이동
    });
</script>
<%@ include file="../includes/end.jsp" %>