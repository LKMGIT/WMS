<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<style>
    /* ===== Calm Theme (차분 팔레트) ===== */
    :root{
        --ink:#1f2937;     /* 본문 */
        --muted:#64748b;   /* 보조 텍스트 */
        --card:#ffffff;    /* 카드 배경 */
        --bg:#f7f9fc;      /* 페이지 배경 */

        /* 포인트 컬러(차분한 블루/그린 라인) */
        --c1:#3b82f6;  /* 블루 */
        --c2:#10b981;  /* 에메랄드 */
        --c3:#f87171;  /* 소프트 레드 */
        --c4:#06b6d4;  /* 시안 */
        --c5:#f59e0b;  /* 앰버 */

        --grid:#e9eef6; /* 차트 그리드 */
    }
    body{ background:var(--bg); color:var(--ink); }

    .card{ border:0; border-radius:14px; box-shadow:0 10px 24px rgba(0,0,0,.06); }
    .card-header{ background:linear-gradient(180deg, rgba(0,0,0,.02), transparent); border-bottom:1px solid #eef2f5; }
    .text-muted.small{ color:var(--muted)!important; font-weight:600; letter-spacing:.2px; }

    /* KPI 카드 상단 포인트 바 */
    .kpi-card{ position:relative; overflow:hidden; }
    .kpi-card::before{
        content:""; position:absolute; inset:0 0 auto 0; height:6px; display:block; background:var(--c1);
    }
    .kpi-card:nth-child(1)::before{ background:var(--c1); }
    .kpi-card:nth-child(2)::before{ background:var(--c2); }
    .kpi-card:nth-child(3)::before{ background:var(--c5); }
    .kpi-card:nth-child(4)::before{ background:var(--c4); }
    .kpi-card:nth-child(5)::before{ background:var(--c2); }
    .kpi-card:nth-child(6)::before{ background:var(--c3); }
</style>

<div class="row g-3">
    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">총 회원 수</div>
        <div id="kpi-usersTotal" class="h4 mb-0">-</div>
    </div></div></div>

    <!-- '어제 가입' → '저번달 가입' -->
    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">저번달 가입</div>
        <div id="kpi-usersPrevMonth" class="h4 mb-0">-</div>
    </div></div></div>

    <!-- '오늘 가입' → '이번달 가입' -->
    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">이번달 가입</div>
        <div id="kpi-usersThisMonth" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">증가량</div>
        <div id="kpi-usersDelta" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">오늘 입고</div>
        <div id="kpi-inboundToday" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">오늘 출고</div>
        <div id="kpi-outboundToday" class="h4 mb-0">-</div>
    </div></div></div>
</div>

<div class="row mt-4">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 30일 회원 수 추이</div>
            <div class="card-body">
                <canvas id="chartUsers" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 30일 입고/출고</div>
            <div class="card-body">
                <canvas id="chartIO" height="140"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    (function(){
        /* ===== 1) JSP 모델(sum) → JS 주입 ===== */
        const labels = [
            <c:forEach var="d" items="${sum.labels}" varStatus="s">
            ${s.first ? '' : ','}'${d}'
            </c:forEach>
        ];
        const usersDaily = [
            <c:forEach var="v" items="${sum.usersDaily}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];
        const inboundDaily = [
            <c:forEach var="v" items="${sum.inboundDaily}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];
        const outboundDaily = [
            <c:forEach var="v" items="${sum.outboundDaily}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];

        // KPI: 저번달/이번달
        const KPI = {
            usersTotal:     ${empty sum.usersTotal     ? 0 : sum.usersTotal},
            usersPrevMonth: ${empty sum.usersPrevMonth ? 0 : sum.usersPrevMonth},
            usersThisMonth: ${empty sum.usersThisMonth ? 0 : sum.usersThisMonth},
            inboundToday:   ${empty sum.inboundToday   ? 0 : sum.inboundToday},
            outboundToday:  ${empty sum.outboundToday  ? 0 : sum.outboundToday}
        };

        /* ===== 2) Helpers ===== */
        const $  = id => document.getElementById(id);
        const nz = v  => (typeof v === 'number' && !isNaN(v)) ? v : 0;
        const toNums = arr => (arr || []).map(v => Number.isFinite(+v) ? +v : 0);

        function setText(id, val){ const el = $(id); if (el) el.textContent = val; }

        /* ===== 3) KPI 렌더 ===== */
        function renderKPIs(){
            setText('kpi-usersTotal',     nz(KPI.usersTotal));
            setText('kpi-usersPrevMonth', nz(KPI.usersPrevMonth));
            setText('kpi-usersThisMonth', nz(KPI.usersThisMonth));

            // 증감: 이번달 - 저번달
            const delta = nz(KPI.usersThisMonth) - nz(KPI.usersPrevMonth);
            setText('kpi-usersDelta', (delta >= 0 ? '+' : '') + delta);

            setText('kpi-inboundToday',   nz(KPI.inboundToday));
            setText('kpi-outboundToday',  nz(KPI.outboundToday));
        }

        /* ===== 4) 차트 렌더 (선 그래프) ===== */
        function renderCharts(){
            if (typeof Chart === 'undefined') return;

            const C_USERS='rgba(59,130,246,0.95)'; // 파랑
            const C_IN   ='rgba(16,185,129,0.95)'; // 초록
            const C_OUT  ='rgba(248,113,113,0.95)';// 레드

            const u = toNums(usersDaily);
            const i = toNums(inboundDaily);
            const o = toNums(outboundDaily);

            const roundUp = (v, step=10)=>Math.max(step, Math.ceil((v||0)/step)*step);
            const maxOf   = a => Math.max(0, ...(Array.isArray(a)?a:[0]));

            // 회원 수 (line)
            const yMaxUsers = roundUp(maxOf(u), 10);
            new Chart(document.getElementById('chartUsers').getContext('2d'), {
                type:'line',
                data:{
                    labels,
                    datasets:[{
                        label:'일일 가입 수',
                        data:u,
                        borderColor:C_USERS,
                        backgroundColor:C_USERS,
                        fill:false,
                        tension:0.3,
                        pointRadius:3,
                        pointHoverRadius:5,
                        pointHitRadius:8,
                        borderWidth:2
                    }]
                },
                options:{
                    responsive:true,
                    animation:false,
                    plugins:{ legend:{ labels:{ color:'#334155' } } },
                    scales:{
                        y:{
                            beginAtZero:true, min:0, max:Math.max(10, yMaxUsers),
                            ticks:{ stepSize:10, precision:0, color:'#475569' },
                            grid:{ color:'var(--grid)' }
                        },
                        x:{ ticks:{ color:'#475569' }, grid:{ display:false } }
                    }
                }
            });

            // 입/출고 (line 2)
            const yMaxIO = roundUp(Math.max(maxOf(i), maxOf(o)), 10);
            new Chart(document.getElementById('chartIO').getContext('2d'), {
                type:'line',
                data:{
                    labels,
                    datasets:[
                        {
                            label:'입고',
                            data:i,
                            borderColor:C_IN,
                            backgroundColor:C_IN,
                            fill:false,
                            tension:0.3,
                            pointRadius:3,
                            pointHoverRadius:5,
                            pointHitRadius:8,
                            borderWidth:2
                        },
                        {
                            label:'출고',
                            data:o,
                            borderColor:C_OUT,
                            backgroundColor:C_OUT,
                            fill:false,
                            tension:0.3,
                            pointRadius:3,
                            pointHoverRadius:5,
                            pointHitRadius:8,
                            borderWidth:2
                        }
                    ]
                },
                options:{
                    responsive:true,
                    animation:false,
                    plugins:{ legend:{ labels:{ color:'#334155' } } },
                    scales:{
                        y:{
                            beginAtZero:true, min:0, max:Math.max(10, yMaxIO),
                            ticks:{ stepSize:10, precision:0, color:'#475569' },
                            grid:{ color:'var(--grid)' }
                        },
                        x:{ ticks:{ color:'#475569' }, grid:{ display:false } }
                    }
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function(){
            try{
                renderKPIs();
                renderCharts(); // 차트 실제 렌더
            }catch(e){
                console.error('[dashboard] 렌더 오류:', e);
            }
        });
    })();
</script>

<!-- Chart.js (한 번만 로드) -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
