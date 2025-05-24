package com.csek.snapshot

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SnapshotApplication

fun main(args: Array<String>) {
	runApplication<SnapshotApplication>(*args)
}
