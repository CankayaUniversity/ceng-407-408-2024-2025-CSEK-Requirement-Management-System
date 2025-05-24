package com.example.demo.controller

import com.example.demo.model.Header
import com.example.demo.service.HeaderService
import org.springframework.web.bind.annotation.*
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus

@RestController
@RequestMapping("/headers")
class HeaderController(
    private val headerService: HeaderService
) {

    @PostMapping
    fun createHeader(
        @RequestBody request: CreateHeaderDTO
    ): ResponseEntity<Header> {
        val saved = headerService.createHeader(request.header)
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @GetMapping
    fun getAllHeaders(): List<Header> {
        return headerService.getAllHeaders()
    }

    @PutMapping("/{oldHeader}")
    fun updateHeader(
        @PathVariable oldHeader: String,
        @RequestBody request: CreateHeaderDTO
    ): ResponseEntity<Header> {
        val updated = headerService.updateHeader(oldHeader, request.header)
        return ResponseEntity.ok(updated)
    }

    @DeleteMapping("/{header}")
    fun deleteHeader(@PathVariable header: String): ResponseEntity<Void> {
        headerService.deleteHeader(header)
        return ResponseEntity.noContent().build()
    }
}

data class CreateHeaderDTO(
    val header: String
)

