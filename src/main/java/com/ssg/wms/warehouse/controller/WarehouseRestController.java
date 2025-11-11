package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.domain.WarehouseUpdateDTO;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/api/warehouse")
public class WarehouseRestController {
    private final WarehouseService warehouseService;

    // 창고 등록
    @PostMapping(produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> registerWarehouse(@RequestBody WarehouseSaveDTO warehouseSaveDTO) {
        log.info("warehouseSaveDTO : " + warehouseSaveDTO);
        boolean result = warehouseService.registerWarehouse(warehouseSaveDTO);
        return result ? ResponseEntity.ok("창고 등록 완료")
                : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 등록 실패");
    }

    // 창고 수정
    @PutMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> updateWarehouse(@PathVariable Long id, @RequestBody WarehouseUpdateDTO warehouseUpdateDTO) {
        warehouseUpdateDTO.setWIndex(id);
        boolean result = warehouseService.modifyWarehouse(warehouseUpdateDTO);
        return result ? ResponseEntity.ok("창고 수정 완료")
                : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 수정 실패");
    }

    // 창고 삭제(논리적 폐쇄)
    @DeleteMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> deleteWarehouse(@PathVariable Long id) {
        boolean result = warehouseService.removeWarehouse(id);
        return result ? ResponseEntity.ok("창고 폐쇄 완료")
                      : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 폐쇄 실패");
    }
}
