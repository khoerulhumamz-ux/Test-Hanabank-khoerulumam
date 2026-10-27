package id.khoerulumam.banking.repository;
import id.khoerulumam.banking.model.BankTransaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface BankTransactionRepository extends JpaRepository<BankTransaction, Long> {
    Page<BankTransaction> findBySourceAccountOrTargetAccountOrderByCreatedAtDesc(String source, String target, Pageable pageable);
    Optional<BankTransaction> findByIdAndSourceAccountOrIdAndTargetAccount(Long id1, String source, Long id2, String target);
}
