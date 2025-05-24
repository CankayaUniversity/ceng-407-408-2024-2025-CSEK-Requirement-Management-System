package com.example.demo.service

import org.springframework.stereotype.Service
import com.example.demo.model.Subsystem2
import com.example.demo.repository.Subsystem2Repository
import com.example.demo.DTO.CreateSubsystem2_DTO
import com.example.demo.model.Subsystem1
import java.util.*

@Service
class Subsystem2Service(
    private val subsystem2Repository: Subsystem2Repository
) {

    fun createSubsystem2(dto: CreateSubsystem2_DTO): CreateSubsystem2_DTO {
        val entity = Subsystem2(
            id = null,
            title = dto.title,
            description = dto.description,
            createdBy  = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,
            projectId = dto.projectId,
        )

        val saved = subsystem2Repository.save(entity)

        return CreateSubsystem2_DTO(
            id = saved.id,
            title = saved.title,
            description = saved.description,
            createdBy = saved.createdBy,
            systemRequirementId = saved.systemRequirementId!!,
            flag = saved.flag,
            projectId = saved.projectId,
        )
    }

    fun getAll(): List<CreateSubsystem2_DTO> {
        return subsystem2Repository.findAll().map {
            CreateSubsystem2_DTO(
                id = it.id,
                title = it.title,
                description = it.description,
                createdBy = it.createdBy,
                systemRequirementId = it.systemRequirementId!!,
                flag = it.flag,
                projectId = it.projectId,
            )
        }
    }

    fun getRequirementsByProjectId(projectId: UUID): List<Subsystem2> {
        return subsystem2Repository.findAllByProjectId(projectId)
    }

    fun updateSubsystem2(id: UUID, dto: CreateSubsystem2_DTO): CreateSubsystem2_DTO {
        val existing = subsystem2Repository.findById(id)
            .orElseThrow { NoSuchElementException("Subsystem2 not found: $id") }

        val updated = existing.copy(
            title = dto.title,
            description = dto.description,
            createdBy = dto.createdBy,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,
            projectId = dto.projectId,
        )

        return subsystem2Repository.save(updated).let {
            CreateSubsystem2_DTO(
                id = it.id,
                title = it.title,
                description = it.description,
                createdBy = it.createdBy,
                systemRequirementId = it.systemRequirementId!!,
                flag = it.flag,
                projectId = it.projectId,
            )
        }
    }

    fun deleteSubsystem2(id: UUID) {
        if (!subsystem2Repository.existsById(id)) {
            throw NoSuchElementException("Subsystem2 not found: $id")
        }
        subsystem2Repository.deleteById(id)
    }
}
