package com.example.demo.controller

import com.example.demo.DTO.Subsystem1_DTO
import com.example.demo.service.SubsystemService
import org.springframework.web.bind.annotation.*

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
}
