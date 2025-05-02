package com.example.demo.service

import com.example.demo.model.Attribute
import com.example.demo.repository.AttributeRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class AttributeService(
    private val attributeRepository: AttributeRepository
) {
    fun createAttribute(header: String, systemRequirementId: UUID, description: String): Attribute {
        val attribute = Attribute(
            header = header,
            systemRequirementId = systemRequirementId,
            description = description
        )
        return attributeRepository.save(attribute)
    }

    fun getAllAttributes(): List<Attribute> {
        return attributeRepository.findAll()
    }
}