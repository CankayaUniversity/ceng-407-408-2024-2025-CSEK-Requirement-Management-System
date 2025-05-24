package com.csek.export.service

import com.csek.export.dto.ExportRequest
import com.csek.export.util.PdfGenerator
import com.csek.export.util.WordGenerator
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate


@Service
class ExportService {

    fun exportBaseline(request: ExportRequest): ByteArray {

        val url = "http://localhost:9500/snapshot/baselines/content" +
                "?projectName=${request.projectName}&baselineName=${request.baselineName}"

        val restTemplate = RestTemplate()

        @Suppress("UNCHECKED_CAST")
        val response = restTemplate.getForObject(url, Map::class.java) as Map<String, String>

        val pdfBytes = PdfGenerator.generatePdfFromBaseline(response)

        return pdfBytes
    }

    fun exportWord(request: ExportRequest): ByteArray {
        val url = "http://localhost:9500/snapshot/baselines/content" +
                "?projectName=${request.projectName}&baselineName=${request.baselineName}"

        val restTemplate = RestTemplate()

        @Suppress("UNCHECKED_CAST")
        val response = restTemplate.getForObject(url, Map::class.java) as Map<String, String>

        val wordBytes = WordGenerator.generateWordFromBaseline(response, request.wordStyle)


        return wordBytes
    }

}
