package com.ssg.wms.quotation.mappers;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.quotation.domain.*;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
@Transactional
public class QuotationMapperTest {

    @Autowired(required = false)
    private QuotationMapper quotationMapper;

    @Test
    public void testMapperExists() {
        assertNotNull(quotationMapper);
        log.info("QuotationMapper 주입 확인: " + quotationMapper);
    }

    // ======== 1. QuotationRequest 테스트 ========

    @Test
    public void testSelectQuotationRequestList() {
        List<QuotationRequestDTO> list = quotationMapper.selectQuotationRequestList(new Criteria(), new QuotationSearchDTO());
        log.info("===== 견적 요청 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("=========================");
    }

    @Test
    public void testSelectQuotationRequestTotalCount() {
        int total = quotationMapper.selectQuotationRequestTotalCount(new QuotationSearchDTO());
        log.info("견적 요청 전체 개수: " + total);
    }

    @Test
    public void testSelectQuotationRequest() {
        // ※※※ 수정된 부분 ※※※
        // 원본 테스트 코드는 DTO를 파라미터로 넘기려 했으나,
        // QuotationMapper.java 인터페이스는 'Long qrequest_index'를 받습니다.
        // 인터페이스에 맞게 Long 타입으로 수정합니다.
        Long qrequest_index = 1L;
        QuotationRequestDTO resultDto = quotationMapper.selectQuotationRequest(qrequest_index);
        log.info("1번 견적 요청: " + resultDto);
        assertNotNull(resultDto);
    }

    @Test
    public void testInsertQuotationRequest() {
        QuotationRequestDTO dto = QuotationRequestDTO.builder()
                .user_index(1L).qrequest_name("새신청자")
                .qrequest_email("new@test.com")
                .qrequest_phone("010-8888-8888")
                .qrequest_detail("새 내용").build();
        quotationMapper.insertQuotationRequest(dto);
        log.info("등록된 견적 요청 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateQuotationRequest() {
        QuotationRequestDTO dto = QuotationRequestDTO.builder()
                .qrequest_index(1L) // 1번 견적 수정
                .qrequest_name("이름수정")
                .qrequest_email("edit@test.com")
                .qrequest_phone("010-1111-2222")
                .qrequest_company("수정회사")
                .qrequest_detail("수정 내용")
                .qrequest_status(EnumStatus.PENDING)
                .build();

        quotationMapper.updateQuotationRequest(dto);
        log.info("1번 견적 수정 완료");
    }

    @Test
    public void testDeleteQuotationRequest() {
        quotationMapper.deleteQuotationRequest(1L);
        log.info("1번 견적 삭제");
    }

    // ======== 2. QuotationResponse 테스트 ========

    @Test
    public void testInsertQuotationResponse() {
        QuotationResponseDTO dto = QuotationResponseDTO.builder()
                .qrequest_index(1L) // 1번 요청에 답변
                .admin_index(1L)
                .qresponse_detail("1번 답변입니다.")
                .build();
        quotationMapper.insertQuotationResponse(dto);
        log.info("등록된 견적 답변 (PK 확인): " + dto);
    }

    @Test
    public void testSelectQuotationResponse() {
        // 2번 요청에 대한 답변 조회 (test-data.sql 기준)
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        log.info("2번 요청의 답변: " + dto);
        assertNotNull(dto);
    }

    @Test
    public void testUpdateQuotationResponse() {
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        dto.setQresponse_detail("수정된 답변");
        quotationMapper.updateQuotationResponse(dto);

        QuotationResponseDTO updatedDto = quotationMapper.selectQuotationResponse(2L);
        log.info("수정된 답변: " + updatedDto);
    }

    @Test
    public void testDeleteQuotationResponse() {
        quotationMapper.deleteQuotationResponse(1L); // 1번 답변 (qrequest_index=2)
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        log.info("삭제 후 조회: " + dto);
    }

    // ======== 3. QuotationComment 테스트 ========

    @Test
    public void testSelectQuotationCommentList() {
        // 3번 견적의 댓글 목록 (test-data.sql 기준)
        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 3L);
        log.info("===== 3번 견적의 댓글 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("==============================");
    }

    @Test
    public void testSelectQuotationCommentTotalCount() {
        // 3번 견적의 댓글 수 (test-data.sql 기준)
        int total = quotationMapper.selectQuotationCommentTotalCount(3L);
        log.info("3번 견적의 댓글 수: " + total);
    }

    @Test
    public void testInsertQuotationComment() {
        // 관리자 댓글 (user_index = null)
        QuotationCommentDTO adminComment = QuotationCommentDTO.builder()
                .qrequest_index(1L).qcomment_detail("관리자 댓글")
                .writer_type(EnumStatus.ADMIN).admin_index(1L).user_index(null)
                .build();
        quotationMapper.insertQuotationComment(adminComment);

        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 1L);
        log.info("등록된 관리자 댓글: " + list.get(0));
    }

    @Test
    public void testUpdateQuotationComment() {
        // 3번 견적의 첫번째 댓글 (test-data.sql 기준, qcomment_index=1)
        QuotationCommentDTO dto = quotationMapper.selectQuotationComment(1L);
        dto.setQcomment_detail("수정된 관리자 댓글");

        quotationMapper.updateQuotationComment(dto);

        QuotationCommentDTO updatedDto = quotationMapper.selectQuotationComment(1L);
        log.info("수정된 댓글: " + updatedDto);
    }

    @Test
    public void testDeleteQuotationComment() {
        // 3번 견적의 첫번째 댓글 (qcomment_index=1)
        quotationMapper.deleteQuotationComment(1L);

        List<QuotationCommentDTO> updatedList = quotationMapper.selectQuotationCommentList(new Criteria(), 3L);
        log.info("삭제 후 댓글 목록 크기: " + updatedList.size());
    }
}