package kz.gazizbek.studentapi.student;

import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<Student, Long> {

	boolean existsByEmailIgnoreCase(String email);
}
