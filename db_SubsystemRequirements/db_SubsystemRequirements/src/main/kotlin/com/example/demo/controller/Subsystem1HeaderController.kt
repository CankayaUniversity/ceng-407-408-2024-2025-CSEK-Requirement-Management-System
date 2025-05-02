package com.example.demo.controller

import com.example.demo.DTO.SubsystemHeaderDTO
import com.example.demo.model.Subsystem1Header
import com.example.demo.service.HeaderService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/subsytem1-header")
class HeaderController(
    private val headerService: HeaderService
) {

    @PostMapping
    fun createHeader(@RequestBody createHeaderDTO: SubsystemHeaderDTO): Subsystem1Header {
        return headerService.createHeader(createHeaderDTO)
    }

    @PutMapping("/{oldHeader}")
    fun updateHeader(
        @PathVariable oldHeader: String,
        @RequestBody updatedDTO: SubsystemHeaderDTO
    ): Subsystem1Header {
        return headerService.updateHeader(oldHeader, updatedDTO)
    }

    @DeleteMapping("/{header}")
    fun deleteHeader(@PathVariable header: String) {
        headerService.deleteHeader(header)
    }
}
