package com.example.ChangeLog.repository

import com.example.ChangeLog.model.UserRequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface UserRequirementChangeLogRepository : JpaRepository<UserRequirementChangeLog, UUID> {
    fun findAllByProjectId(projectId: UUID): List<UserRequirementChangeLog>
}
