package com.example.basictodoappspring;

import com.example.basictodoappspring.model.ToDo;
import com.example.basictodoappspring.repository.ToDoRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.ArrayList;
import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ToDoIntegrationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ToDoRepository toDoRepository;

    private List<ToDo> testToDos;

    @BeforeEach
    public void setup() {
        testToDos = new ArrayList<>();

        ToDo toDo1 = toDoRepository.save(new ToDo(null, "Test ToDo 1", false));
        ToDo toDo2 = toDoRepository.save(new ToDo(null, "Test ToDo 2", false));

        testToDos.add(toDo1);
        testToDos.add(toDo2);
    }

    @AfterEach
    public void cleanup() {
        toDoRepository.deleteAll(testToDos);
    }

    @Test
    public void testCreateToDo() throws Exception {
        ToDo newTodo = new ToDo(null, "Test ToDo", false);

        mockMvc.perform(post("/api/todos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(newTodo)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Test ToDo"))
                .andExpect(jsonPath("$.isCompleted").value(false));
    }

    @Test
    public void testGetAllToDos() throws Exception {
        mockMvc.perform(get("/api/todos"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testUpdateToDo() throws Exception {
        Long todoId = 8L;
        ToDo updatedTodo = new ToDo(todoId, "Updated ToDo", true);

        mockMvc.perform(put("/api/todos/" + todoId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updatedTodo)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(todoId))
                .andExpect(jsonPath("$.title").value("Updated ToDo"))
                .andExpect(jsonPath("$.isCompleted").value(true));
    }

    @Test
    public void testDeleteToDo() throws Exception {
        Long todoId = 2L;

        mockMvc.perform(delete("/api/todos/" + todoId))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/todos" + todoId))
                .andExpect(status().isNotFound());
    }
}
