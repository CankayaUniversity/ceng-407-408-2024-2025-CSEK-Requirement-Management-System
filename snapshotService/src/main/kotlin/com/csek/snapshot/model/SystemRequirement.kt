package com.csek.snapshot.model

import java.util.UUID

data class SystemRequirement(
    val id: UUID,
    val title: String,
    val description: String,
    val createdBy: String,
    val flag: Boolean,
    val user_req_id: UUID,
    val projectId: UUID,
)