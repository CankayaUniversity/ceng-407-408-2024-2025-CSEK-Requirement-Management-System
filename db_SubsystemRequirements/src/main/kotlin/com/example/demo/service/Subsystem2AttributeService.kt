package com.example.demo.service

import com.example.demo.DTO.Subsystem2AttributeDTO
import com.example.demo.model.Subsystem2Attribute
import com.example.demo.repository.Subsystem2AttributeRepository
import com.example.demo.repository.Subsystem2Repository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem2AttributeService(
    private val attributeRepository: Subsystem2AttributeRepository,
    private val subsystem2Repository: Subsystem2Repository
) {

    fun createAttribute(dto: Subsystem2AttributeDTO): Subsystem2AttributeDTO {
        val subsystem = subsystem2Repository.findById(dto.subsystem2Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem2 is not found") }

        val entity = Subsystem2Attribute(
            title = dto.title,
            subsystem2Id = dto.subsystem2Id,
            description = dto.description,
        )

        val saved = attributeRepository.save(entity)

        return Subsystem2AttributeDTO(
            id = saved.id,
            title = saved.title,
            subsystem2Id = saved.subsystem2Id,
            description = saved.description,
        )
    }

    fun getAllAttributes(): List<Subsystem2AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem2AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem2Id = it.subsystem2Id,
                description = it.description,
            )
        }
    }

    fun updateAttribute(id: UUID, dto: Subsystem2AttributeDTO): Subsystem2AttributeDTO {
        val existing = attributeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Attribute not found: $id") }

        val subsystem = subsystem2Repository.findById(dto.subsystem2Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem2 is not found") }

        val updated = existing.copy(
            title = dto.title,
            subsystem2Id = dto.subsystem2Id,
            description = dto.description,

        )

        return attributeRepository.save(updated).let {
            Subsystem2AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem2Id = it.subsystem2Id,
                description = it.description,
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
