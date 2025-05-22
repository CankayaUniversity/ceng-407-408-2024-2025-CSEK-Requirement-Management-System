package com.csek.export.util

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import org.apache.poi.util.Units
import org.apache.poi.xwpf.usermodel.Borders
import org.apache.poi.xwpf.usermodel.ParagraphAlignment
import org.apache.poi.xwpf.usermodel.XWPFDocument
import org.openxmlformats.schemas.wordprocessingml.x2006.main.*
import java.io.ByteArrayOutputStream
import java.math.BigInteger
import java.time.LocalDate
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter


object WordGenerator {

    fun generateWordFromBaseline(data: Map<String, String>, style: String = "table"): ByteArray {
        return when (style.lowercase()) {
            "table" -> generateTableStyleDoc(data)
            "document" -> generateDocumentStyleDoc(data)
            "book" -> generateBookStyleDoc(data)
            else -> generateTableStyleDoc(data)
        }
    }

    fun generateTableStyleDoc(data: Map<String, String>): ByteArray {

        val mapper = jacksonObjectMapper()
        val doc = XWPFDocument()
        val out = ByteArrayOutputStream()

        val infoJson = mapper.readTree(data["baseline-info"])
        val projectName = infoJson["projectName"]?.asText() ?: "-"
        val baselineName = infoJson["baselineName"]?.asText() ?: "-"
        val username = infoJson["username"]?.asText() ?: "-"
        val timestampRaw = infoJson["timestamp"]?.asText() ?: ""
        val correctedTimestamp = timestampRaw.replaceRange(11, 19, timestampRaw.substring(11, 19).replace('-', ':'))
        val formattedTimestamp = OffsetDateTime.parse(correctedTimestamp).toLocalDate().toString()
        val localDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE)

        val logoStream = javaClass.classLoader.getResourceAsStream("static/logo.png")
        if (logoStream != null) {
            doc.createParagraph().apply {
                alignment = ParagraphAlignment.CENTER
            }.createRun().apply {
                addPicture(
                    logoStream,
                    XWPFDocument.PICTURE_TYPE_PNG,
                    "logo.png",
                    Units.toEMU(60.0),
                    Units.toEMU(60.0)
                )
            }
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText(projectName)
            isBold = true
            fontSize = 20
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText("Gereksinim Raporu")
            isBold = true
            fontSize = 18
        }

        fun addLabeledLine(label: String, value: String) {
            doc.createParagraph().apply {
                spacingAfter = 0
                createRun().apply {
                    setText("$label: ")
                    isBold = true
                    isItalic = true
                    fontSize = 11
                }
                createRun().apply {
                    setText(value)
                    isItalic = true
                    fontSize = 11
                }
            }
        }

        doc.createParagraph().createRun()

        addLabeledLine("Sürüm", baselineName)
        addLabeledLine("Tarih", formattedTimestamp)
        addLabeledLine("Oluşturulma Zamanı", localDate)

        doc.createParagraph().createRun()

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
            val moduleJson = mapper.readTree(jsonContent)
            val requirements = moduleJson["requirements"]

            val moduleTitle = prettyModuleNames[moduleName] ?: moduleName
            doc.createParagraph().apply {
                spacingBefore = 300
            }.createRun().apply {
                setText(moduleTitle)
                isBold = true
                isItalic = true
                fontSize = 14
            }

            if (requirements == null || !requirements.isArray || requirements.size() == 0) {
                doc.createParagraph().createRun().apply {
                    setText("❌ Bu modülde gereksinim yok.")
                    fontSize = 11
                }
                return@forEach
            }

            val table = doc.createTable()
            val headerRow = table.getRow(0)

            table.getCTTbl().tblPr.tblW = CTTblWidth.Factory.newInstance().apply {
                type = STTblWidth.DXA
                w = BigInteger.valueOf(9072)
            }

            val cell1 = headerRow.getCell(0)
            cell1.removeParagraph(0)
            cell1.addParagraph().createRun().apply {
                setText("Başlık")
                isBold = true
            }
            cell1.setColor("D9D9D9")
            cell1.getCTTc().addNewTcPr().addNewTcW().w = BigInteger.valueOf(2000)

