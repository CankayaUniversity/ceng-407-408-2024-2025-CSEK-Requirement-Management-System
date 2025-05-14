package com.csek.snapshot.kafka

import com.csek.snapshot.model.*
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue

@Service
class BaselineEventListener (
    private val restTemplate: RestTemplate
) {

    @KafkaListener(
        topics = ["baseline-csek"],
        groupId = "snapshot-baseline",
        containerFactory = "kafkaListenerContainerFactory"
    )
    fun listen(event: BaselineEvent) {
        println("📥 Event alındı: ${event.module}")

        if (event.module == "user-requirements") {
            val url_userreq = "http://localhost:9500/user-requirements/user-requirements"

            try {
                val response = restTemplate.getForObject(url_userreq, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val requirements: List<UserRequirement> = objectMapper.readValue(response!!)

                println("📦 Çekilen User Requirements verisi:")
                requirements.forEach {
                    println("    ID: ${it.id}")
                    println("    Başlık: ${it.title}")
                    println("    Açıklama: ${it.description}")
                    println("    Oluşturan: ${it.createdBy}")
                    println("    Flag: ${it.flag}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("User Requirement çekilemedi: ${ex.message}")
            }

            val url_userreq_attribute = "http://localhost:9500/user-requirements/attributes"

            try {
                val response = restTemplate.getForObject(url_userreq_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val attributes: List<UserRequirementAttribute> = objectMapper.readValue(response!!)

                println("📦 Çekilen User Requirement Attributes verisi:")
                attributes.forEach {
                    println("    ID: ${it.id}")
                    println("    Açıklama: ${it.description}")
                    println("    userRequirementId: ${it.userRequirementId}")
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("User Requirement Attributes çekilemedi: ${ex.message}")
            }

            val url_userreq_header = "http://localhost:9500/user-requirements/headers"

            try {
                val response = restTemplate.getForObject(url_userreq_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val header: List<UserRequirementHeader> = objectMapper.readValue(response!!)

                println("📦 Çekilen User Requirement Headers verisi:")
                header.forEach {
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("User Requirement Header çekilemedi: ${ex.message}")
            }
        }

        else if (event.module == "system-requirements") {
            val url_systemreq = "http://localhost:9500/system-requirements/system-requirements"

            try {
                val response = restTemplate.getForObject(url_systemreq, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val requirements: List<SystemRequirement> = objectMapper.readValue(response!!)

                println("📦 Çekilen System Requirements verisi:")
                requirements.forEach {
                    println("    ID: ${it.id}")
                    println("    Başlık: ${it.title}")
                    println("    Açıklama: ${it.description}")
                    println("    Oluşturan: ${it.createdBy}")
                    println("    LinkId: ${it.user_req_id}")
                    println("    Flag: ${it.flag}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("System Requirement çekilemedi: ${ex.message}")
            }

            val url_systemreq_attribute = "http://localhost:9500/system-requirements/attributes"

            try {
                val response = restTemplate.getForObject(url_systemreq_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val attributes: List<SystemRequirementAttribute> = objectMapper.readValue(response!!)

                println("📦 Çekilen System Requirement Attributes verisi:")
                attributes.forEach {
                    println("    ID: ${it.id}")
                    println("    Açıklama: ${it.description}")
                    println("    systemRequirementId: ${it.systemRequirementId}")
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("System Requirement Attributes çekilemedi: ${ex.message}")
            }

            val url_systemreq_header = "http://localhost:9500/system-requirements/headers"

            try {
                val response = restTemplate.getForObject(url_systemreq_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val header: List<SystemRequirementHeader> = objectMapper.readValue(response!!)

                println("📦 Çekilen System Requirement Headers verisi:")
                header.forEach {
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("System Requirement Header çekilemedi: ${ex.message}")
            }
        }

        else if (event.module == "subsystem1-requirements") {
            val url_subsystem1req = "http://localhost:9500/subsystem-requirements/subsystem1"

            try {
                val response = restTemplate.getForObject(url_subsystem1req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val requirements: List<Subsystem1Requirement> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 1 Requirements verisi:")
                requirements.forEach {
                    println("    ID: ${it.id}")
                    println("    Başlık: ${it.title}")
                    println("    Açıklama: ${it.description}")
                    println("    Oluşturan: ${it.createdBy}")
                    println("    LinkId: ${it.systemRequirementId}")
                    println("    Flag: ${it.flag}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement çekilemedi: ${ex.message}")
            }

            val url_subsystem1req_attribute = "http://localhost:9500/subsystem-requirements/subsystem1-attributes"

            try {
                val response = restTemplate.getForObject(url_subsystem1req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val attributes: List<Subsystem1RequirementAttribute> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 1 Requirement Attributes verisi:")
                attributes.forEach {
                    println("    ID: ${it.id}")
                    println("    Açıklama: ${it.description}")
                    println("    subsystem1RequirementId: ${it.subsystem1Id}")
                    println("    Header: ${it.title}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement Attributes çekilemedi: ${ex.message}")
            }

            val url_subsystem1req_header = "http://localhost:9500/subsystem-requirements/subsystem1-header"

            try {
                val response = restTemplate.getForObject(url_subsystem1req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val sub1headers: List<Subsystem1RequirementHeader> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 1 Requirement Headers verisi:")
                sub1headers.forEach {
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement Header çekilemedi: ${ex.message}")
            }
        }

        else if (event.module == "subsystem2-requirements") {
            val url_subsystem2req = "http://localhost:9500/subsystem-requirements/subsystem2"

            try {
                val response = restTemplate.getForObject(url_subsystem2req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val requirements: List<Subsystem2Requirement> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 2 Requirements verisi:")
                requirements.forEach {
                    println("    ID: ${it.id}")
                    println("    Başlık: ${it.title}")
                    println("    Açıklama: ${it.description}")
                    println("    Oluşturan: ${it.createdBy}")
                    println("    LinkId: ${it.systemRequirementId}")
                    println("    Flag: ${it.flag}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 2 Requirement çekilemedi: ${ex.message}")
            }

            val url_subsystem2req_attribute = "http://localhost:9500/subsystem-requirements/subsystem2-attributes"

            try {
                val response = restTemplate.getForObject(url_subsystem2req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val attributes: List<Subsystem2RequirementAttribute> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 2 Requirement Attributes verisi:")
                attributes.forEach {
                    println("    ID: ${it.id}")
                    println("    Açıklama: ${it.description}")
                    println("    subsystem2RequirementId: ${it.subsystem2Id}")
                    println("    Header: ${it.title}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 2 Requirement Attributes çekilemedi: ${ex.message}")
            }

            val url_subsystem2req_header = "http://localhost:9500/subsystem-requirements/subsystem2-header"

            try {
                val response = restTemplate.getForObject(url_subsystem2req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val sub2headers: List<Subsystem2RequirementHeader> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 1 Requirement Headers verisi:")
                sub2headers.forEach {
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 2 Requirement Header çekilemedi: ${ex.message}")
            }
        }

        else if (event.module == "subsystem3-requirements") {
            val url_subsystem3req = "http://localhost:9500/subsystem-requirements/subsystem3"

            try {
                val response = restTemplate.getForObject(url_subsystem3req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val requirements: List<Subsystem3Requirement> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 3 Requirements verisi:")
                requirements.forEach {
                    println("    ID: ${it.id}")
                    println("    Başlık: ${it.title}")
                    println("    Açıklama: ${it.description}")
                    println("    Oluşturan: ${it.createdBy}")
                    println("    LinkId: ${it.systemRequirementId}")
                    println("    Flag: ${it.flag}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 3 Requirement çekilemedi: ${ex.message}")
            }

            val url_subsystem3req_attribute = "http://localhost:9500/subsystem-requirements/subsystem3-attributes"

            try {
                val response = restTemplate.getForObject(url_subsystem3req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val attributes: List<Subsystem3RequirementAttribute> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 3 Requirement Attributes verisi:")
                attributes.forEach {
                    println("    ID: ${it.id}")
                    println("    Açıklama: ${it.description}")
                    println("    subsystem3RequirementId: ${it.subsystem3Id}")
                    println("    Header: ${it.title}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 3 Requirement Attributes çekilemedi: ${ex.message}")
            }

            val url_subsystem3req_header = "http://localhost:9500/subsystem-requirements/subsystem3-header"

            try {
                val response = restTemplate.getForObject(url_subsystem3req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val sub3headers: List<Subsystem3RequirementHeader> = objectMapper.readValue(response!!)

                println("📦 Çekilen Subsystem 3 Requirement Headers verisi:")
                sub3headers.forEach {
                    println("    Header: ${it.header}")
                    println("--------")
                }

            } catch (ex: Exception) {
                println("Subsystem 3 Requirement Header çekilemedi: ${ex.message}")
            }
        }
    }
}
