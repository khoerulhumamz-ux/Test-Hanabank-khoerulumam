package id.khoerulumam.banking.config;

import id.khoerulumam.banking.model.BankUser;
import id.khoerulumam.banking.repository.BankUserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataSeeder {
    @Bean CommandLineRunner seedUsers(BankUserRepository users, PasswordEncoder encoder) {
        return args -> {
            if (users.count()==0) {
                users.save(new BankUser("umam", encoder.encode("Password123!"), "Khoerul Umam", "1000000001", 10_000_000));
                users.save(new BankUser("siti", encoder.encode("Password123!"), "Siti Aminah", "1000000002", 5_000_000));
            }
        };
    }
}
