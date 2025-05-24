package com.example.demo.controller

import com.example.demo.DTO.CreateSubsystem1_DTO
import com.example.demo.model.Subsystem1
import com.example.demo.service.Subsystem1Service
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID
import org.springframework.http.HttpStatus

@RestController
@RequestMapping("/subsystem1")
class Subsystem1Controller(
    private val subsystem1Service: Subsystem1Service
) {

    @GetMapping("/all")
    fun getAllSubsystem1Requirements(): ResponseEntity<List<CreateSubsystem1_DTO>> {
        return ResponseEntity.ok(subsystem1Service.getAll())
    }

    @GetMapping("/{projectId}")
    fun getByProjectId(@PathVariable projectId: UUID): List<Subsystem1> {
        return subsystem1Service.getRequirementsByProjectId(projectId)
    }

    @PostMapping
    fun createSubsystem1Requirement(@RequestBody dto: CreateSubsystem1_DTO): ResponseEntity<CreateSubsystem1_DTO> {
        val saved = subsystem1Service.createSubsystem1(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(saved)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: CreateSubsystem1_DTO): ResponseEntity<CreateSubsystem1_DTO> {
        val updated = subsystem1Service.updateSubsystem1(id, dto)
        return ResponseEntity.ok(updated)
    }


    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<Void> {
        subsystem1Service.deleteSubsystem(id)
        return ResponseEntity.noContent().build()
    }

}
