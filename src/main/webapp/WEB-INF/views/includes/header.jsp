<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="CTX" value="${pageContext.request.contextPath}"/>
<c:set var="isLoggedIn" value="${not empty sessionScope.loginAdminId}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>Kaiadmin - Bootstrap 5 Admin Dashboard</title>
    <meta content="width=device-width, initial-scale=1.0, shrink-to-fit=no" name="viewport"/>

    <!-- Favicon -->
    <link rel="icon" href="${CTX}/img/kaiadmin/favicon.ico" type="image/x-icon"/>

    <!-- KaKaoMap api -->
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2879f57d00d7fd3009336abf35aad5e6&libraries=services"></script>

    <!-- Fonts and icons -->
    <script src="${CTX}/js/plugin/webfont/webfont.min.js"></script>
    <script>
        WebFont.load({
            google: {families: ["Public Sans:300,400,500,600,700"]},
            custom: {
                families: [
                    "Font Awesome 5 Solid",
                    "Font Awesome 5 Regular",
                    "Font Awesome 5 Brands",
                    "simple-line-icons",
                ],
                urls: ["${CTX}/css/fonts.min.css"],
            },
            active: function () {
                sessionStorage.fonts = true;
            },
        });
    </script>

    <!-- CSS Files -->
    <link rel="stylesheet" href="${CTX}/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${CTX}/css/plugins.min.css"/>
    <link rel="stylesheet" href="${CTX}/css/kaiadmin.min.css"/>
    <!-- Demo CSS (remove in production) -->
    <link rel="stylesheet" href="${CTX}/css/demo.css"/>
</head>
<body>
<div class="wrapper">
    <!-- Sidebar -->
    <div class="sidebar" data-background-color="dark">
        <div class="sidebar-logo">
            <!-- Logo Header -->
            <div class="logo-header" data-background-color="dark">
                <a href="${CTX}/index.html" class="logo">
                    <img src="${CTX}/img/kaiadmin/logo_light.svg" alt="navbar brand" class="navbar-brand" height="20"/>
                </a>
                <div class="nav-toggle">
                    <button class="btn btn-toggle toggle-sidebar"><i class="gg-menu-right"></i></button>
                    <button class="btn btn-toggle sidenav-toggler"><i class="gg-menu-left"></i></button>
                </div>
                <button class="topbar-toggler more"><i class="gg-more-vertical-alt"></i></button>
            </div>
            <!-- End Logo Header -->
        </div>

        <div class="sidebar-wrapper scrollbar scrollbar-inner">
            <div class="sidebar-content">
                <ul class="nav nav-secondary">
                    <li class="nav-item active">
                        <a data-bs-toggle="collapse" href="#dashboard" class="collapsed" aria-expanded="false">
                            <i class="fas fa-home"></i>
                            <p>Dashboard</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="dashboard">
                            <ul class="nav nav-collapse">
                                <li>
                                    <a href="${CTX}/index.html">
                                        <span class="sub-item">Dashboard 1</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-section">
                        <span class="sidebar-mini-icon"><i class="fa fa-ellipsis-h"></i></span>
                        <h4 class="text-section">Components</h4>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#user">
                            <i class="fas fa-pen-square"></i>
                            <p>회원관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="user">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">회원 정보 보기</span>
                                </a>
                                    <a class="nav-link" href="<c:url value='/admin/admin_list'/>">
                                        <span class="sub-item">관리자 보기</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#outbound">
                            <i class="fas fa-pen-square"></i>
                            <p>출고 관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="outbound">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">출고 요청 조회</span>
                                </a>
                                </li>
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">출고 지시서 조회</span>
                                </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#quotation">
                            <i class="fas fa-pen-square"></i>
                            <p>견적관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="quotation">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">견적 신청 목록 조회</span>
                                </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#inbound">
                            <i class="fas fa-pen-square"></i>
                            <p>입고관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="inbound">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">입고 요청 목록 조회</span>
                                </a>
                                    <a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                        <span class="sub-item">기간/날짜별 조회</span>
                                    </a>
                                    <a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                        <span class="sub-item">입고 목록 조회</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#inven">
                            <i class="fas fa-pen-square"></i>
                            <p>재고관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="inven">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">재고 조회</span>
                                </a>
                                    <a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                        <span class="sub-item">실 재고 조회</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#warehouse">
                            <i class="fas fa-pen-square"></i>
                            <p>창고관리</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="warehouse">
                            <ul class="nav nav-collapse">
                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                    <span class="sub-item">창고조회</span>
                                </a>
                                    <a class="nav-link" href="<c:url value='/admin/user_list'/>">
                                        <span class="sub-item">창고 등록</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

