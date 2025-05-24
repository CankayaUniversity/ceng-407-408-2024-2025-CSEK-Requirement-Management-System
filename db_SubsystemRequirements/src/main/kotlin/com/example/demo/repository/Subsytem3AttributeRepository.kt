package com.example.demo.repository

import com.example.demo.model.Subsystem3Attribute
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface Subsystem3AttributeRepository : JpaRepository<Subsystem3Attribute, UUID>
