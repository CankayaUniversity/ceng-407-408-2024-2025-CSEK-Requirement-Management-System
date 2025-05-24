package com.csek.snapshot.service

import com.csek.snapshot.kafka.BaselineEvent
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.stereotype.Service
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.PutObjectRequest
import java.io.File
import java.nio.file.Paths

@Service
class SnapshotUploader(private val s3Client: S3Client) {

    private val bucketName = "csek-snapshots"

    fun uploadJsonToS3(data: Any, event: BaselineEvent) {
        val objectMapper = ObjectMapper()

        val safeTimestamp = event.timestamp.replace(":", "-")
        val safeDescription = event.description.replace(" ", "_").replace(":", "-")
        val projectFolder = event.projectName.replace(" ", "_")
        val fileName = "${event.module}.json"

        val localDir = File("temp_snapshots")
        if (!localDir.exists()) {
            localDir.mkdirs()
        }

        val filePath = "${localDir.path}/$fileName"
        val file = File(filePath)

        objectMapper.writeValue(file, data)

        val folderName = "${safeDescription}_$safeTimestamp"

        createMetadata(event, folderName)

        val s3Key = "baselines/$projectFolder/$folderName/$fileName"

        val putRequest = PutObjectRequest.builder()
            .bucket(bucketName)
            .key(s3Key)
            .build()

        s3Client.putObject(putRequest, Paths.get(filePath))

    }

    private fun createMetadata(event: BaselineEvent, folderName: String) {
        val metadata = mapOf(
            "projectName" to event.projectName,
            "baselineName" to event.description,
            "username" to event.username,
            "timestamp" to event.timestamp
        )

        val objectMapper = ObjectMapper()
        val metadataFileName = "baseline-info.json"
        val localFile = File("temp_snapshots/$metadataFileName")
        objectMapper.writeValue(localFile, metadata)

        val s3Key = "baselines/${event.projectName.replace(" ", "_")}/$folderName/$metadataFileName"

        val doesExist = try {
            s3Client.headObject { it.bucket(bucketName).key(s3Key) }
            true
        } catch (e: Exception) {
            false
        }

        if (!doesExist) {
            s3Client.putObject(
                PutObjectRequest.builder().bucket(bucketName).key(s3Key).build(),
                Paths.get(localFile.path)
            )

        } else {
            //println("ℹ️ metadata.json zaten var, tekrar yazılmadı.")
        }
    }

}
