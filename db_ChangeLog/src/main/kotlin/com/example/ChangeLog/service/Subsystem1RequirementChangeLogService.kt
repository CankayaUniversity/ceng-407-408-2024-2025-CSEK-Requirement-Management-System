package com.example.ChangeLog.service

import com.example.ChangeLog.DTO.Subsystem1RequirementChangeLogDTO
import com.example.ChangeLog.model.Subsystem1RequirementChangeLog
import com.example.ChangeLog.model.UserRequirementChangeLog
import com.example.ChangeLog.repository.Subsystem1RequirementChangeLogRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.*

@Service
class Subsystem1RequirementChangeLogService(
    private val repository: Subsystem1RequirementChangeLogRepository
) {

    fun create(dto: Subsystem1RequirementChangeLogDTO): Subsystem1RequirementChangeLogDTO {
        val entity = Subsystem1RequirementChangeLog(
            id = null,
            modifiedBy = dto.modifiedBy ?: "unknown",
            oldTitle = dto.oldTitle ?: "",
            oldDescription = dto.oldDescription ?: "",
            requirementId = dto.requirementId,
            header = dto.header ?: emptyList(),
            oldAttributeDescription = dto.oldAttributeDescription ?: emptyList(),
            changeType = dto.changeType ?: "unspecified",
            modifiedAt = dto.modifiedAt ?: LocalDateTime.now(),
            projectId = dto.projectId,
        )
        val saved = repository.save(entity)
        return saved.toDTO()
    }

    fun getAll(): List<Subsystem1RequirementChangeLogDTO> {
        return repository.findAll().map { it.toDTO() }
    }

    fun getRequirementsByProjectId(projectId: UUID): List<Subsystem1RequirementChangeLog> {
        return repository.findAllByProjectId(projectId)
    }

    fun update(id: UUID, dto: Subsystem1RequirementChangeLogDTO): Subsystem1RequirementChangeLogDTO {
        val existing = repository.findById(id)
            .orElseThrow { NoSuchElementException("ChangeLog not found for id: $id") }

        val updated = existing.copy(
            modifiedBy = dto.modifiedBy ?: existing.modifiedBy,
            oldTitle = dto.oldTitle ?: existing.oldTitle,
            oldDescription = dto.oldDescription ?: existing.oldDescription,
            requirementId = dto.requirementId ?: existing.requirementId,
            header = dto.header ?: existing.header,
            oldAttributeDescription = dto.oldAttributeDescription ?: existing.oldAttributeDescription,
            changeType = dto.changeType ?: existing.changeType,
            modifiedAt = dto.modifiedAt ?: LocalDateTime.now(),
            projectId = dto.projectId
        )

        return repository.save(updated).toDTO()
    }

    fun delete(id: UUID) {
        if (!repository.existsById(id)) {
            throw NoSuchElementException("ChangeLog not found for id: $id")
        }
        repository.deleteById(id)
    }

    private fun Subsystem1RequirementChangeLog.toDTO(): Subsystem1RequirementChangeLogDTO {
        return Subsystem1RequirementChangeLogDTO(
            id = this.id,
            modifiedBy = this.modifiedBy,
            oldTitle = this.oldTitle,
            oldDescription = this.oldDescription,
            requirementId = this.requirementId,
            header = this.header,
            oldAttributeDescription = this.oldAttributeDescription,
            changeType = this.changeType,
            modifiedAt = this.modifiedAt,
            projectId = this.projectId,
        )
    }
}

