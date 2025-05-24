
package com.example.demo.controller

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
            dto.title,
            dto.description,
            dto.createdBy,
            dto.user_req_id,
            dto.flag,
            UUID.fromString(dto.projectId)
        )
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping("/all")
    fun getAllSystemRequirements(): ResponseEntity<List<SystemRequirements>> {
        return ResponseEntity.ok(systemRequirementService.getAllRequirements())
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<SystemRequirements> {
        return systemRequirementService.getRequirementsByProjectId(projectId)
    }

    @PutMapping("/{id}")
    fun updateSystemRequirement(
        @PathVariable id: UUID,
        @RequestBody dto: CreateSystemRequirementDTO
    ): ResponseEntity<SystemRequirements> {
        val updated = systemRequirementService.updateSystemRequirement(
            id,
            dto.title,
            dto.description,
            dto.createdBy,
            dto.user_req_id,
            dto.flag,
            UUID.fromString(dto.projectId)
        )
        return ResponseEntity.ok(updated)
    }

    @DeleteMapping("/{id}")
    fun deleteSystemRequirement(@PathVariable id: UUID): ResponseEntity<Void> {
        systemRequirementService.deleteSystemRequirement(id)
        return ResponseEntity.noContent().build()
    }
}



data class CreateSystemRequirementDTO(
    val title: String,
    val description: String,
    val createdBy: String,
    val user_req_id: UUID,
    val flag: Boolean,
    val projectId: String
)