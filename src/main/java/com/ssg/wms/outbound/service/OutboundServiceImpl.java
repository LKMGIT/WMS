package com.ssg.wms.outbound.service;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inventory.domain.InvenDTO;
import com.ssg.wms.inventory.service.InvenService;
import com.ssg.wms.outbound.domain.*;
import com.ssg.wms.outbound.exception.OutboundValidationException;
import com.ssg.wms.outbound.mappers.OutboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Log4j2
@Service
@RequiredArgsConstructor // final 필드 생성자 주입
public class OutboundServiceImpl implements OutboundService {

    private final OutboundMapper outboundMapper;
    private final InvenService invenService;
    private static final int VEHICLE_VOLUME_THRESHOLD = 75;

    // 운송장 등록되면 출고 요청 수정/삭제 못하게 예외 던짐
    private void validateWaybillNotExists(Long or_index) throws OutboundValidationException {
        int count = outboundMapper.checkWaybillExistsByOrIndex(or_index);
        if (count > 0) {
            throw new OutboundValidationException("이미 운송장이 등록된 요청은 수정/삭제할 수 없습니다.");
        }
    }

    // 출고 요청 등록 (재고 유효성 검사 포함)
    @Override
    @Transactional
    public boolean registerOutboundRequest(OutboundRequestDTO requestDTO) throws OutboundValidationException {

        //  수취인 우편번호 -> 담당 창고 위치(소재지) 변환
        String zip_prefix = requestDTO.getOr_zip_code().substring(0, 2);
        String requiredLocation = getWarehouseLocationFromZip(zip_prefix);
        if (requiredLocation == null) {
            throw new OutboundValidationException("'" + zip_prefix + "' 우편번호는 배송 불가 지역입니다.");
        }

        // 2. 재고 유효성 검사 ('지역' 재고 확인)
        InvenDTO regionalStock = outboundMapper.selectStockByLocation(
                requestDTO.getUser_index(),
                requestDTO.getItem_index(),
                requiredLocation
        );
        // 재고가 없으면
        if (regionalStock == null) {
            throw new OutboundValidationException("담당 창고('" + requiredLocation + "')에 해당 아이템의 재고가 없습니다.");
        }
        // 재고가 부족하면
    if (regionalStock.getInvenQuantity() < requestDTO.getOr_quantity()) {
            String errorMsg = String.format(
                    "재고가 부족합니다. (요청 수량: %d, 현재 '" + requiredLocation + "' 창고 재고: %d)",
                    requestDTO.getOr_quantity(),
                    regionalStock.getInvenQuantity()
            );
            throw new OutboundValidationException(errorMsg);
        }
        // 문제 없으면 출고 요청 등록
        return outboundMapper.insertOutboundRequest(requestDTO) > 0;
    }

    // 수취인의 우편번호 앞 2자리를 받아, 담당 창고 위치를 반환
    private String getWarehouseLocationFromZip(String zip_prefix) {
        int zip = Integer.parseInt(zip_prefix);
        if (zip >= 1 && zip <= 9) {
            return "서울";
        } else if (zip >= 10 && zip <= 18) {
            // return "경기";
            return "수도권"; //테스트 위해서
        } else if (zip >= 31 && zip <= 33) {
            return "충남";
        } else {
            return null; // 배송 불가 지역
        }
    }

