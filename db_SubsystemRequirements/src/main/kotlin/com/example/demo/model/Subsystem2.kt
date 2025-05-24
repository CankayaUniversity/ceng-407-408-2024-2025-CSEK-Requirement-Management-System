package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
data class Subsystem2(
    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,


    val title: String="",
    val description: String="",
    val createdBy: String="",

    @Column(name = "reqid",nullable = false, columnDefinition = "uuid")
    val systemRequirementId: UUID? = null,

    val flag: Boolean=false,

    @Column(name = "projectId", nullable = false, columnDefinition = "uuid")
    val projectId: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000")


)