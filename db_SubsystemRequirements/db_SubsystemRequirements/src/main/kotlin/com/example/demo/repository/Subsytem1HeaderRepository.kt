package com.example.demo.repository


import com.example.demo.model.Subsystem1Header
import org.springframework.data.jpa.repository.JpaRepository

interface HeaderRepository : JpaRepository<Subsystem1Header, String>