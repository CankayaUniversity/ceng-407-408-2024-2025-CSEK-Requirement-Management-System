package com.example.demo.repository

import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem1
import java.util.UUID

interface SubsystemRepository : JpaRepository<Subsystem1, UUID>
