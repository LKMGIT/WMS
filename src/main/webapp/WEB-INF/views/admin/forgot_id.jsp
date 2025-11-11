<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>

<c:if test="${not empty _csrf}">
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf"        content="${_csrf.token}"/>
</c:if>

<div class="container" style="max-width:520px">
    <div class="card mt-4">
        <div class="card-header d-flex align-items-center justify-content-between">
            <h4 class="mb-0">관리자 아이디 찾기</h4>
        </div>

        <div class="card-body">
            <div class="mb-3">
                <label class="form-label">이름</label>
                <input id="adminName" class="form-control" maxlength="50" placeholder="예) 홍길동"/>
            </div>

            <div class="mb-3">
                <label class="form-label">전화번호</label>
                <input id="adminPhone" class="form-control" maxlength="20" placeholder="예) 010-1234-5678"/>
                <div class="form-text">가입 시 등록한 전화번호를 입력하세요.</div>
            </div>

            <button id="btnFind" type="button" class="btn btn-primary w-100">
                <span id="btnText">아이디 찾기</span>
                <span id="btnSpin" class="spinner-border spinner-border-sm ms-2 d-none" role="status" aria-hidden="true"></span>
            </button>

            <div id="result" class="mt-3"></div>
        </div>

        <div class="card-footer d-flex justify-content-between">
            <a class="auth-link" href="${pageContext.request.contextPath}/admin/forgot_password">비밀번호를 잊으셨나요?</a>
            <a class="auth-link" href="${pageContext.request.contextPath}/login/loginForm">로그인으로 돌아가기</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function(){
        const ctx = '${pageContext.request.contextPath}';
        const get = (sel) => document.querySelector(sel);

        function csrfHeaders(){
            const h = document.querySelector('meta[name="_csrf_header"]')?.content;
            const t = document.querySelector('meta[name="_csrf"]')?.content;
            return (h && t) ? { [h]: t } : {};
        }

        function showMsg(html, ok=true){
            const box = get('#result');
            if (!box) { alert('result 영역을 찾을 수 없습니다.'); return; }
            box.innerHTML = '<div class="alert ' + (ok?'alert-success':'alert-danger') + ' mb-0">' + html + '</div>';
        }

        async function findId(){
            const name  = get('#adminName')?.value?.trim();
            const phone = get('#adminPhone')?.value?.trim();

            if(!name){ showMsg('이름을 입력하세요.', false); return; }
            if(!phone){ showMsg('전화번호를 입력하세요.', false); return; }

            const url = ctx + '/admin/api/forgot-id';
            const headers = Object.assign({'Content-Type':'application/json'}, csrfHeaders());
            const body = JSON.stringify({ adminName: name, adminPhone: phone });

            // 디버깅 로그
            console.log('[REQ]', url, headers, body);

            try {
                const res  = await fetch(url, { method:'POST', headers, body, credentials:'same-origin' });
                const text = await res.text();

                console.log('[RES]', res.status, res.statusText, text);

                // 응답을 바로 알림으로도 표시 (화면에 안 보일 경우 대비)
                alert('서버 응답: ' + text + ' (status ' + res.status + ')');

                if(!res.ok){
                    showMsg(text || '조회 중 오류가 발생했습니다.', false);
                    return;
                }

                if (text && text.trim().length > 0) {
                    showMsg('확인된 관리자 아이디: <strong>' + text.trim() + '</strong>', true);
                } else {
                    showMsg('입력하신 정보로 확인된 아이디가 없습니다.', false);
                }
            } catch (e) {
                console.error(e);
                showMsg(e.message || '네트워크 오류가 발생했습니다.', false);
            }
        }

        // 버튼 타입이 반드시 button 이어야 함 (submit 금지)
        const btn = document.getElementById('btnFind');
        if (btn) btn.setAttribute('type', 'button');
        btn?.addEventListener('click', findId);

        // 엔터키 처리
        ['#adminName', '#adminPhone'].forEach(sel=>{
            const el = get(sel);
            el && el.addEventListener('keydown', function(e){
                if (e.key === 'Enter') { e.preventDefault(); findId(); }
            });
        });
    });
</script>



<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
