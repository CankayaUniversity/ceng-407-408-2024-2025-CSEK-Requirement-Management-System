package com.project.projectName.service

import com.project.projectName.DTO.ProjectDTO
import com.project.projectName.model.Project
import com.project.projectName.repository.ProjectRepository
import org.springframework.stereotype.Service
import java.util.*

@Service
class ProjectService(private val repository: ProjectRepository) {

    fun getAllProjects(): List<Project> = repository.findAll()

    fun createProject(dto: ProjectDTO): Project {
        val project = Project(name = dto.name)
        return repository.save(project)
    }

    fun getProjectById(id: UUID): Project? = repository.findById(id).orElse(null)

    fun deleteProject(id: UUID) {
        if (repository.existsById(id)) {
            repository.deleteById(id)
        } else {
            throw NoSuchElementException("Project with ID $id not found.")
        }
    }
}
