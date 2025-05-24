package com.example.ChangeLog.repository

import com.example.ChangeLog.model.Subsystem1RequirementChangeLog
import com.example.ChangeLog.model.Subsystem3RequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem3RequirementChangeLogRepository: JpaRepository<Subsystem3RequirementChangeLog, UUID> {
    fun findAllByProjectId(projectId: UUID): List<Subsystem3RequirementChangeLog>
}
