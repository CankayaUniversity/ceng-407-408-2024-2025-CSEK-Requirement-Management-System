package com.example.demo.service

import com.example.demo.model.Header
import com.example.demo.repository.HeaderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class HeaderService(
    private val headerRepository: HeaderRepository
) {
    @Transactional
    fun createHeader(header: String): Header {
        val headerEntity = Header(header = header)
        return headerRepository.save(headerEntity)
    }

    fun getAllHeaders(): List<Header> {
        return headerRepository.findAll()
    }

    @Transactional
    fun updateHeader(oldHeader: String, newHeader: String): Header {
        val existing = headerRepository.findById(oldHeader)
            .orElseThrow { NoSuchElementException("Header not found: $oldHeader") }

        headerRepository.delete(existing)
        val updated = Header(header = newHeader)
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
