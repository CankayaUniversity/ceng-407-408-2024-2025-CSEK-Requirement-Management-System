package com.example.demo.service

import com.example.demo.model.Subsystem3
import com.example.demo.repository.Subsystem3Repository
import com.example.demo.DTO.Subsystem3_DTO
import org.springframework.stereotype.Service
import java.util.*

@Service
class Subsystem3Service(
    private val Subsystem3Repository: Subsystem3Repository
) {

    fun createNotificationSubsystem(dto: Subsystem3_DTO): Subsystem3_DTO {
        val entity = Subsystem3(
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,
        )

        val saved = Subsystem3Repository.save(entity)

        return Subsystem3_DTO(
            id = saved.id,
            title = saved.title,
            definition = saved.definition,
            systemRequirementId = saved.systemRequirementId,
            flag = saved.flag,
        )
    }

    fun getAllSubsystem3(): List<Subsystem3_DTO> {
        return Subsystem3Repository.findAll().map {
            Subsystem3_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag,
            )
        }
    }

    fun updateSubsystem3(id: UUID, dto: Subsystem3_DTO): Subsystem3_DTO {
        val existing = Subsystem3Repository.findById(id)
            .orElseThrow { NoSuchElementException("Subsystem3 not found: $id") }

        val updated = existing.copy(
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag
        )

        return Subsystem3Repository.save(updated).let {
            Subsystem3_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag
            )
        }
    }

    fun deleteSubsystem3(id: UUID) {
        if (!Subsystem3Repository.existsById(id)) {
            throw NoSuchElementException("Subsystem3 not found: $id")
        }
        Subsystem3Repository.deleteById(id)
    }
}
