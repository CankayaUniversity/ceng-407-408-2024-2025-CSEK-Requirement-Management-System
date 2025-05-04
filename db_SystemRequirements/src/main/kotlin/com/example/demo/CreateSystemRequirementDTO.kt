package com.example.demo.DTO

import java.util.UUID

data class CreateSystemRequirementDTO(
    val title: String,
    val description: String,
    val createdByUserId: String,
    val flag: Boolean,
    val userRequirementId: UUID,
)