    @Override
    @Transactional
    public boolean modifyOutboundRequest(OutboundRequestDTO requestDTO) {
        OutboundRequestDTO originalRequest = outboundMapper.selectOutboundRequest(requestDTO.getOr_index());
        // 배차가 승인되어 있으면
        if (originalRequest.getOr_dispatch_status() == EnumStatus.APPROVED) {
            // 배차 정보 조회
            DispatchDTO dispatch = outboundMapper.selectDispatch(originalRequest.getOr_index());
            // 출고지시서(SI) 및 운송장(Waybill) 존재 여부 확인
            ShippingInstructionDTO si = outboundMapper.selectShippingInstructionByDispatchIndex(dispatch.getDispatch_index());
            if (si != null) {
                WaybillDTO waybill = outboundMapper.selectWaybill(si.getSi_index());
                if (waybill != null) {
                    // 운송장이 있으면 수정 불가
                    throw new OutboundValidationException("이미 운송장이 등록된 요청은 수정할 수 없습니다.");
                }
                // (운송장이 없으므로) 출고지시서(SI) 삭제
                outboundMapper.deleteShippingInstruction(si.getSi_index());
            }
            // 배차(Dispatch) 삭제
            outboundMapper.deleteDispatch(dispatch.getDispatch_index());

            // DTO의 배차/승인 상태를 'PENDING'으로 리셋
            requestDTO.setOr_dispatch_status(EnumStatus.PENDING);
            requestDTO.setOr_approval(EnumStatus.PENDING);
            requestDTO.setResponded_at(null);
            requestDTO.setReject_detail(null);
        }
        //  수취인 우편번호 -> 담당 창고 위치(소재지) 변환
        String zip_prefix = requestDTO.getOr_zip_code().substring(0, 2);
        String requiredLocation = getWarehouseLocationFromZip(zip_prefix);
        if (requiredLocation == null) {
            throw new OutboundValidationException("'" + zip_prefix + "' 우편번호는 배송 불가 지역입니다.");
        }

        // 2. 재고 유효성 검사 ('지역' 재고 확인)
        InvenDTO regionalStock = outboundMapper.selectStockByLocation(
                requestDTO.getUser_index(),
                requestDTO.getItem_index(),
                requiredLocation
        );
        // 재고가 없으면
        if (regionalStock == null) {
            throw new OutboundValidationException("담당 창고('" + requiredLocation + "')에 해당 아이템의 재고가 없습니다.");
        }
        // 재고가 부족하면
        if (regionalStock.getInvenQuantity() < requestDTO.getOr_quantity()) {
            String errorMsg = String.format(
                    "재고가 부족합니다. (요청 수량: %d, 현재 '" + requiredLocation + "' 창고 재고: %d)",
                    requestDTO.getOr_quantity(),
                    regionalStock.getInvenQuantity()
            );
            throw new OutboundValidationException(errorMsg);
        }
        // 출고 요청 정보 수정 실행
        return outboundMapper.updateOutboundRequest(requestDTO) > 0;
    }

    @Override
    @Transactional
    public boolean removeOutboundRequest(Long or_index) {
        OutboundRequestDTO originalRequest = outboundMapper.selectOutboundRequest(or_index);
        // 배차 상태 확인
        if (originalRequest.getOr_dispatch_status() == EnumStatus.APPROVED) {
            DispatchDTO dispatch = outboundMapper.selectDispatch(originalRequest.getOr_index());
            // 운송장 존재 여부 확인
            ShippingInstructionDTO si = outboundMapper.selectShippingInstructionByDispatchIndex(dispatch.getDispatch_index());
            if (si != null) {
                WaybillDTO waybill = outboundMapper.selectWaybill(si.getSi_index());
                if (waybill != null) {
                    // 운송장이 있으면 삭제 불가
                    throw new OutboundValidationException("이미 운송장이 등록된 요청은 삭제할 수 없습니다.");
                }
                outboundMapper.deleteShippingInstruction(si.getSi_index());
            }
            // 배차(Dispatch) 삭제
            outboundMapper.deleteDispatch(dispatch.getDispatch_index());
        }
        // 출고 요청 삭제 실행 (Soft Delete)
        return outboundMapper.deleteOutboundRequest(or_index) > 0;
    }

    @Override
    @Transactional
    public OutboundRequestDTO getOutboundRequestById(Long or_index) {
        return outboundMapper.selectOutboundRequest(or_index);
    }

    @Override
    @Transactional
    public OutboundRequestDetailDTO getOutboundRequestDetailById(OutboundSearchDTO outboundSearchDTO, Long or_index) {
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(or_index);
        Long previous = getORPreviousPostIndex(outboundSearchDTO, or_index);
        Long next = getORNextPostIndex(outboundSearchDTO, or_index);
        String item_name = outboundMapper.selectItemName(request.getItem_index());

        return OutboundRequestDetailDTO.builder()
                .or_index(or_index)
                .user_index(request.getUser_index())
                .item_index(request.getItem_index())
                .item_name(item_name)
                .or_quantity(request.getOr_quantity())
                .or_name(request.getOr_name())
                .or_phone(request.getOr_phone())
                .or_zip_code(request.getOr_zip_code())
                .or_street_address(request.getOr_street_address())
                .or_detailed_address(request.getOr_detailed_address())
                .or_approval(request.getOr_approval())
                .created_at(request.getCreated_at())
                .updated_at(request.getUpdated_at())
                .status(request.getStatus())
                .or_dispatch_status(request.getOr_dispatch_status())
                .responded_at(request.getResponded_at())
                .reject_detail(request.getReject_detail())
                .previousPostIndex(previous)
                .nextPostIndex(next)
                .build();
    }

