package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem3RequirementChangeLogDTO
import com.example.ChangeLog.service.Subsystem3RequirementChangeLogService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem3Requirement-changelog")
class Subsystem3RequirementChangeLogController(
    private val changeLogService: Subsystem3RequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: Subsystem3RequirementChangeLogDTO): Subsystem3RequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping
    fun getAll(): List<Subsystem3RequirementChangeLogDTO> {
        return changeLogService.getAll()
    }
}