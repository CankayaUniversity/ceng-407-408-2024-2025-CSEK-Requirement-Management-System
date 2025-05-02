package com.example.demo.DTO

data class CreateSystemRequirementDTO(
    val title: String,
    val description: String,
    val userRequirementId: Long,
    val createdByUserId: Long
)
