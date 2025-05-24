package com.csek.snapshot.model

import java.util.UUID

class SystemRequirementAttribute (
    val id: UUID,
    val header: String,
    val systemRequirementId: UUID,
    val description: String
)