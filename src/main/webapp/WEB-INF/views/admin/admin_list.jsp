<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="isMaster" value="${sessionScope.loginAdminRole == 'MASTER'}"/>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">관리자 목록</h4>

                <!-- 필터 폼 -->
                <form method="get" action="${pageContext.request.contextPath}/admin/admin_list" class="d-flex gap-2">
                    <!-- 상태 -->
                    <select class="form-select" name="status" style="width:160px">
                        <option value=""         ${empty param.status ? 'selected':''}>상태(전체)</option>
                        <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected':''}>승인</option>
                        <option value="PENDING"  ${param.status == 'PENDING'  ? 'selected':''}>대기</option>
                        <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected':''}>거절</option>
                    </select>

                    <!-- 역할 -->
                    <select class="form-select" name="role" style="width:160px">
                        <option value=""       ${empty param.role ? 'selected':''}>역할(전체)</option>
                        <option value="ADMIN"  ${param.role == 'ADMIN'  ? 'selected':''}>ADMIN</option>
                        <option value="MASTER" ${param.role == 'MASTER' ? 'selected':''}>MASTER</option>
                    </select>

                    <!-- 키워드 -->
                    <input type="text"
                           class="form-control"
                           name="keyword"
                           placeholder="이름/아이디/전화 검색"
                           value="${fn:escapeXml(param.keyword)}"
                           style="width:240px"/>

                    <!-- 검색 대상: T=이름, I=아이디, P=전화 (단일 선택) -->
                    <select class="form-select" name="type" style="width:160px">
                        <option value=""  ${empty param.type ? 'selected' : ''}>검색항목(전체)</option>
                        <option value="T" ${param.type == 'T' ? 'selected' : ''}>이름</option>
                        <option value="I" ${param.type == 'I' ? 'selected' : ''}>아이디</option>
                        <option value="P" ${param.type == 'P' ? 'selected' : ''}>전화</option>
                    </select>


                    <button type="submit" class="btn btn-primary">적용</button>

                    <!-- 빠른 초기화 -->
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/admin/admin_list">초기화</a>

                    <!-- 페이지 크기 유지 -->
                    <input type="hidden" name="amount" value="${cri.amount}"/>
                </form>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table id="basic-datatables" class="display table table-striped table-hover">
                        <thead>
                        <tr>
                            <th>관리자번호</th>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>전화번호</th>
                            <th>역할</th>
                            <th>가입일</th>
                            <th>수정일</th>
                            <th>상태</th>
                            <c:if test="${isMaster}">
                                <th style="width:130px;">수정</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="admin" items="${admins}">
                            <tr data-admin-id="${admin.adminId}">
                                <td><c:out value="${admin.adminIndex}"/></td>
                                <td><c:out value="${admin.adminName}"/></td>
                                <td><c:out value="${admin.adminId}"/></td>
                                <td><c:out value="${admin.adminPhone}"/></td>
                                <td><c:out value="${admin.adminRole}"/></td>
                                <td><c:out value="${admin.adminCreatedAt}"/></td>
                                <td><c:out value="${admin.adminUpdateAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${admin.adminStatus == 'APPROVED'}">승인</c:when>
                                        <c:when test="${admin.adminStatus == 'PENDING'}">대기</c:when>
                                        <c:when test="${admin.adminStatus == 'REJECTED'}">거절</c:when>
                                        <c:otherwise><c:out value="${admin.adminStatus}"/></c:otherwise>
                                    </c:choose>
                                </td>

                                <c:if test="${isMaster}">
                                    <td class="text-nowrap">
                                        <button type="button" class="btn btn-sm btn-outline-primary me-1 btn-edit">수정</button>
                                        <button type="button" class="btn btn-sm btn-outline-danger btn-delete">삭제</button>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>

                <!-- 수정 모달 -->
                <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form id="editForm" onsubmit="return false;">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editModalLabel">관리자 정보 수정</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                                </div>
                                <div class="modal-body">

                                    <input type="hidden" id="editAdminId"/>

                                    <div class="mb-3">
                                        <label class="form-label" for="editAdminName">이름</label>
                                        <input id="editAdminName" type="text" class="form-control" maxlength="50">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="editAdminPhone">전화번호</label>
                                        <input id="editAdminPhone" type="text" class="form-control" maxlength="20" placeholder="예) 010-1234-5678">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="editAdminRole">역할</label>
                                        <select id="editAdminRole" class="form-select">
                                            <option value="ADMIN">ADMIN</option>
                                            <option value="MASTER">MASTER</option>
                                        </select>
                                    </div>

                                    <div class="mb-0">
                                        <label class="form-label" for="editAdminStatus">상태</label>
                                        <select id="editAdminStatus" class="form-select">
                                            <option value="APPROVED">APPROVED</option>
                                            <option value="PENDING">PENDING</option>
                                            <option value="REJECTED">REJECTED</option>
                                        </select>
                                    </div>

                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                                    <button type="submit" id="btnSaveEdit" class="btn btn-primary">저장</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>


                <!-- 페이지네이션 -->
                <c:if test="${not empty pageMaker}">
                    <ul class="pagination justify-content-center mt-3">
                        <c:if test="${pageMaker.prev}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.startPage - 1}
         &amount=${cri.amount}
         &status=${selectedStatus}
         &role=${selectedRole}
         &keyword=${fn:escapeXml(param.keyword)}
         &type=${param.type}">
                                    Previous
                                </a>
                            </li>
                        </c:if>

                        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
                            <li class="page-item ${cri.pageNum == num ? 'active':''}">
                                <a class="page-link"
                                   href="?pageNum=${num}
          &amount=${cri.amount}
          &status=${selectedStatus}
          &role=${selectedRole}
          &keyword=${fn:escapeXml(param.keyword)}
          &type=${param.type}">
                                        ${num}
                                </a>
                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.endPage + 1}
         &amount=${cri.amount}
         &status=${selectedStatus}
         &role=${selectedRole}
         &keyword=${fn:escapeXml(param.keyword)}
         &type=${param.type}">
                                    Next
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    (function(){
        const ctx = '${pageContext.request.contextPath}';

        function getCsrf(){
            const h = document.querySelector('meta[name="_csrf_header"]')?.content;
            const t = document.querySelector('meta[name="_csrf"]')?.content;
            return {h,t};
        }

        // 행에서 텍스트 추출 유틸
        function cellText(tr, nth){ return tr.children[nth].textContent.trim(); }

        // 수정 버튼 클릭 → 모달 오픈 & 값 바인딩
        document.addEventListener('click', function(e){
            if(!e.target.classList.contains('btn-edit')) return;

            const tr = e.target.closest('tr');
            const adminId = tr.dataset.adminId;

            document.getElementById('editAdminId').value = adminId;
            document.getElementById('editAdminName').value  = cellText(tr, 1); // 이름
            document.getElementById('editAdminPhone').value = cellText(tr, 3); // 전화

            // 역할/상태
            document.getElementById('editAdminRole').value = cellText(tr, 4); // 역할
            const statusText = cellText(tr, 7);
            var statusCode = 'PENDING';
            if(statusText === '승인') statusCode = 'APPROVED';
            else if(statusText === '거절') statusCode = 'REJECTED';
            document.getElementById('editAdminStatus').value = statusCode;

            // 부트스트랩 모달
            if (window.bootstrap && bootstrap.Modal) {
                const modal = new bootstrap.Modal(document.getElementById('editModal'));
                modal.show();
            } else {
                // (혹시 bootstrap JS 미포함 시 graceful fallback)
                document.getElementById('editModal').style.display = 'block';
            }
        });

        // 수정 저장 → PATCH
        document.getElementById('btnSaveEdit').addEventListener('click', async function(){
            const adminId = document.getElementById('editAdminId').value;
            const body = {
                adminName  : document.getElementById('editAdminName').value.trim(),
                adminPhone : document.getElementById('editAdminPhone').value.trim(),
                adminRole  : document.getElementById('editAdminRole').value,
                adminStatus: document.getElementById('editAdminStatus').value
            };
            if(!body.adminName){ alert('이름을 입력하세요.'); return; }

            const {h,t} = getCsrf();
            const btn = this; btn.disabled = true; btn.textContent = '저장 중...';

            try{
                const url = ctx + '/admin/api/admins/' + encodeURIComponent(adminId);
                const res = await fetch(url, {
                    method: 'PATCH',
                    headers: Object.assign({'Content-Type':'application/json'}, (h&&t)?{[h]:t}:{}) ,
                    body: JSON.stringify(body),
                    credentials: 'same-origin'
                });
                if(!res.ok) throw new Error('수정 실패 ('+res.status+')');
                location.reload();
            }catch(err){
                alert(err.message || '요청 오류');
            }finally{
                btn.disabled = false; btn.textContent = '저장';
            }
        });

        // 삭제 버튼 클릭 → 확인 → DELETE
        document.addEventListener('click', async function(e){
            if(!e.target.classList.contains('btn-delete')) return;

            const tr = e.target.closest('tr');
            const adminId = tr.dataset.adminId;
            const name = cellText(tr, 1);

            if(!confirm('관리자 ['+ name +']을(를) 삭제하시겠습니까?')) return;

            const {h,t} = getCsrf();
            e.target.disabled = true;

            try{
                const url = ctx + '/admin/api/admins/' + encodeURIComponent(adminId);
                const res = await fetch(url, {
                    method: 'DELETE',
                    headers: (h&&t)?{[h]:t}:{},
                    credentials: 'same-origin'
                });
                if(!res.ok) throw new Error('삭제 실패 ('+res.status+')');
                tr.remove();
            }catch(err){
                alert(err.message || '요청 오류');
            }finally{
                e.target.disabled = false;
            }
        });

    })();
</script>



<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>



