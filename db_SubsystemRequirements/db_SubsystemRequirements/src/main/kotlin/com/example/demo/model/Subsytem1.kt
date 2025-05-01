package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
data class Subsystem(
    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,


    val title: String="",
    val definition: String="",

    @Column(name = "reqid", updatable = false, nullable = false, columnDefinition = "uuid")
    val systemRequirementId: UUID? = null,

    val flag: Boolean=false,


)

