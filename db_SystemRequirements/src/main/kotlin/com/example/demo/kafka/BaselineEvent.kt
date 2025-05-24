package com.example.demo.kafka

import java.util.*

data class BaselineEvent(
    val action: String = "create_systemrequirement_baseline",
    val module: String,
    val username: String,
    val description: String,
    val timestamp: String,
    val projectId: UUID,
    val projectName: String,
)
