package com.example.demo.repository

import com.example.demo.model.Subsystem1
import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem3
import java.util.UUID

interface Subsystem3Repository : JpaRepository<Subsystem3, UUID> {
    fun findAllByProjectId(projectId: UUID): List<Subsystem3>
}
