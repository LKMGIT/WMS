package com.ssg.wms.outbound.controller; // 공통 패키지 (예시)

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import com.ssg.wms.global.domain.Criteria; // Criteria 임포트
import com.ssg.wms.global.domain.PageDTO; // PageDTO 임포트


@Controller
public class OutboundViewController {

    // === Quotation (견적) Views ===

    @GetMapping("/quotation/requests")
    public String showQuotationRequestListForm() {
        return "/quotation/list";
    }

    @GetMapping("/quotation/request/register") // 명세서 오타(qoutation) 반영
    public String showRegisterQuotationRequestForm() {
        return "/quotation/register";
    }

    @GetMapping("/quotation/request/{qrequest_index}")
    public String showQuotationRequestDetailForm(@PathVariable("qrequest_index") Long qrequest_index , Model model) {
        model.addAttribute("qrequest_index", qrequest_index);
        return "/quotation/detail";
    }

    // === Outbound (출고) Views ===

    @GetMapping("/outbound/requests")
    public String showOutboundRequestListForm() {
        return "/outbound/list";
    }

    @GetMapping("/outbound/request/register")
    public String showRegisterOutboundRequestForm() {
        return "/outbound/register";
    }

    @GetMapping("/outbound/request/{or_index}")
    public String showOutboundRequestDetailForm(@PathVariable("or_index") Long or_index, Model model) {
        model.addAttribute("or_index", or_index);
        return "/outbound/detail";
    }

    @GetMapping("/outbound/instructions")
    public String showShippingInstructionListForm() {
        return "/outbound/instructionList";
    }

    @GetMapping("/outbound/instruction/{si_index}") // 명세서의 {qrequest_index} 오타 수정
    public String showShippingInstructionDetailForm(@PathVariable("si_index") Long si_index, Model model) {
        model.addAttribute("si_index", si_index);
        return "/outbound/instructionDetail";
    }

    // [참고] 명세서의 'showRegisterShippingInstructionForm'은(는)
    // 출고지시서가 '출고 승인' 시 자동으로 생성되는 로직과 충돌하여 제외했습니다.
}