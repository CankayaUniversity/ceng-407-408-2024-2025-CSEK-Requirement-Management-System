package com.example.demo.service

import com.example.demo.DTO.Subsystem2HeaderDTO
import com.example.demo.model.Subsystem2Header
import com.example.demo.repository.Header2Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class Subsystem2HeaderService(
    private val headerRepository: Header2Repository
) {

    @Transactional
    fun createHeader(createHeaderDTO: Subsystem2HeaderDTO): Subsystem2Header {
        val header = Subsystem2Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }

    @Transactional
    fun updateHeader(oldHeader: String, updatedDTO: Subsystem2HeaderDTO): Subsystem2Header {
        val existing = headerRepository.findById(oldHeader)
            .orElseThrow { NoSuchElementException("Header not found: $oldHeader") }

        headerRepository.delete(existing)
        val updated = Subsystem2Header(header = updatedDTO.header)
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
    fun getAllHeaders(): List<Subsystem2Header> {
        return headerRepository.findAll()
    }
}
