package com.csek.csek1

import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component

@Component
class KafkaConsumer {

    @KafkaListener(topics = ["my-topic"], groupId = "my-group")
    fun listen(message: String) {
        println("💬 Kafka'dan mesaj alındı: $message")
    }
}