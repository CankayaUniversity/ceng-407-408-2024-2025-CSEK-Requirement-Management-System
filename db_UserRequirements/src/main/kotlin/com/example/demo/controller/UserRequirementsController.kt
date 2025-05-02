package com.example.demo.controller

import com.example.demo.model.UserRequirements
import com.example.demo.service.RequirementService
import com.example.demo.DTO.CreateRequirementDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/user-requirements")
class UserRequirementController(
    private val requirementService: RequirementService
) {

    @PostMapping
    fun createRequirement(@RequestBody dto: CreateRequirementDTO): ResponseEntity<UserRequirements> {
        val saved = requirementService.createRequirement(dto.title, dto.description, dto.createdBy, dto.flag)
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAllRequirements(): List<UserRequirements> {
        return requirementService.getAllRequirements()
    }

    @PutMapping("/{id}")
    fun updateRequirement(
        @PathVariable id: UUID,
        @RequestBody dto: CreateRequirementDTO
    ): ResponseEntity<UserRequirements> {
        val updated = requirementService.updateRequirement(id, dto.title, dto.description, dto.createdBy, dto.flag)
        return ResponseEntity.ok(updated)
    }

    @DeleteMapping("/{id}")
    fun deleteRequirement(@PathVariable id: UUID): ResponseEntity<Void> {
        requirementService.deleteRequirement(id)
        return ResponseEntity.noContent().build()
    }
}

