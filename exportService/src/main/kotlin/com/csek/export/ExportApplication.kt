package com.csek.export

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class ExportApplication

fun main(args: Array<String>) {
	runApplication<ExportApplication>(*args)
}
