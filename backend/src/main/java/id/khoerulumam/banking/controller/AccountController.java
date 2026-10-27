package id.khoerulumam.banking.controller;
import id.khoerulumam.banking.service.BankingService;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/accounts")
public class AccountController {
    private final BankingService service;
    public AccountController(BankingService service){this.service=service;}
    @GetMapping("/balance") public Object balance(Authentication auth){return service.balance(auth.getName());}
}
