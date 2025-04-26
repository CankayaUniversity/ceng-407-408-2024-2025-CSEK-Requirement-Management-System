package com.example.demo.service

import com.example.demo.dto.CreateHeaderDTO
import com.example.demo.model.Header
import com.example.demo.repository.HeaderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeaderService(
    private val headerRepository: HeaderRepository
) {
    @Transactional
    fun createHeader(createHeaderDTO: CreateHeaderDTO): Header {
        val header = Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }
}