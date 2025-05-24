package com.example.demo.controller

import org.springframework.web.bind.annotation.*
import com.example.demo.service.Subsystem2Service
import com.example.demo.DTO.CreateSubsystem2_DTO
import com.example.demo.model.Subsystem2
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import java.util.UUID

@RestController
@RequestMapping("/subsystem2")
class Subsystem2Controller(
    private val Subsystem2Service: Subsystem2Service
) {
    @GetMapping("/all")
    fun getAllSubsystem2Requirements(): ResponseEntity<List<CreateSubsystem2_DTO>> {
        return ResponseEntity.ok(Subsystem2Service.getAll())
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<Subsystem2> {
        return Subsystem2Service.getRequirementsByProjectId(projectId)
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
