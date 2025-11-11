<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1) notify super-shim: header.jsp 포함 전 (반드시 최상단) -->
<script>
    (function(){
        function shimNotify(content, options){
            try{
                var msg = (typeof content === 'string') ? content
                    : (content && (content.message || content.title)) || '';
                var type = options && (options.type || options.className) || 'info';

                function ensureWrap(){
                    var wrap = document.getElementById('__notify_wrap__');
                    if(!wrap){
                        wrap = document.createElement('div');
                        wrap.id='__notify_wrap__';
                        wrap.style.position='fixed';
                        wrap.style.top='16px';
                        wrap.style.right='16px';
                        wrap.style.zIndex='99999';
                        document.body.appendChild(wrap);
                    }
                    return wrap;
                }

                function run(){
                    var wrap = ensureWrap();
                    var box = document.createElement('div');
                    box.style.padding='10px 12px';
                    box.style.borderRadius='10px';
                    box.style.marginTop='8px';
                    box.style.fontSize='13px';
                    box.style.boxShadow='0 8px 20px rgba(0,0,0,.08)';
                    if(type==='success'){ box.style.background='#ecfdf5'; box.style.color='#065f46'; box.style.border='1px solid #a7f3d0'; }
                    else if(type==='danger'||type==='error'){ box.style.background='#fef2f2'; box.style.color='#991b1b'; box.style.border='1px solid #fecaca'; }
                    else if(type==='warning'){ box.style.background='#fffbeb'; box.style.color='#92400e'; box.style.border='1px solid #fde68a'; }
                    else { box.style.background='#eff6ff'; box.style.color='#1e40af'; box.style.border='1px solid #bfdbfe'; }
                    box.textContent = msg || '[알림]';
                    wrap.appendChild(box);
                    setTimeout(function(){ try{ box.remove(); }catch(e){} }, 2500);
                }

                if(document.readyState==='loading'){
                    document.addEventListener('DOMContentLoaded', run, {once:true});
                }else{ run(); }
            }catch(e){ try{ alert((content && content.message) ? content.message : (content || '알림')); }catch(_){} }
        }

        if(!window.$) window.$ = {};
        if(typeof window.$.notify !== 'function') window.$.notify = shimNotify;

        try{
            var __$ = window.$;
            Object.defineProperty(window, '$', {
                configurable: true,
                get: function(){ return __$; },
                set: function(v){
                    __$ = v;
                    try{
                        if (v && typeof v.notify !== 'function') v.notify = shimNotify;
                        if (window.jQuery && typeof window.jQuery.notify !== 'function') window.jQuery.notify = shimNotify;
                    }catch(e){}
                }
            });
        }catch(e){
            var tries=0, t=setInterval(function(){
                if(window.jQuery){
                    if(typeof window.jQuery.notify !== 'function') window.jQuery.notify = shimNotify;
                    if(window.$ && typeof window.$.notify !== 'function') window.$.notify = shimNotify;
                    clearInterval(t);
                }else if(++tries>60){ clearInterval(t); }
            },50);
        }
    })();
</script>

<script>
    (function(){
        var orig = document.getElementById.bind(document);
        document.getElementById = function(id){
            var el = orig(id);
            if (el) return el;
            // 없는 ID를 요청하면 1x1 숨김 캔버스를 만들어 반환
            var dummy = document.createElement('canvas');
            dummy.id = id;
            dummy.width = 1; dummy.height = 1;
            dummy.style.cssText = 'position:absolute;left:-9999px;width:0;height:0;opacity:0;pointer-events:none;';
            // body가 생긴 뒤에만 붙이기
            if (document.body) document.body.appendChild(dummy);
            else document.addEventListener('DOMContentLoaded', function(){ document.body.appendChild(dummy); }, {once:true});
            return dummy;
        };
    })();
</script>

<%@ include file="../includes/header.jsp" %>

<c:if test="${not empty _csrf}">
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf"        content="${_csrf.token}"/>
</c:if>

<!-- 2) jsVectorMap 같은 공통 플러그인이 찾는 타깃이 없어 죽는 걸 예방: 더미 엘리먼트 -->
<style>.vm-dummy{position:absolute;width:0;height:0;overflow:hidden;pointer-events:none;}</style>
<div id="world-map" class="vm-dummy"></div>
<div id="worldMap"  class="vm-dummy"></div>
<div id="map"       class="vm-dummy"></div>
<div id="vmap"      class="vm-dummy"></div>

