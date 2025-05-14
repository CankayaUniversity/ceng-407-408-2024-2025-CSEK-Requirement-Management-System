package com.example.demo.controller

import com.example.demo.DTO.CreateSubsystem1_DTO
import org.springframework.web.bind.annotation.*
import com.example.demo.service.Subsystem2Service
import com.example.demo.DTO.CreateSubsystem2_DTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.util.UUID

@RestController
@RequestMapping("/subsystem2")
class Subsystem2Controller(
    private val Subsystem2Service: Subsystem2Service
) {
    @GetMapping
    fun getAllSubsystem2Requirements(): ResponseEntity<List<CreateSubsystem2_DTO>> {
        return ResponseEntity.ok(Subsystem2Service.getAll())
    }

    @PostMapping
    fun create(@RequestBody subsystemDto: CreateSubsystem2_DTO): CreateSubsystem2_DTO {
        return Subsystem2Service.createSubsystem2(subsystemDto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: CreateSubsystem2_DTO): CreateSubsystem2_DTO {
        return Subsystem2Service.updateSubsystem2(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        Subsystem2Service.deleteSubsystem2(id)
    }
}
