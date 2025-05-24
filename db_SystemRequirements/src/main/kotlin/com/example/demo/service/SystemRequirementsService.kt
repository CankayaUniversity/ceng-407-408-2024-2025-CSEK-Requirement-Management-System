package com.example.demo.service

import com.example.demo.model.SystemRequirements
import com.example.demo.repository.SystemRequirementRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class SystemRequirementsService(
    private val systemRequirementRepo: SystemRequirementRepository
) {

    fun createSystemRequirement(
        title: String,
        description: String,
        createdBy: String,
        userRequirementId: UUID,
        flag: Boolean,
        projectId: UUID
    ): SystemRequirements {
        val requirement = SystemRequirements(
            title = title,
            description = description,
            createdBy = createdBy,
            user_req_id = userRequirementId,
            flag = false,
            projectId = projectId
        )
        return systemRequirementRepo.save(requirement)
    }

    fun getAllRequirements(): List<SystemRequirements> {
        return systemRequirementRepo.findAll()
    }

    fun getRequirementsByProjectId(projectId: UUID): List<SystemRequirements> {
        return systemRequirementRepo.findAllByProjectId(projectId)
    }

    fun updateSystemRequirement(
        id: UUID,
        title: String,
        description: String,
        createdBy: String,
        userRequirementId: UUID,
        flag: Boolean,
        projectId: UUID
    ): SystemRequirements {
        val existing = systemRequirementRepo.findById(id)
            .orElseThrow { NoSuchElementException("SystemRequirement not found with id: $id") }

        val updated = existing.copy(
            title = title,
            description = description,
            createdBy = createdBy,
            user_req_id = userRequirementId,
            flag = flag,
            projectId = projectId
        )

        return systemRequirementRepo.save(updated)
    }

    fun deleteSystemRequirement(id: UUID) {
        if (!systemRequirementRepo.existsById(id)) {
            throw NoSuchElementException("SystemRequirement not found with id: $id")
        }
        systemRequirementRepo.deleteById(id)
    }
}
