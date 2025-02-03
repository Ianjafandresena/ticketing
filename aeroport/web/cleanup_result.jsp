<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%
    List<String> messages = (List<String>)request.getAttribute("messages");
    String dateTraitee = (String)request.getAttribute("dateTraitee");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <title>Résultats du Nettoyage</title>
    <style>
        .success-message {
            border-left: 4px solid #28a745;
            background-color: #d4edda;
            color: #155724;
        }
        .error-message {
            border-left: 4px solid #dc3545;
            background-color: #f8d7da;
            color: #721c24;
        }
        .info-message {
            border-left: 4px solid #17a2b8;
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .message-item {
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            border-radius: 0.25rem;
        }
        .cleanup-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <div id="header" class="container-fluid"></div>
    
    <div class="container mt-5">
        <div class="cleanup-summary text-center">
            <h2><i class="fas fa-broom"></i> Nettoyage Automatique Terminé</h2>
            <p class="mb-0">
                <strong>Date limite traitée :</strong> <%= dateTraitee %>
                <br>
                <small>Toutes les réservations non payées antérieures à cette date ont été traitées</small>
            </p>
        </div>
        
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h4><i class="fas fa-list"></i> Rapport détaillé</h4>
                
                <% if (messages != null && !messages.isEmpty()) { %>
                    <div class="messages-container">
                        <% for (String message : messages) { 
                            String messageClass = "info-message";
                            String icon = "fas fa-info-circle";
                            
                            if (message.contains("ERREUR")) {
                                messageClass = "error-message";
                                icon = "fas fa-exclamation-triangle";
                            } else if (message.contains("annulée") || message.contains("Redistribué") || message.contains("TERMINÉ")) {
                                messageClass = "success-message";
                                icon = "fas fa-check-circle";
                            }
                        %>
                            <div class="message-item <%= messageClass %>">
                                <i class="<%= icon %>"></i>
                                <%= message %>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        Aucune action n'a été effectuée. Aucune réservation non payée trouvée avant cette date.
                    </div>
                <% } %>
                
                <div class="mt-4 text-center">
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                    <a href="../vol/listAllReservation" class="btn btn-primary">
                        <i class="fas fa-list"></i> Voir toutes les réservations
                    </a>
                    <a href="../rules/listPromotions" class="btn btn-success">
                        <i class="fas fa-tags"></i> Voir les promotions
                    </a>
                </div>
                
                <!-- Instructions pour le prochain nettoyage -->
                <div class="alert alert-warning mt-4">
                    <h6><i class="fas fa-lightbulb"></i> Comment utiliser cette fonction :</h6>
                    <p class="mb-1">
                        <strong>URL :</strong> <code>localhost:8080/aeroport/cleanup/date?date=DD/MM/YYYY</code>
                    </p>
                    <p class="mb-1">
                        <strong>Exemple :</strong> <code>localhost:8080/aeroport/cleanup/date?date=25/08/2025</code>
                    </p>
                    <p class="mb-0">
                        <small class="text-muted">
                            Cette fonction annule automatiquement les réservations non payées antérieures à la date 
                            et redistribue les places promotionnelles vers les promotions suivantes.
                        </small>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="./assets/js/header.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            
            // Animation d'apparition des messages
            const messages = document.querySelectorAll('.message-item');
            messages.forEach((msg, index) => {
                setTimeout(() => {
                    msg.style.opacity = '0';
                    msg.style.transform = 'translateX(-20px)';
                    msg.style.transition = 'all 0.3s ease';
                    
                    setTimeout(() => {
                        msg.style.opacity = '1';
                        msg.style.transform = 'translateX(0)';
                    }, 50);
                }, index * 100);
            });
        }
    </script>
</body>
</html>