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

    @Column(nullable = false, columnDefinition = "TEXT")
    val createdBy: String = "sarper",

    @Column(columnDefinition = "TEXT")
    val flag: Boolean = false,

    @Column(name = "ur_id", updatable = true, nullable = true, columnDefinition = "uuid")
    val user_req_id: UUID? = null, //null olup olamayacağını sormam lazım
)