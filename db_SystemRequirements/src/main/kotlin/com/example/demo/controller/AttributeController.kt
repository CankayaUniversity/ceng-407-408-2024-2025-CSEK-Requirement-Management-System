package com.example.demo.controller

import com.example.demo.model.Attribute
import com.example.demo.service.AttributeService
import jakarta.persistence.Id
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
        val saved = attributeService.createAttribute(request.header, UUID.fromString(request.systemRequirementId), request.description)
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAllAttributes(): List<Attribute> {
        return attributeService.getAllAttributes()
    }
}

data class CreateAttributeDTO(
    val header: String,
    val systemRequirementId: String, // UUID'yi string olarak alıyoruz, controller içinde UUID'e çeviriyoruz
    val description: String
)