package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.UserRequirementChangeLogDTO
import com.example.ChangeLog.model.UserRequirementChangeLog
import com.example.ChangeLog.service.UserRequirementChangeLogService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/userRequirement-changelog")
class UserRequirementChangeLogController(
    private val changeLogService: UserRequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: UserRequirementChangeLogDTO): UserRequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping("/all")
    fun getAll(): List<UserRequirementChangeLogDTO> {
        return changeLogService.getAll()
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<UserRequirementChangeLog> {
        return changeLogService.getRequirementsByProjectId(projectId)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: UserRequirementChangeLogDTO): UserRequirementChangeLogDTO {
        return changeLogService.update(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        changeLogService.delete(id)
    }
}
