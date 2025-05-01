package com.example.demo.controller

import org.springframework.web.bind.annotation.*
import com.example.demo.service.Subsystem2Service
import com.example.demo.DTO.Subsystem2_DTO

@RestController
@RequestMapping("/subsystem2")
class Subsystem2Controller(
    private val Subsystem2Service: Subsystem2Service
) {
    @GetMapping
    fun getAll(): List<Subsystem2_DTO> {
        return Subsystem2Service.getAll()
    }


    @PostMapping
    fun create(@RequestBody subsystemDto: Subsystem2_DTO): Subsystem2_DTO
    {
        return Subsystem2Service.createSubsystem2(subsystemDto)
    }
}
