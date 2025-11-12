<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row g-3">
    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">총 회원 수</div>
        <div id="kpi-usersTotal" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">어제 가입</div>
        <div id="kpi-usersYesterday" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">오늘 가입</div>
        <div id="kpi-usersToday" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">증가량</div>
        <div id="kpi-usersDelta" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">오늘 입고</div>
        <div id="kpi-inboundToday" class="h4 mb-0">-</div>
    </div></div></div>

    <div class="col-md-2"><div class="card shadow-sm"><div class="card-body">
        <div class="text-muted small">오늘 출고</div>
        <div id="kpi-outboundToday" class="h4 mb-0">-</div>
    </div></div></div>
</div>

<div class="row mt-4">
    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 7일 회원 수 추이</div>
            <div class="card-body">
                <canvas id="chartUsers" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card shadow-sm">
            <div class="card-header">최근 7일 입고/출고</div>
            <div class="card-body">
                <canvas id="chartIO" height="140"></canvas>
            </div>
        </div>
    </div>
</div>


<script>
    (function(){
        // ===== 1) JSP 모델(sum)을 JS로 주입 =====
        // 날짜 라벨
        const labels = [
            <c:forEach var="d" items="${sum.labels}" varStatus="s">
            ${s.first ? '' : ','}'${d}'
            </c:forEach>
        ];

        // 일일 가입 수
        const usersDaily = [
            <c:forEach var="v" items="${sum.usersDaily}" varStatus="s">
            ${s.first ? '' : ','}${v}
            </c:forEach>
        ];

        // 일일 입고/출고 수
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

        // KPI 단일 값 (✨ null/빈값 안전 처리)
        const KPI = {
            usersTotal:     ${empty sum.usersTotal     ? 0 : sum.usersTotal},
            usersYesterday: ${empty sum.usersYesterday ? 0 : sum.usersYesterday},
            usersToday:     ${empty sum.usersToday     ? 0 : sum.usersToday},
            usersDelta:     ${empty sum.usersDelta     ? 0 : sum.usersDelta},
            inboundToday:   ${empty sum.inboundToday   ? 0 : sum.inboundToday},
            outboundToday:  ${empty sum.outboundToday  ? 0 : sum.outboundToday}
        };

        // ===== 2) 도우미 =====
        const $ = id => document.getElementById(id);
        const nz = v => (typeof v === 'number' && !isNaN(v)) ? v : 0;

        function setText(id, val){
            const el = $(id);
            if (el) el.textContent = val;
        }

        // ===== 3) KPI 바인딩 =====
        function renderKPIs(){
            setText('kpi-usersTotal',     nz(KPI.usersTotal));
            setText('kpi-usersYesterday', nz(KPI.usersYesterday));
            setText('kpi-usersToday',     nz(KPI.usersToday));

            const delta = nz(KPI.usersDelta);
            setText('kpi-usersDelta', (delta >= 0 ? '+' : '') + delta);

            setText('kpi-inboundToday',   nz(KPI.inboundToday));
            setText('kpi-outboundToday',  nz(KPI.outboundToday));
        }

        // ===== 4) 차트 (Chart.js가 있으면만) =====
        function renderCharts(){
            if (typeof Chart === 'undefined') return;

            const roundUp = (v, step=20) => Math.max(step, Math.ceil((v||0)/step)*step);
            const maxOf = a => Math.max(0, ...(Array.isArray(a)?a:[0]));

            // 1) 회원 수
            const yMaxUsers = roundUp(maxOf(usersDaily));
            new Chart(document.getElementById('chartUsers').getContext('2d'), {
                type: 'bar',
                data: { labels, datasets: [{ label:'일일 가입 수', data: usersDaily }] },
                options: {
                    responsive:true,
                    scales:{
                        y:{ beginAtZero:true, min:0, suggestedMax:yMaxUsers, ticks:{ stepSize:20, precision:0 } },
                        x:{ ticks:{ precision:0 } }
                    }
                }
            });

            // 2) 입/출고
            const yMaxIO = roundUp(Math.max(maxOf(inboundDaily), maxOf(outboundDaily)));
            new Chart(document.getElementById('chartIO').getContext('2d'), {
                type: 'bar',
                data: {
                    labels,
                    datasets: [
                        { label:'입고', data: inboundDaily },
                        { label:'출고', data: outboundDaily }
                    ]
                },
                options: {
                    responsive:true,
                    scales:{
                        y:{ beginAtZero:true, min:0, suggestedMax:yMaxIO, ticks:{ stepSize:20, precision:0 } },
                        x:{ ticks:{ precision:0 } }
                    }
                }
            });
        }

        // ===== 5) 실행 =====
        document.addEventListener('DOMContentLoaded', function(){
            try {
                renderKPIs();
                renderCharts();
                // 디버그 로그
                console.log('[dashboard] KPI:', KPI);
                console.log('[dashboard] labels:', labels);
                console.log('[dashboard] usersDaily:', usersDaily);
                console.log('[dashboard] inboundDaily:', inboundDaily);
                console.log('[dashboard] outboundDaily:', outboundDaily);
            } catch (e) {
                console.error('[dashboard] 렌더 오류:', e);
            }
        });
    })();
</script>




<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>



