package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
data class Subsystem1Attribute(
    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,

    @Column(nullable = false)
    val title: String = "",

    @Column(name = "requirement_id", nullable = false, columnDefinition = "uuid")
    val subsystem1Id: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000"),

    val description: String="",

    )
