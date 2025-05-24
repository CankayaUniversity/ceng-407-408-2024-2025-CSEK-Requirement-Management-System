package com.example.demo.model

import jakarta.persistence.*
import java.util.UUID

@Entity
@Table(name = "system_requirements")
data class SystemRequirements(

    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "uuid")
    val id: UUID? = null,

    @Column(nullable = false)
    val title: String = "",

    @Column(columnDefinition = "TEXT")
    val description: String = "",

    @Column( columnDefinition ="TEXT" )
    val createdBy: String="" ,

    @Column(nullable = false)
    val flag: Boolean = false,

    @Column(name = "ur_id", nullable = false, columnDefinition = "uuid")
    val user_req_id: UUID?=null,

    @Column(name = "projectId", nullable = false, columnDefinition = "uuid")
    val projectId: UUID = UUID.fromString("00000000-0000-0000-0000-000000000000")
)
