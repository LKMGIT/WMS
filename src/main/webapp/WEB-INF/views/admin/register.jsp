<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>

<c:url var="registerAction" value="/admin/register"/>

<!-- ===== Register Card (scoped) ===== -->
<div class="auth-wrap"><!-- 변수/스타일 스코프 컨테이너 -->
    <div class="auth-card">
        <!-- Left -->
        <section class="auth-left">
            <div>
                <div class="auth-brand">
                    <div class="auth-brand-badge">🧴</div>
                    <span>WMS Admin</span>
                </div>
                <div class="auth-slogan">Create your admin account</div>
            </div>
        </section>

        <!-- Right -->
        <section class="auth-right">
            <div class="auth-illus"></div>
            <h1 class="auth-title">Register</h1>

            <!-- 플래시 메시지 영역 -->
            <c:if test="${not empty registerError}">
                <div class="auth-alert">${registerError}</div>
            </c:if>
            <c:if test="${not empty registerOk}">
                <div class="auth-alert" style="background:#e6f9ed; border-color:#b5ebc7; color:#137a3a;">
                        ${registerOk}
                </div>
            </c:if>

            <form method="post" action="${registerAction}" >
                <!-- 이름 -->
                <div class="auth-form-group">
                    <label class="auth-label">Name</label>
                    <input class="auth-input" type="text" name="adminName" placeholder="이름" required/>
                </div>

                <!-- 아이디 -->
                <div class="auth-form-group">
                    <label class="auth-label">ID</label>
                    <input class="auth-input" type="text" name="adminId" placeholder="아이디" required/>
                </div>

                <!-- 비밀번호 -->
                <div class="auth-form-group">
                    <label class="auth-label">Password</label>
                    <input class="auth-input" type="password" name="adminPw" placeholder="비밀번호" required/>
                </div>

                <!-- 역할 -->
                <div class="auth-form-group">
                    <label class="auth-label">Role</label>
                    <select class="auth-input" name="adminRole" required>
                        <option value="" disabled selected>Select role</option>
                        <option value="ADMIN">ADMIN</option>
                        <option value="MASTER">MASTER</option>
                    </select>
                </div>

                <!-- 전화번호 -->
                <div class="auth-form-group">
                    <label class="auth-label">Phone</label>
                    <input class="auth-input" type="tel" name="adminPhone" placeholder="010-1234-5678" />
                </div>

                <div class="auth-actions" style="margin-top:12px">
                    <a class="auth-link" href="<c:url value='/login/loginForm'/>">Back to Sign in</a>
                    <button type="submit" class="auth-btn">Create account</button>
                </div>

            </form>
        </section>
    </div>
</div>

<!-- ===== Scoped Styles (로그인과 동일 스코프/클래스명 재사용) ===== -->
<style>
    .auth-wrap{
        --accent: #0b6b65;         /* 메인 색 (회원가입은 톤만 다르게) */
        --accent-ink:#ffffff;
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
                radial-gradient(120px 60px at 60% 40%, rgba(11,107,101,.12), transparent 60%),
                radial-gradient(120px 60px at 40% 60%, rgba(11,107,101,.12), transparent 60%);
        border-radius:16px;
    }
    .auth-title{font-size:22px; margin:6px 0 18px}
    .auth-form-group{margin-bottom:14px}
    .auth-label{display:block; margin:0 0 6px; font-size:13px; color:var(--muted)}
    .auth-input{
        width:100%; padding:12px 14px; border-radius:10px; border:1px solid #e5e7eb;
        outline:none; transition:.15s; background:#fff;
    }
    .auth-input:focus{border-color:var(--accent); box-shadow:0 0 0 4px rgba(11,107,101,.15)}
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

    @media (max-width:880px){
        .auth-card{grid-template-columns:1fr}
        .auth-left{min-height:160px; padding:28px}
        .auth-slogan{position:static; margin-top:8px}
        .auth-right{padding:28px}
    }
</style>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
