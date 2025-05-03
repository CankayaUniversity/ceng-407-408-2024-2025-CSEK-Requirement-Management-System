package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.SystemRequirementChangeLogDTO
import com.example.ChangeLog.service.SystemRequirementChangeLogService
import org.springframework.web.bind.annotation.*
import java.util.UUID

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

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: SystemRequirementChangeLogDTO): SystemRequirementChangeLogDTO {
        return changeLogService.update(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        changeLogService.delete(id)
    }
}
