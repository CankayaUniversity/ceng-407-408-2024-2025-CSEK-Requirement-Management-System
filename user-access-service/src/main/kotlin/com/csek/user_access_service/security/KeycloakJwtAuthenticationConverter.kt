package com.csek.user_access_service.security

import org.springframework.core.convert.converter.Converter
import org.springframework.security.authentication.AbstractAuthenticationToken
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.oauth2.jwt.Jwt
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken

class KeycloakJwtAuthenticationConverter(
    private val clientIdList: List<String>
) : Converter<Jwt, AbstractAuthenticationToken> {

    override fun convert(jwt: Jwt): AbstractAuthenticationToken {
        val authorities = extractAuthorities(jwt)
        return JwtAuthenticationToken(jwt, authorities)
    }

    private fun extractAuthorities(jwt: Jwt): Collection<GrantedAuthority> {
        val realmRoles = (jwt.claims["realm_access"] as? Map<*, *>)?.get("roles") as? List<*> ?: emptyList<Any>()

        val clientRoles = clientIdList.flatMap { clientId ->
            val resourceAccess = jwt.claims["resource_access"] as? Map<*, *>
            val client = resourceAccess?.get(clientId) as? Map<*, *>
            val roles = client?.get("roles") as? List<*>
            roles ?: emptyList<Any>()
        }

        return (realmRoles + clientRoles).mapNotNull {
            it?.toString()?.let { roleName -> SimpleGrantedAuthority("ROLE_$roleName") }
        }
    }
}
