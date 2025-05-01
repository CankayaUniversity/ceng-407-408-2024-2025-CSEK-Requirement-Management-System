package com.example.demo.service

import com.example.demo.DTO.Subsystem1AttributeDTO
import com.example.demo.model.Subsystem1Attribute
import com.example.demo.repository.Subsystem1AttributeRepository
import com.example.demo.repository.SubsystemRepository
import org.springframework.stereotype.Service

@Service
class Subsystem1AttributeService(
    private val attributeRepository: Subsystem1AttributeRepository,
    private val subsystem1Repository: SubsystemRepository
) {

    fun createAttribute(dto: Subsystem1AttributeDTO): Subsystem1AttributeDTO {
        val subsystem = subsystem1Repository.findById(dto.subsystem1Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem1 is not found") }

        val entity = Subsystem1Attribute(
            title = dto.title,
            reqId = dto.reqId!!,
            definition = dto.definition,
            subsystem1 = subsystem
        )

        val saved = attributeRepository.save(entity)

        return Subsystem1AttributeDTO(
            id = saved.id,
            title = saved.title,
            reqId = saved.reqId,
            definition = saved.definition,
            subsystem1Id = subsystem.id!!
        )
    }
    fun getAllAttributes(): List<Subsystem1AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem1AttributeDTO(
                id = it.id,
                title = it.title,
                reqId = it.reqId,
                definition = it.definition,
                subsystem1Id = it.subsystem1?.id!!
            )
        }
    }

}
