package com.example.demo.repository

import com.example.demo.model.SystemRequirements
import org.springframework.data.jpa.repository.JpaRepository

interface SystemRequirementRepository : JpaRepository<SystemRequirements, Long>
