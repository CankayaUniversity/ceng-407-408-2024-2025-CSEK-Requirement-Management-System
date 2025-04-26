package com.example.demo.DTO

data class CreateRequirementDTO(
    val title: String,
    val description: String,
    val userId: String,
    val flag: Boolean
)
