package com.example.demo.service

import com.example.demo.DTO.CreateSubsystem1_DTO
import com.example.demo.model.Subsystem1
import com.example.demo.repository.Subsystem1Repository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem1Service(
    private val subsystem1Repository: Subsystem1Repository
) {

    fun createSubsystem1(dto: CreateSubsystem1_DTO): CreateSubsystem1_DTO {
        val entity = Subsystem1(
            id = null,
            title = dto.title,
            description = dto.description,
            createdBy  = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,
            projectId = dto.projectId
        )

        val saved = subsystem1Repository.save(entity)

        return CreateSubsystem1_DTO(
            id = saved.id,
            title = saved.title,
            description = saved.description,
            createdBy = saved.createdBy,
            systemRequirementId = saved.systemRequirementId!!,
            flag = saved.flag,
            projectId = saved.projectId
        )
    }

    fun getAll(): List<CreateSubsystem1_DTO> {
        return subsystem1Repository.findAll().map {
            CreateSubsystem1_DTO(
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

    fun getRequirementsByProjectId(projectId: UUID): List<Subsystem1> {
        return subsystem1Repository.findAllByProjectId(projectId)
    }

    fun updateSubsystem1(id: UUID, dto: CreateSubsystem1_DTO): CreateSubsystem1_DTO {
        val existing = subsystem1Repository.findById(id)
            .orElseThrow { NoSuchElementException("Subsystem1 not found with id: $id") }

        val updated = existing.copy(
            title = dto.title,
            description = dto.description,
            createdBy = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag
        )

        return subsystem1Repository.save(updated).let {
            CreateSubsystem1_DTO(
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

    fun deleteSubsystem(id: UUID) {
        if (!subsystem1Repository.existsById(id)) {
            throw NoSuchElementException("Subsystem1 not found with id: $id")
        }
        subsystem1Repository.deleteById(id)
    }
}
