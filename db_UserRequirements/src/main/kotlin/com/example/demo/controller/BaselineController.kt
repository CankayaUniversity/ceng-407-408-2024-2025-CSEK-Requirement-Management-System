package com.example.demo.controller

import com.example.demo.kafka.BaselineEventProducer
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/baseline")
class BaselineController(
    private val producer: BaselineEventProducer
) {

    @PostMapping("/send/{module}")
    fun sendBaseline(
        @PathVariable module: String,
        @RequestBody request: Map<String, String>
    ): ResponseEntity<String> {
        val projectId = request["projectId"] ?: return ResponseEntity.badRequest().body("projectId eksik")
        val projectName = request["projectName"] ?: return ResponseEntity.badRequest().body("projectName eksik")
        val username = request["username"] ?: return ResponseEntity.badRequest().body("username eksik")
        val timestamp = request["timestamp"] ?: return ResponseEntity.badRequest().body("timestamp eksik")
        val description = request["description"] ?: return ResponseEntity.badRequest().body("description eksik")

        producer.sendBaselineEvent(module, UUID.fromString(projectId), projectName, username, timestamp, description)
        return ResponseEntity.ok("✅ Baseline gönderildi: $module | $projectName ($projectId) | $username")
    }
}