<style>
    .pw-page{min-height:calc(100vh - 120px);display:grid;place-items:center;background:#f3f5f9;padding:24px 12px;}
    .pw-card{width:100%;max-width:520px;background:#fff;border-radius:16px;box-shadow:0 10px 30px rgba(22,28,45,.06);overflow:hidden;animation:fadeIn .25s ease;}
    .pw-card-header{padding:18px 20px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid #eef1f6;}
    .pw-title{margin:0;font-size:18px;font-weight:700;color:#1f2937;}
    .pw-card-body{padding:20px;}
    .pw-card-footer{padding:14px 20px;background:#fafbfe;border-top:1px solid #eef1f6;display:flex;justify-content:space-between;gap:8px;flex-wrap:wrap;}
    .pw-form .form-row{margin-bottom:14px;}
    .pw-label{font-size:13px;color:#4b5563;margin-bottom:6px;display:block;}
    .pw-input,.pw-btn,.pw-select{width:100%;box-sizing:border-box;border:1px solid #e5e7eb;border-radius:10px;padding:10px 12px;font-size:14px;color:#111827;outline:none;background:#fff;transition:border-color .15s ease,box-shadow .15s ease;}
    .pw-input:focus{border-color:#2563eb;box-shadow:0 0 0 3px rgba(37,99,235,.12);}
    .pw-input::placeholder{color:#9ca3af;}
    .pw-group{display:flex;gap:8px;}
    .pw-toggle{white-space:nowrap;border-radius:10px;padding:0 12px;border:1px solid #e5e7eb;background:#f9fafb;color:#374151;cursor:pointer;font-size:13px;}
    .pw-toggle:hover{background:#f3f4f6;}
    .pw-btn{background:#2563eb;color:#fff;border:none;font-weight:600;padding:12px 14px;border-radius:12px;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;gap:8px;}
    .pw-btn[disabled]{opacity:.7;cursor:not-allowed;}
    .pw-btn-outline{background:#fff;color:#374151;border:1px solid #e5e7eb;padding:8px 12px;border-radius:10px;text-decoration:none;}
    .pw-btn-outline:hover{background:#f9fafb;}
    .pw-alert{padding:10px 12px;border-radius:10px;font-size:13px;}
    .pw-alert-success{background:#ecfdf5;color:#065f46;border:1px solid #a7f3d0;}
    .pw-alert-error{background:#fef2f2;color:#991b1b;border:1px solid #fecaca;}
    .pw-links{display:flex;flex-direction:column;gap:4px;}
    .pw-link{font-size:13px;color:#2563eb;text-decoration:none;}
    .pw-link:hover{text-decoration:underline;}
    @keyframes fadeIn{from{opacity:0;transform:translateY(4px);}to{opacity:1;transform:none;}}
</style>

<div class="pw-page">
    <div class="pw-card">
        <div class="pw-card-header">
            <h4 class="pw-title">관리자 비밀번호 재설정</h4>
        </div>

        <div class="pw-card-body">
            <div class="pw-form">
                <div class="form-row">
                    <label class="pw-label">관리자 아이디</label>
                    <input id="adminId" class="pw-input" maxlength="50" placeholder="예) admin01"/>
                </div>

                <div class="form-row">
                    <label class="pw-label">새 비밀번호</label>
                    <div class="pw-group">
                        <input id="pw1" type="password" class="pw-input" minlength="6" maxlength="100" placeholder="6자 이상"/>
                        <button id="toggle1" type="button" class="pw-toggle">보기</button>
                    </div>
                </div>

                <div class="form-row">
                    <label class="pw-label">새 비밀번호 확인</label>
                    <div class="pw-group">
                        <input id="pw2" type="password" class="pw-input" minlength="6" maxlength="100" placeholder="다시 입력"/>
                        <button id="toggle2" type="button" class="pw-toggle">보기</button>
                    </div>
                </div>

                <button id="btnChange" type="button" class="pw-btn">
                    <span id="btnText">비밀번호 변경</span>
                    <!-- classList를 안 쓰기 위해 display로만 제어 -->
                    <svg id="btnSpin" style="display:none" width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-opacity=".2" stroke-width="4"/>
                        <path d="M22 12a10 10 0 0 0-10-10" stroke="currentColor" stroke-width="4"/>
                    </svg>
                </button>

                <div id="result" class="form-row" style="margin-top:12px;"></div>
            </div>
        </div>

        <div class="pw-card-footer">
            <div class="pw-links">
                <a class="pw-link" href="<c:url value='/admin/forgot_id'/>">아이디를 잊어버렸나요?</a>
                <a class="pw-link" href="<c:url value='/admin/forgot_password'/>">비밀번호를 잊어버렸나요?</a>
            </div>
            <a class="pw-btn-outline" href="<c:url value='/login/loginForm'/>">로그인 화면</a>
        </div>
    </div>
</div>

<!-- 3) 우리 스크립트: classList 미사용 + 요소 존재 검사 -->
<script>
    (function(){
        function qs(s){ return document.querySelector(s); }
        function getCtx(){ return '${pageContext.request.contextPath}' || ''; }
        function getMeta(name){ var m=document.querySelector('meta[name="'+name+'"]'); return m?m.content:null; }

        function showMsg(text, ok){
            var r=qs('#result'); if(!r){ alert(text); return; }
            r.innerHTML = '<div class="'+(ok?'pw-alert pw-alert-success':'pw-alert pw-alert-error')+'">'+ text +'</div>';
        }
        function setLoading(on){
            var btn = qs('#btnChange'), txt = qs('#btnText'), spin = qs('#btnSpin');
            if(!btn || !txt || !spin) return; // 요소 없으면 무시
            if(on){ btn.disabled = true; txt.textContent='처리 중...'; spin.style.display='inline-block'; }
            else  { btn.disabled = false; txt.textContent='비밀번호 변경'; spin.style.display='none'; }
        }
        function missingIds(ids){ return ids.filter(function(id){ return !qs('#'+id); }); }
        function reportMissing(ids){
            if(!ids.length) return;
            showMsg('다음 요소 id가 없습니다: ' + ids.map(function(id){return '#'+id;}).join(', '), false);
        }

        window.addEventListener('error', function(e){
            try{
                var where = (e.filename?(' ('+e.filename+':'+e.lineno+')'):'');
                showMsg('스크립트 오류: ' + (e.message||e) + where, false);
            }catch(_){}
        });

        document.addEventListener('DOMContentLoaded', function(){
            // 필수 요소 확인
            reportMissing(missingIds(['adminId','pw1','pw2','btnChange','btnText','btnSpin','result']));

            var ctx = getCtx();
            var adminIdEl = qs('#adminId');
            var pw1El = qs('#pw1');
            var pw2El = qs('#pw2');
            var btnEl = qs('#btnChange');
            var t1 = qs('#toggle1');
            var t2 = qs('#toggle2');

            if(!adminIdEl || !pw1El || !pw2El || !btnEl){
                showMsg('필수 요소가 없어 동작을 중단합니다.', false);
                return;
            }

            function bindToggle(inp, btn){
                if(!inp || !btn) return;
                btn.addEventListener('click', function(){
                    var isPw = inp.type === 'password';
                    try{
                        inp.type = isPw ? 'text' : 'password';
                    }catch(_){
                        var clone = document.createElement('input');
                        clone.setAttribute('type', isPw ? 'text' : 'password');
                        clone.className = inp.className;
                        clone.value = inp.value;
                        inp.parentNode.replaceChild(clone, inp);
                        inp = clone;
                    }
                    btn.textContent = isPw ? '숨기기' : '보기';
                });
            }
            bindToggle(pw1El, t1); bindToggle(pw2El, t2);

            function csrfHeaders(){
                var header = getMeta('_csrf_header');
                var token  = getMeta('_csrf');
                var h={}; if(header && token) h[header]=token; return h;
            }

            async function changePassword(){
                var adminId = (adminIdEl.value||'').trim();
                var p1 = pw1El.value||'';
                var p2 = pw2El.value||'';

                if(!adminId){ showMsg('관리자 아이디를 입력하세요.', false); return; }
                if(p1.length < 6){ showMsg('비밀번호는 6자 이상이어야 합니다.', false); return; }
                if(p1 !== p2){ showMsg('비밀번호가 일치하지 않습니다.', false); return; }

                setLoading(true);
                try{
                    var form = new URLSearchParams();
                    form.append('newPassword', p1);

                    var res = await fetch(ctx + '/admin/api/admins/' + encodeURIComponent(adminId) + '/password', {
                        method: 'POST',
                        headers: Object.assign({'Content-Type':'application/x-www-form-urlencoded'}, csrfHeaders()),
                        credentials: 'same-origin',
                        body: form.toString()
                    });

                    var text = await res.text();
                    if(!res.ok){
                        showMsg('변경 실패(' + res.status + '): ' + (text || '오류가 발생했습니다.'), false);
                        return;
                    }
                    if((text||'').trim() === 'true'){
                        showMsg('비밀번호가 변경되었습니다. 로그인 화면으로 이동해 주세요.', true);
                        // setTimeout(function(){ location.href = ctx + '/admin/login'; }, 1000);
                    }else{
                        showMsg('해당 아이디를 찾을 수 없거나 변경에 실패했습니다.', false);
                    }
                }catch(err){
                    showMsg('예외 발생: ' + (err && err.message ? err.message : err), false);
                }finally{
                    setLoading(false);
                }
            }

            btnEl.addEventListener('click', changePassword);
            [adminIdEl, pw1El, pw2El].forEach(function(el){
                el && el.addEventListener('keydown', function(e){
                    if(e.key==='Enter'){ e.preventDefault(); changePassword(); }
                });
            });
        });
    })();
</script>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
