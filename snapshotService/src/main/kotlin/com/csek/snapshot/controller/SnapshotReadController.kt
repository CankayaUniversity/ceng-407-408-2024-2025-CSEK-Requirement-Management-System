package com.csek.snapshot.controller

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import org.springframework.web.bind.annotation.*
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.*
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.File
import com.fasterxml.jackson.databind.JsonNode

@RestController
@RequestMapping("/baselines")
class SnapshotReadController(private val s3Client: S3Client) {

    private val bucketName = "csek-snapshots"

    @GetMapping
    fun listBaselines(@RequestParam projectName: String): List<String> {
        val safeProjectName = projectName.replace(" ", "_")
        val prefix = "baselines/$safeProjectName/"

        val request = ListObjectsV2Request.builder()
            .bucket(bucketName)
            .prefix(prefix)
            .delimiter("/")
            .build()

        val result = s3Client.listObjectsV2(request)
        return result.commonPrefixes().map { it.prefix().removePrefix(prefix).removeSuffix("/") }
    }

    @GetMapping("/content")
    fun getBaselineContent(
        @RequestParam projectName: String,
        @RequestParam baselineName: String
    ): Map<String, Any> {
        val safeProjectName = projectName.replace(" ", "_")
        val prefix = "baselines/$safeProjectName/$baselineName/"

        val listRequest = ListObjectsV2Request.builder()
            .bucket(bucketName)
            .prefix(prefix)
            .build()

        val response = s3Client.listObjectsV2(listRequest)

        val result = mutableMapOf<String, Any>()

        for (s3Object in response.contents()) {
            val getRequest = GetObjectRequest.builder()
                .bucket(bucketName)
                .key(s3Object.key())
                .build()

            s3Client.getObject(getRequest).use { inputStream ->
                val content = BufferedReader(InputStreamReader(inputStream)).readText()
                val fileName = s3Object.key().split("/").last().removeSuffix(".json")
                result[fileName] = content
            }
        }

        return result
    }

    @RestController
    @RequestMapping("/baseline")
    class BaselineDiffController(
        private val s3Client: S3Client
    ) {
        private val bucketName = "csek-snapshots"
        private val modules = listOf(
            "user-requirements",
            "system-requirements",
            "subsystem1-requirements",
            "subsystem2-requirements",
            "subsystem3-requirements"
        )

        @GetMapping("/compare")
        fun compareBaselines(
            @RequestParam projectName: String,
            @RequestParam baseline1: String,
            @RequestParam baseline2: String
        ): Map<String, Any> {
            val objectMapper = jacksonObjectMapper()
            val result = mutableMapOf<String, Any>()

            modules.forEach { module ->
                val key1 = "baselines/${projectName.replace(" ", "_")}/$baseline1/$module.json"
                val key2 = "baselines/${projectName.replace(" ", "_")}/$baseline2/$module.json"

                try {
                    val response1 = s3Client.getObjectAsBytes(
                        GetObjectRequest.builder().bucket(bucketName).key(key1).build()
                    ).asUtf8String()

                    val response2 = s3Client.getObjectAsBytes(
                        GetObjectRequest.builder().bucket(bucketName).key(key2).build()
                    ).asUtf8String()

                    val json1 = objectMapper.readTree(response1)
                    val json2 = objectMapper.readTree(response2)

                    val list1 = json1["requirements"] ?: objectMapper.createArrayNode()
                    val list2 = json2["requirements"] ?: objectMapper.createArrayNode()

                    val map1 = list1.associateBy { it["id"]?.asText() }
                    val map2 = list2.associateBy { it["id"]?.asText() }

                    val added = map2.filterKeys { it !in map1.keys }.values.toList()
                    val removed = map1.filterKeys { it !in map2.keys }.values.toList()
                    val updated = map1.keys.intersect(map2.keys).mapNotNull { id ->
                        val a = map1[id]!!
                        val b = map2[id]!!
                        if (a["title"] != b["title"] || a["description"] != b["description"]) {
                            mapOf("id" to id, "before" to a, "after" to b)
                        } else null
                    }

                    result[module] = mapOf(
                        "added" to added,
                        "removed" to removed,
                        "updated" to updated
                    )

                } catch (e: Exception) {
                    result[module] = "Karşılaştırma başarısız: ${e.message}"
                }

            }

            return result
        }
    }

}
