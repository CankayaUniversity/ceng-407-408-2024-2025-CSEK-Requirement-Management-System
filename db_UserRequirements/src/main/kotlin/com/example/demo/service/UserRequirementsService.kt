package com.example.demo.service

import com.example.demo.model.UserRequirements
import com.example.demo.repository.UserRequirementsRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class RequirementService(
    private val userRequirementRepo: UserRequirementsRepository
) {

    fun createRequirement(title: String, description: String, userId: String, flag: Boolean): UserRequirements {
        val requirement = UserRequirements(
            title = title,
            description = description,
            createdBy = userId,
            flag = flag
        )
        return userRequirementRepo.save(requirement)
    }

    fun getAllRequirements(): List<UserRequirements> {
        return userRequirementRepo.findAll()
    }

    fun updateRequirement(id: UUID, title: String, description: String, createdBy: String, flag: Boolean): UserRequirements {
        val requirement = userRequirementRepo.findById(id)
            .orElseThrow { NoSuchElementException("Requirement not found with ID: $id") }

        val updated = requirement.copy(
            title = title,
            description = description,
            createdBy = createdBy,
            flag = flag
        )

        return userRequirementRepo.save(updated)
    }

    fun deleteRequirement(id: UUID) {
        if (!userRequirementRepo.existsById(id)) {
            throw NoSuchElementException("Requirement not found with ID: $id")
        }
        userRequirementRepo.deleteById(id)
    }
}



