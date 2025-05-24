package com.example.demo.kafka

import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Service
import java.util.UUID

@Service
class BaselineEventProducer(
    private val kafkaTemplate: KafkaTemplate<String, BaselineEvent>
) {
    fun sendBaselineEvent(module: String, projectId: UUID, projectName: String, username: String, timestamp: String, description: String) {
        val event = BaselineEvent(
            module = module,
            username = username,
            description = description,
            projectId = projectId,
            projectName = projectName,
            timestamp = timestamp,
        )
        kafkaTemplate.send("baseline-csek", event)
    }
}
