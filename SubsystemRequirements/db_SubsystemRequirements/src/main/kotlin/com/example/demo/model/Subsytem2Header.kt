package com.example.demo.model


import jakarta.persistence.*

@Entity
@Table(name = "subsytem2header")
data class Subsytem2Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)