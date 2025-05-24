package com.example.demo.service

import com.example.demo.model.Subsystem3
import com.example.demo.repository.Subsystem3Repository
import com.example.demo.DTO.Subsystem3_DTO
import com.example.demo.model.Subsystem1
import com.example.demo.repository.Subsystem2Repository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem3Service(
    private val Subsystem3Repository: Subsystem3Repository,
) {

    fun createNotificationSubsystem(dto: Subsystem3_DTO): Subsystem3_DTO {
        val entity = Subsystem3(
            id = null,
            title = dto.title,
            description = dto.description,
            createdBy = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,
            projectId = dto.projectId
        )

        val saved = Subsystem3Repository.save(entity)

        return Subsystem3_DTO(
            id = saved.id,
            title = saved.title,
            description = saved.description,
            createdBy = saved.createdBy,
            systemRequirementId = saved.systemRequirementId!!,
            flag = saved.flag,
            projectId = saved.projectId
        )
    }

    fun getAllSubsystem3(): List<Subsystem3_DTO> {
        return Subsystem3Repository.findAll().map {
            Subsystem3_DTO(
                id = it.id,
                title = it.title,
                description = it.description,
                createdBy = it.createdBy,
                systemRequirementId = it.systemRequirementId!!,
                flag = it.flag,
                projectId = it.projectId
            )
        }
    }

    fun getRequirementsByProjectId(projectId: UUID): List<Subsystem3> {
        return Subsystem3Repository.findAllByProjectId(projectId)
    }

    fun updateSubsystem3(id: UUID, dto: Subsystem3_DTO): Subsystem3_DTO {
        val existing = Subsystem3Repository.findById(id)
            .orElseThrow { NoSuchElementException("Subsystem3 not found: $id") }

        val updated = existing.copy(
            title = dto.title,
            description = dto.description,
            createdBy = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag
        )

        return Subsystem3Repository.save(updated).let {
            Subsystem3_DTO(
                id = it.id,
                title = it.title,
                description = it.description,
                createdBy = it.createdBy,
                systemRequirementId = it.systemRequirementId!!,
                flag = it.flag,
                projectId = it.projectId
            )
        }
    }

    fun deleteSubsystem3(id: UUID) {
        if (!Subsystem3Repository.existsById(id)) {
            throw NoSuchElementException("Subsystem3 not found: $id")
        }
        Subsystem3Repository.deleteById(id)
    }
}
