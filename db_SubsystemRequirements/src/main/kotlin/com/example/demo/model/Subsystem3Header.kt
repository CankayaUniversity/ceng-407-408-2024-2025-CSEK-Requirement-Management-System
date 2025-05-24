package com.example.demo.model

import jakarta.persistence.*

@Entity
@Table(name = "subsystem3header")
data class Subsystem3Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)