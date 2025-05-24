package com.example.demo.DTO

import java.util.UUID

data class CreateSubsystem1_DTO(
    val id: UUID? = null,
    val title: String,
    val description: String,
    val createdBy: String,
    val systemRequirementId: UUID,
    val flag: Boolean,
    val projectId: UUID
)

