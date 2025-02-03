<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="aeroport.vol.Promotion" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
    Promotion[] promotions = (Promotion[])request.getAttribute("list_promotions");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/styles.css">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <title>Suivi des Promotions</title>
    <style>
        .promo-card {
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
        }
        .promo-active {
            border-left-color: #28a745;
            background-color: #f8fff9;
        }
        .promo-expired {
            border-left-color: #dc3545;
            background-color: #fff5f5;
        }
        .promo-exhausted {
            border-left-color: #ffc107;
            background-color: #fffbf0;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .seats-progress {
            height: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
        }
        .seats-bar {
            height: 100%;
            background: linear-gradient(90deg, #28a745, #20c997);
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
    <div id="header" class="container-fluid"></div>
    
    <div class="container mt-5">
        <div class="row">
            <div class="col">
                <h2><i class="fas fa-tags"></i> Suivi des Promotions</h2>
                <p class="text-muted">État en temps réel de toutes les promotions</p>
            </div>
            <div class="col-auto">
                <a href="formPromo" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nouvelle Promotion
                </a>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <% if (promotions != null && promotions.length > 0) { %>
            <div class="row">
                <% for (Promotion promo : promotions) { 
                    String statusClass = "promo-card";
                    String badgeClass = "badge bg-primary";
                    String statusText = "Inconnue";
                    
                    if (promo.isActive()) {
                        statusClass += " promo-active";
                        badgeClass = "badge bg-success";
                        statusText = "Active";
                    } else if (promo.getNbSiege() <= 0) {
                        statusClass += " promo-exhausted";
                        badgeClass = "badge bg-warning text-dark";
                        statusText = "Épuisée";
                    } else {
                        statusClass += " promo-expired";
                        badgeClass = "badge bg-danger";
                        statusText = "Expirée";
                    }
                    
                    // Calculer le pourcentage d'utilisation (supposons un max initial de 50 pour l'exemple)
                    int maxInitial = 50; // À ajuster selon vos besoins
                    int utilises = maxInitial - promo.getNbSiege();
                    double pourcentageUtilise = maxInitial > 0 ? (utilises * 100.0 / maxInitial) : 0;
                %>
                
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card <%= statusClass %>">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h6 class="mb-0">
                                <i class="fas fa-plane"></i> <%= promo.getIdVol() %>
                            </h6>
                            <span class="<%= badgeClass %>"><%= statusText %></span>
                        </div>
                        <div class="card-body">
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">Prix Promo</small>
                                    <div class="h5 text-success">
                                        <%= String.format("%.2f", promo.getPrixPromotion()) %>€
                                    </div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Sièges Restants</small>
                                    <div class="h5 <%= promo.getNbSiege() > 0 ? "text-primary" : "text-danger" %>">
                                        <%= promo.getNbSiege() %>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-2">
                                <small class="text-muted">Progression d'utilisation</small>
                                <div class="seats-progress">
                                    <div class="seats-bar" style="width: <%= pourcentageUtilise %>%"></div>
                                </div>
                                <small class="text-muted"><%= String.format("%.1f", pourcentageUtilise) %>% utilisés</small>
                            </div>
                            
                            <div class="mb-2">
                                <small class="text-muted">Classe</small>
                                <div><%= promo.getIdTypeSiege() %></div>
                            </div>
                            
                            <div class="mb-2">
                                <small class="text-muted">Fin de promotion</small>
                                <div>
                                    <i class="fas fa-calendar-alt"></i>
                                    <%= sdf.format(promo.getDateFin()) %>
                                </div>
                            </div>
                            
                            <% if (promo.isActive()) { %>
                                <div class="alert alert-success py-1 px-2 mb-0">
                                    <i class="fas fa-check-circle"></i>
                                    <small>Promotion active et disponible</small>
                                </div>
                            <% } else if (promo.getNbSiege() <= 0) { %>
                                <div class="alert alert-warning py-1 px-2 mb-0">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <small>Tous les sièges ont été utilisés</small>
                                </div>
                            <% } else { %>
                                <div class="alert alert-danger py-1 px-2 mb-0">
                                    <i class="fas fa-times-circle"></i>
                                    <small>Promotion expirée</small>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="text-center mt-5">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    Aucune promotion créée pour le moment.
                    <br>
                    <a href="formPromo" class="btn btn-primary mt-2">
                        <i class="fas fa-plus"></i> Créer votre première promotion
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <script src="./assets/js/header.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            
            // Auto-refresh toutes les 30 secondes pour voir les mises à jour en temps réel
            setInterval(function() {
                location.reload();
            }, 30000);
        }
        
        // Animation des cartes au survol
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.promo-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                    this.style.boxShadow = '0 4px 15px rgba(0,0,0,0.1)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = 'none';
                });
            });
        });
    </script>
</body>
</html>