package com.example.demo.model

import jakarta.persistence.*

@Entity
@Table(name = "subsytem3headers")
data class Subsytem3Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)