<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="CTX" value="${pageContext.request.contextPath}"/>
<c:set var="isLoggedIn" value="${not empty sessionScope.loginAdminId}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>바름생각</title>
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
                <a href="<c:url value='/admin/dashbaord'/>">
                    <img src="${CTX}/img/kaiadmin/logo_background.png" alt="navbar brand" class="navbar-brand" height="20"/>
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
                            <p>대시보드</p>
                            <span class="caret"></span>
                        </a>
                        <div class="collapse" id="dashboard">
                            <ul class="nav nav-collapse">
                                <li>
                                    <a href="<c:url value='/admin/dashbaord'/>">
                                        <span class="sub-item">대시보드 확인</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-section">
                        <span class="sidebar-mini-icon"><i class="fa fa-ellipsis-h"></i></span>
                        <h4 class="text-section">목록</h4>
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
                                <li><a class="nav-link" href="<c:url value='/outbound/requests'/>">
                                    <span class="sub-item">출고요청 목록 조회</span>
                                </a>
                                </li>
                                <li><a class="nav-link" href="<c:url value='/outbound/instructions'/>">
                                    <span class="sub-item">출고 지시서 목록 조회</span>
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
                                <li><a class="nav-link" href="<c:url value='/quotation/requests'/>">
                                    <span class="sub-item">견적신청 목록 조회</span>
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
                                <li><a class="nav-link" href="<c:url value='/inventory/inventory_list'/>">
                                    <span class="sub-item">재고 조회</span>
                                </a>
                                    <a class="nav-link" href="<c:url value='/inventory/inventory_count_list'/>">
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