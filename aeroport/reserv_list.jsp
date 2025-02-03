<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "aeroport.vol.Vol" %>
<%@page import = "aeroport.reservation.Reservation" %>
<%
    Reservation[] reservations = (Reservation[])request.getAttribute("list_reservations");
    String role = (String)session.getAttribute("role");
    String errorMessage = "";
    if(request.getAttribute("errorMessage") != null) errorMessage = (String)request.getAttribute("errorMessage");
    boolean isAdmin = false;
    if(role.equals("admin")){
        isAdmin = true;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/styles.css">
    <link rel="stylesheet" href="./assets/css/filtre.css">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <script src="assets/css/bootstrap-5.3.2-dist/js/bootstrap.bundle.min.js"></script>
    <title>Liste des reservations</title>
    <style>
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-weight: bold;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-confirmed {
            background-color: #d1edff;
            color: #055160;
            border: 1px solid #b6effb;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .reservation-card {
            border-left: 4px solid #dee2e6;
            transition: all 0.3s ease;
        }
        .reservation-card.pending {
            border-left-color: #ffc107;
        }
        .reservation-card.confirmed {
            border-left-color: #28a745;
        }
        .reservation-card.cancelled {
            border-left-color: #dc3545;
        }
        .btn-group-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .action-buttons {
            margin-top: 0.5rem;
        }
    </style>
</head>
<body id="body">
    <div id="header" class="container-fluid"></div>
    <div id="errorMessage" data-value="<%= errorMessage %>"></div>
    <!-- Fond sombre -->
    <div id="overlay"></div>
    <div class="container mt-4">
        <div class="container mt-5">
            <div class="row">
                <div class="col text-center">
                    <%
                        if(isAdmin){ %>
                            <h2>Listes des reservations</h2>
                        <% 
                        }else{ %>
                            <h2>Mes reservations</h2>
                        <% }
                    %>
                </div>
            </div>
        </div>

        <div class="list-group">
            <% for(Reservation v : reservations){ %>
                <div class="list-group-item reservation-card <%= v.getStatus() != null ? v.getStatus() : "pending" %>">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <h5 class="mb-1">
                                <% if(v.getCli() == null){ %>
                                    Particulier
                                <% } else { %>
                                    <%= v.getCli().getNom() %> <%= v.getCli().getPrenom() %>
                                <% } %>
                                <span class="status-badge status-<%= v.getStatus() != null ? v.getStatus() : "pending" %>">
                                    <%= v.getStatusDisplay() %>
                                </span>
                            </h5>
                            <p class="mb-1">
                                <strong>Date :</strong> <%= v.getDateString() %><br>
                                <strong>Vol :</strong> <%= v.getIdVol() %><br>
                                <strong>Classe :</strong> <%= v.getClasse() %><br>
                                <strong>Enfants :</strong> <%= v.getNbEnfant() %> |
                                <strong>Adultes :</strong> <%= v.getNbAdulte() %><br>
                                <strong>Prix total :</strong> <%= String.format("%.2f", v.getPrix()) %> €
                            </p>
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <div class="btn-group-actions">
                            <% 
                            String status = v.getStatus();
                            if (status == null) status = "pending";
                            
                            if ("pending".equals(status)) { %>
                                <!-- Bouton Payer pour les réservations en attente -->
                                <form method="post" action="markAsPaid" style="display: inline;">
                                    <input type="hidden" name="idReservation" value="<%= v.getIdReservation() %>">
                                    <button type="submit" class="btn btn-success btn-sm" 
                                            onclick="return confirm('Confirmer le paiement de cette réservation ?')">
                                        <i class="fas fa-credit-card"></i> Payer
                                    </button>
                                </form>
                                
                                <!-- Bouton Annuler pour les réservations en attente -->
                                <a href="formAnnul?idReservation=<%= v.getIdReservation() %>" 
                                   class="btn btn-outline-danger btn-sm">
                                    <i class="fas fa-times"></i> Annuler
                                </a>
                            <% } else if ("confirmed".equals(status)) { %>
                                <!-- Réservation payée - optionnel: bouton pour annuler même après paiement -->
                                <a href="formAnnul?idReservation=<%= v.getIdReservation() %>" 
                                   class="btn btn-outline-warning btn-sm">
                                    <i class="fas fa-exclamation-triangle"></i> Demander remboursement
                                </a>
                            <% } else if ("cancelled".equals(status)) { %>
                                <!-- Réservation annulée - aucune action possible -->
                                <span class="text-muted small">
                                    <i class="fas fa-ban"></i> Réservation annulée
                                </span>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <% if (reservations.length == 0) { %>
            <div class="text-center mt-5">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    Aucune réservation trouvée.
                </div>
            </div>
        <% } %>
    </div>
    
    <script src="./assets/js/header.js"></script>
    <script src="./assets/js/filtre.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            var value = document.getElementById("errorMessage").dataset.value;
            if(value != undefined && value != ""){
                if(value.includes("Erreur")) {
                    alert("❌ " + value);
                } else if(value.includes("succès") || value.includes("payée")) {
                    alert("✅ " + value);
                } else {
                    alert(value);
                }
            }
        }
        
        // Fonction pour confirmer le paiement
        function confirmPayment(reservationId) {
            return confirm('Êtes-vous sûr de vouloir marquer cette réservation comme payée ?\n\nRéservation: ' + reservationId);
        }
        
        // Animation pour les changements de statut
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.reservation-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                    this.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)';
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