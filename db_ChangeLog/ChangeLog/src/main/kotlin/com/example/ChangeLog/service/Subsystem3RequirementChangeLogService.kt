package com.example.ChangeLog.service

import com.example.ChangeLog.DTO.Subsystem3RequirementChangeLogDTO
import com.example.ChangeLog.model.Subsystem3RequirementChangeLog
import com.example.ChangeLog.repository.Subsystem3RequirementChangeLogRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.*

@Service
class Subsystem3RequirementChangeLogService(
    private val repository: Subsystem3RequirementChangeLogRepository
) {

    fun create(dto: Subsystem3RequirementChangeLogDTO): Subsystem3RequirementChangeLogDTO {
        val entity = Subsystem3RequirementChangeLog(
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

    fun getAll(): List<Subsystem3RequirementChangeLogDTO> {
        return repository.findAll().map { it.toDTO() }
    }

    fun update(id: UUID, dto: Subsystem3RequirementChangeLogDTO): Subsystem3RequirementChangeLogDTO {
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

    private fun Subsystem3RequirementChangeLog.toDTO(): Subsystem3RequirementChangeLogDTO {
        return Subsystem3RequirementChangeLogDTO(
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
