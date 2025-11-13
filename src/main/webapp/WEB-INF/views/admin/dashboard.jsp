<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<!-- 1) Chart.js를 먼저 로드 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    :root{
        --ink:#1f2937; --muted:#64748b; --card:#ffffff; --bg:#f7f9fc;
        --c1:#3b82f6; --c2:#10b981; --c3:#f87171; --c4:#06b6d4; --c5:#f59e0b;
        --grid:#e9eef6;
    }
    body{ background:var(--bg); color:var(--ink); }
    .card{ border:0; border-radius:14px; box-shadow:0 10px 24px rgba(0,0,0,.06); }
    .card-header{ background:linear-gradient(180deg, rgba(0,0,0,.02), transparent); border-bottom:1px solid #eef2f5; }
    .text-muted.small{ color:var(--muted)!important; font-weight:600; letter-spacing:.2px; }
    .kpi-card{ position:relative; overflow:hidden; }
    .kpi-card::before{ content:""; position:absolute; inset:0 0 auto 0; height:6px; background:var(--c1); }
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

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">저번달 가입</div>
        <div id="kpi-usersPrevMonth" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">이번달 가입</div>
        <div id="kpi-usersThisMonth" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">증가량</div>
        <div id="kpi-usersDelta" class="h4 mb-0">-</div>
    </div></div></div>

    <!-- ⬇️ “오늘 입고/출고” → “이번달 입고/출고”로 변경 -->
    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">이번달 입고</div>
        <div id="kpi-inboundThisMonth" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm kpi-card"><div class="card-body">
        <div class="text-muted small">이번달 출고</div>
        <div id="kpi-outboundThisMonth" class="h4 mb-0">-</div>
    </div></div></div>
</div>

<div class="row mt-4">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 ${range == '30d' ? '30일' : '7일'} 회원 수 추이</div>
            <div class="card-body">
                <canvas id="chartUsers" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 ${range == '30d' ? '30일' : '7일'} 입고/출고</div>
            <div class="card-body">
                <canvas id="chartIO" height="140"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- 월별 입/출고 (최근 12개월) -->
<div class="row mt-4">
    <div class="col-12">
        <div class="card shadow-sm">
            <div class="card-header">최근 12개월 입/출고 (월별)</div>
            <div class="card-body">
                <canvas id="chartIOMonthly" height="140"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    (function(){
        /* ===== JSP → JS 주입 ===== */
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

        const monthLabels = [
            <c:forEach var="m" items="${sum.monthLabels}" varStatus="s">
            ${s.first ? '' : ','}'${m}'
            </c:forEach>
        ];
        const inboundMonthly = [
            <c:forEach var="v" items="${sum.inboundMonthly}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];
        const outboundMonthly = [
            <c:forEach var="v" items="${sum.outboundMonthly}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];

        const KPI = {
            usersTotal:        ${empty sum.usersTotal        ? 0 : sum.usersTotal},
            usersPrevMonth:    ${empty sum.usersPrevMonth    ? 0 : sum.usersPrevMonth},
            usersThisMonth:    ${empty sum.usersThisMonth    ? 0 : sum.usersThisMonth},
            inboundThisMonth:  ${empty sum.inboundThisMonth  ? 0 : sum.inboundThisMonth},
            outboundThisMonth: ${empty sum.outboundThisMonth ? 0 : sum.outboundThisMonth}
        };

        const $ = id => document.getElementById(id);
        const nz = v => (typeof v === 'number' && !isNaN(v)) ? v : 0;
        const toNums = arr => (arr || []).map(v => Number.isFinite(+v) ? +v : 0);

        function setText(id, val){ const el = $(id); if (el) el.textContent = val; }

        function renderKPIs(){
            setText('kpi-usersTotal',     nz(KPI.usersTotal));
            setText('kpi-usersPrevMonth', nz(KPI.usersPrevMonth));
            setText('kpi-usersThisMonth', nz(KPI.usersThisMonth));
            const delta = nz(KPI.usersThisMonth) - nz(KPI.usersPrevMonth);
            setText('kpi-usersDelta', (delta >= 0 ? '+' : '') + delta);

            // ⬇️ 월별 입출고로 교체
            setText('kpi-inboundThisMonth',   nz(KPI.inboundThisMonth));
            setText('kpi-outboundThisMonth',  nz(KPI.outboundThisMonth));
        }

        function renderCharts(){
            const C_USERS='rgba(59,130,246,0.95)', C_IN='rgba(16,185,129,0.95)', C_OUT='rgba(248,113,113,0.95)';
            const u=toNums(usersDaily), i=toNums(inboundDaily), o=toNums(outboundDaily);
            const im=toNums(inboundMonthly), om=toNums(outboundMonthly);

            const roundUp = (v, step=10)=>Math.max(step, Math.ceil((v||0)/step)*step);
            const maxOf = a => Math.max(0, ...(Array.isArray(a)?a:[0]));

            // 일별 - 회원
            const yMaxUsers = roundUp(maxOf(u), 10);
            new Chart($('chartUsers').getContext('2d'), {
                type:'line',
                data:{ labels, datasets:[{ label:'일일 가입 수', data:u, borderColor:C_USERS, backgroundColor:C_USERS, fill:false, tension:0.3, pointRadius:3, borderWidth:2 }]},
                options:{ responsive:true, animation:false,
                    scales:{ y:{ beginAtZero:true, min:0, max:Math.max(10,yMaxUsers), ticks:{ stepSize:10, precision:0 }}, x:{ grid:{ display:false }}}}
            });

            // 일별 - 입/출고
            const yMaxIO = roundUp(Math.max(maxOf(i), maxOf(o)), 10);
            new Chart($('chartIO').getContext('2d'), {
                type:'line',
                data:{ labels, datasets:[
                        { label:'입고', data:i, borderColor:C_IN,  backgroundColor:C_IN,  fill:false, tension:0.3, pointRadius:3, borderWidth:2 },
                        { label:'출고', data:o, borderColor:C_OUT, backgroundColor:C_OUT, fill:false, tension:0.3, pointRadius:3, borderWidth:2 }
                    ]},
                options:{ responsive:true, animation:false,
                    scales:{ y:{ beginAtZero:true, min:0, max:Math.max(10,yMaxIO), ticks:{ stepSize:10, precision:0 }}, x:{ grid:{ display:false }}}}
            });

            // 월별 - 입/출고
            const yMaxIOM = roundUp(Math.max(maxOf(im), maxOf(om)), 10);
            new Chart($('chartIOMonthly').getContext('2d'), {
                type:'line',
                data:{ labels: monthLabels, datasets:[
                        { label:'입고(월)', data:im, borderColor:C_IN,  backgroundColor:C_IN,  fill:false, tension:0.3, pointRadius:3, borderWidth:2 },
                        { label:'출고(월)', data:om, borderColor:C_OUT, backgroundColor:C_OUT, fill:false, tension:0.3, pointRadius:3, borderWidth:2 }
                    ]},
                options:{ responsive:true, animation:false,
                    scales:{ y:{ beginAtZero:true, min:0, max:Math.max(10,yMaxIOM), ticks:{ stepSize:10, precision:0 }}, x:{ grid:{ display:false }}}}
            });
        }

        // Chart 준비 대기(재시도)
        function waitAndRender(retry=0){
            if (typeof Chart === 'undefined'){
                if (retry < 10) return setTimeout(() => waitAndRender(retry+1), 100);
                console.warn('[dashboard] Chart.js가 로드되지 않았습니다.');
                return;
            }
            try { renderCharts(); } catch(e){ console.error(e); }
        }

        document.addEventListener('DOMContentLoaded', function(){
            try { renderKPIs(); waitAndRender(); } catch(e){ console.error(e); }
        });
    })();
</script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
