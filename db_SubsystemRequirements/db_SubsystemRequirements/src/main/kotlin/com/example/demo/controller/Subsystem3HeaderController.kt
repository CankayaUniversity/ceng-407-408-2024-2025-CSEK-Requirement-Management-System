package com.example.demo.controller

import com.example.demo.DTO.Subsystem3HeaderDTO
import com.example.demo.model.Subsytem3Header
import com.example.demo.service.Subsystem3HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsytem3-header")
class Subsystem3HeaderController(
    private val headerService: Subsystem3HeaderService
) {
    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: Subsystem3HeaderDTO): Subsytem3Header {
        return headerService.createHeader(createHeaderDTO)
    }
}