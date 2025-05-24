package com.example.ChangeLog.repository

import com.example.ChangeLog.model.SystemRequirementChangeLog
import com.example.ChangeLog.model.UserRequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface SystemRequirementChangeLogRepository : JpaRepository<SystemRequirementChangeLog, UUID> {
    fun findAllByProjectId(projectId: UUID): List<SystemRequirementChangeLog>
}
