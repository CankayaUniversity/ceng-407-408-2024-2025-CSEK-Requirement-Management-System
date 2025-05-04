package com.example.demo.service

import com.example.demo.DTO.Subsystem1HeaderDTO
import com.example.demo.model.Subsystem1Header
import com.example.demo.repository.HeaderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeaderService(
    private val headerRepository: HeaderRepository
) {
    @Transactional
    fun createHeader(createHeaderDTO: Subsystem1HeaderDTO): Subsystem1Header {
        val header = Subsystem1Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }

    @Transactional
    fun updateHeader(oldHeader: String, updatedDTO: Subsystem1HeaderDTO): Subsystem1Header {
        val existing = headerRepository.findById(oldHeader)
            .orElseThrow { NoSuchElementException("Header not found: $oldHeader") }

        headerRepository.delete(existing)
        val updated = Subsystem1Header(header = updatedDTO.header)
        return headerRepository.save(updated)
    }

    @Transactional
    fun deleteHeader(header: String) {
        if (!headerRepository.existsById(header)) {
            throw NoSuchElementException("Header not found: $header")
        }
        headerRepository.deleteById(header)
    }

    @Transactional(readOnly = true)
    fun getAllHeaders(): List<Subsystem1Header> {
        return headerRepository.findAll()
    }
}
