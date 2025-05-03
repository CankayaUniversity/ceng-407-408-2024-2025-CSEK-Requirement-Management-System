package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.Subsystem3RequirementChangeLogDTO
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

    @GetMapping
    fun getAll(): List<Subsystem3RequirementChangeLogDTO> {
        return changeLogService.getAll()
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
