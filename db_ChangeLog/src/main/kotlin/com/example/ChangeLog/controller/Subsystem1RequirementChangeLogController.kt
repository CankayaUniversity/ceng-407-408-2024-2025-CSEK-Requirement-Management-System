package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem1RequirementChangeLogDTO
import com.example.ChangeLog.model.Subsystem1RequirementChangeLog
import com.example.ChangeLog.model.UserRequirementChangeLog
import com.example.ChangeLog.service.Subsystem1RequirementChangeLogService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem1Requirement-changelog")
class Subsystem1RequirementChangeLogController(
    private val changeLogService: Subsystem1RequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: Subsystem1RequirementChangeLogDTO): Subsystem1RequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping("/all")
    fun getAll(): List<Subsystem1RequirementChangeLogDTO> {
        return changeLogService.getAll()
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<Subsystem1RequirementChangeLog> {
        return changeLogService.getRequirementsByProjectId(projectId)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem1RequirementChangeLogDTO): Subsystem1RequirementChangeLogDTO {
        return changeLogService.update(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        changeLogService.delete(id)
    }
}
