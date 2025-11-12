<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">회원정보</h4>

                <form method="get" action="${pageContext.request.contextPath}/admin/user_list" class="d-flex gap-2">
                    <!-- 거래처코드 검색(부분일치) -->
                    <input type="text"
                           class="form-control"
                           name="company_code"
                           placeholder="거래처코드 검색"
                           value="${fn:escapeXml(param.company_code)}"
                           style="width:200px"/>

                    <!-- 상태 선택 -->
                    <select class="form-select" name="status" style="width:160px">
                        <option value=""         ${empty param.status ? 'selected':''}>전체</option>
                        <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected':''}>승인(APPROVED)</option>
                        <option value="PENDING"  ${param.status == 'PENDING'  ? 'selected':''}>대기(PENDING)</option>
                        <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected':''}>거절(REJECTED)</option>
                    </select>

                    <button type="submit" class="btn btn-primary">적용</button>

                    <!-- 옵션: 빠른 초기화 -->
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/admin/user_list">초기화</a>

                    <!-- 페이지 크기 유지 -->
                    <input type="hidden" name="amount" value="${cri.amount}"/>
                </form>
            </div>


            <div class="card-body">
                <div class="table-responsive">
                    <table id="basic-datatables" class="display table table-striped table-hover">
                        <thead>
                        <tr>
                            <th>회원번호</th>
                            <th>회원이름</th>
                            <th>회원아이디</th>
                            <th>회원이메일</th>
                            <th>회원전화번호</th>
                            <th>거래처이름</th>
                            <th>거래처코드</th>
                            <th>회원가입일</th>
                            <th>정보수정일</th>
                            <th>회원상태</th>
                            <th style="width:130px;">액션</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr data-user-id="${user.userId}">
                                <td><c:out value="${user.userIndex}"/></td>
                                <td><c:out value="${user.userName}"/></td>
                                <td><c:out value="${user.userId}"/></td>
                                <td><c:out value="${user.userEmail}"/></td>
                                <td><c:out value="${user.userPhone}"/></td>
                                <td><c:out value="${user.companyName}"/></td>
                                <td><c:out value="${user.companyCode}"/></td>
                                <td><c:out value="${user.userCreatedAt}"/></td>
                                <td><c:out value="${user.userUpdateAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.userStatus == 'APPROVED'}">승인</c:when>
                                        <c:when test="${user.userStatus == 'PENDING'}">대기</c:when>
                                        <c:when test="${user.userStatus == 'REJECTED'}">거절</c:when>
                                        <c:otherwise><c:out value="${user.userStatus}"/></c:otherwise>
                                    </c:choose>
                                </td>
                                <!-- ★ 액션 -->
                                <td class="text-nowrap">
                                    <button type="button" class="btn btn-sm btn-outline-primary me-1 btn-edit">수정
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger btn-delete">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 수정 모달 -->
                <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form id="userEditForm" onsubmit="return false;">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editUserModalLabel">회원정보 수정</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="닫기"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" id="editUserId"/>

                                    <div class="mb-3">
                                        <label class="form-label" for="editUserName">이름</label>
                                        <input id="editUserName" type="text" class="form-control" maxlength="50">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="editUserEmail">이메일</label>
                                        <input id="editUserEmail" type="email" class="form-control" maxlength="100">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="editUserPhone">전화번호</label>
                                        <input id="editUserPhone" type="text" class="form-control" maxlength="20"
                                               placeholder="예) 010-1234-5678">
                                    </div>

                                    <div class="mb-0">
                                        <label class="form-label" for="editUserStatus">상태</label>
                                        <select id="editUserStatus" class="form-select">
                                            <option value="APPROVED">APPROVED</option>
                                            <option value="PENDING">PENDING</option>
                                            <option value="REJECTED">REJECTED</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기
                                    </button>
                                    <button type="submit" id="btnSaveUser" class="btn btn-primary">저장</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>


                <!-- 페이지네이션(필요 시 조건부로 노출) -->
                <c:if test="${not empty pageMaker}">
                    <ul class="pagination justify-content-center mt-3">
                        <c:if test="${pageMaker.prev}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.startPage - 1}&amount=${cri.amount}&status=${selectedStatus}">Previous</a>
                            </li>
                        </c:if>

                        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
                            <li class="page-item ${cri.pageNum == num ? 'active':''}">
                                <a class="page-link" href="?pageNum=${num}
  &amount=${cri.amount}
  &status=${selectedStatus}
  &company_code=${fn:escapeXml(param.company_code)}">${num}</a>

                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="?pageNum=${pageMaker.endPage + 1}&amount=${cri.amount}&status=${selectedStatus}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>

            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';

        function getCsrf() {
            var h = document.querySelector('meta[name="_csrf_header"]') && document.querySelector('meta[name="_csrf_header"]').content;
            var t = document.querySelector('meta[name="_csrf"]') && document.querySelector('meta[name="_csrf"]').content;
            return {h: h, t: t};
        }

        // n번째 셀 텍스트
        function cellText(tr, nth) {
            return (tr.children[nth].textContent || '').trim();
        }

        // 상태 한글→영문
        function statusToCode(txt) {
            if (txt === '승인') return 'APPROVED';
            if (txt === '거절') return 'REJECTED';
            return 'PENDING';
        }

        // 수정 버튼 → 모달 열고 값 주입
        document.addEventListener('click', function (e) {
            if (!e.target.classList.contains('btn-edit')) return;
            var tr = e.target.closest('tr');
            var userId = tr.getAttribute('data-user-id');

            document.getElementById('editUserId').value = userId;
            document.getElementById('editUserName').value = cellText(tr, 1); // 이름
            document.getElementById('editUserEmail').value = cellText(tr, 3); // 이메일
            document.getElementById('editUserPhone').value = cellText(tr, 4); // 전화
            document.getElementById('editUserStatus').value = statusToCode(cellText(tr, 9)); // 상태

            if (window.bootstrap && bootstrap.Modal) {
                new bootstrap.Modal(document.getElementById('editUserModal')).show();
            } else {
                document.getElementById('editUserModal').style.display = 'block';
            }
        });

        // 저장 → PATCH /admin/api/users/{userId}
        document.getElementById('btnSaveUser').addEventListener('click', async function () {
            var userId = document.getElementById('editUserId').value;
            var body = {
                userName: document.getElementById('editUserName').value.trim(),
                userEmail: document.getElementById('editUserEmail').value.trim(),
                userPhone: document.getElementById('editUserPhone').value.trim(),
                userStatus: document.getElementById('editUserStatus').value
            };
            if (!body.userName) {
                alert('이름을 입력하세요.');
                return;
            }

            var csrf = getCsrf();
            var btn = this;
            btn.disabled = true;
            btn.textContent = '저장 중...';
            try {
                var url = ctx + '/users/' + encodeURIComponent(userId);
                var res = await fetch(url, {
                    method: 'PATCH',
                    headers: Object.assign({'Content-Type': 'application/json'}, (csrf.h && csrf.t) ? {[csrf.h]: csrf.t} : {}),
                    body: JSON.stringify(body),
                    credentials: 'same-origin'
                });
                if (!res.ok) throw new Error('수정 실패 (' + res.status + ')');
                location.reload();
            } catch (err) {
                alert(err.message || '요청 오류');
            } finally {
                btn.disabled = false;
                btn.textContent = '저장';
            }
        });

        // 삭제 → DELETE /admin/api/users/{userId}
        document.addEventListener('click', async function (e) {
            if (!e.target.classList.contains('btn-delete')) return;
            var tr = e.target.closest('tr');
            var userId = tr.getAttribute('data-user-id');
            var name = cellText(tr, 1);

            if (!confirm('회원 [' + name + ']을(를) 삭제하시겠습니까?')) return;

            var csrf = getCsrf();
            e.target.disabled = true;
            try {
                var url = ctx + '/users/' + encodeURIComponent(userId);
                var res = await fetch(url, {
                    method: 'DELETE',
                    headers: (csrf.h && csrf.t) ? {[csrf.h]: csrf.t} : {},
                    credentials: 'same-origin'
                });
                if (!res.ok) throw new Error('삭제 실패 (' + res.status + ')');
                tr.remove();
            } catch (err) {
                alert(err.message || '요청 오류');
            } finally {
                e.target.disabled = false;
            }
        });

    })();
</script>


<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
