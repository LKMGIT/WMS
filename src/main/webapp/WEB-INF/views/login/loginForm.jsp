<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../includes/header.jsp" %>

<c:url var="loginAction" value="/login/loginForm"/>

<!-- ===== Login Card (scoped) ===== -->
<div class="auth-wrap"><!-- 변수/스타일 스코프 컨테이너 -->
    <div class="auth-card">
        <!-- Left -->
        <section class="auth-left">
            <div>
                <div class="auth-brand">
                    <div class="auth-brand-badge">🚛</div>
                    <span>WMS Admin</span>
                </div>
                <div class="auth-slogan">Smart & Simple Warehouse for Beauty/Health</div>
            </div>
        </section>

        <!-- Right -->
        <section class="auth-right">
            <div class="auth-illus"></div>
            <h1 class="auth-title">Sign in</h1>

            <c:if test="${not empty loginError}">
                <div class="auth-alert">${loginError}</div>
            </c:if>

            <form method="post" action="${loginAction}">
                <div class="auth-form-group">
                    <label class="auth-label">ID</label>
                    <input class="auth-input" type="text" name="adminId" placeholder="아이디" required autofocus/>
                </div>

                <div class="auth-form-group">
                    <label class="auth-label">Password</label>
                    <input class="auth-input" type="password" name="adminPw" placeholder="비밀번호" required/>
                </div>

                <div class="auth-actions">
                    <div class="auth-links">
                        <a class="auth-link" href="<c:url value='/admin/forgot_id'/>">아이디를 잊어버렸나요?</a>
                        <a class="auth-link" href="<c:url value='/admin/forgot_password'/>">비밀번호를 잊어버렸나요?</a>
                    </div>
                    <button type="submit" class="auth-btn">Sign in</button>
                </div>

                <!-- (선택) CSRF 사용 시 -->
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </c:if>
            </form>

            <div class="auth-footer">
                <a class="auth-link" href="<c:url value='/admin/register'/>">Create account</a>
            </div>
        </section>
    </div>
</div>

<!-- ===== Scoped Styles (충돌 방지: .auth-wrap 하위에만 적용) ===== -->
<style>
    .auth-wrap{
        /* 테마 색상(여기만 바꾸면 됨) */
        --accent: #210a42;         /* 메인 색 */
        --accent-ink:#ffffff;     /* 좌패널 글자색 */
        --ink:#222;
        --muted:#6b7280;
        --card:#ffffff;
        --bg:#f3f5f9;
        --radius:18px;
        --shadow:0 30px 70px rgba(0,0,0,.15);

        padding: 24px 16px;
        background: var(--bg);
    }
    .auth-card{
        max-width:980px; margin:40px auto;
        display:grid; grid-template-columns: 1.1fr 1fr;
        background:var(--card); border-radius:var(--radius);
        box-shadow:var(--shadow); overflow:hidden;
    }
    .auth-left{
        position:relative; background:var(--accent); color:var(--accent-ink);
        padding:56px 48px; display:flex; align-items:center; justify-content:center;
    }
    .auth-brand{display:flex; align-items:center; gap:12px; font-weight:700; font-size:22px;}
    .auth-brand-badge{
        width:36px; height:36px; border-radius:50%; background:rgba(255,255,255,.18);
        display:grid; place-items:center; backdrop-filter: blur(4px);
        border:1px solid rgba(255,255,255,.35);
    }
    .auth-slogan{position:absolute; left:48px; bottom:42px; opacity:.85; font-size:14px;}

    .auth-right{ padding:56px 56px; background:#fff }
    .auth-illus{
        width:170px; height:110px; margin:0 auto 18px; opacity:.9;
        background:
                radial-gradient(120px 60px at 60% 40%, rgba(36,8,83,.12), transparent 60%),
                radial-gradient(120px 60px at 40% 60%, rgba(36,8,83,.12), transparent 60%);
        border-radius:16px;
    }
    .auth-title{font-size:22px; margin:6px 0 18px}
    .auth-form-group{margin-bottom:14px}
    .auth-label{display:block; margin:0 0 6px; font-size:13px; color:var(--muted)}
    .auth-input{
        width:100%; padding:12px 14px; border-radius:10px; border:1px solid #e5e7eb;
        outline:none; transition:.15s; background:#fff;
    }
    .auth-input:focus{border-color:var(--accent); box-shadow:0 0 0 4px rgba(36,8,83,.15)}
    .auth-actions{display:flex; align-items:center; justify-content:space-between; margin-top:6px}
    .auth-link{font-size:13px; color:var(--accent); text-decoration:none}
    .auth-btn{
        appearance:none; border:0; padding:11px 18px; border-radius:10px; cursor:pointer;
        background:var(--accent); color:#fff; font-weight:600; transition:.15s;
    }
    .auth-btn:hover{filter:brightness(.95)}
    .auth-footer{display:flex; gap:14px; justify-content:flex-end; margin-top:28px; color:var(--muted); font-size:12px;}

    .auth-alert{
        background:#ffe3e3; color:#b42318; border:1px solid #ffb4b4;
        padding:10px 12px; border-radius:10px; margin-bottom:12px; font-size:14px;
    }

    .auth-actions {
        display: flex;
        flex-direction: column;    /* 세로 배치 */
        gap: 12px;
        align-items: stretch;
    }

    .auth-links {
        display: flex;
        flex-direction: column;    /* 링크를 세로로 */
        gap: 4px;                  /* 링크 간 간격 */
    }

    .auth-link {
        display: inline-block;     /* 줄바꿈 유지 + 클릭영역 조금 더 넓게 */
        font-size: 0.9rem;
    }

    .auth-btn {
        width: 100%;
    }


    @media (max-width:880px){
        .auth-card{grid-template-columns:1fr}
        .auth-left{min-height:160px; padding:28px}
        .auth-slogan{position:static; margin-top:8px}
        .auth-right{padding:28px}
    }
</style>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
