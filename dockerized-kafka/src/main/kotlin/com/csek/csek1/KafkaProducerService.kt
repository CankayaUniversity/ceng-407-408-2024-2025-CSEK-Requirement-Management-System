package com.csek.csek1

import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Service

@Service
class KafkaProducerService(
    private val kafkaTemplate: KafkaTemplate<String, String>
) {
    fun sendMessage(message: String) {
        kafkaTemplate.send("my-topic", message)
    }
}
