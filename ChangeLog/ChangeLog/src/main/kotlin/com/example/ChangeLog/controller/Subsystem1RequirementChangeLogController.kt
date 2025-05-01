package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem1RequirementChangeLogDTO
import com.example.ChangeLog.service.Subsystem1RequirementChangeLogService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem1Requirement-changelog")
class Subsystem1RequirementChangeLogController(
    private val changeLogService: Subsystem1RequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: Subsystem1RequirementChangeLogDTO): Subsystem1RequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping
    fun getAll(): List<Subsystem1RequirementChangeLogDTO> {
        return changeLogService.getAll()
    }
}
