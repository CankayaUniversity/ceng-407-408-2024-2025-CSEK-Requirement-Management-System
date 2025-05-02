package com.example.demo.service

import com.example.demo.model.SystemRequirements
import com.example.demo.repository.SystemRequirementRepository
import org.springframework.stereotype.Service
import java.util.UUID


@Service
class SystemRequirementsService(
    private val systemRequirementRepo: SystemRequirementRepository,

    ) {
    fun createSystemRequirement(title: String, description: String, userId: String, ur_id: UUID,flag: Boolean): SystemRequirements {


        val requirement = SystemRequirements(
            title = title,
            description = description,
            createdBy = userId,
            user_req_id = ur_id,
            flag = false
        )

        return systemRequirementRepo.save(requirement)
    }

    fun getAllRequirements(): List<SystemRequirements> {
        return systemRequirementRepo.findAll()
    }
}


