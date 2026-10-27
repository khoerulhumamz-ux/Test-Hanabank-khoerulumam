package id.khoerulumam.banking.controller;
import id.khoerulumam.banking.dto.*;
import id.khoerulumam.banking.service.BankingService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/auth")
public class AuthController {
    private final BankingService service;
    public AuthController(BankingService service){this.service=service;}
    @PostMapping("/login") public LoginResponse login(@Valid @RequestBody LoginRequest request){return service.login(request);}
}
