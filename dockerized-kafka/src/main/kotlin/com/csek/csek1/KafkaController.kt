package com.csek.csek1

import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/kafka")
class KafkaController(
    private val producer: KafkaProducerService
) {
    @PostMapping("/send")
    fun send(@RequestParam message: String): String {
        producer.sendMessage(message)
        return "Kafka'ya gönderildi: $message"
    }
}
