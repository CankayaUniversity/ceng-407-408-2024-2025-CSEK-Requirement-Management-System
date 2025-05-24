package com.csek.snapshot.model

import java.util.UUID

data class UserRequirementAttribute (
    val id: UUID,
    val header: String,
    val userRequirementId: UUID,
    val description: String
)