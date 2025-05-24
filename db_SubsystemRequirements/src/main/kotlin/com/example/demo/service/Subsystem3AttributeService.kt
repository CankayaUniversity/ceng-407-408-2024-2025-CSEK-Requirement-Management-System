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
            subsystem3Id = dto.subsystem3Id!!,
            description = dto.description,
        )

        val saved = attributeRepository.save(entity)

        return Subsystem3AttributeDTO(
            id = saved.id,
            title = saved.title,
            subsystem3Id = saved.subsystem3Id,
            description = saved.description,
        )
    }

    fun getAllAttributes(): List<Subsystem3AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem3AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem3Id = it.subsystem3Id,
                description = it.description,
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
            subsystem3Id = dto.subsystem3Id!!,
            description = dto.description,
        )

        return attributeRepository.save(updated).let {
            Subsystem3AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem3Id = it.subsystem3Id,
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

