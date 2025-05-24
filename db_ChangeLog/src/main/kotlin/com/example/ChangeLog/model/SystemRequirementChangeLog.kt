package com.example.ChangeLog.model

import jakarta.persistence.*
import java.util.UUID
import java.time.LocalDateTime
import com.example.ChangeLog.converter.StringListConverter

@Entity
data class SystemRequirementChangeLog(
    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid")
    val id: UUID? = null,

    val modifiedBy: String? =null,
    val oldTitle: String? =null,
    val oldDescription: String?=null,

    val requirementId: UUID?=null,
    val changeType: String?=null,

    @Convert(converter = StringListConverter::class)
    @Column(columnDefinition = "TEXT")
    val header: List<String>? = null,

    @Convert(converter = StringListConverter::class)
    @Column(columnDefinition = "TEXT")
    val oldAttributeDescription: List<String>? = null,

    val modifiedAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "projectId", nullable = false, columnDefinition = "uuid")
    val projectId: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000")
)

