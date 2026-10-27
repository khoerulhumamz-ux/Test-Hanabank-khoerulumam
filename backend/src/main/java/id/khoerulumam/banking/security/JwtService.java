package id.khoerulumam.banking.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {
    @Value("${app.jwt.secret}") private String secret;
    @Value("${app.jwt.expiration-minutes}") private long expirationMinutes;
    private SecretKey key() { return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8)); }
    public String generate(String username) {
        Date now = new Date();
        return Jwts.builder().subject(username).issuedAt(now)
            .expiration(new Date(now.getTime() + expirationMinutes * 60_000))
            .signWith(key()).compact();
    }
    public String extractUsername(String token) {
        return Jwts.parser().verifyWith(key()).build().parseSignedClaims(token).getPayload().getSubject();
    }
}
