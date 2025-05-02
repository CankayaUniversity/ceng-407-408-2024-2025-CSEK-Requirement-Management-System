package com.example.demo.controller

import com.example.demo.DTO.CreateSystemRequirementDTO
import com.example.demo.model.SystemRequirements
import com.example.demo.service.SystemRequirementsService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/system-requirements")
class SystemRequirementController(
    private val systemRequirementService: SystemRequirementsService
) {

    @PostMapping
    fun createSystemRequirement(@RequestBody dto: CreateSystemRequirementDTO): ResponseEntity<SystemRequirements> {
        val saved = systemRequirementService.createSystemRequirement(
            title = dto.title,
            description = dto.description,
            userId = dto.createdByUserId.toString(), // Long -> String'e çeviriyor
            ur_id = UUID.fromString(dto.userRequirementId.toString()), // Long -> UUID
            flag = false
        )
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAll(): List<SystemRequirements> = systemRequirementService.getAllRequirements()
}

data class CreateSystemRequirementDTO(
    val title: String,
    val description: String,
    val userRequirementId: UUID,
    val createdByUserId: String
)