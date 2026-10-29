package kz.gazizbek.studentapi.student;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "students")
@JsonPropertyOrder({"id", "firstName", "lastName", "email", "groupName", "course", "createdAt", "updatedAt"})
public class Student {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false, length = 60)
	private String firstName;

	@Column(nullable = false, length = 60)
	private String lastName;

	@Column(nullable = false, unique = true, length = 120)
	private String email;

	@Column(nullable = false, length = 20)
	private String groupName;

	@Column(nullable = false)
	private Integer course;

	private Instant createdAt;

	private Instant updatedAt;

	protected Student() {
	}

	public Student(String firstName, String lastName, String email, String groupName, Integer course) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.groupName = groupName;
		this.course = course;
	}

	@PrePersist
	void onCreate() {
		createdAt = Instant.now();
		updatedAt = createdAt;
	}

	@PreUpdate
	void onUpdate() {
		updatedAt = Instant.now();
	}

	public Long getId() {
		return id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public Integer getCourse() {
		return course;
	}

	public void setCourse(Integer course) {
		this.course = course;
	}

	public Instant getCreatedAt() {
		return createdAt;
	}

	public Instant getUpdatedAt() {
		return updatedAt;
	}
}
