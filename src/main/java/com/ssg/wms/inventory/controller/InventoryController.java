package com.ssg.wms.inventory.controller;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.inventory.domain.InvenDTO;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import com.ssg.wms.inventory.service.InvenService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.EnumSet;
import java.util.List;
import java.util.Set;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InventoryController {

    private final InvenService inventoryService;

    @GetMapping("/inventory_list")
    public String inventoryList(@ModelAttribute("cri") Criteria criteria,
                                @RequestParam(value = "category",       required = false) String category,
                                @RequestParam(value = "warehouseIndex", required = false) Long warehouseIndex,
                                @RequestParam(value = "sectionIndex",      required = false) Long sectionIndex,
                                @RequestParam(value = "itemName",       required = false) String itemName,
                                Model model) {

        criteria.setCategory(category);
        criteria.setWarehouseIndex(warehouseIndex);
        criteria.setSectionIndex(sectionIndex);
        criteria.setItemName(itemName);

        List<InvenItemViewDTO> list = inventoryService.getInventoryPage(criteria);
        PageDTO pageDTO = new PageDTO(criteria, inventoryService.getInventoryTotal(criteria));

        model.addAttribute("inventories", list);
        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("selectedCategory", criteria.getCategory());
        model.addAttribute("selectedWarehouseIndex", criteria.getWarehouseIndex());
        model.addAttribute("selectedsectionIndex", criteria.getSectionIndex());
        model.addAttribute("searchedItemName", criteria.getItemName());

        return "inventory/inventory_list"; // /WEB-INF/views/inventory/inventory_list.jsp
    }

    // JSON이 필요하면 같은 클래스에 별도 메서드 추가
    @GetMapping(value="/inventory_list", produces="application/json")
    @ResponseBody
    public PagedResponse<InvenItemViewDTO> inventoryListJson(Criteria criteria) {
        List<InvenItemViewDTO> list = inventoryService.getInventoryPage(criteria);
        PageDTO page = new PageDTO(criteria, inventoryService.getInventoryTotal(criteria));
        PagedResponse<InvenItemViewDTO> res = new PagedResponse<>();
        res.setList(list);
        res.setPage(page);
        return res;
    }

    @lombok.Data
    public static class PagedResponse<T> {
        private List<T> list;
        private PageDTO page;
    }
}
