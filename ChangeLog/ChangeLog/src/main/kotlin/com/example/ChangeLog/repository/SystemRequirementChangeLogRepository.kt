package com.example.ChangeLog.repository

import com.example.ChangeLog.model.SystemRequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface SystemRequirementChangeLogRepository : JpaRepository<SystemRequirementChangeLog, UUID>
