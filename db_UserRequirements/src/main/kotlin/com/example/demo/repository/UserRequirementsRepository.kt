package com.example.demo.repository

import com.example.demo.model.UserRequirements
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface UserRequirementsRepository : JpaRepository<UserRequirements, UUID> {
    fun findAllByProjectId(projectId: UUID): List<UserRequirements>
}

