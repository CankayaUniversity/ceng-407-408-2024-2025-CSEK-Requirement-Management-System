package com.example.demo.repository

import com.example.demo.model.Subsystem2Header
import org.springframework.data.jpa.repository.JpaRepository

interface Header2Repository : JpaRepository<Subsystem2Header, String>