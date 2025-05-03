package com.example.demo.controller

import com.example.demo.DTO.Subsystem1_DTO
import com.example.demo.service.SubsystemService
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem1")
class SubsystemController(
    private val subsystemService: SubsystemService
) {

    @GetMapping
    fun getAll(): List<Subsystem1_DTO> {
        return subsystemService.getAll()
    }

    @PostMapping
    fun create(@RequestBody dto: Subsystem1_DTO): Subsystem1_DTO {
        return subsystemService.createSubsystem(dto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem1_DTO): Subsystem1_DTO {
        return subsystemService.updateSubsystem(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        subsystemService.deleteSubsystem(id)
    }
}
