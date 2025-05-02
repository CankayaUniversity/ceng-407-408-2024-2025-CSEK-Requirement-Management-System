package com.example.demo.controller

import com.example.demo.DTO.Subsystem3AttributeDTO
import com.example.demo.service.Subsystem3AttributeService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem3-attributes")
class Subsystem3AttributeController(
    private val subsystem3AttributeService: Subsystem3AttributeService
) {

    @GetMapping
    fun getAll(): List<Subsystem3AttributeDTO> {
        return subsystem3AttributeService.getAllAttributes()
    }

    @PostMapping
    fun create(@RequestBody dto: Subsystem3AttributeDTO): Subsystem3AttributeDTO {
        return subsystem3AttributeService.createAttribute(dto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem3AttributeDTO): Subsystem3AttributeDTO {
        return subsystem3AttributeService.updateAttribute(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        subsystem3AttributeService.deleteAttribute(id)
    }
}
