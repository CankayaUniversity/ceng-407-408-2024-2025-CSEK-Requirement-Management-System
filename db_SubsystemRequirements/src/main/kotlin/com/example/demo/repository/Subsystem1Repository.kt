package com.example.demo.repository

import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem1
import java.util.UUID

interface Subsystem1Repository : JpaRepository<Subsystem1, UUID> {
    fun findAllByProjectId(projectId: UUID): List<Subsystem1>
}
