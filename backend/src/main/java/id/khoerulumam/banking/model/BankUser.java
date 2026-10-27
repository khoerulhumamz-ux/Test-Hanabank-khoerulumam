package id.khoerulumam.banking.model;

import jakarta.persistence.*;

@Entity
@Table(name = "bank_users")
public class BankUser {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable=false, unique=true) private String username;
    @Column(nullable=false) private String passwordHash;
    @Column(nullable=false) private String fullName;
    @Column(nullable=false, unique=true) private String accountNumber;
    @Column(nullable=false) private long balance;

    protected BankUser() {}
    public BankUser(String username, String passwordHash, String fullName, String accountNumber, long balance) {
        this.username=username; this.passwordHash=passwordHash; this.fullName=fullName;
        this.accountNumber=accountNumber; this.balance=balance;
    }
    public Long getId(){return id;}
    public String getUsername(){return username;}
    public String getPasswordHash(){return passwordHash;}
    public String getFullName(){return fullName;}
    public String getAccountNumber(){return accountNumber;}
    public long getBalance(){return balance;}
    public void setBalance(long balance){this.balance=balance;}
}
