package com.example.demo.kafka

import java.time.Instant

data class BaselineEvent(
    val action: String = "create_systemrequirement_baseline",
    val module: String,
    val username: String,
    val description: String,
    val timestamp: String = Instant.now().toString()
)
