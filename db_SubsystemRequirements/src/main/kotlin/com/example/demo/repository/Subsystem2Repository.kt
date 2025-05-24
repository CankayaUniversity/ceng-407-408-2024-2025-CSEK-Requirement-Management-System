package com.example.demo.repository

import com.example.demo.model.Subsystem1
import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem2
import java.util.UUID

interface Subsystem2Repository : JpaRepository<Subsystem2, UUID> {
    fun findAllByProjectId(projectId: UUID): List<Subsystem2>
}
