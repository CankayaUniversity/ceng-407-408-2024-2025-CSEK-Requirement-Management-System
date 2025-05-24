package com.example.demo.repository

import com.example.demo.model.SystemRequirements
import org.springframework.data.jpa.repository.JpaRepository
import java.util.*

interface SystemRequirementRepository : JpaRepository<SystemRequirements, UUID> {
    fun findAllByProjectId(projectId: UUID): List<SystemRequirements>
}
