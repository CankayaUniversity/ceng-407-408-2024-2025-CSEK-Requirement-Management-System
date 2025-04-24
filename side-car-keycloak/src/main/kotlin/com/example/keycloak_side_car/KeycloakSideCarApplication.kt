package com.example.keycloak_side_car

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class KeycloakSideCarApplication

fun main(args: Array<String>) {
	runApplication<KeycloakSideCarApplication>(*args)
}
