package id.khoerulumam.banking.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
public record TransferRequest(@NotBlank String targetAccountNumber, @Positive long amount, String description) {}
