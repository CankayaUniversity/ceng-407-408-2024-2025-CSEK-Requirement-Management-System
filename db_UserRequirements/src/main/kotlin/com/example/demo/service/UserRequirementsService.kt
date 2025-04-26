package com.example.demo.service

import com.example.demo.model.UserRequirements
import com.example.demo.repository.UserRequirementsRepository
import org.springframework.stereotype.Service


@Service
class RequirementService(
    private val userRequirementRepo: UserRequirementsRepository,

    ) {
    fun createRequirement(title: String, description: String, userId: String,flag: Boolean): UserRequirements {


        val requirement = UserRequirements(
            title = title,
            description = description,
            createdBy = userId,
            flag = false
        )

        return userRequirementRepo.save(requirement)
    }

    fun getAllRequirements(): List<UserRequirements> {
        return userRequirementRepo.findAll()
    }
}


