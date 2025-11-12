package com.ssg.wms.warehouse.controller;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.warehouse.domain.WarehouseDTO;
import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.domain.WarehouseUpdateDTO;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/warehouse")
public class WarehouseController {
    private final WarehouseService warehouseService;

    // 창고 조회 시, 필터 조건 검색창, 창고 리스트, 지도 화면 출력 페이지
    // 요청 : /warehouses/list
    // /WEB-INF/views/warehouse/list.jsp
    @GetMapping("/list")
    public String getWarehouses(@ModelAttribute("cri") Criteria cri,
                                @RequestParam(value = "typeStr", required = false, defaultValue = "") String typeStr,
                                @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                                Model model) {
        cri.setTypeStr(typeStr);
        cri.setKeyword(keyword);

        List<WarehouseDTO> list = warehouseService.getList(cri);
        PageDTO pageDTO = new PageDTO(cri, warehouseService.getTotal(cri));

        model.addAttribute("pageMaker", pageDTO);
        model.addAttribute("warehouses", list);
        model.addAttribute("selectedTypeStr", typeStr);  // (선택 유지용)
        model.addAttribute("selectedKeyword", keyword);  // (선택 유지용)

        return "warehouse/list";
    }

    // 상세 조회 페이지
    // 요청 : /warehouses/{id}
    // /WEB-INF/views/warehouse/detail.jsp
    @GetMapping("/{id}")
    public String getWarehouse(@PathVariable Long id, Model model) {
        WarehouseDTO warehouseDTO = warehouseService.getWarehouse(id);
        model.addAttribute("warehouse", warehouseDTO);
        return "warehouse/detail";
    }

    // 창고 수정 폼 페이지
    // 요청 : /warehouse/{id}/update
    // /WEB-INF/views/warehouse/updateForm
    @GetMapping("/{id}/update")
    public String updateWarehouseForm(@PathVariable Long id, Model model) {
        WarehouseDTO warehouseDTO = warehouseService.getWarehouse(id);
        model.addAttribute("id", warehouseDTO.getWIndex());
        model.addAttribute("warehouse", warehouseDTO);

        return "/warehouse/updateForm";
    }

    // 창고 등록 폼 페이지
    // 요청 : /warehouse/register
    // /WEB-INF/views/warehouse/register
    @GetMapping("/register")
    public String registerWarehouseForm(Model model) {
        WarehouseSaveDTO warehouseSaveDTO = new WarehouseSaveDTO();
        model.addAttribute("warehouse", warehouseSaveDTO);
        return "/warehouse/registerForm";
    }
}
