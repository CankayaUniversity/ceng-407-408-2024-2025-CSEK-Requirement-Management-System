package com.csek.snapshot.model

import java.util.UUID

data class UserRequirement(
    val id: UUID,
    val title: String,
    val description: String,
    val createdBy: String,
    val flag: Boolean,
    val projectId: UUID,
)
