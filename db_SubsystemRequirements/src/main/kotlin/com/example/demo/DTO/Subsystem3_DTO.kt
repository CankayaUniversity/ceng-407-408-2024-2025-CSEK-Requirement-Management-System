package com.example.demo.DTO

import java.util.UUID

data class Subsystem3_DTO(
    val id: UUID? = null,
    val title: String,
    val description: String,
    val createdBy: String,
    val systemRequirementId: UUID?=null,
    val flag: Boolean,
    val projectId: UUID
)

