package com.example.demo.repository

import com.example.demo.model.Subsystem2Attribute
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem2AttributeRepository : JpaRepository<Subsystem2Attribute, UUID>
