package kz.gazizbek.studentapi.info;

import kz.gazizbek.studentapi.student.StudentController;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.info.BuildProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

/** Shows who owns this application and which version is running. */
@RestController
public class InfoController {

	private final String fullName;
	private final String group;
	private final String studentId;
	private final String version;

	public InfoController(@Value("${student.full-name}") String fullName,
			@Value("${student.group}") String group,
			@Value("${student.id}") String studentId,
			ObjectProvider<BuildProperties> buildProperties) {
		this.fullName = fullName;
		this.group = group;
		this.studentId = studentId;
		BuildProperties build = buildProperties.getIfAvailable();
		this.version = build != null ? build.getVersion() : "dev";
	}

	@GetMapping({"/", "/api/gazizbek-batyr/info"})
	public Map<String, Object> info() {
		Map<String, Object> info = new LinkedHashMap<>();
		info.put("application", "gazizbek-batyr-student-api");
		info.put("student", fullName);
		info.put("group", group);
		info.put("studentId", studentId);
		info.put("version", version);
		info.put("studentsEndpoint", StudentController.BASE_PATH);
		return info;
	}
}
