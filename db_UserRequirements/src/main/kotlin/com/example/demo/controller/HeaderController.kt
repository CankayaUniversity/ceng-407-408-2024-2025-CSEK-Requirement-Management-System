package com.example.demo.controller

import com.example.demo.dto.CreateHeaderDTO
import com.example.demo.model.Header
import com.example.demo.service.HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/headers")
class HeaderController(
    private val headerService: HeaderService
) {
    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: CreateHeaderDTO): Header {
        return headerService.createHeader(createHeaderDTO)
    }
}