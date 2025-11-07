<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h4 class="card-title mb-0">회원정보</h4>

                <form method="get" action="${pageContext.request.contextPath}/admin/user_list" class="d-flex gap-2">
                    <!-- 아이디 검색(부분일치) -->
                    <input type="text"
                           class="form-control"
                           name="userId"
                           placeholder="아이디 검색"
                           value="${fn:escapeXml(param.userId)}"
                           style="width:200px"/>

                    <!-- 상태 선택 -->
                    <select class="form-select" name="status" style="width:160px">
                        <option value=""         ${empty param.status ? 'selected':''}>전체</option>
                        <option value="APPROVED" ${param.status == 'APPROVED' ? 'selected':''}>승인(APPROVED)</option>
                        <option value="PENDING"  ${param.status == 'PENDING'  ? 'selected':''}>대기(PENDING)</option>
                        <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected':''}>거절(REJECTED)</option>
                    </select>

                    <button type="submit" class="btn btn-primary">적용</button>

                    <!-- 옵션: 빠른 초기화 -->
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/admin/user_list">초기화</a>

                    <!-- 페이지 크기 유지 -->
                    <input type="hidden" name="amount" value="${cri.amount}"/>
                </form>
            </div>


            <div class="card-body">
                <div class="table-responsive">
                    <table id="basic-datatables" class="display table table-striped table-hover">
                        <thead>
                        <tr>
                            <th>회원번호</th>
                            <th>회원이름</th>
                            <th>회원아이디</th>
                            <th>회원이메일</th>
                            <th>회원전화번호</th>
                            <th>회원가입일</th>
                            <th>정보수정일</th>
                            <th>회원상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td><c:out value="${user.userIndex}"/></td>
                                <td><c:out value="${user.userName}"/></td>
                                <td><c:out value="${user.userId}"/></td>
                                <td><c:out value="${user.userEmail}"/></td>
                                <td><c:out value="${user.userPhone}"/></td>

                                <!-- 일단 문자열로 안전 출력 (문자열이면 그대로, Date면 fmt로 교체 가능) -->
                                <td><c:out value="${user.userCreatedAt}"/></td>
                                <td><c:out value="${user.userUpdateAt}"/></td>

                                <!-- 상태: 영문 → 한글 매핑 -->
                                <td>
                                    <c:choose>
                                        <c:when test="${user.userStatus == 'APPROVED'}">승인</c:when>
                                        <c:when test="${user.userStatus == 'PENDING'}">대기</c:when>
                                        <c:when test="${user.userStatus == 'REJECTED'}">거절</c:when>
                                        <c:otherwise><c:out value="${user.userStatus}"/></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 페이지네이션(필요 시 조건부로 노출) -->
                <c:if test="${not empty pageMaker}">
                    <ul class="pagination justify-content-center mt-3">
                        <c:if test="${pageMaker.prev}">
                            <li class="page-item">
                                <a class="page-link" href="?pageNum=${pageMaker.startPage - 1}&amount=${cri.amount}&status=${selectedStatus}">Previous</a>
                            </li>
                        </c:if>

                        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="num">
                            <li class="page-item ${cri.pageNum == num ? 'active':''}">
                                <a class="page-link" href="?pageNum=${num}&amount=${cri.amount}&status=${selectedStatus}">${num}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="page-item">
                                <a class="page-link" href="?pageNum=${pageMaker.endPage + 1}&amount=${cri.amount}&status=${selectedStatus}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>

            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
<%@ include file="../includes/end.jsp" %>
