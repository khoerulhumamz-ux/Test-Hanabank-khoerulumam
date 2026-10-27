package id.khoerulumam.banking.model;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "bank_transactions")
public class BankTransaction {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(nullable=false) private String referenceNumber;
    @Column(nullable=false) private String sourceAccount;
    @Column(nullable=false) private String targetAccount;
    @Column(nullable=false) private long amount;
    @Column(nullable=false) private String description;
    @Column(nullable=false) private String status;
    @Column(nullable=false) private Instant createdAt;

    protected BankTransaction() {}
    public BankTransaction(String referenceNumber, String sourceAccount, String targetAccount,
                           long amount, String description, String status, Instant createdAt) {
        this.referenceNumber=referenceNumber; this.sourceAccount=sourceAccount; this.targetAccount=targetAccount;
        this.amount=amount; this.description=description; this.status=status; this.createdAt=createdAt;
    }
    public Long getId(){return id;}
    public String getReferenceNumber(){return referenceNumber;}
    public String getSourceAccount(){return sourceAccount;}
    public String getTargetAccount(){return targetAccount;}
    public long getAmount(){return amount;}
    public String getDescription(){return description;}
    public String getStatus(){return status;}
    public Instant getCreatedAt(){return createdAt;}
}
