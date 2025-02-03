<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "aeroport.Ville" %>
<%@page import = "aeroport.avion.Avion" %>
<%
    Ville[] villes = (Ville[])request.getAttribute("list_villes");
    Avion[] avions = (Avion[])request.getAttribute("list_avion");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <script src="assets/css/bootstrap-5.3.2-dist/js/bootstrap.bundle.min.js"></script>
    <title>Nouveau Vol</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            margin: 2rem auto;
            max-width: 500px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header h2 {
            color: #2d3748;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: #718096;
            font-size: 0.9rem;
        }

        .form-header .icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
            background: white;
        }

        .duration-group {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 0.5rem;
            align-items: end;
        }

        .duration-separator {
            font-weight: 700;
            color: #667eea;
            font-size: 1.2rem;
            text-align: center;
            padding-bottom: 0.75rem;
        }

        .pricing-group {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 0.75rem;
            align-items: end;
        }

        .price-input {
            position: relative;
        }

        .price-input input {
            padding-right: 2rem;
        }

        .price-currency {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            color: white;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            width: 100%;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .input-icon {
            color: #667eea;
            font-size: 0.85rem;
        }

        .route-connector {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-size: 1.1rem;
            margin: 0.5rem 0;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .form-container {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .duration-group,
            .pricing-group {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }
            
            .duration-separator {
                display: none;
            }
        }

        /* Animation d'entrée */
        .form-container {
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-group {
            animation: fadeIn 0.8s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeIn {
            to {
                opacity: 1;
            }
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }
    </style>
</head>
<body>
    <div class="container-fluid" id="header"></div>

    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <div class="icon">
                    <i class="fas fa-plane"></i>
                </div>
                <h2>Nouveau Vol</h2>
                <p>Planifiez votre prochaine destination</p>
            </div>

            <form id="formAjout" action="register" method="POST">
                <input type="hidden" name="business.idTypeSiege" value="TYP000001">
                <input type="hidden" name="eco.idTypeSiege" value="TYP000002">
                
                <!-- Ville de départ -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-map-marker-alt input-icon"></i>
                        Ville de départ
                    </label>
                    <select name="vol.depart" class="form-select" required>
                        <option value="">Sélectionnez la ville de départ</option>
                        <%
                            for(Ville v : villes){
                                %>
                                    <option value="<%=v.getId_ville() %>"><%= v.getDesignation() %></option>
                                <%
                            }
                        %>
                    </select>
                </div>

                <!-- Connecteur visuel -->
                <div class="route-connector">
                    <i class="fas fa-arrow-down"></i>
                </div>

                <!-- Destination -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-map-marker-alt input-icon"></i>
                        Destination
                    </label>
                    <select name="vol.destination" class="form-select" required>
                        <option value="">Sélectionnez la destination</option>
                        <%
                            for(Ville v : villes){
                                %>
                                    <option value="<%=v.getId_ville() %>"><%= v.getDesignation() %></option>
                                <%
                            }
                        %>
                    </select>
                </div>

                <!-- Date de départ -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-calendar-alt input-icon"></i>
                        Date et heure de départ
                    </label>
                    <input type="datetime-local" name="vol.dateDepart" class="form-control" required>
                </div>

                <!-- Durée du vol -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock input-icon"></i>
                        Durée du vol
                    </label>
                    <div class="duration-group">
                        <input type="number" name="duree.heure" class="form-control" 
                               placeholder="Heures" min="0" max="23" required>
                        <div class="duration-separator">:</div>
                        <input type="number" name="duree.minute" class="form-control" 
                               placeholder="Minutes" min="0" max="59" required>
                    </div>
                </div>

                <!-- Tarifs -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-euro-sign input-icon"></i>
                        Tarifs
                    </label>
                    <div class="pricing-group">
                        <div class="price-input">
                            <input type="number" id="b_tarif" name="business.tarif" 
                                   class="form-control" placeholder="Business" 
                                   step="0.01" min="0" required>
                            <span class="price-currency">€</span>
                        </div>
                        <div class="duration-separator">|</div>
                        <div class="price-input">
                            <input type="number" id="e_tarif" name="eco.tarif" 
                                   class="form-control" placeholder="Économique" 
                                   step="0.01" min="0" required>
                            <span class="price-currency">€</span>
                        </div>
                    </div>
                </div>

                <!-- Avion -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-plane input-icon"></i>
                        Avion
                    </label>
                    <select name="idAvion" class="form-select" required>
                        <option value="">Sélectionnez l'avion</option>
                        <%
                            for(Avion v : avions){
                                %>
                                    <option value="<%=v.getId_avion() %>"><%= v.getModel() %></option>
                                <%
                            }
                        %>
                    </select>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane me-2"></i>
                    Créer le vol
                </button>
            </form>
        </div>
    </div>

    <script src="./assets/js/header.js"></script>
    <script>
        setHeader('../header.html');
        
        // Validation et formatage des prix
        document.getElementById('formAjout').addEventListener('submit', function () {
            const inputEco = document.getElementById('e_tarif');
            const inputBusiness = document.getElementById('b_tarif');
            
            inputEco.value = parseFloat(inputEco.value).toFixed(1);
            inputBusiness.value = parseFloat(inputBusiness.value).toFixed(1);
        });

        // Validation en temps réel
        document.addEventListener('DOMContentLoaded', function() {
            const dureeMinuteInput = document.querySelector('[name="duree.minute"]');
            const dureeHeureInput = document.querySelector('[name="duree.heure"]');
            
            dureeMinuteInput.addEventListener('input', function() {
                if (this.value > 59) this.value = 59;
                if (this.value < 0) this.value = 0;
            });
            
            dureeHeureInput.addEventListener('input', function() {
                if (this.value < 0) this.value = 0;
            });

            // Validation des prix
            const priceInputs = document.querySelectorAll('[step="0.01"]');
            priceInputs.forEach(input => {
                input.addEventListener('input', function() {
                    if (this.value < 0) this.value = 0;
                });
            });
        });
    </script>
</body>
</html>