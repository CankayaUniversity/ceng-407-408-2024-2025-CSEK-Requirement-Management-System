package com.example.demo.controller

import com.example.demo.DTO.Subsystem3_DTO
import com.example.demo.service.Subsystem3Service
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/subsystem3")
class Subsystem3Controller(
    private val subsystem3Service: Subsystem3Service
) {

    @GetMapping
    fun getAll(): List<Subsystem3_DTO> {
        return subsystem3Service.getAllSubsystem3()
    }

    @PostMapping
    fun create(@RequestBody dto: Subsystem3_DTO): Subsystem3_DTO {
        return subsystem3Service.createNotificationSubsystem(dto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody dto: Subsystem3_DTO): Subsystem3_DTO {
        return subsystem3Service.updateSubsystem3(id, dto)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID) {
        subsystem3Service.deleteSubsystem3(id)
    }
}