    // 출고 요청 리스트 (페이징 + 검색)
    @Override
    @Transactional
    public List<OutboundRequestDTO> getOutboundRequestList(Criteria criteria, OutboundSearchDTO outboundSearchDTO) {
        return outboundMapper.selectOutboundRequestList(criteria, outboundSearchDTO);
    }

    // 출고 요청 리스트 검색된 충 개수
    @Override
    @Transactional
    public int getOutboundRequestTotalCount(OutboundSearchDTO outboundSearchDTO){
        return outboundMapper.selectOutboundRequestTotalCount(outboundSearchDTO);
    }


    // 배차 가능한 차량 리스트 조회
    @Override
    @Transactional
    public List<AvailableDispatchDTO> getAvailableDispatch(Long or_index) {
        return outboundMapper.selectVehicleList(or_index).stream().map(vehicle -> {
            int vehicle_volume = vehicle.getVehicle_volume() - outboundMapper.selectUsedVolumeOfVehicle(vehicle.getVehicle_index());
            return AvailableDispatchDTO.builder()
                    .driver_name(vehicle.getDriver_name())
                    .vehicle_index(vehicle.getVehicle_index())
                    .vehicle_id(vehicle.getVehicle_id())
                    .vehicle_type(vehicle.getVehicle_volume()>=VEHICLE_VOLUME_THRESHOLD?"대형":"중형")
                    .vehicle_volume(vehicle_volume)
                    .build();
        }).collect(Collectors.toList());
    }

    // 배차 등록 (관리자용: 차량 연결)
    @Override
    @Transactional
    public boolean registerDispatch(DispatchDTO dispatchDTO) throws OutboundValidationException {

        // 출고 요청 정보 조회
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatchDTO.getOr_index());
        // 배차 시점에는 '출고 승인'이 PENDING 상태여야 함
        if (request.getOr_approval() == EnumStatus.APPROVED) {
            throw new OutboundValidationException("이미 출고 승인된 요청은 배차할 수 없습니다.");
        }

        //  수취인 우편번호 -> 담당 창고 위치(소재지) 변환
        String zip_prefix = request.getOr_zip_code().substring(0, 2);
        String requiredLocation = getWarehouseLocationFromZip(zip_prefix);
        InvenDTO regionalStock = outboundMapper.selectStockByLocation(
                request.getUser_index(),
                request.getItem_index(),
                requiredLocation
        );
        log.info(regionalStock);
        if (regionalStock == null || regionalStock.getWarehouseIndex() == null) {
            throw new OutboundValidationException("해당 지역(" + requiredLocation + ")에 출고 가능한 유효 재고 위치를 찾을 수 없습니다. (재고 부족/소유권/입고상태 문제)");
        }
        Long warehouse_index = regionalStock.getWarehouseIndex();

        // 출발지/도착지 확정
        String warehouse_address = outboundMapper.selectWarehouseAddress(warehouse_index);
        dispatchDTO.setStart_point(warehouse_address);
        dispatchDTO.setEnd_point(request.getOr_street_address() + " " + request.getOr_detailed_address());

        // 배차 정보 INSERT (start/end 포함)
        boolean result = outboundMapper.insertDispatch(dispatchDTO) > 0;

