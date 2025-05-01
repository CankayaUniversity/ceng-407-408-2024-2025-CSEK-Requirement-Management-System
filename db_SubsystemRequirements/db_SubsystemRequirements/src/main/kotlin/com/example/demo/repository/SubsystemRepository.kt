package com.example.demo.repository

import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem
import java.util.UUID

interface SubsystemRepository : JpaRepository<Subsystem, UUID>
