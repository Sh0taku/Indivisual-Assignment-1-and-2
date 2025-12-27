<%-- 
    Document   : viewProfiles
    Created on : Dec 20, 2025, 4:29:04 PM
    Author     : Emir
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.individualapp.ProfileBean"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profiles Database</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            color: white;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 16px;
        }

        .nav-menu {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .search-box {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-form input {
            flex: 1;
            padding: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 16px;
        }

        .search-form input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .search-form button {
            padding: 12px 25px;
            background: #2196F3;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        .profiles-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .profiles-table th {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .profiles-table td {
            padding: 15px;
            color: white;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(255, 255, 255, 0.05);
        }

        .profiles-table tr:last-child td {
            border-bottom: none;
        }

        .delete-btn {
            background: #F44336;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: rgba(255, 255, 255, 0.7);
        }

        .empty-state h3 {
            color: white;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .empty-state a {
            color: #4FC3F7;
            text-decoration: none;
            font-weight: bold;
        }

        .stats {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }

        .stats span {
            color: #4FC3F7;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .card {
                padding: 20px;
            }
            
            .nav-menu {
                flex-direction: column;
                align-items: center;
            }
            
            .search-form {
                flex-direction: column;
            }
            
            .profiles-table {
                display: block;
                overflow-x: auto;
            }
        }
   
    
    
    
    
    
    
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Student Profiles Data Base</h1>
                <p>View all student profiles</p>
            </div>
            
            <div class="nav-menu">
                <a href="index.html">Create New Profile</a>
                <a href="TheSecServlet?action=view">Refresh</a>
            </div>
            
            <div class="search-box">
                <form action="TheSecServlet" method="GET" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Search by name or student ID..." required>
                    <button type="submit">Search</button>
                </form>
            </div>
            
            <%
                List<ProfileBean> profiles = (List<ProfileBean>) request.getAttribute("profiles");
                if (profiles != null && !profiles.isEmpty()) {
            %>
            
            <table class="profiles-table">
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Name</th>
                        <th>Program</th>
                        <th>Email</th>
                        <th>Hobbies</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ProfileBean profile : profiles) { %>
                    <tr>
                        <td><%= profile.getStudentId() %></td>
                        <td><%= profile.getName() %></td>
                        <td><%= profile.getProgram() %></td>
                        <td><%= profile.getEmail() %></td>
                        <td><%= profile.getHobbies() %></td>
                        <td>
                            <a href="TheSecServlet?action=delete&studentId=<%= profile.getStudentId() %>" 
                               class="delete-btn"
                               onclick="return confirm('Are you sure you want to delete this profile?')">
                                Delete
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            
            <div class="stats">
                Total Profiles: <span><%= profiles.size() %></span>
            </div>
            
            <% } else { %>
            
            <div class="empty-state">
                <h3>No profiles found</h3>
                <p>Create your first profile!</p>
                <p><a href="index.html">Create Profile</a></p>
            </div>
            
            <% } %>
        </div>
    </div>
</body>
</html>