package com.example.ChangeLog.DTO

import java.util.UUID
import java.time.LocalDateTime

data class Subsystem1RequirementChangeLogDTO(
    val id: UUID? = null,
    val modifiedBy: String?=null,
    val oldTitle: String?=null,
    val oldDescription: String?=null,
    val requirementId: UUID? = null,
    val header: List<String>? = null,
    val oldAttributeDescription: List<String>? = null,
    val changeType: String? = null,
    val modifiedAt: LocalDateTime? = null,
    val projectId: UUID
)
