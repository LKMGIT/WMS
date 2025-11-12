package com.ssg.wms.inventory.controller;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.inventory.domain.InvenCountDTO;
import com.ssg.wms.inventory.service.InvenCountService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InvenCountController {

    private final InvenCountService service;

    // HTML (기본)
    @GetMapping("/inventory_count_list")
    public String invenCountListHtml(@ModelAttribute("cri") Criteria criteria,
                                     @RequestParam(value = "invenIndex", required = false) Long invenIndex,
                                     @RequestParam(value = "fromDate",   required = false) String fromDate,
                                     @RequestParam(value = "toDate",     required = false) String toDate,
                                     Model model) {

        criteria.setInvenIndex(invenIndex);
        criteria.setFromDate(fromDate);
        criteria.setToDate(toDate);

        List<InvenCountDTO> list = service.getPage(criteria);
        PageDTO pageDTO = new PageDTO(criteria, service.getTotal(criteria));

        model.addAttribute("counts", list);
        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("selectedInvenIndex", criteria.getInvenIndex());
        model.addAttribute("selectedFromDate", criteria.getFromDate());
        model.addAttribute("selectedToDate", criteria.getToDate());

        return "inventory/inventory_count_list"; // /WEB-INF/views/inventory/inventory_count_list.jsp
    }

    // JSON (?format=json 일 때)
    @GetMapping(value = "/inventory_count_list", params = "format=json")
    @ResponseBody
    public PagedResponse<InvenCountDTO> invenCountListJson(Criteria criteria,
                                                           @RequestParam(value = "invenIndex", required = false) Long invenIndex,
                                                           @RequestParam(value = "fromDate",   required = false) String fromDate,
                                                           @RequestParam(value = "toDate",     required = false) String toDate) {

        criteria.setInvenIndex(invenIndex);
        criteria.setFromDate(fromDate);
        criteria.setToDate(toDate);

        List<InvenCountDTO> list = service.getPage(criteria);
        PageDTO page = new PageDTO(criteria, service.getTotal(criteria));

        PagedResponse<InvenCountDTO> res = new PagedResponse<>();
        res.setList(list);
        res.setPage(page);
        return res;
    }

    @PostMapping(value = "/inventory_count_list", produces = "application/json")
    @ResponseBody
    @ResponseStatus(HttpStatus.CREATED)
    public IdResponse create(@RequestBody InvenCountDTO dto) {
        return new IdResponse(service.create(dto));
    }

    @PutMapping(value = "/inventory_count_list/{countIndex}", produces = "application/json")
    @ResponseBody
    public boolean update(@PathVariable Long countIndex, @RequestBody InvenCountDTO dto) {
        dto.setCountIndex(countIndex);
        return service.update(dto);
    }

    @DeleteMapping(value = "/inventory_count_list/{countIndex}", produces = "application/json")
    @ResponseBody
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long countIndex) {
        service.delete(countIndex);
    }

    @lombok.Data
    public static class PagedResponse<T> {
        private List<T> list;
        private PageDTO page;
    }
    @lombok.Data
    public static class IdResponse {
        private final Long id;
    }
}


