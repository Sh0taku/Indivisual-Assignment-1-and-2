<%-- 
    Document   : viewProfiles
    Created on : Dec 20, 2025, 10:17:04 AM
    Author     : Emir
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.individualapp.ProfileBean"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Saved Successfully</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 800px;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 40px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h2 {
            color: white;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 16px;
        }

        .success-message {
            text-align: center;
            color: #4CAF50;
            font-size: 18px;
            margin-bottom: 30px;
            font-weight: bold;
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

        .profile-info {
            margin-bottom: 30px;
        }

        .info-section {
            margin-bottom: 25px;
        }

        .info-label {
            color: #4FC3F7;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .info-value {
            color: white;
            font-size: 16px;
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            border-left: 3px solid #4FC3F7;
        }

        .intro-text {
            color: white;
            font-size: 16px;
            line-height: 1.6;
            padding: 15px;
            background: rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            color: white;
        }

        .btn-primary {
            background: #2196F3;
        }

        .btn-secondary {
            background: #607D8B;
        }

        .error-message {
            color: #FF5252;
            text-align: center;
            padding: 20px;
            background: rgba(255, 82, 82, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(255, 82, 82, 0.2);
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .card {
                padding: 20px;
            }
            
            .nav-menu {
                flex-direction: column;
            }
            
            .buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    
        <div class="card">
            <div class="header">
                <h2>Profile Saved Successfully</h2>
                <p>Your student profile has been saved to the database</p>
            </div>
            
            <div class="success-message">
                ✓ Profile successfully saved
            </div>
            
            <div class="nav-menu">
                <a href="index.html">Create Another Profile</a>
                <a href="TheSecServlet?action=view">View All Profiles</a>
            </div>
            
            <%
                ProfileBean profile = (ProfileBean) request.getAttribute("profile");
                if (profile != null) {
            %>
            
            <div class="profile-info">
                <div class="info-section">
                    <div class="info-label">Full Name</div>
                    <div class="info-value"><%= profile.getName() %></div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">Student ID</div>
                    <div class="info-value"><%= profile.getStudentId() %></div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">Program</div>
                    <div class="info-value"><%= profile.getProgram() %></div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">Email</div>
                    <div class="info-value"><%= profile.getEmail() %></div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">Hobbies</div>
                    <div class="info-value"><%= profile.getHobbies() %></div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">Introduction</div>
                    <div class="intro-text"><%= profile.getIntroduction() %></div>
                </div>
            </div>
            
            <% } else { %>
            
            <div class="error-message">
                Error: Profile data could not be loaded lol. Please try again.
            </div>
            
            <% } %>
            
            <div class="buttons">
                <a href="index.html" class="btn btn-secondary">Back to Form</a>
                <a href="TheSecServlet?action=view" class="btn btn-primary">Browse Profiles</a>
            </div>
        </div>
    
</body>
</html>