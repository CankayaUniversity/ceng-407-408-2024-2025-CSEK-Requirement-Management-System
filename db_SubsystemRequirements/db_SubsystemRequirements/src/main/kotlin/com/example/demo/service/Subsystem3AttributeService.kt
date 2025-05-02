package com.example.demo.service

import com.example.demo.DTO.Subsystem3AttributeDTO
import com.example.demo.model.Subsystem3Attribute
import com.example.demo.repository.Subsystem3AttributeRepository
import com.example.demo.repository.Subsystem3Repository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem3AttributeService(
    private val attributeRepository: Subsystem3AttributeRepository,
    private val subsystem3Repository: Subsystem3Repository
) {

    fun createAttribute(dto: Subsystem3AttributeDTO): Subsystem3AttributeDTO {
        val subsystem = subsystem3Repository.findById(dto.subsystem3Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem3 is not found") }

        val entity = Subsystem3Attribute(
            id = null,
            title = dto.title,
            reqId = dto.reqId!!,
            definition = dto.definition,
            subsystem3 = subsystem
        )

        val saved = attributeRepository.save(entity)

        return Subsystem3AttributeDTO(
            id = saved.id,
            title = saved.title,
            reqId = saved.reqId,
            definition = saved.definition,
            subsystem3Id = subsystem.id!!
        )
    }

    fun getAllAttributes(): List<Subsystem3AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem3AttributeDTO(
                id = it.id,
                title = it.title,
                reqId = it.reqId,
                definition = it.definition,
                subsystem3Id = it.subsystem3?.id!!
            )
        }
    }

    fun updateAttribute(id: UUID, dto: Subsystem3AttributeDTO): Subsystem3AttributeDTO {
        val existing = attributeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Attribute not found: $id") }

        val subsystem = subsystem3Repository.findById(dto.subsystem3Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem3 is not found") }

        val updated = existing.copy(
            title = dto.title,
            reqId = dto.reqId!!,
            definition = dto.definition,
            subsystem3 = subsystem
        )

        return attributeRepository.save(updated).let {
            Subsystem3AttributeDTO(
                id = it.id,
                title = it.title,
                reqId = it.reqId,
                definition = it.definition,
                subsystem3Id = it.subsystem3?.id!!
            )
        }
    }

    fun deleteAttribute(id: UUID) {
        if (!attributeRepository.existsById(id)) {
            throw NoSuchElementException("Attribute not found: $id")
        }
        attributeRepository.deleteById(id)
    }
}

