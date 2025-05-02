package com.example.demo.repository

import com.example.demo.model.Header
import org.springframework.data.jpa.repository.JpaRepository

interface HeaderRepository : JpaRepository<Header, String>