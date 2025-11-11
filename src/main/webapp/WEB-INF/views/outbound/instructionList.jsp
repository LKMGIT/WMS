<%--
  Created by IntelliJ IDEA.
  User: JangwooJoo
  Date: 2025-11-10
  Time: 오후 8:18
  To change this template use File | Settings | File Templates.
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
            <li class="nav-item"><a href="${contextPath}/instructions">출고 지시서 목록</a></li>
        </ul>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="card-title">출고 지시서 목록</div>
                </div>
                <div class="card-body">
                    <div class="row g-3 justify-content-center mb-3">
                        <form id="searchForm" class="input-group">
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
                                <th>지시서 ID (si_index)</th>
                                <th>상품명 (item_name)</th>
                                <th>수량 (or_quantity)</th>
                                <th>창고 ID (warehouse_index)</th>
                                <th>승인일 (approved_at)</th>
                                <th>운송장 상태 (si_waybill_status)</th>
                            </tr>
                            </thead>
                            <tbody id="instructionTbody">
                            <tr><td colspan="6" class="text-center">데이터를 불러오는 중입니다...</td></tr>
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
    const API_BASE = `${contextPath}/api/admin/outbound`;

    /**
     * [신규] LocalDateTime 배열을 JavaScript Date 객체로 변환
     * @param {array} arr (예: [2025, 11, 11, 12, 58, 30])
     * @returns {Date}
     */
    function parseLocalDateTime(arr) {
        if (!arr || arr.length < 6) {
            // arr가 null이거나(예: approved_at이 null인 경우) 유효하지 않으면 빈 문자열 반환
            return null;
        }
        // new Date(year, monthIndex(0-11), day, hours, minutes, seconds)
        return new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]);
    }

    /**
     * 지시서 목록 로드 함수
     * @param {number} page - 요청할 페이지 번호
     * @param {string} type - 검색 타입
     * @param {string} keyword - 검색 키워드
     */
    async function loadInstructionList(page = 1, type = '', keyword = '') {
        const tbody = document.getElementById("instructionTbody");
        tbody.innerHTML = `<tr><td colspan="6" class="text-center">데이터를 불러오는 중입니다...</td></tr>`;

        try {
            // [API 경로 수정]: 컨트롤러 경로(/instruction) 반영
            const params = new URLSearchParams({ page, amount: 10, type, keyword });
            const response = await axios.get(`${API_BASE}/instruction`, { params });

            // API 응답: { list: [ShippingInstructionDetailDTO, ...], pageDTO: {...} }
            const { list, pageDTO } = response.data;

            tbody.innerHTML = ""; // tbody 초기화

            if (!list || list.length === 0) {
                tbody.innerHTML = `<tr><td colspan="6" class="text-center">출고 지시 내역이 없습니다.</td></tr>`;
                renderPagination(pageDTO, loadInstructionList);
                return;
            }

            // [JS 렌더링]: DTO 속성(si_index, item_name 등)에 맞춰 렌더링
            list.forEach(item => {
                const tr = document.createElement("tr");
                tr.style.cursor = "pointer";
                tr.onclick = () => {
                    // [경로 수정] OutboundViewController.java 매핑 경로
                    location.href = `${contextPath}/instruction/${item.si_index}`;
                };

                // [수정] parseLocalDateTime 함수를 사용하여 날짜 변환
                // DTO 속성: approved_at (LocalDateTime)
                const approvedDateObj = parseLocalDateTime(item.approved_at);
                const approvedDateStr = approvedDateObj
                    ? approvedDateObj.toLocaleString("ko-KR")
                    : "N/A"; // (승인일이 null일 경우 N/A 표시)

                // DTO 속성: si_index, item_name, or_quantity, warehouse_index, si_waybill_status
                tr.innerHTML = `
                    <td>${item.si_index}</td>
                    <td>${item.item_name}</td>
                    <td>${item.or_quantity}</td>
                    <td>${item.warehouse_index}</td>
                    <td>${approvedDateStr}</td>
                    <td>${item.si_waybill_status}</td>
                `;
                tbody.appendChild(tr);
            });

            // [JS 렌더링]: 페이지네이션 생성
            renderPagination(pageDTO, loadInstructionList);

        } catch (error) {
            console.error("Instruction List loading failed:", error);
            tbody.innerHTML = `<tr><td colspan="6" class="text-center text-danger">목록 로딩에 실패했습니다.</td></tr>`;
        }
    }

    /**
     * 페이지네이션 렌더링 함수 (list.jsp의 것과 동일)
     * @param {object} pageDTO
     * @param {function} loadFn
     */
    function renderPagination(pageDTO, loadFn) {
        const paginationUl = document.getElementById("instructionPagination");
        paginationUl.innerHTML = "";

        if (!pageDTO) return;

        let paginationHtml = '<ul class="pagination">';
        const { criteria, startPage, endPage, prev, next } = pageDTO;
        const { type, keyword } = criteria;

        if (prev) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${startPage - 1}">Previous</a></li>`;
        }
        for (let i = startPage; i <= endPage; i++) {
            paginationHtml += `
                <li class="page-item ${criteria.pageNum == i ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>
            `;
        }
        if (next) {
            paginationHtml += `<li class="page-item"><a class="page-link" href="#" data-page="${endPage + 1}">Next</a></li>`;
        }
        paginationHtml += '</ul>';
        paginationUl.innerHTML = paginationHtml;

        paginationUl.querySelectorAll("a.page-link").forEach(link => {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const pageNum = this.dataset.page;

                // 검색 조건 가져오기
                const form = document.getElementById("searchForm");
                const currentType = form.type.value;
                const currentKeyword = form.keyword.value;

                loadFn(pageNum, currentType, currentKeyword);
            });
        });
    }

    // 페이지 로드 시 1페이지 데이터 로드
    document.addEventListener("DOMContentLoaded", () => {
        loadInstructionList(1);
    });

    // 검색 버튼 이벤트
    document.getElementById("searchBtn").addEventListener("click", () => {
        const form = document.getElementById("searchForm");
        const type = form.type.value;
        const keyword = form.keyword.value;
        loadInstructionList(1, type, keyword);
    });
</script>
<%@ include file="../includes/end.jsp" %>
<%@ include file="../includes/end.jsp" %>