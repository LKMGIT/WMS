package com.ssg.wms.inventory.service;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inventory.domain.InvenCountDTO;
import com.ssg.wms.inventory.mappers.InvenCountMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class InvenCountServiceImpl implements InvenCountService {

    private final InvenCountMapper countMapper;

    @Override
    public List<InvenCountDTO> getPage(Criteria cri) {
        return countMapper.selectInvenCountPage(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        return countMapper.selectInvenCountTotal(cri);
    }

    @Override
    @Transactional
    public Long create(InvenCountDTO dto) {
        // 필수값 간단 검증
        if (dto.getInvenIndex() == null) throw new IllegalArgumentException("invenIndex is required");
        if (dto.getUpdateAt() == null)   throw new IllegalArgumentException("updateAt is required");
        if (dto.getInvenQuantity() < 0 || dto.getActualQuantity() < 0)
            throw new IllegalArgumentException("quantities must be >= 0");

        int rows = countMapper.insertInvenCount(dto);
        if (rows != 1 || Objects.isNull(dto.getCountIndex())) {
            throw new IllegalStateException("Insert inven_count failed");
        }
        return dto.getCountIndex();
    }

    @Override
    @Transactional
    public boolean update(InvenCountDTO dto) {
        if (dto.getCountIndex() == null) throw new IllegalArgumentException("countIndex is required");
        return countMapper.updateInvenCount(dto) == 1;
    }

    @Override
    @Transactional
    public boolean delete(Long countIndex) {
        return countMapper.deleteInvenCount(countIndex) == 1;
    }
}
