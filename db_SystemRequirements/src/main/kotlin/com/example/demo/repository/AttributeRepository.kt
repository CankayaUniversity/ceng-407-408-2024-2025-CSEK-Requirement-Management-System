package com.example.demo.repository

import com.example.demo.model.Attribute
import org.springframework.data.jpa.repository.JpaRepository
import java.util.UUID

interface AttributeRepository : JpaRepository<Attribute, UUID>