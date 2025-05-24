package com.example.demo.dto

data class CreateRequirementDTO(
    val title: String,
    val description: String,
    val createdBy: String,
    val flag: Boolean,
    val projectId: String
)
