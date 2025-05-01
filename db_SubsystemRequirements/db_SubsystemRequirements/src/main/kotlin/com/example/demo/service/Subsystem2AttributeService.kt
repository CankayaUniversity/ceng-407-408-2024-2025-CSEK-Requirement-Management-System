package com.example.demo.service

import com.example.demo.DTO.Subsystem2AttributeDTO
import com.example.demo.model.Subsystem2Attribute
import com.example.demo.repository.Subsystem2AttributeRepository
import com.example.demo.repository.Subsystem2Repository
import org.springframework.stereotype.Service

@Service
class Subsystem2AttributeService(
    private val attributeRepository: Subsystem2AttributeRepository,
    private val subsystem2Repository: Subsystem2Repository
) {

    fun createAttribute(dto: Subsystem2AttributeDTO): Subsystem2AttributeDTO {
        val subsystem = subsystem2Repository.findById(dto.subsystem2Id)
            .orElseThrow { IllegalArgumentException("Subsystem2 is not found") }

        val entity = Subsystem2Attribute(
            title = dto.title,
            reqId = dto.id!!,
            definition = dto.definition,
            subsystem2 = subsystem
        )

        val saved = attributeRepository.save(entity)

        return Subsystem2AttributeDTO(
            id = saved.id,
            title = saved.title,
            reqId = saved.reqId,
            definition = saved.definition,
            subsystem2Id = subsystem.id!!
        )
    }
    fun getAllAttributes(): List<Subsystem2AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem2AttributeDTO(
                id = it.id,
                title = it.title,
                reqId = it.reqId,
                definition = it.definition,
                subsystem2Id = it.subsystem2?.id!!
            )
        }
    }

}
