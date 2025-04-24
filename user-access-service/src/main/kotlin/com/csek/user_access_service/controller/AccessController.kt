package com.csek.user_access_service.controller

import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/access")
class AccessController {

    @GetMapping("/view")
    @PreAuthorize("hasRole('user') or hasRole('admin')")
    fun viewData(): String {
        return "Veri Görüntülendi"
    }

    @PostMapping("/update")
    @PreAuthorize("hasRole('admin')")
    fun updateData(@RequestBody body: String): String {
        return "Veri Güncellendi: $body"
    }

    @GetMapping("/viewadmin")
    @PreAuthorize("hasRole('admin')")
    fun adminData(): String {
        return "Admin Görüntülendi"
    }


}