        if (!result) {
            return false;
        } else {
            // 출고 요청의 배차 상태(or_dispatch_status) 'APPROVED'로 변경
            request.setOr_dispatch_status(EnumStatus.APPROVED);
            request.setResponded_at(LocalDateTime.now());
            outboundMapper.updateOutboundResponse(request);
            return true;
        }
    }

    // 배차 수정
    @Override
    @Transactional
    public boolean modifyDispatch(DispatchDTO dispatchDTO) {
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatchDTO.getOr_index());
        if (request.getOr_approval() == EnumStatus.APPROVED) {
            throw new OutboundValidationException("이미 출고 승인된 배차는 취소할 수 없습니다.");
        }

        boolean result = outboundMapper.updateDispatch(dispatchDTO) > 0;

        if (!result) {
            return false;
        } else {
            // 출고 요청의 배차 상태(or_dispatch_status) 'APPROVED'로 변경
            request.setOr_dispatch_status(EnumStatus.APPROVED);
            request.setResponded_at(LocalDateTime.now());
            outboundMapper.updateOutboundResponse(request);
            return true;
        }
    }

    // 배차 취소
    @Override
    @Transactional
    public boolean removeDispatch(Long dispatch_index) {
        DispatchDTO dispatch = outboundMapper.selectDispatchByIndex(dispatch_index);
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatch.getOr_index());
        if (request.getOr_approval() == EnumStatus.APPROVED) {
            throw new OutboundValidationException("이미 출고 승인된 배차는 취소할 수 없습니다.");
        }

        boolean result = outboundMapper.deleteDispatch(dispatch_index) > 0;

        if (!result) {
            return false;
        } else {
            request.setOr_dispatch_status(EnumStatus.PENDING);
            outboundMapper.updateOutboundResponse(request);
            return true;
        }
    }

    // 배차 상세 조회
    @Override
    @Transactional
    public DispatchDetailDTO getDispatchById(Long or_index) {
        DispatchDTO dispatch = outboundMapper.selectDispatch(or_index);
        if (dispatch == null) return null;
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(or_index);
        VehicleDTO vehicle = outboundMapper.selectVehicle(dispatch.getVehicle_index());

        return DispatchDetailDTO.builder()
                .dispatch_index(dispatch.getDispatch_index())
                .dispatch_date(dispatch.getDispatch_date())
                .or_index(request.getOr_index())
                .vehicle_index(vehicle.getVehicle_index())
                .vehicle_id(vehicle.getVehicle_id())
                .driver_name(vehicle.getDriver_name())
                .vehicle_type(vehicle.getVehicle_volume()>=VEHICLE_VOLUME_THRESHOLD?"대형":"중형")
                .start_point(dispatch.getStart_point())
                .end_point(dispatch.getEnd_point())
                .build();
    }

    @Override
    @Transactional
    public DispatchDTO getDispatchByIndex(Long dispatch_index) {
        return outboundMapper.selectDispatchByIndex(dispatch_index);
    }


    // 출고 요청 승인 (관리자용: 출고지시서 자동 생성)
    @Override
    @Transactional
    public boolean approveOutboundRequest(OutboundResponseRegisterDTO outboundResponseRegisterDTO) throws OutboundValidationException {
        // 출고 요청 정보 조회
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(outboundResponseRegisterDTO.getOr_index());
        // 배차가 되었는지(APPROVED) 확인
        if (request.getOr_dispatch_status() != EnumStatus.APPROVED) {
            throw new OutboundValidationException("배차가 먼저 완료되어야 합니다.");
        }
        // 이미 승인되었는지 확인
        if (request.getOr_approval() == EnumStatus.APPROVED) {
            throw new OutboundValidationException("이미 출고 승인된 요청입니다.");
        }

        // 출고 요청 상태 'APPROVED'로 변경
        request.setOr_approval(EnumStatus.APPROVED);
        boolean result = outboundMapper.updateOutboundResponse(request) > 0;
        if(result){
            DispatchDTO dispatch = outboundMapper.selectDispatch(outboundResponseRegisterDTO.getOr_index());
            String zip_prefix = request.getOr_zip_code().substring(0, 2);
            String requiredLocation = getWarehouseLocationFromZip(zip_prefix);
            InvenDTO stockLocation = outboundMapper.selectStockByLocation(
                    request.getUser_index(),
                    request.getItem_index(),
                    requiredLocation
            );

            // 출고 지시서(ShippingInstruction) 자동 생성
            ShippingInstructionDTO si = ShippingInstructionDTO.builder()
                    .dispatch_index(dispatch.getDispatch_index())
                    .admin_index(outboundResponseRegisterDTO.getAdmin_index()) // 승인한 관리자
                    .warehouse_index(stockLocation.getWarehouseIndex())
                    .section_index(stockLocation.getSectionIndex())
                    .build();

            outboundMapper.insertShippingInstruction(si);

            ShippingInstructionDetailDTO sidDTO = ShippingInstructionDetailDTO.builder()
                    .si_index(si.getSi_index())
                    .or_index(dispatch.getOr_index())
                    .warehouse_index(si.getWarehouse_index())
                    .section_index(si.getSection_index())
                    .item_index(request.getItem_index())
                    .user_index(request.getUser_index())
                    .item_name(outboundMapper.selectItemName(request.getItem_index()))
                    .or_quantity(request.getOr_quantity())
                    .si_waybill_status(si.getSi_waybill_status())
                    .approved_at(si.getApproved_at())
                    .build();

            invenService.applyOutbound(sidDTO);
        }
        return result;
    }

    /**
     * (프로세스 변경)
     * 출고 요청 반려 (관리자용)
     */
    @Override
    @Transactional
    public boolean rejectOutboundRequest(OutboundResponseRegisterDTO outboundResponseRegisterDTO) {
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(outboundResponseRegisterDTO.getOr_index());
        if (request.getOr_approval() != EnumStatus.PENDING) {
            throw new OutboundValidationException("이미 처리(승인/반려)된 요청입니다.");
        }

        request.setOr_approval(outboundResponseRegisterDTO.getOr_approval());
        request.setReject_detail(outboundResponseRegisterDTO.getReject_detail());
        return outboundMapper.updateOutboundResponse(request) > 0;
    }

    // 출고 지시서 리스트 (페이징 + 검색)
    @Override
    @Transactional
    public List<ShippingInstructionDetailDTO> getShippingInstructionList(Criteria criteria, OutboundSearchDTO outboundSearchDTO) {
        List<ShippingInstructionDetailDTO> shippingInstructionDetailDTOList = outboundMapper.selectShippingInstructionList(criteria, outboundSearchDTO).stream().map(shippingInstructionDTO -> {
            DispatchDTO dispatchDTO = outboundMapper.selectDispatchByIndex(shippingInstructionDTO.getDispatch_index());
            OutboundRequestDTO outboundRequestDTO = outboundMapper.selectOutboundRequest(dispatchDTO.getOr_index());
            return ShippingInstructionDetailDTO.builder()
                    .si_index(shippingInstructionDTO.getSi_index())
                    .warehouse_index(shippingInstructionDTO.getWarehouse_index())
                    .section_index(shippingInstructionDTO.getSection_index())
                    .item_index(outboundRequestDTO.getItem_index())
                    .item_name(outboundMapper.selectItemName(outboundRequestDTO.getItem_index()))
                    .user_index(outboundRequestDTO.getUser_index())
                    .or_quantity(outboundRequestDTO.getOr_quantity())
                    .si_waybill_status(shippingInstructionDTO.getSi_waybill_status())
                    .approved_at(shippingInstructionDTO.getApproved_at())
                    .build();
        }).collect(Collectors.toList());
        return shippingInstructionDetailDTOList;
    }

    // 출고 지시서 검색된 총 개수
    @Override
    @Transactional
    public int getShippingInstructionTotalCount(OutboundSearchDTO outboundSearchDTO){
        return outboundMapper.selectShippingInstructionTotalCount(outboundSearchDTO);
    }

    @Override
    @Transactional
    public ShippingInstructionDTO getShippingInstructionById(Long si_index) {
        return outboundMapper.selectShippingInstruction(si_index);
    }

    // 출고 지시서 상세 조회 (DTO 조합)
    @Override
    @Transactional
    public ShippingInstructionDetailDTO getShippingInstructionDetailById(OutboundSearchDTO outboundSearchDTO, Long si_index) {
        ShippingInstructionDTO si = outboundMapper.selectShippingInstruction(si_index);
        DispatchDTO dispatch = outboundMapper.selectDispatchByIndex(si.getDispatch_index());
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatch.getOr_index());
        Long previous = getSIPreviousPostIndex(outboundSearchDTO, si_index);
        Long next = getSINextPostIndex(outboundSearchDTO, si_index);

        return ShippingInstructionDetailDTO.builder()
                .si_index(si.getSi_index())
                .or_index(dispatch.getOr_index())
                .warehouse_index(si.getWarehouse_index())
                .section_index(si.getSection_index())
                .item_index(request.getItem_index())
                .user_index(request.getUser_index())
                .item_name(outboundMapper.selectItemName(request.getItem_index()))
                .or_quantity(request.getOr_quantity())
                .si_waybill_status(si.getSi_waybill_status())
                .approved_at(si.getApproved_at())
                .previousPostIndex(previous)
                .nextPostIndex(next)
                .build();
    }

