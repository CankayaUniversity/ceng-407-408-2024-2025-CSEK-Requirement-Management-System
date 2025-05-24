package com.example.demo.model


import jakarta.persistence.*

@Entity
@Table(name = "subsystem2header")
data class Subsystem2Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)