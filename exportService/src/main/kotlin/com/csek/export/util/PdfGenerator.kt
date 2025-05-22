package com.csek.export.util

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.lowagie.text.*
import com.lowagie.text.pdf.BaseFont
import com.lowagie.text.pdf.PdfPCell
import com.lowagie.text.pdf.PdfPTable
import com.lowagie.text.pdf.PdfWriter
import java.awt.Color
import java.io.ByteArrayOutputStream
import java.time.LocalDate
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter

object PdfGenerator {

    val baseFontRegular = BaseFont.createFont("fonts/OpenSans-Regular.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED)
    val baseFontBold = BaseFont.createFont("fonts/OpenSans-Bold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED)
    val baseFontItalic = BaseFont.createFont("fonts/OpenSans-Italic.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED)
    val baseFontBoldItalic = BaseFont.createFont("fonts/OpenSans-BoldItalic.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED)

    val fontRegular = Font(baseFontRegular, 11f)
    val fontBoldHeader = Font(baseFontBold, 20f, Font.BOLD)
    val fontBoldHeader2 = Font(baseFontBold, 18f, Font.BOLD)
    val fontHeader = Font(baseFontBold, 12f, Font.BOLD)
    val fontBoldItalic = Font(baseFontBoldItalic, 16f, Font.BOLDITALIC)
    val labelFont = Font(baseFontBoldItalic, 12f, Font.BOLDITALIC)
    val valueFont = Font(baseFontItalic, 12f,  Font.ITALIC)

    fun generatePdfFromBaseline(data: Map<String, String>): ByteArray {
        val document = Document()
        val outputStream = ByteArrayOutputStream()
        PdfWriter.getInstance(document, outputStream)

        val mapper = jacksonObjectMapper()
        document.open()

        val infoJson = mapper.readTree(data["baseline-info"])
        val projectName = infoJson["projectName"]?.asText() ?: ""
        val baselineName = infoJson["baselineName"]?.asText() ?: ""
        val username = infoJson["username"]?.asText() ?: ""
        val timestampRaw = infoJson["timestamp"]?.asText() ?: ""
        val correctedTimestamp = timestampRaw.replaceRange(11, 19, timestampRaw.substring(11, 19).replace('-', ':'))
        val formattedTimestamp = OffsetDateTime.parse(correctedTimestamp).toLocalDate().toString()
        val localDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE)

        val logoStream = javaClass.classLoader.getResourceAsStream("static/logo.png")
        val logoImage = Image.getInstance(logoStream.readAllBytes())
        logoImage.scaleToFit(80f, 80f)
        logoImage.setAbsolutePosition(450f, 730f)
        document.add(logoImage)

        val projectTitle = Paragraph(projectName, fontBoldHeader).apply {
            alignment = Element.ALIGN_CENTER
            spacingAfter = 5f
        }
        val reportTitle = Paragraph("Gereksinim Raporu", fontBoldHeader2).apply {
            alignment = Element.ALIGN_CENTER
            spacingAfter = 15f
        }

        document.add(projectTitle)
        document.add(reportTitle)

        fun labeledLine(label: String, value: String): Paragraph {
            return Paragraph().apply {
                add(Chunk("$label: ", labelFont))
                add(Chunk(value, valueFont))
                spacingAfter = 4f
            }
        }

        document.add(labeledLine("Sürüm", baselineName))
        document.add(labeledLine("Tarih", formattedTimestamp))
        document.add(labeledLine("Oluşturulma Zamanı", localDate))
        document.add(Chunk.NEWLINE)


        val prettyModuleNames = mapOf(
            "user-requirements" to "Kullanıcı Gereksinimleri",
            "system-requirements" to "Sistem Gereksinimleri",
            "subsystem1-requirements" to "Donanım Gereksinimleri",
            "subsystem2-requirements" to "Yazılım Gereksinimleri",
            "subsystem3-requirements" to "Güvenlik Gereksinimleri"
        )

        val orderedModuleKeys = listOf(
            "user-requirements",
            "system-requirements",
            "subsystem1-requirements",
            "subsystem2-requirements",
            "subsystem3-requirements"
        )

        orderedModuleKeys.forEach { moduleName ->
            val jsonContent = data[moduleName] ?: return@forEach

            val displayName = prettyModuleNames[moduleName] ?: moduleName
            val moduleTitle = Paragraph(displayName, fontBoldItalic).apply {
                spacingBefore = 12f
                spacingAfter = 10f
            }
            document.add(moduleTitle)

            val moduleJson = mapper.readTree(jsonContent)
            val requirements = moduleJson["requirements"]

            if (requirements == null || !requirements.isArray || requirements.size() == 0) {
                document.add(Paragraph("❌ Bu modülde gereksinim yok.\n"))
                return@forEach
            }

            val table = PdfPTable(2)
            table.widthPercentage = 100f
            table.setWidths(floatArrayOf(2f, 5f))

            val headerBackground = Color(220, 220, 220)

            val cellTitleHeader = PdfPCell(Phrase("Başlık", fontHeader)).apply {
                backgroundColor = headerBackground
                horizontalAlignment = Element.ALIGN_CENTER
                setPadding(6f)
            }
            val cellDescHeader = PdfPCell(Phrase("Açıklama", fontHeader)).apply {
                backgroundColor = headerBackground
                horizontalAlignment = Element.ALIGN_CENTER
                setPadding(6f)
            }

            table.addCell(cellTitleHeader)
            table.addCell(cellDescHeader)

            requirements.forEach {
                val title = it["title"]?.asText() ?: "-"
                val description = it["description"]?.asText() ?: "-"

                val titleCell = PdfPCell(Phrase(title, fontRegular)).apply {
                    setPadding(5f)
                }
                val descCell = PdfPCell(Phrase(description, fontRegular)).apply {
                    setPadding(5f)
                }

                table.addCell(titleCell)
                table.addCell(descCell)
            }

            document.add(table)
            document.add(Chunk.NEWLINE)
        }

        document.close()
        return outputStream.toByteArray()
    }
}