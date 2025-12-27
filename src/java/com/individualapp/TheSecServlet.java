/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.individualapp;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 *
 * @author Emir
 */
@WebServlet("/TheSecServlet")
public class TheSecServlet extends HttpServlet {
    
    private static final String DB_URL = "jdbc:derby://localhost:1527/student_profiles;create=true";
    private static final String DB_USER = "app";
    private static final String DB_PASS = "app";
    
    @Override
    public void init() throws ServletException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            createTableIfNotExists();
        } catch (ClassNotFoundException e) {
            throw new ServletException("Database initialization failed", e);
        }
    }
    
    //testing database in servlet?
    private void createTableIfNotExists() {
        String sql = "CREATE TABLE profiles (" +
                     "id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), " +
                     "name VARCHAR(100) NOT NULL, " +
                     "student_id VARCHAR(50) UNIQUE NOT NULL, " +
                     "program VARCHAR(100), " +
                     "email VARCHAR(100), " +
                     "hobbies VARCHAR(255), " +
                     "introduction CLOB, " +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                     "PRIMARY KEY (id)" +
                     ")";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table 'profiles' created successfully.");
        } catch (SQLException e) {
            System.out.println("Table already exists or error: " + e.getMessage());
        }
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        //Getter form data
        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String program = request.getParameter("program");
        String email = request.getParameter("email");
        String hobbies = request.getParameter("hobbies");
        String introduction = request.getParameter("introduction");
        
        if (name == null || name.trim().isEmpty() || 
            studentId == null || studentId.trim().isEmpty()) {
            response.sendRedirect("index.html?error=missing_fields");
            return;
        }
        
        // Save to database
        boolean success = saveToDatabase(name, studentId, program, email, hobbies, introduction);
        
        if (success) {
            ProfileBean profile = new ProfileBean();
            profile.setName(name);
            profile.setStudentId(studentId);
            profile.setProgram(program);
            profile.setEmail(email);
            profile.setHobbies(hobbies);
            profile.setIntroduction(introduction);
            
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.html?error=database_error");
        }
    }
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("index.html");
            return;
        }
        
        switch (action) {
            case "view":
                List<ProfileBean> profiles = getAllProfiles();
                request.setAttribute("profiles", profiles);
                request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
                break;
                
            case "search":
                String keyword = request.getParameter("keyword");
                if (keyword == null || keyword.trim().isEmpty()) {
                    response.sendRedirect("TheSecServlet?action=view");
                    return;
                }
                List<ProfileBean> searchResults = searchProfiles(keyword);
                request.setAttribute("profiles", searchResults);
                request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
                break;
                
            case "delete":
                String studentId = request.getParameter("studentId");
                if (studentId != null && !studentId.trim().isEmpty()) {
                    deleteProfile(studentId);
                }
                response.sendRedirect("TheSecServlet?action=view");
                break;
                
            default:
                response.sendRedirect("index.html");
        }
    }
    
    //DATABASE under here
    
    private boolean saveToDatabase(String name, String studentId, String program, 
                                  String email, String hobbies, String introduction) {
        String sql = "INSERT INTO profiles (name, student_id, program, email, hobbies, introduction) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, name);
            stmt.setString(2, studentId);
            stmt.setString(3, program);
            stmt.setString(4, email);
            stmt.setString(5, hobbies);
            stmt.setString(6, introduction);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            return false;
        }
    }
    
    //
    private List<ProfileBean> getAllProfiles() {
        List<ProfileBean> profiles = new ArrayList<>();
        String sql = "SELECT * FROM profiles ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setName(rs.getString("name"));
                profile.setStudentId(rs.getString("student_id"));
                profile.setProgram(rs.getString("program"));
                profile.setEmail(rs.getString("email"));
                profile.setHobbies(rs.getString("hobbies"));
                profile.setIntroduction(rs.getString("introduction"));
                profiles.add(profile);
            }
            
        } catch (SQLException e) {
        }
        
        return profiles;
    }
    
    
    //SEARCH function
    private List<ProfileBean> searchProfiles(String keyword) {
        List<ProfileBean> profiles = new ArrayList<>();
        String sql = "SELECT * FROM profiles WHERE name LIKE ? OR student_id LIKE ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setName(rs.getString("name"));
                profile.setStudentId(rs.getString("student_id"));
                profile.setProgram(rs.getString("program"));
                profile.setEmail(rs.getString("email"));
                profile.setHobbies(rs.getString("hobbies"));
                profile.setIntroduction(rs.getString("introduction"));
                profiles.add(profile);
            }
            
        } catch (SQLException e) {
        }
        
        return profiles;
    }
    
    
    //DELETE function 
    private void deleteProfile(String studentId) {
        String sql = "DELETE FROM profiles WHERE student_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
        }
    }
}