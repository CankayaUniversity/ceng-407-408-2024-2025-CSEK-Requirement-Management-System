package com.example.demo.DTO

import java.util.UUID

data class Subsystem2_DTO(
    val id: UUID? = null,
    val title: String,
    val definition: String,
    val systemRequirementId: UUID?=null,
    val flag: Boolean,

)
