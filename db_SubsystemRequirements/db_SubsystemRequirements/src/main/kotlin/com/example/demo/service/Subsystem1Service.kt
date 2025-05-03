package com.example.demo.service

import com.example.demo.DTO.Subsystem1_DTO
import com.example.demo.model.Subsystem1
import com.example.demo.repository.SubsystemRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem1Service(
    private val subsystemRepository: SubsystemRepository
) {

    fun createSubsystem(dto: Subsystem1_DTO): Subsystem1_DTO {
        val entity = Subsystem1(
            id = null,
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag
        )

        val saved = subsystemRepository.save(entity)

        return Subsystem1_DTO(
            id = saved.id,
            title = saved.title,
            definition = saved.definition,
            systemRequirementId = saved.systemRequirementId,
            flag = saved.flag
        )
    }

    fun getAll(): List<Subsystem1_DTO> {
        return subsystemRepository.findAll().map {
            Subsystem1_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag
            )
        }
    }

    fun updateSubsystem(id: UUID, dto: Subsystem1_DTO): Subsystem1_DTO {
        val existing = subsystemRepository.findById(id)
            .orElseThrow { NoSuchElementException("Subsystem1 not found with id: $id") }

        val updated = existing.copy(
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag
        )

        return subsystemRepository.save(updated).let {
            Subsystem1_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag
            )
        }
    }

    fun deleteSubsystem(id: UUID) {
        if (!subsystemRepository.existsById(id)) {
            throw NoSuchElementException("Subsystem1 not found with id: $id")
        }
        subsystemRepository.deleteById(id)
    }
}
