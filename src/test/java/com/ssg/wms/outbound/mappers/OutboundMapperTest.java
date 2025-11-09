package com.ssg.wms.outbound.mappers;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.*;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
@Transactional
@Sql("classpath:sql/test-data.sql")
public class OutboundMapperTest {

    @Autowired(required = false)
    private OutboundMapper outboundMapper;

    @Test
    public void testMapperExists() {
        log.info("OutboundMapper 주입 확인: " + outboundMapper);
    }

    // ======== 1. OutboundRequest 테스트 ========

    @Test
    public void testSelectOutbountRequestList() {
        List<OutboundRequestDTO> list = outboundMapper.selectOutbountRequestList(new Criteria(), new OutboundSearchDTO());
        log.info("===== 출고 요청 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("=========================");
    }

    @Test
    public void testSelectOutboundRequestTotalCount() {
        int total = outboundMapper.selectOutboundRequestTotalCount(new OutboundSearchDTO());
        log.info("출고 요청 전체 개수: " + total);
    }

    @Test
    public void testInsertOutboundRequest() {
        OutboundRequestDTO dto = OutboundRequestDTO.builder()
                .user_index(1L).item_index(1L).or_quantity(1)
                .or_name("새요청").or_phone("111").or_zip_code("11")
                .or_street_address("11").or_detailed_address("11").build();
        outboundMapper.insertOutboundRequest(dto);
        log.info("등록된 DTO (PK 확인): " + dto);
    }

    @Test
    public void testSelectOutboundRequest() {
        OutboundRequestDTO dto = outboundMapper.selectOutboundRequest(1L);
        log.info("1번 출고 요청: " + dto);
    }

    @Test
    public void testUpdateOutboundRequest() {
        OutboundRequestDTO dto = outboundMapper.selectOutboundRequest(1L);
        dto.setOr_name("이름수정");
        outboundMapper.updateOutboundRequest(dto);

        OutboundRequestDTO updatedDto = outboundMapper.selectOutboundRequest(1L);
        log.info("수정된 DTO: " + updatedDto);
    }

    @Test
    public void testDeleteOutboundRequest() {
        outboundMapper.deleteOutboundRequest(1L);
        OutboundRequestDTO dto = outboundMapper.selectOutboundRequest(1L);
        log.info("삭제 후 조회: " + dto);
    }

    @Test
    public void testUpdateOutboundResponse() {
        OutboundRequestDTO dto = OutboundRequestDTO.builder()
                .or_index(4L) // 4번은 PENDING 상태
                .or_approval(EnumStatus.APPROVED)
                .reject_detail(null)
                .build();
        outboundMapper.updateOutboundResponse(dto);

        OutboundRequestDTO updatedDto = outboundMapper.selectOutboundRequest(4L);
        log.info("승인 처리된 DTO: " + updatedDto);
    }

    // ======== 2. ShippingInstruction 테스트 ========

    @Test
    public void testSelectShippingInstructionList() {
        List<ShippingInstructionDTO> list = outboundMapper.selectShippingInstructionList(new Criteria(), new OutboundSearchDTO());
        log.info("===== 출고 지시서 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("==========================");
    }

    @Test
    public void testSelectShippingInstructionTotalCount() {
        int total = outboundMapper.selectShippingInstructionTotalCount(new OutboundSearchDTO());
        log.info("출고 지시서 전체 개수: " + total);
    }

    @Test
    public void testSelectShippingInstruction() {
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        log.info("1번 출고 지시서: " + dto);
    }

    @Test
    public void testInsertShippingInstruction() {
        ShippingInstructionDTO dto = ShippingInstructionDTO.builder()
                .dispatch_index(1L).admin_index(1L)
                .warehouse_index(1L).section_index(1L).build();
        outboundMapper.insertShippingInstruction(dto);
        log.info("등록된 SI DTO (PK 확인): " + dto);
    }

    @Test
    public void testUpdateShippingInstruction() {
        // OutboundMapper.xml에 이 쿼리가 있는지 확인하세요.
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        dto.setSi_waybill_status(EnumStatus.PENDING); // APPROVED -> PENDING
        outboundMapper.updateShippingInstruction(dto);

        ShippingInstructionDTO updatedDto = outboundMapper.selectShippingInstruction(1L);
        log.info("수정된 SI DTO: " + updatedDto);
    }

    @Test
    public void testDeleteShippingInstruction() {
        outboundMapper.deleteShippingInstruction(1L);
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        log.info("삭제 후 조회: " + dto);
    }


    // ======== 3. 배차 (Dispatch & Vehicle) 로직 테스트 ========

    @Test
    public void testSelectVehicleList() {
        // test-data.sql 기준
        // or_index=1 (item(1) 20개, 필요용량 200 (20*10), 위치 '12')
        // 1호차: 위치 '12', PENDING, 용량 500, 현재사용 100 (or_index=2)
        //       - 남은 용량 400 (>= 200) -> OK
        // 2호차: 위치 '12', PENDING, 용량 50, 현재사용 0
        //       - 남은 용량 50 (< 200) -> Fail

        List<VehicleDTO> list = outboundMapper.selectVehicleList(1L);
        log.info("===== or_index=1 배차 가능 차량 목록 (1호차만 나와야 함) =====");
        list.forEach(dto -> log.info(dto));
        log.info("======================================================");

        // test-data.sql 기준
        // or_index=4 (item(2) 5개, 필요용량 25 (5*5), 위치 '31')
        // 3호차: 위치 '31', PENDING, 용량 500, 현재사용 0
        //       - 남은 용량 500 (>= 25) -> OK
        List<VehicleDTO> list2 = outboundMapper.selectVehicleList(4L);
        log.info("===== or_index=4 배차 가능 차량 목록 (3호차만 나와야 함) =====");
        list2.forEach(dto -> log.info(dto));
        log.info("======================================================");
    }

    @Test
    public void testSelectUsedVolumeOfVehicle() {
        // 1호차: or_index=2 (용량 100) 배송 중
        int usedVolume = outboundMapper.selectUsedVolumeOfVehicle(1L);
        log.info("1호차 사용중 용량 (배송중): " + usedVolume);

        // 4호차: or_index=3 (용량 300) 배송 완료
        int completedVolume = outboundMapper.selectUsedVolumeOfVehicle(4L);
        log.info("4호차 사용중 용량 (배송완료): " + completedVolume);
    }

    @Test
    public void testInsertDispatch() {
        DispatchDTO dto = DispatchDTO.builder()
                .vehicle_index(1L).or_index(4L) // 4번 요청
                .start_point("출발").end_point("도착").build();
        outboundMapper.insertDispatch(dto);
        log.info("등록된 배차 (PK 확인): " + dto);
    }

    @Test
    public void testSelectDispatch() {
        // or_index=2에 연결된 배차
        DispatchDTO dto = outboundMapper.selectDispatch(2L);
        log.info("or_index=2 배차 조회: " + dto);
    }

    @Test
    public void testUpdateDispatch() {
        DispatchDTO dto = outboundMapper.selectDispatch(2L);
        dto.setVehicle_index(2L); // 1호차 -> 2호차로 변경
        outboundMapper.updateDispatch(dto);

        DispatchDTO updatedDto = outboundMapper.selectDispatch(2L);
        log.info("수정된 배차: " + updatedDto);
    }

    @Test
    public void testDeleteDispatch() {
        outboundMapper.deleteDispatch(1L); // dispatch_index=1
        DispatchDTO dto = outboundMapper.selectDispatch(2L); // or_index=2
        log.info("삭제 후 조회: " + dto);
    }

    @Test
    public void testInsertVehicle() {
        VehicleDTO dto = VehicleDTO.builder()
                .vehicle_name("테스트차량").vehicle_id("99가9999")
                .vehicle_volume(1000).driver_name("테스트기사")
                .driver_phone("010-9999-9999").build();
        outboundMapper.insertVehicle(dto);
        log.info("등록된 차량 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateVehicle() {
        VehicleDTO dto = VehicleDTO.builder()
                .vehicle_index(1L)
                .vehicle_status(EnumStatus.WORKING)
                .build();
        outboundMapper.updateVehicle(dto);
        log.info("1번 차량 상태 WORKING으로 변경");
    }

    @Test
    public void testDeleteVehicle() {
        outboundMapper.deleteVehicle(1L);
        log.info("1번 차량 삭제 (Soft Delete)");
    }

    @Test
    public void testInsertVehicleLocation() {
        VehicleLocationDTO dto = VehicleLocationDTO.builder()
                .vehicle_index(3L).vl_zip_code("55").build();
        outboundMapper.insertVehicleLocation(dto);
        log.info("등록된 차량 위치 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateVehicleLocation() {
        VehicleLocationDTO dto = VehicleLocationDTO.builder()
                .vl_index(1L) // 1번 차량(Vehicle 1)의 위치(vl_index 1)
                .vehicle_index(1L)
                .vl_zip_code("88")
                .build();
        outboundMapper.updateVehicleLocation(dto);
        log.info("1번 차량 위치 '88'로 수정");
    }

    @Test
    public void testDeleteVehicleLocation() {
        outboundMapper.deleteVehicleLocation(1L);
        log.info("1번 차량 위치(vl_index 1) 삭제 (Soft Delete)");
    }


    // ======== 4. 운송장 (Waybill) 테스트 ========

    @Test
    public void testInsertWaybill() {
        WaybillDTO dto = WaybillDTO.builder()
                .si_index(2L) // 2번 SI
                .waybill_id("TEST-WAYBILL-123")
                .build();
        outboundMapper.insertWaybill(dto);
        log.info("등록된 운송장 (PK 확인): " + dto);
    }

    @Test
    public void testSelectWaybill() {
        // si_index=1
        WaybillDTO dto = outboundMapper.selectWaybill(1L);
        log.info("si_index=1 운송장: " + dto);
    }

    @Test
    public void testUpdateWaybill() {
        WaybillDTO dto = outboundMapper.selectWaybill(1L); // 1번 (IN_TRANSIT)
        log.info("수정 전 운송장: " + dto);

        outboundMapper.updateWaybill(dto); // 완료 처리

        WaybillDTO updatedDto = outboundMapper.selectWaybill(1L);
        log.info("배송 완료 처리된 운송장: " + updatedDto);
    }
}