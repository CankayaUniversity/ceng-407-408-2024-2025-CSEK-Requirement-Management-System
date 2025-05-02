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

    @Transactional
    fun updateHeader(oldHeader: String, updatedDTO: Subsystem3HeaderDTO): Subsytem3Header {
        val existing = headerRepository.findById(oldHeader)
            .orElseThrow { NoSuchElementException("Header not found: $oldHeader") }

        headerRepository.delete(existing)
        val updated = Subsytem3Header(header = updatedDTO.header)
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
