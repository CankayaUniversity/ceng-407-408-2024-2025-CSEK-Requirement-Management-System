package com.example.demo.service

import com.example.demo.model.Attribute
import com.example.demo.repository.AttributeRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class AttributeService(
    private val attributeRepository: AttributeRepository
) {
    fun createAttribute(header: String, userRequirementId: UUID, description: String): Attribute {
        val attribute = Attribute(
            header = header,
            userRequirementId = userRequirementId,
            description = description
        )
        return attributeRepository.save(attribute)
    }

    fun getAllAttributes(): List<Attribute> {
        return attributeRepository.findAll()
    }

    fun updateAttribute(id: UUID, header: String, userRequirementId: UUID, description: String): Attribute {
        val existing = attributeRepository.findById(id)
            .orElseThrow { NoSuchElementException("Attribute not found with id: $id") }

        val updated = existing.copy(
            header = header,
            userRequirementId = userRequirementId,
            description = description
        )
        return attributeRepository.save(updated)
    }

    fun deleteAttribute(id: UUID) {
        if (!attributeRepository.existsById(id)) {
            throw NoSuchElementException("Attribute not found with id: $id")
        }
        attributeRepository.deleteById(id)
    }
}
