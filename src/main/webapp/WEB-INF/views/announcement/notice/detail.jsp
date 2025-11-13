<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:import url="/WEB-INF/views/includes/header.jsp"/>

<style>
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .fade-in-up { animation: fadeInUp 0.6s ease-out; }

    /* 헤더 */
    .detail-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 20px;
        padding: 2.5rem;
        color: white;
        box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        margin-bottom: 2rem;
        position: relative;
        overflow: hidden;
    }

    .detail-header::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,165.3C1248,171,1344,149,1392,138.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
        background-size: cover;
        opacity: 0.3;
    }

    .detail-header h2 {
        margin: 0;
        font-weight: 700;
        position: relative;
        z-index: 1;
    }

    .detail-header .meta {
        margin-top: 1rem;
        opacity: 0.9;
        position: relative;
        z-index: 1;
    }

    .priority-badge {
        display: inline-block;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        font-weight: 600;
        margin-top: 1rem;
    }

    .priority-important {
        background: rgba(245, 101, 101, 0.2);
        backdrop-filter: blur(10px);
        border: 2px solid rgba(255,255,255,0.3);
    }

    .priority-normal {
        background: rgba(255,255,255,0.2);
        backdrop-filter: blur(10px);
    }

    /* 본문 카드 */
    .content-card {
        border: none;
        border-radius: 20px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        margin-bottom: 2rem;
    }

    .content-card .card-body {
        padding: 3rem;
        line-height: 1.8;
        font-size: 1.05rem;
        color: #2d3748;
        min-height: 300px;
    }

    /* 정보 카드 */
    .info-card {
        border: none;
        border-radius: 20px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        margin-bottom: 2rem;
    }

    .info-card .card-body {
        padding: 2rem;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        padding: 1rem;
        border-bottom: 1px solid #e2e8f0;
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-label {
        font-weight: 600;
        color: #718096;
    }

    .info-value {
        color: #2d3748;
        font-weight: 600;
    }

    /* 버튼 */
    .btn-modern {
        border-radius: 10px;
        padding: 0.6rem 1.5rem;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
    }

    .btn-edit {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .btn-edit:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        color: white;
    }

    .btn-delete {
        background: linear-gradient(135deg, #f56565 0%, #ed8936 100%);
        color: white;
    }

    .btn-delete:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(245, 101, 101, 0.4);
        color: white;
    }

    .btn-list {
        background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
        color: #2d3748;
    }

    .btn-list:hover {
        background: linear-gradient(135deg, #cbd5e0 0%, #a0aec0 100%);
        color: #2d3748;
    }

    .loading-overlay {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(255,255,255,0.95);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }

    .loading-spinner {
        width: 60px;
        height: 60px;
        border: 6px solid rgba(102, 126, 234, 0.2);
        border-radius: 50%;
        border-top-color: #667eea;
        animation: spin 1s ease-in-out infinite;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }
</style>

<div class="container">
    <div class="page-inner">

        <div class="page-header fade-in-up">
            <ul class="breadcrumbs mb-3">
                <li class="nav-home"><a href="<c:url value='/'/>"><i class="icon-home"></i></a></li>
                <li class="separator"><i class="icon-arrow-right"></i></li>
                <li class="nav-item"><a href="<c:url value='/announcement/notice/list'/>">공지사항</a></li>
                <li class="separator"><i class="icon-arrow-right"></i></li>
                <li class="nav-item">상세보기</li>
            </ul>
        </div>

        <!-- 헤더 -->
        <div class="detail-header fade-in-up" id="noticeHeader">
            <h2><i class="fas fa-bullhorn"></i> <span id="noticeTitle">로딩 중...</span></h2>
            <div class="meta">
                <span><i class="fas fa-calendar"></i> <span id="noticeDate">-</span></span>
                <span style="margin-left: 2rem;"><i class="fas fa-user-shield"></i> 관리자</span>
            </div>
            <div id="priorityBadge"></div>
        </div>

        <!-- 본문 -->
        <div class="card content-card fade-in-up">
            <div class="card-body" id="noticeContent">
                <div class="text-center py-5">
                    <div class="loading-spinner"></div>
                    <p class="mt-3 text-muted">내용을 불러오는 중입니다...</p>
                </div>
            </div>
        </div>

        <!-- 정보 -->
        <div class="card info-card fade-in-up">
            <div class="card-body">
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-calendar-plus"></i> 작성일</div>
                    <div class="info-value" id="createDate">-</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-calendar-check"></i> 수정일</div>
                    <div class="info-value" id="updateDate">-</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fas fa-flag"></i> 중요도</div>
                    <div class="info-value" id="priorityText">-</div>
                </div>
            </div>
        </div>

        <!-- 버튼 -->
        <div class="text-center mb-4">
            <button class="btn btn-modern btn-edit" onclick="goToEdit()">
                <i class="fas fa-edit"></i> 수정
            </button>
            <button class="btn btn-modern btn-delete" onclick="deleteNotice()">
                <i class="fas fa-trash"></i> 삭제
            </button>
            <button class="btn btn-modern btn-list" onclick="goToList()">
                <i class="fas fa-list"></i> 목록으로
            </button>
        </div>

    </div>
</div>

<c:import url="/WEB-INF/views/includes/footer.jsp"/>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var currentNoticeIndex = '';

        var $ = function(id) { return document.getElementById(id); };
        var safeHtml = function(s) {
            var str = (s != null && s != undefined) ? String(s) : '';
            return str.replace(/[&<>"']/g, function(m) {
                var map = {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'};
                return map[m];
            });
        };

        function formatDateTime(dateStr) {
            if (!dateStr) return '-';
            var d = new Date(dateStr);
            if (!isNaN(d.getTime())) {
                var pad = function(n) { return String(n).padStart(2,'0'); };
                return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
            }
            return String(dateStr);
        }

        function loadNoticeDetail(noticeIndex) {
            if (!noticeIndex || isNaN(Number(noticeIndex))) {
                alert('잘못된 공지사항 번호입니다.');
                goToList();
                return;
            }

            currentNoticeIndex = noticeIndex;
            var url = ctx + '/announcement/notice/' + noticeIndex;

            fetch(url, {
                method: 'GET',
                headers: { 'Accept': 'application/json' },
                credentials: 'same-origin'
            })
                .then(function(res) {
                    if (res.ok) return res.json();
                    return Promise.reject(new Error('HTTP ' + res.status));
                })
                .then(function(data) {
                    displayNotice(data);
                })
                .catch(function(err) {
                    console.error('[loadNoticeDetail] error:', err);
                    alert('공지사항을 불러오는 중 오류가 발생했습니다.');
                    goToList();
                });
        }

        function displayNotice(notice) {
            var title = notice.nTitle || notice.n_title || '제목 없음';
            var content = notice.nContent || notice.n_content || '내용 없음';
            var createAt = notice.nCreateAt || notice.n_create_at;
            var updateAt = notice.nUpdateAt || notice.n_update_at;
            var priority = notice.nPriority || notice.n_priority || 0;

            $('noticeTitle').textContent = title;
            $('noticeDate').textContent = formatDateTime(createAt);
            $('noticeContent').innerHTML = '<div style="white-space: pre-wrap;">' + safeHtml(content) + '</div>';

            $('createDate').textContent = formatDateTime(createAt);
            $('updateDate').textContent = updateAt ? formatDateTime(updateAt) : '-';
            $('priorityText').textContent = priority == 1 ? '중요' : '일반';

            if (priority == 1) {
                $('priorityBadge').innerHTML = '<span class="priority-badge priority-important"><i class="fas fa-star"></i> 중요 공지</span>';
            } else {
                $('priorityBadge').innerHTML = '<span class="priority-badge priority-normal">일반 공지</span>';
            }
        }

        window.goToEdit = function() {
            if (!currentNoticeIndex) {
                alert('잘못된 접근입니다.');
                return;
            }
            location.href = ctx + '/announcement/notice/form?noticeIndex=' + currentNoticeIndex;
        };

        window.deleteNotice = function() {
            if (!currentNoticeIndex) {
                alert('잘못된 접근입니다.');
                return;
            }

            if (!confirm('이 공지사항을 삭제하시겠습니까?')) return;

            var url = ctx + '/announcement/notice/' + currentNoticeIndex;

            fetch(url, {
                method: 'DELETE',
                headers: { 'Accept': 'application/json' },
                credentials: 'same-origin'
            })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data && data.success) {
                        alert('공지사항이 삭제되었습니다.');
                        goToList();
                    } else {
                        alert(data.message || '삭제에 실패했습니다.');
                    }
                })
                .catch(function(err) {
                    console.error(err);
                    alert('삭제 중 오류가 발생했습니다.');
                });
        };

        window.goToList = function() {
            location.href = ctx + '/announcement/notice/list';
        };

        document.addEventListener('DOMContentLoaded', function () {
            try {
                var segs = (location.pathname || '').split('/').filter(Boolean);
                var last = segs[segs.length - 1] || '';
                var noticeIndex = /^[0-9]+$/.test(last) ? last : '';

                if (noticeIndex) {
                    loadNoticeDetail(noticeIndex);
                } else {
                    alert('공지사항 번호가 없습니다.');
                    goToList();
                }
            } catch (e) {
                console.error('[init] error:', e);
                goToList();
            }
        });
    })();
</script>
