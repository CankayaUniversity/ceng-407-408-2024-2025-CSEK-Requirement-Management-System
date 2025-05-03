package com.example.demo.DTO

import java.util.UUID

data class Subsystem2AttributeDTO(
    val id: UUID? = null,
    val title: String,
    val reqId: UUID?=null,
    val definition: String,
    val subsystem2Id: UUID
)
