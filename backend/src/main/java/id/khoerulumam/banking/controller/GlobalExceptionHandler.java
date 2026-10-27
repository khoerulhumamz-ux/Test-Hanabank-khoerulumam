package id.khoerulumam.banking.controller;
import id.khoerulumam.banking.dto.ApiError;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.*;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.time.Instant;
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiError> status(ResponseStatusException ex, HttpServletRequest req) {
        HttpStatus status=HttpStatus.valueOf(ex.getStatusCode().value());
        return ResponseEntity.status(status).body(new ApiError(Instant.now(),status.value(),status.getReasonPhrase(),ex.getReason(),req.getRequestURI()));
    }
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> validation(MethodArgumentNotValidException ex,HttpServletRequest req) {
        var status=HttpStatus.BAD_REQUEST;
        return ResponseEntity.badRequest().body(new ApiError(Instant.now(),400,"Bad Request","Input tidak valid: periksa field wajib dan nominal transfer",req.getRequestURI()));
    }
}
