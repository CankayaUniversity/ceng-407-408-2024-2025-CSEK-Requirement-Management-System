package com.example.demo.controller

import com.example.demo.DTO.Subsystem2HeaderDTO
import com.example.demo.model.Subsystem2Header
import com.example.demo.service.Subsystem2HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem2-header")
class Subsystem2HeaderController(
    private val header2Service: Subsystem2HeaderService
) {

    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: Subsystem2HeaderDTO): Subsystem2Header {
        return header2Service.createHeader(createHeaderDTO)
    }

    @PutMapping("/{oldHeader}")
    fun updateHeader(
        @PathVariable oldHeader: String,
        @RequestBody updatedDTO: Subsystem2HeaderDTO
    ): Subsystem2Header {
        return header2Service.updateHeader(oldHeader, updatedDTO)
    }

    @DeleteMapping("/{header}")
    fun deleteHeader(@PathVariable header: String) {
        header2Service.deleteHeader(header)
    }

    @GetMapping
    fun getAllHeaders(): List<Subsystem2Header> {
        return header2Service.getAllHeaders()
    }
}

