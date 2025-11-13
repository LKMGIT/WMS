package com.ssg.wms.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 입고(Inbound) 기능의 뷰(View) 페이지만을 담당하는 컨트롤러
 * - 모든 데이터는 InboundApiController를 통해 JavaScript(fetch)로 비동기 로드됩니다.
 * - 이 컨트롤러는 Model에 데이터를 담지 않습니다.
 */
@Controller
@RequestMapping("/inbound/admin") // JSP에서 사용하는 공통 경로
public class ViewController {

    /**
     * 입고 목록
     * (호출 경로: /inbound/admin/list)
     * (반환 뷰: /WEB-INF/views/inbound/admin/list.jsp)
     */
    @GetMapping("/list")
    public String showListPage() {
        // "inbound/admin/list" 뷰(JSP) 껍데기를 반환
        return "inbound/admin/list";
    }

    /**
     * 입고 상세
     * (호출 경로: /inbound/admin/detail/1)
     * (반환 뷰: /WEB-INF/views/inbound/admin/detail.jsp)
     */
    @GetMapping("/detail/{inboundIndex}")
    public String showDetailPage(@PathVariable("inboundIndex") Long inboundIndex) {
        // 이 페이지는 JSP 껍데기만 반환하고,
        // 로드된 후 JS가 /inbound/admin/request/{inboundIndex} API를 호출합니다.
        return "inbound/admin/detail";
    }

    /**
     * 입고 통계
     * (호출 경로: /inbound/admin/stats)
     * (반환 뷰: /WEB-INF/views/inbound/admin/stats.jsp)
     */
    @GetMapping("/status")
    public String showStatsPage() {
        // "inbound/admin/stats" 뷰(JSP) 껍데기를 반환
        return "inbound/admin/status";
    }
}