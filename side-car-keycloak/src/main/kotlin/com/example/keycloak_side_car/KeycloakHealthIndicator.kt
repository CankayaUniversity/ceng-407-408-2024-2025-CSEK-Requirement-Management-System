package com.example.keycloak_side_car

import org.springframework.boot.actuate.health.Health
import org.springframework.boot.actuate.health.HealthIndicator
import org.springframework.stereotype.Component
import org.springframework.web.client.RestTemplate

@Component
class KeycloakHealthIndicator : HealthIndicator {
    private val restTemplate = RestTemplate()

    override fun health(): Health {
        return try {
            val response = restTemplate.getForEntity("http://localhost:8081/realms/myrealm1", String::class.java)
            if (response.statusCode.is2xxSuccessful) {
                Health.up().withDetail("Keycloak", "Available").build()
            } else {
                Health.down().withDetail("Keycloak", "Unavailable").build()
            }
        } catch (ex: Exception) {
            Health.down().withDetail("Keycloak Error", ex.message).build()
        }
    }
}
