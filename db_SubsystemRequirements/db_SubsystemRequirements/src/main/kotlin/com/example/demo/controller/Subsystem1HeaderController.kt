package com.example.demo.controller

import com.example.demo.DTO.Subsystem1HeaderDTO
import com.example.demo.model.Subsystem1Header
import com.example.demo.service.HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsystem1-header")
class HeaderController(
    private val headerService: HeaderService
) {

    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: Subsystem1HeaderDTO): Subsystem1Header {
        return headerService.createHeader(createHeaderDTO)
    }

    @PutMapping("/{oldHeader}")
    fun updateHeader(
        @PathVariable oldHeader: String,
        @RequestBody updatedDTO: Subsystem1HeaderDTO
    ): Subsystem1Header {
        return headerService.updateHeader(oldHeader, updatedDTO)
    }

    @DeleteMapping("/{header}")
    fun deleteHeader(@PathVariable header: String) {
        headerService.deleteHeader(header)
    }

    @GetMapping
    fun getAllHeaders(): List<Subsystem1Header> {
        return headerService.getAllHeaders()
    }
}
