package id.khoerulumam.banking.controller;
import id.khoerulumam.banking.model.BankTransaction;
import id.khoerulumam.banking.service.BankingService;
import org.springframework.data.domain.Page;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/transactions")
public class TransactionController {
    private final BankingService service;
    public TransactionController(BankingService service){this.service=service;}
    @GetMapping public Page<BankTransaction> history(Authentication auth,
        @RequestParam(defaultValue="0") int page,@RequestParam(defaultValue="20") int size){
        return service.history(auth.getName(),page,size);
    }
    @GetMapping("/{id}") public BankTransaction detail(Authentication auth,@PathVariable Long id){
        return service.detail(auth.getName(),id);
    }
}
