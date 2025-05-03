package com.example.demo.repository

import com.example.demo.model.Subsystem1Attribute
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem1AttributeRepository : JpaRepository<Subsystem1Attribute, UUID>
