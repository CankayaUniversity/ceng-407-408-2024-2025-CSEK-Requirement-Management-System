package com.example.demo.service

import com.example.demo.DTO.Subsystem3HeaderDTO
import com.example.demo.model.Subsytem3Header
import com.example.demo.repository.Header3Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class Subsystem3HeaderService(
    private val headerRepository: Header3Repository
) {
    @Transactional
    fun createHeader(createHeaderDTO: Subsystem3HeaderDTO): Subsytem3Header {
        val header = Subsytem3Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }
}
