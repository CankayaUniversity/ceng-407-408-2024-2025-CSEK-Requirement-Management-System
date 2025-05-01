package com.example.ChangeLog.DTO

import java.util.UUID
import java.time.LocalDateTime

data class SystemRequirementChangeLogDTO(
    val id: UUID? = null,
    val modifiedBy: String?=null,
    val oldTitle: String?=null,
    val oldDefinition: String?=null,
    val requirementId: UUID? = null,
    val header: String? = null,
    val oldAttributeDefinition: String? = null,
    val modifiedAt: LocalDateTime? = null
)
