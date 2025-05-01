package com.example.demo.service

import com.example.demo.DTO.Subsystem1_DTO
import com.example.demo.model.Subsystem
import com.example.demo.repository.SubsystemRepository

import org.springframework.stereotype.Service
import java.util.UUID

@Service
class SubsystemService(
    private val subsystemRepository: SubsystemRepository,

) {

    fun createSubsystem(dto: Subsystem1_DTO): Subsystem1_DTO {


        val entity = Subsystem(
            id = null,
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,

        )

        val saved = subsystemRepository.save(entity)

        return Subsystem1_DTO(
            id = saved.id,
            title = saved.title,
            definition = saved.definition,
            systemRequirementId = saved.systemRequirementId,
            flag = saved.flag,

        )
    }


    fun getAll(): List<Subsystem1_DTO> {
        return subsystemRepository.findAll().map {
            Subsystem1_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag,
            )
        }
    }
}
