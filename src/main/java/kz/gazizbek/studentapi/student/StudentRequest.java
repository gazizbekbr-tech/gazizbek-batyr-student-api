package kz.gazizbek.studentapi.student;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/** Request body for creating a student. */
public record StudentRequest(
		@NotBlank @Size(max = 60) String firstName,
		@NotBlank @Size(max = 60) String lastName,
		@NotBlank @Email @Size(max = 120) String email,
		@NotBlank @Size(max = 20) String groupName,
		@NotNull @Min(1) @Max(4) Integer course) {
}
