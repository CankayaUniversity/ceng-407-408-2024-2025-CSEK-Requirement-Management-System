package com.example.demo.service

import com.example.demo.DTO.Subsystem2HeaderDTO
import com.example.demo.model.Subsytem2Header
import com.example.demo.repository.Header2Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class Subsystem2HeaderService(
    private val headerRepository: Header2Repository
) {

    @Transactional
    fun createHeader(createHeaderDTO: Subsystem2HeaderDTO): Subsytem2Header {
        val header = Subsytem2Header(
            header = createHeaderDTO.header
        )
        return headerRepository.save(header)
    }

    @Transactional
    fun updateHeader(oldHeader: String, updatedDTO: Subsystem2HeaderDTO): Subsytem2Header {
        val existing = headerRepository.findById(oldHeader)
            .orElseThrow { NoSuchElementException("Header not found: $oldHeader") }

        headerRepository.delete(existing)
        val updated = Subsytem2Header(header = updatedDTO.header)
        return headerRepository.save(updated)
    }

    @Transactional
    fun deleteHeader(header: String) {
        if (!headerRepository.existsById(header)) {
            throw NoSuchElementException("Header not found: $header")
        }
        headerRepository.deleteById(header)
    }
}
