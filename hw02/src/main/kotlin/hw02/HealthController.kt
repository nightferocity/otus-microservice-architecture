package hw02

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HealthController {

    @GetMapping("/health", "/health/")
    fun health(): Map<String, String> = mapOf("status" to "OK")
}