//    @Override
//    @Transactional
//    public boolean removeShippingInstruction(Long si_index) {
//        ShippingInstructionDTO si = outboundMapper.selectShippingInstruction(si_index);
//        if(si.getSi_waybill_status() == EnumStatus.APPROVED) {
//            throw new OutboundValidationException("이미 운송장이 등록된 요청은 삭제할 수 없습니다.");
//        }
//        // 먼저 배차 정보 가져오고 출고지시서 지우기
//        DispatchDTO dispatch = outboundMapper.selectDispatch(si_index);
//        boolean result = outboundMapper.deleteShippingInstruction(si_index) > 0;
//
//        if(result) {
//            //출고요청 정보 가져오고 출고 요청 승인 상태 변경
//            OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatch.getOr_index());
//            request.setOr_approval(EnumStatus.PENDING);
//            request.setOr_dispatch_status(EnumStatus.PENDING);
//            removeDispatch(dispatch.getDispatch_index());
//            outboundMapper.updateOutboundRequest(request);
//        }
//        return result;
//    }


    // 운송장 등록 (운송장 번호 생성 및 트랜잭션)
    @Override
    @Transactional
    public boolean registerWaybill(Long si_index) {
        ShippingInstructionDTO si = outboundMapper.selectShippingInstruction(si_index);
        if (si.getSi_waybill_status() == EnumStatus.APPROVED) {
            throw new OutboundValidationException("이미 운송장이 등록된 출고지시서입니다.");
        }

        String newWaybillId = generateWaybillId(si_index);

        WaybillDTO waybillDTO = WaybillDTO.builder()
                .si_index(si_index)
                .waybill_id(newWaybillId)
                .build();

        boolean result = outboundMapper.insertWaybill(waybillDTO) > 0;


        if(result) {
            si.setSi_waybill_status(EnumStatus.APPROVED);
            outboundMapper.updateShippingInstruction(si);
        }
        return result;
    }

    // 운송장 상세 조회 (DTO 조합)
    @Override
    @Transactional
    public WaybillDetailDTO getWaybillDetail(Long si_index) {
        WaybillDTO waybill = outboundMapper.selectWaybill(si_index);
        if (waybill == null) return null;

        ShippingInstructionDTO si = outboundMapper.selectShippingInstruction(si_index);
        if (si == null) return null;

        DispatchDTO dispatch = outboundMapper.selectDispatchByIndex(si.getDispatch_index());
        if (dispatch == null) return null;

        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(dispatch.getOr_index());

        VehicleDTO vehicle = outboundMapper.selectVehicle(dispatch.getVehicle_index());

        return WaybillDetailDTO.builder()
                .waybill_index(waybill.getWaybill_index())
                .waybill_id(waybill.getWaybill_id())
                .user_index(request.getUser_index())
                .warehouse_index(si.getWarehouse_index())
                .warehouse_zip_code(outboundMapper.selectWarehouseZipCode(si.getWarehouse_index()))
                .warehouse_address(dispatch.getStart_point())
                .or_zip_code(request.getOr_zip_code())
                .or_street_address(request.getOr_street_address())
                .or_detailed_address(request.getOr_detailed_address())
                .item_index(request.getItem_index())
                .or_quantity(request.getOr_quantity())
                .item_name(outboundMapper.selectItemName(request.getItem_index()))
                .vehicle_index(dispatch.getVehicle_index())
                .vehicle_id(vehicle.getVehicle_id())
                .vehicle_type(vehicle.getVehicle_volume()>=VEHICLE_VOLUME_THRESHOLD?"대형":"중형")
                .driver_name(vehicle.getDriver_name())
                .driver_phone(vehicle.getDriver_phone())
                .created_at(waybill.getCreated_at())
                .completed_at(waybill.getCompleted_at())
                .waybill_status(waybill.getWaybill_status())
                .build();
    }

    // 운송장 번호 생성 메서드
    private String generateWaybillId(Long si_index) {
        final String COMPANY_CODE = "07";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
        String datePart = dateFormat.format(new Date());
        String idPart = String.format("%06d", si_index);
        return COMPANY_CODE + datePart + idPart;
    }

    private Long getORPreviousPostIndex(OutboundSearchDTO searchDTO, Long current_index) {
        return outboundMapper.getORPreviousPostIndex(searchDTO, current_index);
    }

    private Long getORNextPostIndex(OutboundSearchDTO searchDTO, Long current_index) {
        return outboundMapper.getORNextPostIndex(searchDTO, current_index);
    }

    private Long getSIPreviousPostIndex(OutboundSearchDTO searchDTO, Long current_index) {
        return outboundMapper.getSIPreviousPostIndex(searchDTO, current_index);
    }

    private Long getSINextPostIndex(OutboundSearchDTO searchDTO, Long current_index) {
        return outboundMapper.getSINextPostIndex(searchDTO, current_index);
    }
}
