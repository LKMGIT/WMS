package com.ssg.wms.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 입고(Inbound) 기능의 뷰(View) 페이지만을 담당하는 컨트롤러
 */
@Controller
@RequestMapping("/inbound/admin")
public class ViewController {

    /**
     * 입고 목록
     * (호출 경로: /inbound/admin/list)
     */
    @GetMapping("/list")
    public String showListPage() {
        return "inbound/admin/list";
    }

    /**
     * 입고 상세
     * (호출 경로: /inbound/admin/detail/1)
     */
    @GetMapping("/detail/{inboundIndex}")
    public String showDetailPage(@PathVariable("inboundIndex") Long inboundIndex) {
        return "inbound/admin/detail";
    }

    /**
     * 입고 통계
     * (호출 경로: /inbound/admin/status)
     */
    @GetMapping("/status")
    public String showStatsPage() {
        return "inbound/admin/status";
    }
}