            val cell2 = headerRow.addNewTableCell()
            cell2.removeParagraph(0)
            cell2.addParagraph().createRun().apply {
                setText("Açıklama")
                isBold = true
            }
            cell2.setColor("D9D9D9")
            cell2.getCTTc().addNewTcPr().addNewTcW().w = BigInteger.valueOf(7072)

            for (req in requirements) {
                val row = table.createRow()

                val cell1 = row.getCell(0)
                cell1.removeParagraph(0)
                cell1.addParagraph().createRun().apply {
                    setText(req["title"]?.asText() ?: "-")
                    fontSize = 11
                }
                cell1.getCTTc().addNewTcPr().addNewTcW().w = BigInteger.valueOf(2000)

                val cell2 = if (row.tableCells.size > 1) {
                    row.getCell(1)
                } else {
                    row.addNewTableCell()
                }
                cell2.removeParagraph(0)
                cell2.addParagraph().createRun().apply {
                    setText(req["description"]?.asText() ?: "-")
                    fontSize = 11
                }
                cell2.getCTTc().addNewTcPr().addNewTcW().w = BigInteger.valueOf(7072)
            }

            doc.createParagraph().createRun().addBreak()
        }

        doc.write(out)
        return out.toByteArray()
    }

    fun generateDocumentStyleDoc(data: Map<String, String>): ByteArray {

        val mapper = jacksonObjectMapper()
        val doc = XWPFDocument()
        val out = ByteArrayOutputStream()

        val infoJson = mapper.readTree(data["baseline-info"])
        val projectName = infoJson["projectName"]?.asText() ?: "-"
        val baselineName = infoJson["baselineName"]?.asText() ?: "-"
        val username = infoJson["username"]?.asText() ?: "-"
        val timestampRaw = infoJson["timestamp"]?.asText() ?: ""
        val correctedTimestamp = timestampRaw.replaceRange(11, 19, timestampRaw.substring(11, 19).replace('-', ':'))
        val formattedTimestamp = OffsetDateTime.parse(correctedTimestamp).toLocalDate().toString()
        val localDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE)

        val logoStream = javaClass.classLoader.getResourceAsStream("static/logo.png")
        if (logoStream != null) {
            doc.createParagraph().apply {
                alignment = ParagraphAlignment.CENTER
            }.createRun().apply {
                addPicture(
                    logoStream,
                    XWPFDocument.PICTURE_TYPE_PNG,
                    "logo.png",
                    Units.toEMU(60.0),
                    Units.toEMU(60.0)
                )
            }
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText(projectName)
            isBold = true
            fontSize = 20
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText("Gereksinim Raporu")
            isBold = true
            fontSize = 18
        }

        fun addLabeledLine(label: String, value: String) {
            doc.createParagraph().apply {
                spacingAfter = 0
                createRun().apply {
                    setText("$label: ")
                    isBold = true
                    isItalic = true
                    fontSize = 11
                }
                createRun().apply {
                    setText(value)
                    isItalic = true
                    fontSize = 11
                }
            }
        }

        doc.createParagraph().createRun()

        addLabeledLine("Sürüm", baselineName)
        addLabeledLine("Tarih", formattedTimestamp)
        addLabeledLine("Oluşturulma Zamanı", localDate)

        doc.createParagraph().createRun()

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

        for (moduleKey in orderedModuleKeys) {
            val content = data[moduleKey] ?: continue
            val json = mapper.readTree(content)
            val requirements = json["requirements"]

            val moduleTitle = prettyModuleNames[moduleKey] ?: moduleKey
            doc.createParagraph().apply {
                spacingBefore = 500
                spacingAfter = 60
            }.createRun().apply {
                setText("📂 $moduleTitle")


                isBold = true
                isItalic = true
                fontSize = 14
            }

            if (requirements == null || !requirements.isArray || requirements.size() == 0) {
                doc.createParagraph().createRun().apply {
                    setText("❌ Bu modülde gereksinim yok.")
                    fontSize = 11
                }
                continue
            }

            for (req in requirements) {
                val id = req["title"]?.asText() ?: "-"
                val description = req["description"]?.asText() ?: "-"

                doc.createParagraph().createRun().apply {
                    setText("📌 [$id]")
                    fontSize = 12
                    isBold = true
                }

                doc.createParagraph().createRun().apply {
                    setText("📝 Açıklama: $description")
                    fontSize = 11
                }

                doc.createParagraph().createRun()
            }
        }

        doc.write(out)
        return out.toByteArray()
    }

    fun generateBookStyleDoc(data: Map<String, String>): ByteArray {

        val mapper = jacksonObjectMapper()
        val doc = XWPFDocument()
        val out = ByteArrayOutputStream()

        val infoJson = mapper.readTree(data["baseline-info"])
        val projectName = infoJson["projectName"]?.asText() ?: "-"
        val baselineName = infoJson["baselineName"]?.asText() ?: "-"
        val username = infoJson["username"]?.asText() ?: "-"
        val timestampRaw = infoJson["timestamp"]?.asText() ?: ""
        val correctedTimestamp = timestampRaw.replaceRange(11, 19, timestampRaw.substring(11, 19).replace('-', ':'))
        val formattedTimestamp = OffsetDateTime.parse(correctedTimestamp).toLocalDate().toString()
        val localDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE)

        val logoStream = javaClass.classLoader.getResourceAsStream("static/logo.png")
        if (logoStream != null) {
            doc.createParagraph().apply {
                alignment = ParagraphAlignment.CENTER
            }.createRun().apply {
                addPicture(
                    logoStream,
                    XWPFDocument.PICTURE_TYPE_PNG,
                    "logo.png",
                    Units.toEMU(60.0),
                    Units.toEMU(60.0)
                )
            }
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText(projectName)
            isBold = true
            fontSize = 20
        }

        doc.createParagraph().apply {
            alignment = ParagraphAlignment.CENTER
        }.createRun().apply {
            setText("Gereksinim Raporu")
            isBold = true
            fontSize = 18
        }

        fun addLabeledLine(label: String, value: String) {
            doc.createParagraph().apply {
                spacingAfter = 0
                createRun().apply {
                    setText("$label: ")
                    isBold = true
                    isItalic = true
                    fontSize = 11
                }
                createRun().apply {
                    setText(value)
                    isItalic = true
                    fontSize = 11
                }
            }
        }

        doc.createParagraph().createRun()

        addLabeledLine("Sürüm", baselineName)
        addLabeledLine("Tarih", formattedTimestamp)
        addLabeledLine("Oluşturulma Zamanı", localDate)

        doc.createParagraph().createRun()

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

        for (moduleKey in orderedModuleKeys) {
            val content = data[moduleKey] ?: continue
            val json = mapper.readTree(content)
            val requirements = json["requirements"]

            val moduleTitle = prettyModuleNames[moduleKey] ?: moduleKey
            doc.createParagraph().apply {
                spacingBefore = 500
                spacingAfter = 60
            }.createRun().apply {
                setText("📘 $moduleTitle")
                isBold = true
                isItalic = true
                fontSize = 14
            }

            if (requirements == null || !requirements.isArray || requirements.size() == 0) {
                doc.createParagraph().createRun().apply {
                    setText("❌ Bu modülde gereksinim yok.")
                    fontSize = 11
                }
                continue
            }

            for (req in requirements) {
                val id = req["title"]?.asText() ?: "-"
                val description = req["description"]?.asText() ?: "-"

                doc.createParagraph().apply {
                    spacingBefore = 200
                }.createRun().apply {
                    setText("📌 [$id]")
                    fontSize = 12
                    isBold = true
                }

                doc.createParagraph().apply {
                    spacingAfter = 40
                }.createRun().apply {
                    setText("📝 Açıklama: $description")
                    fontSize = 11
                    isItalic = true
                }

                doc.createParagraph().apply {
                    spacingAfter = 80
                    spacingBefore = 20
                    borderBottom = Borders.SINGLE
                }

                doc.createParagraph().createRun()
            }
        }

        doc.write(out)
        return out.toByteArray()

    }

}