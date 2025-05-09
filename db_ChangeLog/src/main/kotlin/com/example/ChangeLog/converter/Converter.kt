package com.example.ChangeLog.converter


import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import jakarta.persistence.AttributeConverter
import jakarta.persistence.Converter

@Converter
class StringListConverter : AttributeConverter<List<String>, String> {
    private val objectMapper = jacksonObjectMapper()

    override fun convertToDatabaseColumn(attribute: List<String>?): String {
        return objectMapper.writeValueAsString(attribute ?: emptyList<String>())
    }

    override fun convertToEntityAttribute(dbData: String?): List<String> {
        return if (dbData.isNullOrBlank()) emptyList() else objectMapper.readValue(dbData, List::class.java).map { it.toString() }
    }
}