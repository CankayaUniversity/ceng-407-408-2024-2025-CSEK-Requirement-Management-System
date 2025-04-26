package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
@Table(name = "user_requirements")
data class UserRequirements(


    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,

    @Column(nullable = false)
    val title: String = "",

    @Column(columnDefinition = "TEXT")
    val description: String = "",

    @Column(nullable = false, columnDefinition = "TEXT")
    val createdBy: String = "sarper",

    @Column(columnDefinition = "TEXT")
    val flag: Boolean = false
)