package com.csek.export.dto

data class ExportRequest(
    val projectName: String,
    val baselineName: String,
    val format: String = "",
    val wordStyle: String = "",
)