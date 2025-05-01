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
}
