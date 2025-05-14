package com.example.demo.model

import jakarta.persistence.*

@Entity
@Table(name = "subsystem1header")
data class Subsystem1Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)