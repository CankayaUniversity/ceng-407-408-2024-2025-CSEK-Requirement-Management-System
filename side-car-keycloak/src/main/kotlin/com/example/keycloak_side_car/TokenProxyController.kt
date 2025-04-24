package com.example.keycloak_side_car

import org.springframework.http.*
import org.springframework.web.bind.annotation.*
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder

@RestController
@RequestMapping("/oidc")
class TokenProxyController {

    private val restTemplate = RestTemplate()

    @PostMapping("/token")
    fun getToken(@RequestParam username: String,
                 @RequestParam password: String): ResponseEntity<String> {

        val keycloakTokenUrl = "http://localhost:8081/realms/myrealm1/protocol/openid-connect/token"

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED

        val form = LinkedHashMap<String, String>()
        form["grant_type"] = "password"
        form["client_id"] = "spring_client"
        form["username"] = username
        form["password"] = password

        val body = UriComponentsBuilder.newInstance()
            .queryParam("grant_type", form["grant_type"])
            .queryParam("client_id", form["client_id"])
            .queryParam("username", form["username"])
            .queryParam("password", form["password"])
            .build()
            .toUriString()
            .removePrefix("?")

        val entity = HttpEntity(body, headers)

        return try {
            val response = restTemplate.exchange(
                keycloakTokenUrl,
                HttpMethod.POST,
                entity,
                String::class.java
            )
            ResponseEntity.status(response.statusCode).body(response.body)
        } catch (ex: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("{\"error\": \"${ex.message}\"}")
        }
    }
}
