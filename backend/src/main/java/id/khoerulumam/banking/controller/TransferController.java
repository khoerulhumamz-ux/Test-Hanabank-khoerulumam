package id.khoerulumam.banking.controller;
import id.khoerulumam.banking.dto.TransferRequest;
import id.khoerulumam.banking.model.BankTransaction;
import id.khoerulumam.banking.service.BankingService;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/transfers")
public class TransferController {
    private final BankingService service;
    public TransferController(BankingService service){this.service=service;}
    @PostMapping("/overbooking") public BankTransaction transfer(Authentication auth,@Valid @RequestBody TransferRequest request){
        return service.transfer(auth.getName(),request);
    }
}
