package kz.gazizbek.studentapi;

import kz.gazizbek.studentapi.student.StudentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class StudentControllerTests {

	private static final String URL = "/api/gazizbek-batyr/students";

	private static final String BATYR = """
			{"firstName":"Batyr","lastName":"Gazizbek","email":"batyr.gazizbek@student.kz",
			 "groupName":"IT2-2301","course":3}
			""";

	@Autowired
	private MockMvc mvc;

	@Autowired
	private StudentRepository repository;

	@BeforeEach
	void cleanDatabase() {
		repository.deleteAll();
	}

	@Test
	void infoShowsStudentName() throws Exception {
		mvc.perform(get("/"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.student").value("Batyr Gazizbek"))
				.andExpect(jsonPath("$.studentId").value("38091"));
	}

	@Test
	void createsAndReadsStudent() throws Exception {
		String location = createBatyr().getResponse().getHeader("Location");

		mvc.perform(get(location))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.firstName").value("Batyr"))
				.andExpect(jsonPath("$.lastName").value("Gazizbek"));
		mvc.perform(get(URL))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$", hasSize(1)));
	}

	@Test
	void rejectsInvalidStudent() throws Exception {
		mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON)
						.content("{\"firstName\":\"\",\"lastName\":\"Gazizbek\",\"email\":\"not-an-email\",\"groupName\":\"IT2-2301\",\"course\":7}"))
				.andExpect(status().isBadRequest())
				.andExpect(jsonPath("$.status").value(400));
	}

	@Test
	void rejectsDuplicateEmail() throws Exception {
		createBatyr();
		mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(BATYR))
				.andExpect(status().isConflict());
	}

	@Test
	void updatesStudent() throws Exception {
		String location = createBatyr().getResponse().getHeader("Location");

		mvc.perform(put(location).contentType(MediaType.APPLICATION_JSON)
						.content("{\"firstName\":\"Batyr\",\"lastName\":\"Gazizbek\",\"email\":\"b.gazizbek@student.kz\",\"groupName\":\"IT2-2301\",\"course\":4}"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.email").value("b.gazizbek@student.kz"))
				.andExpect(jsonPath("$.course").value(4));
		mvc.perform(get(location))
				.andExpect(jsonPath("$.course").value(4));
	}

	@Test
	void updateOfMissingStudentReturns404() throws Exception {
		mvc.perform(put(URL + "/999999").contentType(MediaType.APPLICATION_JSON).content(BATYR))
				.andExpect(status().isNotFound());
	}

	@Test
	void deletesStudent() throws Exception {
		String location = createBatyr().getResponse().getHeader("Location");

		mvc.perform(delete(location)).andExpect(status().isNoContent());
		mvc.perform(get(location)).andExpect(status().isNotFound());
	}

	@Test
	void returns404ForMissingStudent() throws Exception {
		mvc.perform(get(URL + "/999999"))
				.andExpect(status().isNotFound())
				.andExpect(jsonPath("$.message").value("Student with id 999999 not found"));
	}

	private MvcResult createBatyr() throws Exception {
		return mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(BATYR))
				.andExpect(status().isCreated())
				.andExpect(header().exists("Location"))
				.andExpect(jsonPath("$.id").isNumber())
				.andReturn();
	}
}
