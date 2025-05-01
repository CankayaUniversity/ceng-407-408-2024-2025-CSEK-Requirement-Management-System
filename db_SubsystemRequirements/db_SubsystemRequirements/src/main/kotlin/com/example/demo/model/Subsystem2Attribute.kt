package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
data class Subsystem2Attribute(
    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,

    @Column(nullable = false)
    val title: String = "",

    @Column(name = "requirement_id", nullable = false, columnDefinition = "uuid")
    val reqId: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000"),

    val definition: String="",

    @ManyToOne
    @JoinColumn(name = "subsystem2_id")
    val subsystem2: Subsystem2? = null
)
