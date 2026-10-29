package kz.gazizbek.studentapi.config;

import kz.gazizbek.studentapi.student.Student;
import kz.gazizbek.studentapi.student.StudentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.util.List;

/** Inserts individual test data on the first start (empty table only). */
@Component
@ConditionalOnProperty(name = "student.seed-data", havingValue = "true")
public class StudentDataSeeder implements ApplicationRunner {

	private static final Logger log = LoggerFactory.getLogger(StudentDataSeeder.class);

	private final StudentRepository repository;
	private final String owner;

	public StudentDataSeeder(StudentRepository repository, @Value("${student.full-name}") String owner) {
		this.repository = repository;
		this.owner = owner;
	}

	@Override
	public void run(ApplicationArguments args) {
		log.info("Student API owner: {}", owner);
		if (repository.count() > 0) {
			log.info("Database already contains {} students, seed skipped", repository.count());
			return;
		}
		repository.saveAll(List.of(
				new Student("Batyr", "Gazizbek", "batyr.gazizbek@student.kz", "IT2-2301", 3),
				new Student("Aruzhan", "Seitkali", "aruzhan.seitkali@student.kz", "IT2-2301", 3),
				new Student("Nurlan", "Abenov", "nurlan.abenov@student.kz", "IT2-2302", 2)));
		log.info("Seeded {} students for {}", repository.count(), owner);
	}
}
