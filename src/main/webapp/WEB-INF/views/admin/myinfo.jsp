<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<!-- CSRF (Spring Security 사용 시) -->
<c:if test="${not empty _csrf}">
  <meta name="_csrf_header" content="${_csrf.headerName}"/>
  <meta name="_csrf"        content="${_csrf.token}"/>
</c:if>

<div class="row">
  <div class="col-md-10 mx-auto">
    <div class="card">
      <div class="card-header d-flex align-items-center justify-content-between">
        <h4 class="card-title mb-0">내 정보</h4>

        <div class="d-flex gap-2">
          <!-- 뒤로가기: 단순 네비게이션은 a 허용 -->
          <a class="btn btn-outline-secondary"
             href="${pageContext.request.contextPath}/admin/admin_list">뒤로가기</a>

          <!-- 수정 모달 열기 -->
          <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editModal">
            수정
          </button>
        </div>
      </div>

      <div class="card-body">
        <c:if test="${empty admin}">
          <div class="alert alert-warning mb-0">표시할 관리자 정보가 없습니다.</div>
        </c:if>

        <c:if test="${not empty admin}">
          <div class="table-responsive">
            <table class="table table-bordered mb-0">
              <tbody>
              <tr>
                <th style="width:180px">관리자 번호</th>
                <td><c:out value="${admin.adminIndex}"/></td>
              </tr>
              <tr>
                <th>아이디</th>
                <td><c:out value="${admin.adminId}"/></td>
              </tr>
              <tr>
                <th>이름</th>
                <td><c:out value="${admin.adminName}"/></td>
              </tr>
              <tr>
                <th>전화번호</th>
                <td><c:out value="${admin.adminPhone}"/></td>
              </tr>
              <tr>
                <th>역할</th>
                <td><c:out value="${admin.adminRole}"/></td>
              </tr>
              <tr>
                <th>상태</th>
                <td>
                  <c:choose>
                    <c:when test="${admin.adminStatus == 'APPROVED'}">승인</c:when>
                    <c:when test="${admin.adminStatus == 'PENDING'}">대기</c:when>
                    <c:when test="${admin.adminStatus == 'REJECTED'}">거절</c:when>
                    <c:otherwise><c:out value="${admin.adminStatus}"/></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr>
                <th>가입일</th>
                <td><c:out value="${admin.adminCreatedAt}"/></td>
              </tr>
              <tr>
                <th>수정일</th>
                <td><c:out value="${admin.adminUpdateAt}"/></td>
              </tr>
              </tbody>
            </table>
          </div>
        </c:if>

        <!-- 결과 메시지 -->
        <div id="msgBox" class="mt-3" style="display:none;"></div>
      </div>
    </div>
  </div>
</div>

<!-- 수정 모달 -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="editForm" onsubmit="return false;">
        <div class="modal-header">
          <h5 class="modal-title" id="editModalLabel">내 정보 수정</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>

        <div class="modal-body">
          <input type="hidden" id="adminIdHidden" value="<c:out value='${admin.adminId}'/>"/>

          <div class="mb-3">
            <label for="adminName" class="form-label">이름</label>
            <input type="text" class="form-control" id="adminName" maxlength="50"
                   value="<c:out value='${admin.adminName}'/>">
          </div>

          <div class="mb-3">
            <label for="adminPhone" class="form-label">전화번호</label>
            <input type="text" class="form-control" id="adminPhone" maxlength="20"
                   value="<c:out value='${admin.adminPhone}'/>"
                   placeholder="예) 010-1234-5678">
          </div>

          <div class="mb-3">
            <label for="adminRole" class="form-label">역할</label>
            <select id="adminRole" class="form-select">
              <option value="ADMIN"  ${admin.adminRole == 'ADMIN'  ? 'selected' : ''}>ADMIN</option>
              <option value="MASTER" ${admin.adminRole == 'MASTER' ? 'selected' : ''}>MASTER</option>
            </select>
          </div>

          <div class="mb-0">
            <label for="adminStatus" class="form-label">상태</label>
            <select id="adminStatus" class="form-select">
              <option value="APPROVED" ${admin.adminStatus == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
              <option value="PENDING"  ${admin.adminStatus == 'PENDING'  ? 'selected' : ''}>PENDING</option>
              <option value="REJECTED" ${admin.adminStatus == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
            </select>
          </div>

          <!-- 비밀번호 변경은 별도 API (POST /admin/api/admins/{id}/password)라 분리 권장 -->
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
          <button type="submit" id="btnSave" class="btn btn-primary">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  (function(){
    const ctx = '${pageContext.request.contextPath}';
    const msgBox = document.getElementById('msgBox');

    function showMsg(type, text){
      msgBox.className = 'alert alert-' + (type || 'info');
      msgBox.textContent = text;
      msgBox.style.display = 'block';
    }

    function getCsrf(){
      const header = document.querySelector('meta[name="_csrf_header"]')?.content;
      const token  = document.querySelector('meta[name="_csrf"]')?.content;
      return { header, token };
    }

    // 저장
    document.getElementById('btnSave').addEventListener('click', async function(){
      const adminId = document.getElementById('adminIdHidden').value;
      const body = {
        adminName  : document.getElementById('adminName').value.trim(),
        adminPhone : document.getElementById('adminPhone').value.trim(),
        adminRole  : document.getElementById('adminRole').value,
        adminStatus: document.getElementById('adminStatus').value
      };

      if(!body.adminName){ showMsg('warning','이름을 입력해주세요.'); return; }

      const url = ctx + '/admin/api/admins/' + encodeURIComponent(adminId);
      const {header, token} = getCsrf();

      const btn = this;
      btn.disabled = true; btn.textContent = '저장 중...';

      try{
        const res = await fetch(url, {
          method: 'PATCH',
          headers: Object.assign(
                  { 'Content-Type': 'application/json' },
                  header && token ? { [header]: token } : {}
          ),
          body: JSON.stringify(body),
          credentials: 'same-origin'
        });

        if(!res.ok){
          const t = await res.text();
          throw new Error('저장 실패 (' + res.status + '): ' + t);
        }

        // 성공 후 새로고침하여 최신 데이터 반영
        showMsg('success','저장되었습니다. 화면을 새로 고칩니다...');
        setTimeout(() => location.reload(), 600);

      }catch(err){
        console.error(err);
        showMsg('danger', err.message || '요청 처리 중 오류가 발생했습니다.');
      }finally{
        btn.disabled = false; btn.textContent = '저장';
      }
    });

  })();
</script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
