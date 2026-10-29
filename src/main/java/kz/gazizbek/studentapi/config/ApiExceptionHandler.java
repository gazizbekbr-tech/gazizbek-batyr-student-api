package kz.gazizbek.studentapi.config;

import jakarta.servlet.http.HttpServletRequest;
import kz.gazizbek.studentapi.student.DuplicateEmailException;
import kz.gazizbek.studentapi.student.StudentNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

/** Turns application exceptions into readable JSON error responses. */
@RestControllerAdvice
public class ApiExceptionHandler {

	@ExceptionHandler(StudentNotFoundException.class)
	public ResponseEntity<Map<String, Object>> notFound(StudentNotFoundException ex, HttpServletRequest request) {
		return error(HttpStatus.NOT_FOUND, ex.getMessage(), request);
	}

	@ExceptionHandler(DuplicateEmailException.class)
	public ResponseEntity<Map<String, Object>> duplicate(DuplicateEmailException ex, HttpServletRequest request) {
		return error(HttpStatus.CONFLICT, ex.getMessage(), request);
	}

	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<Map<String, Object>> invalid(MethodArgumentNotValidException ex, HttpServletRequest request) {
		String message = ex.getBindingResult().getFieldErrors().stream()
				.map(e -> e.getField() + ": " + e.getDefaultMessage())
				.sorted()
				.collect(Collectors.joining("; "));
		return error(HttpStatus.BAD_REQUEST, message, request);
	}

	private ResponseEntity<Map<String, Object>> error(HttpStatus status, String message, HttpServletRequest request) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("timestamp", Instant.now().toString());
		body.put("status", status.value());
		body.put("error", status.getReasonPhrase());
		body.put("message", message);
		body.put("path", request.getRequestURI());
		return ResponseEntity.status(status).body(body);
	}
}
