package com.csek.snapshot.kafka

data class BaselineEvent(
    val action: String,
    val module: String,
    val username: String,
    val description: String,
    val timestamp: String
)
