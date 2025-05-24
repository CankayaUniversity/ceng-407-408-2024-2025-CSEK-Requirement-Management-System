package com.example.demo.controller

import com.example.demo.model.Attribute
import com.example.demo.service.AttributeService
import org.springframework.web.bind.annotation.*
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import java.util.UUID

@RestController
@RequestMapping("/attributes")
class AttributeController(
    private val attributeService: AttributeService
) {

    @PostMapping
    fun createAttribute(
        @RequestBody request: CreateAttributeDTO
    ): ResponseEntity<Attribute> {
        val saved = attributeService.createAttribute(
            request.header,
            UUID.fromString(request.userRequirementId),
            request.description
        )
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAllAttributes(): List<Attribute> {
        return attributeService.getAllAttributes()
    }

    @PutMapping("/{id}")
    fun updateAttribute(
        @PathVariable id: UUID,
        @RequestBody request: CreateAttributeDTO
    ): ResponseEntity<Attribute> {
        val updated = attributeService.updateAttribute(
            id,
            request.header,
            UUID.fromString(request.userRequirementId),
            request.description
        )
        return ResponseEntity.ok(updated)
    }

    @DeleteMapping("/{id}")
    fun deleteAttribute(@PathVariable id: UUID): ResponseEntity<Void> {
        attributeService.deleteAttribute(id)
        return ResponseEntity.noContent().build()
    }
}

data class CreateAttributeDTO(
    val header: String,
    val userRequirementId: String,
    val description: String
)
