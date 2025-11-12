package com.ssg.wms.outbound.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.*; // 필요한 모든 DTO 임포트

import java.util.List;

public interface OutboundService {

    /**
     * 출고 요청 등록 (재고 유효성 검사 포함)
     */
    boolean registerOutboundRequest(OutboundRequestDTO requestDTO);

    /**
     * 출고 요청 수정 (재고 유효성 검사 및 관련 배차/SI 처리 포함)
     */
    boolean modifyOutboundRequest(OutboundRequestDTO requestDTO);

    /**
     * 출고 요청 삭제 (관련 배차/SI 처리 포함)
     */
    boolean removeOutboundRequest(Long or_index);

    /**
     * 출고 요청 단건 조회 (CUD 재조회용)
     */
    OutboundRequestDTO getOutboundRequestById(Long or_index);

    /**
     * 출고 요청 상세 조회 (이전/다음 글 ID 포함)
     */
    OutboundRequestDetailDTO getOutboundRequestDetailById(OutboundSearchDTO outboundSearchDTO, Long or_index);

    /**
     * 출고 요청 리스트 (페이징 + 검색)
     */
    List<OutboundRequestDTO> getOutboundRequestList(Criteria criteria, OutboundSearchDTO outboundSearchDTO);

    /**
     * 출고 요청 리스트 검색된 총 개수
     */
    int getOutboundRequestTotalCount(OutboundSearchDTO outboundSearchDTO);

    /**
     * 배차 가능한 차량 리스트 조회
     */
    List<AvailableDispatchDTO> getAvailableDispatch(Long or_index);

    /**
     * 배차 등록 (관리자용: 차량 연결)
     */
    boolean registerDispatch(DispatchDTO dispatchDTO);

    /**
     * 배차 수정
     */
    boolean modifyDispatch(DispatchDTO dispatchDTO);

    /**
     * 배차 취소
     */
    boolean removeDispatch(Long dispatch_index);

    /**
     * 배차 상세 조회
     * (참고: ServiceImpl의 파라미터가 or_index로 되어있어 그대로 반영)
     */
    DispatchDetailDTO getDispatchById(Long or_index);

    DispatchDTO getDispatchByIndex(Long dispatch_index);

    /**
     * 출고 요청 승인 (관리자용: 출고지시서 자동 생성)
     */
    boolean approveOutboundRequest(OutboundResponseRegisterDTO outboundResponseRegisterDTO);

    /**
     * 출고 요청 반려 (관리자용)
     */
    boolean rejectOutboundRequest(OutboundResponseRegisterDTO outboundResponseRegisterDTO);

    /**
     * 출고 지시서 리스트 (페이징 + 검색)
     */
    List<ShippingInstructionDetailDTO> getShippingInstructionList(Criteria criteria, OutboundSearchDTO outboundSearchDTO);

    /**
     * 출고 지시서 검색된 총 개수
     */
    int getShippingInstructionTotalCount(OutboundSearchDTO outboundSearchDTO);

    /**
     * 출고 지시서 단건 조회 (CUD 재조회용)
     */
    ShippingInstructionDTO getShippingInstructionById(Long si_index);

    /**
     * 출고 지시서 상세 조회 (DTO 조합 및 이전/다음 글 ID 포함)
     */
    ShippingInstructionDetailDTO getShippingInstructionDetailById(OutboundSearchDTO outboundSearchDTO, Long si_index);

    /**
     * 출고 지시서 삭제 (운송장 등록 전)
     */
//    boolean removeShippingInstruction(Long si_index);

    /**
     * 운송장 등록 (운송장 번호 생성 및 트랜잭션)
     */
    boolean registerWaybill(Long si_index);

    /**
     * 운송장 상세 조회 (DTO 조합)
     */
    WaybillDetailDTO getWaybillDetail(Long si_index);
}
