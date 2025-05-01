package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.SystemRequirementChangeLogDTO
import com.example.ChangeLog.service.SystemRequirementChangeLogService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/systemRequirement-changelog")
class SystemRequirementChangeLogController(
    private val changeLogService: SystemRequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: SystemRequirementChangeLogDTO): SystemRequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping
    fun getAll(): List<SystemRequirementChangeLogDTO> {
        return changeLogService.getAll()
    }
}
