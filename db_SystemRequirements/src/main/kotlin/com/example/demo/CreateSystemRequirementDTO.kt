package com.example.demo.dto

import java.util.UUID

data class CreateSystemRequirementDTO(
    val title: String,
    val description: String,
    val createdByUserId: String,
    val flag: Boolean,
    val userRequirementId: UUID,
    val projectId: String
)
