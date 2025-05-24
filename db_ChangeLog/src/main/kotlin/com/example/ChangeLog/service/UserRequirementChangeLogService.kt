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
            id = null,
            modifiedBy = dto.modifiedBy ?: "unknown",
            oldTitle = dto.oldTitle ?: "",
            oldDescription = dto.oldDescription ?: "",
            requirementId = dto.requirementId,
            header = dto.header ?: emptyList(),
            oldAttributeDescription = dto.oldAttributeDescription ?: emptyList(),
            changeType = dto.changeType ?: "unspecified",
            modifiedAt = dto.modifiedAt ?: LocalDateTime.now(),
            projectId = dto.projectId
        )
        val saved = repository.save(entity)
        return saved.toDTO()
    }

    fun getAll(): List<UserRequirementChangeLogDTO> {
        return repository.findAll().map { it.toDTO() }
    }

    fun getRequirementsByProjectId(projectId: UUID): List<UserRequirementChangeLog> {
        return repository.findAllByProjectId(projectId)
    }

    fun update(id: UUID, dto: UserRequirementChangeLogDTO): UserRequirementChangeLogDTO {
        val existing = repository.findById(id)
            .orElseThrow { NoSuchElementException("ChangeLog not found with id: $id") }

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
            throw NoSuchElementException("ChangeLog not found with id: $id")
        }
        repository.deleteById(id)
    }

    private fun UserRequirementChangeLog.toDTO(): UserRequirementChangeLogDTO {
        return UserRequirementChangeLogDTO(
            id = this.id,
            modifiedBy = this.modifiedBy,
            oldTitle = this.oldTitle,
            oldDescription = this.oldDescription,
            requirementId = this.requirementId,
            header = this.header,
            oldAttributeDescription = this.oldAttributeDescription,
            changeType = this.changeType,
            modifiedAt = this.modifiedAt,
            projectId = this.projectId
        )
    }
}
