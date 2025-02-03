<%
    String errorMessage = "";
    if(request.getAttribute("errorMessage") != null){
        errorMessage = (String)request.getAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Aéroport</title>
    <link href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --input-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.2"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.2"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            pointer-events: none;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 1.5rem;
            box-shadow: var(--card-shadow);
            max-width: 420px;
            width: 90%;
            padding: 3rem 2.5rem;
            position: relative;
            z-index: 1;
            animation: slideInUp 0.6s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .login-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .login-header p {
            color: #64748b;
            font-size: 1rem;
            margin: 0;
        }

        .logo-container {
            width: 80px;
            height: 80px;
            background: var(--gradient-bg);
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .logo-container i {
            font-size: 2rem;
            color: white;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            letter-spacing: 0.025em;
        }

        .form-control {
            border: 2px solid #e5e7eb;
            border-radius: 0.75rem;
            padding: 0.875rem 1rem 0.875rem 3rem;
            font-size: 1rem;
            transition: all 0.2s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: var(--input-shadow);
            background: white;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            z-index: 2;
            margin-top: 0.75rem;
        }

        .btn-login {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            border-radius: 0.75rem;
            padding: 0.875rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            width: 100%;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
            overflow: hidden;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(135deg, var(--primary-dark) 0%, #1e40af 100%);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-login::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.3s, height 0.3s;
        }

        .btn-login:active::after {
            width: 300px;
            height: 300px;
        }

        .error-message {
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
            color: #dc2626;
            padding: 1rem;
            border-radius: 0.75rem;
            margin: 1rem 0;
            border: 1px solid #fecaca;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .forgot-password {
            text-align: center;
            margin-top: 1.5rem;
        }

        .forgot-password a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
            position: relative;
        }

        .forgot-password a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary-color);
            transition: width 0.2s ease;
        }

        .forgot-password a:hover {
            color: var(--primary-dark);
        }

        .forgot-password a:hover::after {
            width: 100%;
        }

        /* Animations flottantes pour le background */
        .floating-shapes {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 0;
        }

        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 100px;
            height: 100px;
            top: 20%;
            left: 10%;
            animation-delay: -2s;
        }

        .shape:nth-child(2) {
            width: 150px;
            height: 150px;
            top: 70%;
            right: 10%;
            animation-delay: -4s;
        }

        .shape:nth-child(3) {
            width: 80px;
            height: 80px;
            top: 40%;
            right: 20%;
            animation-delay: -1s;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(180deg);
            }
        }

        /* Responsive */
        @media (max-width: 480px) {
            .login-container {
                padding: 2rem 1.5rem;
                margin: 1rem;
            }
            
            .login-header h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="login-container">
        <div class="login-header">
            <div class="logo-container">
                <i class="fas fa-plane"></i>
            </div>
            <h1>Connexion</h1>
            <p>Accédez à votre espace de gestion</p>
        </div>

        <form action="login" method="post" id="loginForm">
            <div class="form-group">
                <label for="email" class="form-label">Identifiant</label>
                <i class="fas fa-user input-icon"></i>
                <input type="text" 
                       class="form-control" 
                       id="email" 
                       name="login" 
                       placeholder="Entrez votre identifiant"
                       required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Mot de passe</label>
                <i class="fas fa-lock input-icon"></i>
                <input type="password" 
                       class="form-control" 
                       id="password" 
                       name="password" 
                       placeholder="Entrez votre mot de passe"
                       required>
            </div>

            <% if(!errorMessage.isEmpty()) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= errorMessage %>
                </div>
            <% } %>

            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt me-2"></i>
                Se connecter
            </button>
        </form>

        <div class="forgot-password">
            <a href="#" onclick="showForgotPassword()">
                <i class="fas fa-question-circle me-1"></i>
                Mot de passe oublié ?
            </a>
        </div>
    </div>

    <script>
        // Animation au focus des champs
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.classList.remove('focused');
                }
            });
        });

        // Gestion du formulaire
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const login = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!login || !password) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs');
            }
        });

        function showForgotPassword() {
            alert('Contactez votre administrateur système pour récupérer votre mot de passe.');
        }

        // Animation d'entrée retardée pour les éléments
        window.addEventListener('load', function() {
            document.querySelector('.login-container').style.animationDelay = '0s';
        });
    </script>
</body>
</html>