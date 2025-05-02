package com.example.demo.controller

import com.example.demo.DTO.Subsystem1AttributeDTO
import com.example.demo.service.Subsystem1AttributeService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem1-attributes")
class Subsystem1AttributeController(
    private val subsystem1AttributeService: Subsystem1AttributeService
) {

    @GetMapping
    fun getAll(): List<Subsystem1AttributeDTO> {
        return subsystem1AttributeService.getAllAttributes()
    }

    @PostMapping
    fun create(@RequestBody dto: Subsystem1AttributeDTO): Subsystem1AttributeDTO {
        return subsystem1AttributeService.createAttribute(dto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem1AttributeDTO): Subsystem1AttributeDTO {
        return subsystem1AttributeService.updateAttribute(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        subsystem1AttributeService.deleteAttribute(id)
    }
}
