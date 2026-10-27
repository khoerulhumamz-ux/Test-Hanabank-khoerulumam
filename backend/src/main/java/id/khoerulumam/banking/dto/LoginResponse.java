package id.khoerulumam.banking.dto;
public record LoginResponse(String token, String tokenType, String username, String fullName, String accountNumber) {}
