package com.project.projectName.controller

import com.project.projectName.DTO.ProjectDTO
import com.project.projectName.model.Project
import com.project.projectName.service.ProjectService
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/projects")
@CrossOrigin // frontend için
class ProjectController(private val projectService: ProjectService) {

    @GetMapping
    fun getAllProjects(): List<Project> = projectService.getAllProjects()

    @GetMapping("/{id}")
    fun getProject(@PathVariable id: UUID): Project? = projectService.getProjectById(id)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun createProject(@RequestBody dto: ProjectDTO): Project =
        projectService.createProject(dto)

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteProject(@PathVariable id: UUID) {
        projectService.deleteProject(id)
    }
}