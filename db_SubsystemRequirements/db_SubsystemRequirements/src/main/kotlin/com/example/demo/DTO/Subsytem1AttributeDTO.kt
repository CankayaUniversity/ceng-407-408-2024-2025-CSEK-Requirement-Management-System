package com.example.demo.DTO

import java.util.UUID

data class Subsystem1AttributeDTO(
    val id: UUID? = null,
    val title: String,
    val subsystem1Id: UUID?=null,
    val description: String,
)
