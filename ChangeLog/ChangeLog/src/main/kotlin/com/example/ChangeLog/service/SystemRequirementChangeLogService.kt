package com.example.ChangeLog.service

import com.example.ChangeLog.DTO.SystemRequirementChangeLogDTO
import com.example.ChangeLog.model.SystemRequirementChangeLog
import com.example.ChangeLog.repository.SystemRequirementChangeLogRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.*

@Service
class SystemRequirementChangeLogService(
    private val repository: SystemRequirementChangeLogRepository
) {

    fun create(dto: SystemRequirementChangeLogDTO): SystemRequirementChangeLogDTO {
        val entity = SystemRequirementChangeLog(
            id = null,
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

    fun getAll(): List<SystemRequirementChangeLogDTO> {
        return repository.findAll().map { it.toDTO() }
    }

    fun update(id: UUID, dto: SystemRequirementChangeLogDTO): SystemRequirementChangeLogDTO {
        val existing = repository.findById(id)
            .orElseThrow { NoSuchElementException("ChangeLog not found for id: $id") }

        val updated = existing.copy(
            modifiedBy = dto.modifiedBy ?: existing.modifiedBy,
            oldTitle = dto.oldTitle ?: existing.oldTitle,
            oldDefinition = dto.oldDefinition ?: existing.oldDefinition,
            requirementId = dto.requirementId ?: existing.requirementId,
            header = dto.header ?: existing.header,
            oldAttributeDefinition = dto.oldAttributeDefinition ?: existing.oldAttributeDefinition,
            modifiedAt = dto.modifiedAt ?: LocalDateTime.now()
        )

        return repository.save(updated).toDTO()
    }

    fun delete(id: UUID) {
        if (!repository.existsById(id)) {
            throw NoSuchElementException("ChangeLog not found for id: $id")
        }
        repository.deleteById(id)
    }

    private fun SystemRequirementChangeLog.toDTO(): SystemRequirementChangeLogDTO {
        return SystemRequirementChangeLogDTO(
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
