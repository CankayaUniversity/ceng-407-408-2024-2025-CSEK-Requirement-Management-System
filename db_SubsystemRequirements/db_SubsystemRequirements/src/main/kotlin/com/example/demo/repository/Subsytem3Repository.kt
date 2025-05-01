package com.example.demo.repository

import org.springframework.data.jpa.repository.JpaRepository
import com.example.demo.model.Subsystem3
import java.util.UUID

interface Subsystem3Repository : JpaRepository<Subsystem3, UUID>
