package id.khoerulumam.banking.repository;
import id.khoerulumam.banking.model.BankUser;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface BankUserRepository extends JpaRepository<BankUser, Long> {
    Optional<BankUser> findByUsername(String username);
    Optional<BankUser> findByAccountNumber(String accountNumber);
}
