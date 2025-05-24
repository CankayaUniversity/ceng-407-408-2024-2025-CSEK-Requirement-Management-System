package com.csek.snapshot.kafka

import java.util.UUID

data class BaselineEvent(
    val action: String,
    val module: String,
    val username: String,
    val description: String,
    val timestamp: String,
    val projectId: UUID,
    val projectName: String,
)
