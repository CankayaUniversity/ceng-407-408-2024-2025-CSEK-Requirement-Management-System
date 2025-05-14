package com.csek.snapshot.model

import java.util.UUID

class Subsystem3Requirement (
    val id: UUID,
    val title: String,
    val description: String,
    val createdBy: String,
    val flag: Boolean,
    val systemRequirementId: UUID,
)