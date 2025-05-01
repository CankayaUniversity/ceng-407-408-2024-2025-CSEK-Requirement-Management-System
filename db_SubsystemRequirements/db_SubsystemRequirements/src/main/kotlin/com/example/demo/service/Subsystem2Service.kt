package com.example.demo.service

import org.springframework.stereotype.Service
import com.example.demo.model.Subsystem2
import com.example.demo.repository.Subsystem2Repository

import com.example.demo.DTO.Subsystem2_DTO

@Service
class Subsystem2Service(
    private val subsystem2Repository: Subsystem2Repository,

) {

    fun createSubsystem2(dto: Subsystem2_DTO): Subsystem2_DTO {



        val entity = Subsystem2(
            title = dto.title,
            definition = dto.definition,
            systemRequirementId = dto.systemRequirementId,
            flag = dto.flag,

        )

        val saved = subsystem2Repository.save(entity)

        return Subsystem2_DTO(
            id = saved.id,
            title = saved.title,
            definition = saved.definition,
            systemRequirementId = saved.systemRequirementId,
            flag = saved.flag,
        )
    }
    fun getAll(): List<Subsystem2_DTO> {
        return subsystem2Repository.findAll().map {
            Subsystem2_DTO(
                id = it.id,
                title = it.title,
                definition = it.definition,
                systemRequirementId = it.systemRequirementId,
                flag = it.flag
            )
        }
    }

}
