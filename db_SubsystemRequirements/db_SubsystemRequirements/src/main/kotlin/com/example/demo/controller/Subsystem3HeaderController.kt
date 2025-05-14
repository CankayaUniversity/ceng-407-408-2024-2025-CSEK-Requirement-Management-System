package com.example.demo.controller

import com.example.demo.DTO.Subsystem3HeaderDTO
import com.example.demo.model.Subsystem3Header
import com.example.demo.service.Subsystem3HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem3-header") // düzeltildi: "subsytem" → "subsystem"
class Subsystem3HeaderController(
    private val headerService: Subsystem3HeaderService
) {

    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: Subsystem3HeaderDTO): Subsystem3Header {
        return headerService.createHeader(createHeaderDTO)
    }

    @PutMapping("/{oldHeader}")
    fun updateHeader(
        @PathVariable oldHeader: String,
        @RequestBody updatedDTO: Subsystem3HeaderDTO
    ): Subsystem3Header {
        return headerService.updateHeader(oldHeader, updatedDTO)
    }

    @DeleteMapping("/{header}")
    fun deleteHeader(@PathVariable header: String) {
        headerService.deleteHeader(header)
    }

    @GetMapping
    fun getAllHeaders(): List<Subsystem3Header> {
        return headerService.getAllHeaders()
    }
}
