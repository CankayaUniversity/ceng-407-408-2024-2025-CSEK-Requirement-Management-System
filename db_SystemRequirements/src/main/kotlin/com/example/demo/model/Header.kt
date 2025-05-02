package com.example.demo.model

import jakarta.persistence.*

@Entity
@Table(name = "headers")
data class Header(

    @Id
    @Column(name = "header", nullable = false)
    val header: String =""
)