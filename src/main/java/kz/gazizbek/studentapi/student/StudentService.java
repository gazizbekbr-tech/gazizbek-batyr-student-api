package kz.gazizbek.studentapi.student;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class StudentService {

	private final StudentRepository repository;

	public StudentService(StudentRepository repository) {
		this.repository = repository;
	}

	@Transactional(readOnly = true)
	public List<Student> findAll() {
		return repository.findAll(Sort.by("id"));
	}

	@Transactional(readOnly = true)
	public Student findById(Long id) {
		return repository.findById(id).orElseThrow(() -> new StudentNotFoundException(id));
	}

	public Student create(StudentRequest request) {
		if (repository.existsByEmailIgnoreCase(request.email())) {
			throw new DuplicateEmailException(request.email());
		}
		Student student = new Student(request.firstName(), request.lastName(), request.email(),
				request.groupName(), request.course());
		return repository.save(student);
	}

	public Student update(Long id, StudentRequest request) {
		Student student = findById(id);
		boolean emailChanged = !student.getEmail().equalsIgnoreCase(request.email());
		if (emailChanged && repository.existsByEmailIgnoreCase(request.email())) {
			throw new DuplicateEmailException(request.email());
		}
		student.setFirstName(request.firstName());
		student.setLastName(request.lastName());
		student.setEmail(request.email());
		student.setGroupName(request.groupName());
		student.setCourse(request.course());
		return repository.saveAndFlush(student);
	}

	public void delete(Long id) {
		Student student = findById(id);
		repository.delete(student);
	}
}
