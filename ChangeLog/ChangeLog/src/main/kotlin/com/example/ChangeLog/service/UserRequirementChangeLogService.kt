package com.example.ChangeLog.service

import com.example.ChangeLog.DTO.UserRequirementChangeLogDTO
import com.example.ChangeLog.model.UserRequirementChangeLog
import com.example.ChangeLog.repository.UserRequirementChangeLogRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.*

@Service
class UserRequirementChangeLogService(
    private val repository: UserRequirementChangeLogRepository
) {

    fun create(dto: UserRequirementChangeLogDTO): UserRequirementChangeLogDTO {
        val entity = UserRequirementChangeLog(
            id = UUID.randomUUID(),
            modifiedBy = dto.modifiedBy ?: "unknown",
            oldTitle = dto.oldTitle ?: "",
            oldDefinition = dto.oldDefinition ?: "",
            requirementId = dto.requirementId,
            header = dto.header,
            oldAttributeDefinition = dto.oldAttributeDefinition ?: "",
            modifiedAt = dto.modifiedAt ?: LocalDateTime.now()
        )
        val saved = repository.save(entity)
        return saved.toDTO()
    }

    fun getAll(): List<UserRequirementChangeLogDTO> {
        return repository.findAll().map { it.toDTO() }
    }


    private fun UserRequirementChangeLog.toDTO(): UserRequirementChangeLogDTO {
        return UserRequirementChangeLogDTO(
            id = this.id,
            modifiedBy = this.modifiedBy,
            oldTitle = this.oldTitle,
            oldDefinition = this.oldDefinition,
            requirementId = this.requirementId,
            header = this.header,
            oldAttributeDefinition = this.oldAttributeDefinition,
            modifiedAt = this.modifiedAt
        )
    }
}
