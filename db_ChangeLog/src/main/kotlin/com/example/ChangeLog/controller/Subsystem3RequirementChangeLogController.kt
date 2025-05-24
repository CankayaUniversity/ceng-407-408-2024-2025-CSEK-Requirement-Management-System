package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem3RequirementChangeLogDTO
import com.example.ChangeLog.model.Subsystem1RequirementChangeLog
import com.example.ChangeLog.model.Subsystem3RequirementChangeLog
import com.example.ChangeLog.service.Subsystem3RequirementChangeLogService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem3Requirement-changelog")
class Subsystem3RequirementChangeLogController(
    private val changeLogService: Subsystem3RequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: Subsystem3RequirementChangeLogDTO): Subsystem3RequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping("/all")
    fun getAll(): List<Subsystem3RequirementChangeLogDTO> {
        return changeLogService.getAll()
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<Subsystem3RequirementChangeLog> {
        return changeLogService.getRequirementsByProjectId(projectId)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem3RequirementChangeLogDTO): Subsystem3RequirementChangeLogDTO {
        return changeLogService.update(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        changeLogService.delete(id)
    }
}
