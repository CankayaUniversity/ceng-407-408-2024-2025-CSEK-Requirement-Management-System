package com.example.demo.service

import com.example.demo.DTO.SubsystemHeaderDTO
import com.example.demo.model.Subsystem1Header
import com.example.demo.repository.HeaderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeaderService(
    private val headerRepository: HeaderRepository
) {
    @Transactional
    fun createHeader(createHeaderDTO: SubsystemHeaderDTO): Subsystem1Header {
        val header = Subsystem1Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }
}
