package com.example.demo.DTO

import java.util.UUID

data class Subsystem2AttributeDTO(
    val id: UUID? = null,
    val title: String,
    val subsystem2Id: UUID?=null,
    val description: String,
)
