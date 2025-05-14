package com.example.demo.service

import com.example.demo.DTO.Subsystem1AttributeDTO
import com.example.demo.model.Subsystem1Attribute
import com.example.demo.repository.Subsystem1AttributeRepository
import com.example.demo.repository.Subsystem1Repository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem1AttributeService(
    private val attributeRepository: Subsystem1AttributeRepository,
    private val subsystem1Repository: Subsystem1Repository
) {

    fun createAttribute(dto: Subsystem1AttributeDTO): Subsystem1AttributeDTO {
        val subsystem = subsystem1Repository.findById(dto.subsystem1Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem1 is not found") }

        val entity = Subsystem1Attribute(
            title = dto.title,
            subsystem1Id = dto.subsystem1Id,
            description = dto.description,
        )

        val saved = attributeRepository.save(entity)

        return Subsystem1AttributeDTO(
            id = saved.id,
            title = saved.title,
            subsystem1Id = saved.subsystem1Id,
            description = saved.description,
        )
    }

    fun getAllAttributes(): List<Subsystem1AttributeDTO> {
        return attributeRepository.findAll().map {
            Subsystem1AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem1Id = it.subsystem1Id,
                description = it.description,
            )
        }
    }

    fun updateAttribute(id: UUID, dto: Subsystem1AttributeDTO): Subsystem1AttributeDTO {
        val existing = attributeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Attribute not found: $id") }

        val subsystem = subsystem1Repository.findById(dto.subsystem1Id!!)
            .orElseThrow { IllegalArgumentException("Subsystem1 is not found") }

        val updated = existing.copy(
            title = dto.title,
            subsystem1Id = dto.subsystem1Id,
            description = dto.description,
        )

        return attributeRepository.save(updated).let {
            Subsystem1AttributeDTO(
                id = it.id,
                title = it.title,
                subsystem1Id = it.subsystem1Id,
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
