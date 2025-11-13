<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>WMS Admin - Home</title>
    <!-- 아이콘 폰트(선택) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/css/all.min.css" rel="stylesheet">
    <style>
        /* ===== 공통 테마 (로그인 화면과 톤 맞춤) ===== */
        :root{
            --accent: #210a42;
            --accent-ink:#ffffff;
            --ink:#222;
            --muted:#6b7280;
            --card:#ffffff;
            --bg:#f3f5f9;
            --radius:18px;
            --shadow:0 30px 70px rgba(0,0,0,.15);
        }
        *{box-sizing:border-box}
        body{
            margin:0; font-family:ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", "Helvetica Neue", Arial, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
            color:var(--ink); background:var(--bg);
        }
        a{color:inherit; text-decoration:none}
        .container{max-width:1100px; margin:0 auto; padding:24px 16px}

        /* ===== 헤더 ===== */
        .site-header{
            position:sticky; top:0; z-index:10; background:rgba(255,255,255,.7);
            backdrop-filter: blur(10px);
            border-bottom:1px solid rgba(0,0,0,.05);
        }
        .nav{
            display:flex; align-items:center; justify-content:space-between; gap:16px;
            padding:12px 0;
        }
        .brand{
            display:flex; align-items:center; gap:10px; font-weight:800; color:var(--accent);
        }
        .brand-badge{
            width:34px; height:34px; border-radius:50%; display:grid; place-items:center;
            background:rgba(33,10,66,.1); border:1px solid rgba(33,10,66,.2);
        }
        .nav-actions{display:flex; align-items:center; gap:8px}
        .btn{
            appearance:none; cursor:pointer; border:0; padding:10px 14px; border-radius:10px; font-weight:700;
        }
        .btn-accent{background:var(--accent); color:#fff}
        .btn-ghost{background:transparent; color:var(--accent)}
        .btn-outline{background:#fff; border:1px solid #e5e7eb}

        /* ===== 히어로 ===== */
        .hero{
            display:flex;
            align-items:center;            /* 세로 가운데 */
            justify-content:center;        /* 가로 가운데 */
            min-height:calc(100vh - 120px);/* 헤더가 있으면 대략 높이만큼 빼 주세요 */
            padding:40px 20px;             /* 가장자리 여백 */
            background:linear-gradient(180deg,#f7f9fc,#eef3fb); /* 선택: 은은한 배경 */
        }

        /* 가운데 올 콘텐츠 래퍼 */
        .hero-left{
            width:100%;
            max-width: 820px;              /* 텍스트 폭 제한 */
            text-align:center;             /* 가운데 정렬 */
        }
        .hero-title{
            margin:0 0 16px;
            font-size: clamp(28px, 4.5vw, 44px);
            line-height:1.2;
            color:#111827;
            letter-spacing:-0.02em;
        }

        .hero-sub{
            margin:0 auto 28px;
            max-width: 720px;
            color:#64748b;                 /* muted */
            font-size: clamp(14px, 1.6vw, 18px);
            line-height:1.7;
        }

        .hero-cta{
            display:flex;
            flex-wrap:wrap;
            gap:12px;
            justify-content:center;
        }
        .hero-right{
            background:
                    radial-gradient(180px 80px at 70% 40%, rgba(36,8,83,.08), transparent 60%),
                    radial-gradient(160px 70px at 40% 70%, rgba(36,8,83,.10), transparent 60%),
                    linear-gradient(135deg, rgba(33,10,66,.06), rgba(33,10,66,.02));
            border-radius:14px; min-height:220px;
            position:relative;
        }
        .hero-stats{
            position:absolute; inset:auto 16px 16px 16px; display:grid; grid-template-columns: repeat(3,1fr); gap:10px;
        }
        .kpi{
            background:#fff; border:1px solid #eee; border-radius:12px; padding:12px;
        }
        .kpi .label{font-size:12px; color:var(--muted)}
        .kpi .value{font-size:20px; font-weight:800; margin-top:6px}

        /* ===== 기능 카드 ===== */
        .grid{
            display:grid; gap:16px; grid-template-columns: repeat(3, 1fr);
            margin-top:24px;
        }
        .card{
            background:var(--card); border-radius:16px; box-shadow:var(--shadow); overflow:hidden;
            display:flex; flex-direction:column; min-height:180px;
        }
        .card-head{
            padding:16px; border-bottom:1px solid #f0f2f5; display:flex; align-items:center; gap:10px;
        }
        .card-head .icon{
            width:36px; height:36px; border-radius:10px; display:grid; place-items:center;
            color:#fff; background:var(--accent);
        }
        .card-body{padding:16px; color:#444; flex:1}
        .card-foot{padding:12px 16px; border-top:1px solid #f0f2f5; background:#fafbff; display:flex; justify-content:flex-end}
        .link{color:var(--accent); font-weight:700}

        /* ===== 푸터 ===== */
        .site-footer{
            margin:28px 0 12px; color:var(--muted); font-size:12px; text-align:center;
        }

        @media (max-width:980px){
            .hero{grid-template-columns:1fr}
            .grid{grid-template-columns:1fr 1fr}
        }
        @media (max-width:620px){
            .grid{grid-template-columns:1fr}
            .hero-title{font-size:28px}
        }
    </style>
</head>
<body>
<!-- 헤더 -->
<header class="site-header">
    <div class="container">
        <nav class="nav">
            <div class="brand">
                <div class="brand-badge">🚛</div>
                <span>WMS Admin</span>
            </div>
            <div class="nav-actions">
                <a class="btn btn-accent" href="/login/loginForm">로그인</a>
                <a class="btn btn-ghost" href="/admin/register">회원가입</a>
            </div>
        </nav>
    </div>
</header>

<!-- 히어로 -->
<main class="container">
    <section class="hero">
        <div class="hero-left">
            <h1 class="hero-title">스마트하고 간단한<br/>창고 운영을 시작하세요</h1>
            <p class="hero-sub">
                사용자·입출고·차량·운송장까지 한 화면에서. WMS Admin은 뷰(/admin), API(/admin/api) 경로를 분리하고
                보안·확장성을 고려한 구조로 설계되었습니다.
            </p>
            <div class="hero-cta">
                <a class="btn btn-accent" href="/login/loginForm"><i class="fa fa-right-to-bracket"></i> 지금 로그인</a>
            </div>
        </div>
    </section>

    

    <footer class="site-footer">
        © 2025 WMS Admin · /admin (view) & /admin/api (API) · UTF-8 · CSRF ready
    </footer>
</main>
</body>
</html>
