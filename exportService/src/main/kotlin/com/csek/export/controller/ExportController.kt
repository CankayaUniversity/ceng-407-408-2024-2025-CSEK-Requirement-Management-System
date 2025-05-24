package com.csek.export.controller

import com.csek.export.dto.ExportRequest
import com.csek.export.service.ExportService
import org.springframework.core.io.ByteArrayResource
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/export")
class ExportController(
    private val exportService: ExportService
) {

    @PostMapping
    fun exportBaseline(@RequestBody request: ExportRequest): ResponseEntity<ByteArrayResource> {
        val (fileBytes, filename, mediaType) = when (request.format.lowercase()) {
            "word" -> {
                val bytes = exportService.exportWord(request)
                Triple(
                    bytes,
                    "${request.projectName}_${request.baselineName}.docx",
                    MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                )
            }
            "pdf" -> {
                val bytes = exportService.exportBaseline(request)
                Triple(
                    bytes,
                    "${request.projectName}_${request.baselineName}.pdf",
                    MediaType.APPLICATION_PDF
                )
            }
            else -> throw IllegalArgumentException("Geçersiz format: ${request.format}")
        }

        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=$filename")
            .contentLength(fileBytes.size.toLong())
            .contentType(mediaType)
            .body(ByteArrayResource(fileBytes))
    }
}