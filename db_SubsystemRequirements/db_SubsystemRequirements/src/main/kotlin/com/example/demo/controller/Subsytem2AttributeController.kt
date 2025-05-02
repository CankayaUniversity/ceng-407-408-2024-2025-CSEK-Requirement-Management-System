package com.example.demo.controller

import com.example.demo.DTO.Subsystem2AttributeDTO
import com.example.demo.service.Subsystem2AttributeService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem2-attributes")
class Subsystem2AttributeController(
    private val subsystem2AttributeService: Subsystem2AttributeService
) {

    @GetMapping
    fun getAll(): List<Subsystem2AttributeDTO> {
        return subsystem2AttributeService.getAllAttributes()
    }

    @PostMapping
    fun create(@RequestBody dto: Subsystem2AttributeDTO): Subsystem2AttributeDTO {
        return subsystem2AttributeService.createAttribute(dto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem2AttributeDTO): Subsystem2AttributeDTO {
        return subsystem2AttributeService.updateAttribute(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        subsystem2AttributeService.deleteAttribute(id)
    }
}

