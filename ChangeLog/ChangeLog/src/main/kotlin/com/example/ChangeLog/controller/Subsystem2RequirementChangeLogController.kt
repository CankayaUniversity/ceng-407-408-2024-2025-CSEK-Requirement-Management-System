package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem2RequirementChangeLogDTO
import com.example.ChangeLog.service.Subsystem2RequirementChangeLogService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem2Requirement-changelog")
class Subsystem2RequirementChangeLogController(
    private val changeLogService: Subsystem2RequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: Subsystem2RequirementChangeLogDTO): Subsystem2RequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping
    fun getAll(): List<Subsystem2RequirementChangeLogDTO> {
        return changeLogService.getAll()
    }
}