<%--                    <li class="nav-item">--%>
<%--                        <a data-bs-toggle="collapse" href="#map">--%>
<%--                            <i class="fas fa-pen-square"></i>--%>
<%--                            <p>지도</p>--%>
<%--                            <span class="caret"></span>--%>
<%--                        </a>--%>
<%--                        <div class="collapse" id="map">--%>
<%--                            <ul class="nav nav-collapse">--%>
<%--                                <li><a class="nav-link" href="<c:url value='/admin/user_list'/>">--%>
<%--                                    <span class="sub-item">창고 위치</span>--%>
<%--                                </a>--%>
<%--                                </li>--%>
<%--                            </ul>--%>
<%--                        </div>--%>
<%--                    </li>--%>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#base">
                            <i class="fas fa-layer-group"></i>
                            <p>Base</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="base">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/avatars.html"><span class="sub-item">Avatars</span></a></li>
                                <li><a href="${CTX}/buttons.html"><span class="sub-item">Buttons</span></a></li>
                                <li><a href="${CTX}/gridsystem.html"><span class="sub-item">Grid System</span></a></li>
                                <li><a href="${CTX}/panels.html"><span class="sub-item">Panels</span></a></li>
                                <li><a href="${CTX}/notifications.html"><span class="sub-item">Notifications</span></a>
                                </li>
                                <li><a href="${CTX}/sweetalert.html"><span class="sub-item">Sweet Alert</span></a></li>
                                <li><a href="${CTX}/font-awesome-icons.html"><span
                                        class="sub-item">Font Awesome Icons</span></a></li>
                                <li><a href="${CTX}/simple-line-icons.html"><span
                                        class="sub-item">Simple Line Icons</span></a></li>
                                <li><a href="${CTX}/typography.html"><span class="sub-item">Typography</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#sidebarLayouts">
                            <i class="fas fa-th-list"></i>
                            <p>Sidebar Layouts</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="sidebarLayouts">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/sidebar-style-2.html"><span class="sub-item">Sidebar Style 2</span></a>
                                </li>
                                <li><a href="${CTX}/icon-menu.html"><span class="sub-item">Icon Menu</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#forms">
                            <i class="fas fa-pen-square"></i>
                            <p>Forms</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="forms">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/forms.html"><span class="sub-item">Basic Form</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#tables">
                            <i class="fas fa-table"></i>
                            <p>Tables</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="tables">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/tables.html"><span class="sub-item">Basic Table</span></a></li>
                                <li><a href="${CTX}/datatables.html"><span class="sub-item">Datatables</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#maps">
                            <i class="fas fa-map-marker-alt"></i>
                            <p>Maps</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="maps">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/googlemaps.html"><span class="sub-item">Google Maps</span></a></li>
                                <li><a href="${CTX}/jsvectormap.html"><span class="sub-item">Jsvectormap</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#charts">
                            <i class="far fa-chart-bar"></i>
                            <p>Charts</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="charts">
                            <ul class="nav nav-collapse">
                                <li><a href="${CTX}/charts.html"><span class="sub-item">Chart Js</span></a></li>
                                <li><a href="${CTX}/sparkline.html"><span class="sub-item">Sparkline</span></a></li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a href="${CTX}/widgets.html">
                            <i class="fas fa-desktop"></i>
                            <p>Widgets</p>
                            <span class="badge badge-success">4</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a href="${CTX}/documentation/index.html">
                            <i class="fas fa-file"></i>
                            <p>Documentation</p>
                            <span class="badge badge-secondary">1</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a data-bs-toggle="collapse" href="#submenu">
                            <i class="fas fa-bars"></i>
                            <p>Menu Levels</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="submenu">
                            <ul class="nav nav-collapse">
                                <li>
                                    <a data-bs-toggle="collapse" href="#subnav1">
                                        <span class="sub-item">Level 1</span>
                                        <span class="caret"></span>
                                    </a>
                                    <div class="collapse" id="subnav1">
                                        <ul class="nav nav-collapse subnav">
                                            <li><a href="#"><span class="sub-item">Level 2</span></a></li>
                                            <li><a href="#"><span class="sub-item">Level 2</span></a></li>
                                        </ul>
                                    </div>
                                </li>
                                <li>
                                    <a data-bs-toggle="collapse" href="#subnav2">
                                        <span class="sub-item">Level 1</span>
                                        <span class="caret"></span>
                                    </a>
                                    <div class="collapse" id="subnav2">
                                        <ul class="nav nav-collapse subnav">
                                            <li><a href="#"><span class="sub-item">Level 2</span></a></li>
                                        </ul>
                                    </div>
                                </li>
                                <li><a href="#"><span class="sub-item">Level 1</span></a></li>
                            </ul>
                        </div>
                    </li>

                </ul>
            </div>
        </div>
    </div>
    <!-- End Sidebar -->

    <div class="main-panel">
        <div class="main-header">
            <div class="main-header-logo">
                <!-- Logo Header -->
                <div class="logo-header" data-background-color="dark">
                    <a href="${CTX}/index.html" class="logo">
                        <img src="${CTX}/img/kaiadmin/logo_light.svg" alt="navbar brand" class="navbar-brand"
                             height="20"/>
                    </a>
                    <div class="nav-toggle">
                        <button class="btn btn-toggle toggle-sidebar"><i class="gg-menu-right"></i></button>
                        <button class="btn btn-toggle sidenav-toggler"><i class="gg-menu-left"></i></button>
                    </div>
                    <button class="topbar-toggler more"><i class="gg-more-vertical-alt"></i></button>
                </div>
                <!-- End Logo Header -->
            </div>

            <!-- Navbar Header -->
            <c:choose>
                <c:when test="${isLoggedIn}">
                    <nav class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom">
                        <div class="container-fluid">
                            <ul class="navbar-nav topbar-nav ms-md-auto align-items-center">
                                <li class="nav-item topbar-user dropdown hidden-caret">
                                    <a class="dropdown-toggle profile-pic" data-bs-toggle="dropdown" href="#" aria-expanded="false">
                                        <div class="avatar-sm">
                                            <img src="${CTX}/img/defaultprofile.jpg" alt="..." class="avatar-img rounded-circle"/>
                                        </div>
                                        <span class="profile-username">
                <span class="op-7">Hi,</span>
                <span class="fw-bold">
                  <c:out value="${sessionScope.loginAdminName != null ? sessionScope.loginAdminName : sessionScope.loginAdminId}"/>
                </span>
              </span>
                                    </a>

                                    <ul class="dropdown-menu dropdown-user animated fadeIn">
                                            <li>
                                                <div class="user-box">
                                                    <div class="avatar-lg">
                                                        <img src="${CTX}/img/defaultprofile.jpg" alt="image profile" class="avatar-img rounded"/>
                                                    </div>
                                                    <div class="u-text">
                                                        <h4><c:out value="${sessionScope.loginAdminName != null ? sessionScope.loginAdminName : sessionScope.loginAdminId}"/></h4>
                                                        <p class="text-muted">
                                                            <c:out value="${sessionScope.loginAdminEmail != null ? sessionScope.loginAdminEmail : 'hello@example.com'}"/>
                                                        </p>
                                                        <a href="${CTX}/admin/myinfo" class="btn btn-xs btn-secondary btn-sm">View Profile</a>
                                                    </div>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="dropdown-divider"></div>
                                                <a class="dropdown-item" href="${CTX}/admin/myinfo">내 정보 확인</a>
                                                <a class="dropdown-item" href="${CTX}/login/logout">로그아웃</a>
                                            </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </c:when>

                <c:otherwise>
                    <nav class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom">
                        <div class="container-fluid">
                            <ul class="navbar-nav ms-auto">
                                <li class="nav-item me-2">
                                    <a class="btn btn-outline-primary" href="${CTX}/login/loginForm">로그인</a>
                                </li>
                                <li class="nav-item">
                                    <a class="btn btn-primary" href="${CTX}/admin/register">회원가입</a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </c:otherwise>
            </c:choose>
        </div>
            <!-- End Navbar -->

        <!-- Content Start -->
        <div class="container">
            <div class="page-inner">