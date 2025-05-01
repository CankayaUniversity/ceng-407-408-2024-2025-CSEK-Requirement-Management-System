package com.example.demo.controller

import com.example.demo.DTO.Subsystem2HeaderDTO
import com.example.demo.model.Subsytem2Header
import com.example.demo.service.Subsystem2HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem2-header")
class Subsystem2HeaderController(
    private val header2Service: Subsystem2HeaderService
) {
    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: Subsystem2HeaderDTO): Subsytem2Header {
        return header2Service.createHeader(createHeaderDTO)
    }
}