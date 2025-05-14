package com.example.demo.controller

import com.example.demo.kafka.BaselineEventProducer
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/baseline")
class BaselineController(
    private val producer: BaselineEventProducer
) {

    @PostMapping("/send/{module}")
    fun sendBaseline(@PathVariable module: String): ResponseEntity<String> {
        producer.sendBaselineEvent(module)
        return ResponseEntity.ok("Baseline event gönderildi: $module")
    }
}
