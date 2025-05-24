package com.csek.snapshot.kafka

import com.csek.snapshot.model.*
import com.csek.snapshot.service.SnapshotUploader
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue

@Service
class BaselineEventListener (
    private val restTemplate: RestTemplate,
    private val snapshotUploader: SnapshotUploader
) {

    @KafkaListener(
        topics = ["baseline-csek"],
        groupId = "snapshot-baseline",
        containerFactory = "kafkaListenerContainerFactory"
    )
    fun listen(event: BaselineEvent) {
        //println("📥 Event alındı: ${event.module}(Baseline name: ${event.description})  (Proje: ${event.projectName}) ( / ${event.projectId}) (User Name: ${event.username}) (Time Stamp: ${event.timestamp})")

        if (event.module == "user-requirements") {
            val url_userreq = "http://api-gateway:9500/user-requirements/user-requirements/${event.projectId}"
            val url_userreq_attribute = "http://api-gateway:9500/user-requirements/attributes"
            val url_userreq_header = "http://api-gateway:9500/user-requirements/headers"

            var requirements: List<UserRequirement> = emptyList()
            var attributes: List<UserRequirementAttribute> = emptyList()
            var header: List<UserRequirementHeader> = emptyList()

            try {
                val response = restTemplate.getForObject(url_userreq, String::class.java)
                val objectMapper = jacksonObjectMapper()
                requirements = objectMapper.readValue(response!!)

            } catch (ex: Exception) {
                println("User Requirement çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_userreq_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allAttributes: List<UserRequirementAttribute> = objectMapper.readValue(response!!)

                val requirementIds = requirements.mapNotNull { it.id }.toSet()
                attributes = allAttributes.filter { it.userRequirementId in requirementIds }

            } catch (ex: Exception) {
                println("User Requirement Attributes çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_userreq_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allHeaders: List<UserRequirementHeader> = objectMapper.readValue(response!!)

                val usedHeaders = attributes.map { it.header }.toSet()
                header = allHeaders.filter { it.header in usedHeaders }


            } catch (ex: Exception) {
                println("User Requirement Header çekilemedi: ${ex.message}")
            }

            snapshotUploader.uploadJsonToS3(
                mapOf(
                    "requirements" to requirements,
                    "attributes" to attributes,
                    "headers" to header
                ),
                event
            )
        }

        else if (event.module == "system-requirements") {
            val url_systemreq = "http://api-gateway:9500/system-requirements/system-requirements/${event.projectId}"
            val url_systemreq_attribute = "http://api-gateway:9500/system-requirements/attributes"
            val url_systemreq_header = "http://api-gateway:9500/system-requirements/headers"

            var requirements: List<SystemRequirement> = emptyList()
            var attributes: List<SystemRequirementAttribute> = emptyList()
            var header: List<SystemRequirementHeader> = emptyList()

            try {
                val response = restTemplate.getForObject(url_systemreq, String::class.java)
                val objectMapper = jacksonObjectMapper()
                requirements = objectMapper.readValue(response!!)

            } catch (ex: Exception) {
                println("System Requirement çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_systemreq_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allAttributes: List<SystemRequirementAttribute> = objectMapper.readValue(response!!)

                val requirementIds = requirements.mapNotNull { it.id }.toSet()
                attributes = allAttributes.filter { it.systemRequirementId in requirementIds }

            } catch (ex: Exception) {
                println("System Requirement Attributes çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_systemreq_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allHeaders: List<SystemRequirementHeader> = objectMapper.readValue(response!!)

                val usedHeaders = attributes.map { it.header }.toSet()
                header = allHeaders.filter { it.header in usedHeaders }

            } catch (ex: Exception) {
                println("System Requirement Header çekilemedi: ${ex.message}")
            }

            snapshotUploader.uploadJsonToS3(
                mapOf(
                    "requirements" to requirements,
                    "attributes" to attributes,
                    "headers" to header
                ),
                event
            )
        }

        else if (event.module == "subsystem1-requirements") {
            val url_subsystem1req = "http://api-gateway:9500/subsystem-requirements/subsystem1/${event.projectId}"
            val url_subsystem1req_attribute = "http://api-gateway:9500/subsystem-requirements/subsystem1-attributes"
            val url_subsystem1req_header = "http://api-gateway:9500/subsystem-requirements/subsystem1-header"

            var requirements: List<Subsystem1Requirement> = emptyList()
            var attributes: List<Subsystem1RequirementAttribute> = emptyList()
            var sub1headers: List<Subsystem1RequirementHeader> = emptyList()

            try {
                val response = restTemplate.getForObject(url_subsystem1req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                requirements = objectMapper.readValue(response!!)

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem1req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allAttributes: List<Subsystem1RequirementAttribute> = objectMapper.readValue(response!!)

                val requirementIds = requirements.mapNotNull { it.id }.toSet()
                attributes = allAttributes.filter { it.subsystem1Id in requirementIds }

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement Attributes çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem1req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allHeaders: List<Subsystem1RequirementHeader> = objectMapper.readValue(response!!)

                val usedHeaders = attributes.map { it.title }.toSet()
                sub1headers = allHeaders.filter { it.header in usedHeaders }

            } catch (ex: Exception) {
                println("Subsystem 1 Requirement Header çekilemedi: ${ex.message}")
            }

            snapshotUploader.uploadJsonToS3(
                mapOf(
                    "requirements" to requirements,
                    "attributes" to attributes,
                    "headers" to sub1headers
                ),
                event
            )
        }

        else if (event.module == "subsystem2-requirements") {
            val url_subsystem2req = "http://api-gateway:9500/subsystem-requirements/subsystem2/${event.projectId}"
            val url_subsystem2req_attribute = "http://api-gateway:9500/subsystem-requirements/subsystem2-attributes"
            val url_subsystem2req_header = "http://api-gateway:9500/subsystem-requirements/subsystem2-header"

            var requirements: List<Subsystem2Requirement> = emptyList()
            var attributes: List<Subsystem2RequirementAttribute> = emptyList()
            var sub2headers: List<Subsystem2RequirementHeader> = emptyList()

            try {
                val response = restTemplate.getForObject(url_subsystem2req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                requirements = objectMapper.readValue(response!!)

            } catch (ex: Exception) {
                println("Subsystem 2 Requirement çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem2req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allAttributes: List<Subsystem2RequirementAttribute> = objectMapper.readValue(response!!)

                val requirementIds = requirements.mapNotNull { it.id }.toSet()
                attributes = allAttributes.filter { it.subsystem2Id in requirementIds }

            } catch (ex: Exception) {
                println("Subsystem 2 Requirement Attributes çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem2req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allHeaders: List<Subsystem2RequirementHeader> = objectMapper.readValue(response!!)

                val usedHeaders = attributes.map { it.title }.toSet()
                sub2headers = allHeaders.filter { it.header in usedHeaders }


            } catch (ex: Exception) {
                println("Subsystem 2 Requirement Header çekilemedi: ${ex.message}")
            }

            snapshotUploader.uploadJsonToS3(
                mapOf(
                    "requirements" to requirements,
                    "attributes" to attributes,
                    "headers" to sub2headers
                ),
                event
            )
        }

        else if (event.module == "subsystem3-requirements") {
            val url_subsystem3req = "http://api-gateway:9500/subsystem-requirements/subsystem3/${event.projectId}"
            val url_subsystem3req_attribute = "http://api-gateway:9500/subsystem-requirements/subsystem3-attributes"
            val url_subsystem3req_header = "http://api-gateway:9500/subsystem-requirements/subsystem3-header"

            var requirements: List<Subsystem3Requirement> = emptyList()
            var attributes: List<Subsystem3RequirementAttribute> = emptyList()
            var sub3headers: List<Subsystem3RequirementHeader> = emptyList()

            try {
                val response = restTemplate.getForObject(url_subsystem3req, String::class.java)
                val objectMapper = jacksonObjectMapper()
                requirements = objectMapper.readValue(response!!)

            } catch (ex: Exception) {
                println("Subsystem 3 Requirement çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem3req_attribute, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allAttributes: List<Subsystem3RequirementAttribute> = objectMapper.readValue(response!!)

                val requirementIds = requirements.mapNotNull { it.id }.toSet()
                attributes = allAttributes.filter { it.subsystem3Id in requirementIds }


            } catch (ex: Exception) {
                println("Subsystem 3 Requirement Attributes çekilemedi: ${ex.message}")
            }

            try {
                val response = restTemplate.getForObject(url_subsystem3req_header, String::class.java)
                val objectMapper = jacksonObjectMapper()
                val allHeaders: List<Subsystem3RequirementHeader> = objectMapper.readValue(response!!)

                val usedHeaders = attributes.map { it.title }.toSet()
                sub3headers = allHeaders.filter { it.header in usedHeaders }


            } catch (ex: Exception) {
                println("Subsystem 3 Requirement Header çekilemedi: ${ex.message}")
            }

            snapshotUploader.uploadJsonToS3(
                mapOf(
                    "requirements" to requirements,
                    "attributes" to attributes,
                    "headers" to sub3headers
                ),
                event
            )
        }
    }
}
