package com.example.ChangeLog.repository

import com.example.ChangeLog.model.Subsystem2RequirementChangeLog
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem2RequirementChangeLogRepository : JpaRepository<Subsystem2RequirementChangeLog, UUID>
