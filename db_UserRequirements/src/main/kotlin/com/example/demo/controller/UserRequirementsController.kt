package com.example.demo.controller

import com.example.demo.model.UserRequirements
import org.springframework.web.bind.annotation.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import com.example.demo.service.RequirementService
import com.example.demo.DTO.CreateRequirementDTO


@RestController
@RequestMapping("/user-requirements")
class UserRequirementController(
    private val requirementService: RequirementService
) {

    @PostMapping
    fun createRequirement(@RequestBody dto: CreateRequirementDTO): ResponseEntity<UserRequirements> {
        val saved = requirementService.createRequirement(dto.title, dto.description, dto.userId, dto.flag)
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAllRequirements(): List<UserRequirements> {
        return requirementService.getAllRequirements()
    }
}

