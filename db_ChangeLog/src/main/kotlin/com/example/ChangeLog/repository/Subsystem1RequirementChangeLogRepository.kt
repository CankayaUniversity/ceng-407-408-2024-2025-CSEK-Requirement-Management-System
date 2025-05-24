package com.example.ChangeLog.repository

import com.example.ChangeLog.model.Subsystem1RequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem1RequirementChangeLogRepository : JpaRepository<Subsystem1RequirementChangeLog, UUID> {
    fun findAllByProjectId(projectId: UUID): List<Subsystem1RequirementChangeLog>
}
