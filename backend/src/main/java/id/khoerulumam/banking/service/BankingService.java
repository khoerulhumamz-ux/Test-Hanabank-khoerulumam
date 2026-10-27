package id.khoerulumam.banking.service;

import id.khoerulumam.banking.dto.*;
import id.khoerulumam.banking.model.*;
import id.khoerulumam.banking.repository.*;
import id.khoerulumam.banking.security.JwtService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
import java.util.UUID;

@Service
public class BankingService {
    private final BankUserRepository users;
    private final BankTransactionRepository transactions;
    private final PasswordEncoder encoder;
    private final JwtService jwt;
    public BankingService(BankUserRepository users, BankTransactionRepository transactions, PasswordEncoder encoder, JwtService jwt) {
        this.users=users; this.transactions=transactions; this.encoder=encoder; this.jwt=jwt;
    }
    public LoginResponse login(LoginRequest request) {
        BankUser user=users.findByUsername(request.username()).orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED,"Username atau password salah"));
        if (!encoder.matches(request.password(), user.getPasswordHash())) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,"Username atau password salah");
        return new LoginResponse(jwt.generate(user.getUsername()), "Bearer", user.getUsername(), user.getFullName(), user.getAccountNumber());
    }
    public BankUser currentUser(String username) {
        return users.findByUsername(username).orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED,"User tidak ditemukan"));
    }
    public Object balance(String username) {
        BankUser u=currentUser(username);
        return java.util.Map.of("accountNumber",u.getAccountNumber(),"balance",u.getBalance(),"currency","IDR");
    }
    @Transactional
    public BankTransaction transfer(String username, TransferRequest request) {
        BankUser source=currentUser(username);
        BankUser target=users.findByAccountNumber(request.targetAccountNumber())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,"Rekening tujuan tidak ditemukan"));
        if (source.getAccountNumber().equals(target.getAccountNumber())) throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Rekening tujuan tidak boleh sama dengan rekening asal");
        if (request.amount() <= 0) throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Nominal transfer harus lebih besar dari 0");
        if (source.getBalance() < request.amount()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"Saldo tidak mencukupi");
        source.setBalance(source.getBalance()-request.amount());
        target.setBalance(target.getBalance()+request.amount());
        users.save(source); users.save(target);
        String desc=(request.description()==null || request.description().isBlank()) ? "Transfer antar rekening" : request.description().trim();
        return transactions.save(new BankTransaction("TRX-"+UUID.randomUUID().toString().substring(0,8).toUpperCase(),
            source.getAccountNumber(),target.getAccountNumber(),request.amount(),desc,"SUCCESS",Instant.now()));
    }
    public Page<BankTransaction> history(String username, int page, int size) {
        BankUser user=currentUser(username);
        int safePage=Math.max(page,0), safeSize=Math.max(1,Math.min(size,100));
        return transactions.findBySourceAccountOrTargetAccountOrderByCreatedAtDesc(
            user.getAccountNumber(),user.getAccountNumber(),PageRequest.of(safePage,safeSize));
    }
    public BankTransaction detail(String username, Long id) {
        String account=currentUser(username).getAccountNumber();
        return transactions.findByIdAndSourceAccountOrIdAndTargetAccount(id,account,id,account)
            .orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND,"Transaksi tidak ditemukan"));
    }
}
