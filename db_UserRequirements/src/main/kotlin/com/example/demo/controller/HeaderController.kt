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
}

data class CreateHeaderDTO(
    val header: String
)
