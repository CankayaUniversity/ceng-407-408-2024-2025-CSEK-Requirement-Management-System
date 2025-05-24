package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
@Table(name = "attributes")
data class Attribute(
    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,

    @Column(nullable = false)
    val header: String = "",

    @Column(name = "user_requirement_id", nullable = false, columnDefinition = "uuid")
    val userRequirementId: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000"),

    @Column(columnDefinition = "TEXT")
    val description: String = ""
)