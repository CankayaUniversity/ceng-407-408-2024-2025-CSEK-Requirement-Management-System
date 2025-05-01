package com.example.ChangeLog.controller

import com.example.ChangeLog.DTO.UserRequirementChangeLogDTO
import com.example.ChangeLog.service.UserRequirementChangeLogService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/userRequirement-changelog")
class UserRequirementChangeLogController(
    private val changeLogService: UserRequirementChangeLogService
) {

    @PostMapping
    fun create(@RequestBody dto: UserRequirementChangeLogDTO): UserRequirementChangeLogDTO {
        return changeLogService.create(dto)
    }

    @GetMapping
    fun getAll(): List<UserRequirementChangeLogDTO> {
        return changeLogService.getAll()
    }
}
