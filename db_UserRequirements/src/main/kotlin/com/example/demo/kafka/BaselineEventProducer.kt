package com.example.demo.kafka

import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Service

@Service
class BaselineEventProducer(
    private val kafkaTemplate: KafkaTemplate<String, BaselineEvent>
) {
    fun sendBaselineEvent(module: String) {
        val event = BaselineEvent(
            module = module,
            username = "cancino",
            description = "Kafka User Requirements Baseline",

        )
        kafkaTemplate.send("baseline-csek", event)
        println("📤 Kafka user requirement baseline event gönderildi: $event")
    }
}
