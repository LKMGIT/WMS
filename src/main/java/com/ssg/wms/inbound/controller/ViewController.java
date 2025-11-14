package com.ssg.wms.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/inbound/admin")
public class ViewController {

    /** 입고 목록 */
    @GetMapping("/list")
    public String showListPage() {
        return "inbound/admin/list";
    }

    /** 입고 상세 */
    @GetMapping("/detail/{inboundIndex}")
    public String showDetailPage(@PathVariable("inboundIndex") Long inboundIndex) {
        return "inbound/admin/detail";
    }

    /** 입고 통계 */
    @GetMapping("/status")
    public String showStatsPage() {
        return "inbound/admin/status";
    }
}