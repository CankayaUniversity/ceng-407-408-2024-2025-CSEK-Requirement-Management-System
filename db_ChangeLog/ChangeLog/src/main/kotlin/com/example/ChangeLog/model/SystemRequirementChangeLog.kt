package com.example.ChangeLog.model

import jakarta.persistence.*
import java.util.UUID
import java.time.LocalDateTime

@Entity
data class SystemRequirementChangeLog(
    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid")
    val id: UUID? = null,

    val modifiedBy: String? =null,
    val oldTitle: String? =null ,
    val oldDefinition: String?=null,

    val requirementId: UUID?=null,
    val header: String? = null,
    val oldAttributeDefinition: String?=null,

    val modifiedAt: LocalDateTime = LocalDateTime.now()
)

