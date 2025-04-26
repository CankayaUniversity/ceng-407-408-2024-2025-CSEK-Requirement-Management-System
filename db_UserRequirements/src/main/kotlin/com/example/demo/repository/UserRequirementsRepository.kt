package com.example.demo.repository

import com.example.demo.model.UserRequirements
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRequirementsRepository : JpaRepository<UserRequirements, Long>

