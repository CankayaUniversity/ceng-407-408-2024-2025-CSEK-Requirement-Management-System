package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem2RequirementChangeLogDTO
import com.example.ChangeLog.service.Subsystem2RequirementChangeLogService
import org.springframework.web.bind.annotation.*
import java.util.UUID

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

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem2RequirementChangeLogDTO): Subsystem2RequirementChangeLogDTO {
        return changeLogService.update(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        changeLogService.delete(id)
    }
}
