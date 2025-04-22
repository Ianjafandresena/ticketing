<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import = "aeroport.vol.Vol" %>
<%@page import = "aeroport.Ville" %>
<%
    Vol[] vols = (Vol[])request.getAttribute("list_vols");
    Ville[] villes = (Ville[])request.getAttribute("list_villes");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/styles.css">
    <link rel="stylesheet" href="./assets/css/filtre.css">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <script src="assets/css/bootstrap-5.3.2-dist/js/bootstrap.bundle.min.js"></script>
    <title>Liste des vols</title>
    <style>
        /* Styles spécifiques pour la liste des vols */
        .vol-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 250, 252, 0.95) 100%);
            border: none;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .vol-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        }

        .vol-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        .vol-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .vol-route {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .route-arrow {
            color: #2563eb;
            font-size: 1.25rem;
        }

        .vol-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-item {
            background: rgba(255, 255, 255, 0.7);
            border-radius: 0.75rem;
            padding: 1rem;
            border: 1px solid rgba(226, 232, 240, 0.8);
        }

        .info-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }

        .info-value {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1e293b;
        }

        .pricing-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .pricing-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .pricing-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }

        .price-item {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.2s ease;
        }

        .price-item.business {
            border-color: #d97706;
        }

        .price-item.economy {
            border-color: #059669;
        }

        .price-label {
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .price-label.business {
            color: #d97706;
        }

        .price-label.economy {
            color: #059669;
        }

        .price-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
        }

        .availability-section {
            background: linear-gradient(135deg, #fefce8 0%, #fef3c7 100%);
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .availability-title {
            font-size: 1rem;
            font-weight: 600;
            color: #92400e;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .availability-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }

        .availability-item {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            text-align: center;
            border: 2px solid rgba(217, 119, 6, 0.2);
        }

        .availability-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #92400e;
            margin-bottom: 0.5rem;
        }

        .availability-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
        }

        .reservation-section {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .btn-reserver {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            border: none;
            border-radius: 0.75rem;
            padding: 0.875rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .btn-reserver:hover {
            background: linear-gradient(135deg, #047857 0%, #065f46 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        .filter-form {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .filter-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .duration-inputs {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .duration-separator {
            font-weight: 600;
            color: #64748b;
            font-size: 1.25rem;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #cbd5e1;
        }

        .vol-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .vol-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .vol-route {
                font-size: 1.25rem;
            }

            .vol-info-grid {
                grid-template-columns: 1fr;
            }

            .pricing-grid,
            .availability-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body id="body">
    <div id="header" class="container-fluid"></div>
    
    <!-- Overlay pour le filtre -->
    <div id="overlay"></div>
    
    <div class="container mt-4">
        <!-- En-tête de la page -->
        <div class="row mb-5">
            <div class="col text-center">
                <h1 class="display-5 fw-bold text-primary mb-3">
                    <i class="fas fa-plane me-3"></i>
                    Vols Disponibles
                </h1>
                <p class="lead text-muted">Découvrez nos destinations et réservez votre vol</p>
            </div>
        </div>

        <!-- Bouton filtre flottant -->
        <button class="fixed-button" id="fixButton" title="Filtrer les vols">
            <i class="fas fa-filter"></i>
        </button>

        <!-- Formulaire de filtre -->
        <div id="filtre" class="filtre">
            <div class="filter-form">
                <h3 class="filter-title">
                    <i class="fas fa-search"></i>
                    Filtrer les vols
                </h3>
                
                <form id="form_filtre" action="searchVol" method="GET">
                    <input type="hidden" name="vol_idVol" value="">
                    
                    <!-- Ville de départ -->
                    <div class="form-group mb-3">
                        <label for="vol_depart" class="form-label">
                            <i class="fas fa-map-marker-alt me-2"></i>
                            Ville de départ
                        </label>
                        <select name="vol_depart" id="vol_depart" class="form-select">
                            <option value="">Toutes les villes</option>
                            <% for (Ville s : villes) { %>
                            <option value="<%= s.getId_ville() %>"><%= s.getDesignation() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Destination -->
                    <div class="form-group mb-3">
                        <label for="vol_destination" class="form-label">
                            <i class="fas fa-map-marker-alt me-2"></i>
                            Destination
                        </label>
                        <select name="vol_destination" id="vol_destination" class="form-select">
                            <option value="">Toutes les destinations</option>
                            <% for (Ville s : villes) { %>
                            <option value="<%= s.getId_ville() %>"><%= s.getDesignation() %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Durée minimale -->
                    <div class="form-group mb-3">
                        <label class="form-label">
                            <i class="fas fa-clock me-2"></i>
                            Durée minimale
                        </label>
                        <div class="duration-inputs">
                            <input type="number" name="dureeMin_heure" class="form-control" 
                                   placeholder="Heures" value="0" min="0">
                            <span class="duration-separator">:</span>
                            <input type="number" name="dureeMin_minute" class="form-control" 
                                   placeholder="Minutes" value="0" min="0" max="59">
                        </div>
                    </div>

                    <!-- Durée maximale -->
                    <div class="form-group mb-4">
                        <label class="form-label">
                            <i class="fas fa-clock me-2"></i>
                            Durée maximale
                        </label>
                        <div class="duration-inputs">
                            <input type="number" name="dureeMax_heure" class="form-control" 
                                   placeholder="Heures" value="0" min="0">
                            <span class="duration-separator">:</span>
                            <input type="number" name="dureeMax_minute" class="form-control" 
                                   placeholder="Minutes" value="0" min="0" max="59">
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-fill">
                            <i class="fas fa-search me-2"></i>
                            Rechercher
                        </button>
                        <button type="button" onclick="fermerFormulaire()" class="btn btn-secondary">
                            <i class="fas fa-times me-1"></i>
                            Annuler
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Liste des vols -->
        <div class="row">
            <div class="col">
                <% if (vols != null && vols.length > 0) { %>
                    <% for(Vol v : vols) { %>
                        <div class="vol-card">
                            <div class="vol-badge">
                                Vol <%= v.getIdVol() %>
                            </div>
                            
                            <!-- En-tête du vol -->
                            <div class="vol-header">
                                <div class="vol-route">
                                    <%= v.getDepartV() %>
                                    <i class="fas fa-plane route-arrow"></i>
                                    <%= v.getDestinationV() %>
                                </div>
                            </div>

                            <!-- Informations du vol -->
                            <div class="vol-info-grid">
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        Départ
                                    </div>
                                    <div class="info-value"><%= v.getDateString() %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fas fa-clock me-1"></i>
                                        Durée
                                    </div>
                                    <div class="info-value"><%= v.getDureeV() %></div>
                                </div>
                            </div>

                            <!-- Section tarifs -->
                            <div class="pricing-section">
                                <h4 class="pricing-title">
                                    <i class="fas fa-tag"></i>
                                    Tarifs
                                </h4>
                                <div class="pricing-grid">
                                    <div class="price-item business">
                                        <div class="price-label business">Business</div>
                                        <div class="price-value"><%= v.getTarifs()[0].getTarif() %> €</div>
                                    </div>
                                    <div class="price-item economy">
                                        <div class="price-label economy">Économique</div>
                                        <div class="price-value"><%= v.getTarifs()[1].getTarif() %> €</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section disponibilité -->
                            <div class="availability-section">
                                <h4 class="availability-title">
                                    <i class="fas fa-users"></i>
                                    Places disponibles
                                </h4>
                                <div class="availability-grid">
                                    <div class="availability-item">
                                        <div class="availability-label">Business</div>
                                        <div class="availability-value"><%= v.getDispoB() %></div>
                                    </div>
                                    <div class="availability-item">
                                        <div class="availability-label">Économique</div>
                                        <div class="availability-value"><%= v.getDispoE() %></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bouton de réservation -->
                            <div class="reservation-section">
                                <a href="formReserv?idVol=<%= v.getIdVol() %>" class="btn-reserver">
                                    <i class="fas fa-ticket-alt"></i>
                                    Réserver
                                </a>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-plane-slash"></i>
                        <h3>Aucun vol trouvé</h3>
                        <p>Aucun vol ne correspond à vos critères de recherche. Essayez de modifier vos filtres.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="./assets/js/header.js"></script>
    <script src="./assets/js/filtre.js"></script>
    <script>
        // Initialisation du header
        setHeader('../header.html');

        // Animation d'apparition des cartes
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.vol-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Validation du formulaire de filtre
        document.getElementById('form_filtre').addEventListener('submit', function(e) {
            const dureeMinHeure = parseInt(document.querySelector('[name="dureeMin_heure"]').value) || 0;
            const dureeMinMinute = parseInt(document.querySelector('[name="dureeMin_minute"]').value) || 0;
            const dureeMaxHeure = parseInt(document.querySelector('[name="dureeMax_heure"]').value) || 0;
            const dureeMaxMinute = parseInt(document.querySelector('[name="dureeMax_minute"]').value) || 0;

            // Validation des minutes
            if (dureeMinMinute > 59 || dureeMaxMinute > 59) {
                alert('Les minutes ne peuvent pas dépasser 59.');
                e.preventDefault();
                return false;
            }

            // Validation de la cohérence des durées
            const dureeMinTotal = dureeMinHeure * 60 + dureeMinMinute;
            const dureeMaxTotal = dureeMaxHeure * 60 + dureeMaxMinute;

            if (dureeMaxTotal > 0 && dureeMinTotal > dureeMaxTotal) {
                alert('La durée minimale ne peut pas être supérieure à la durée maximale.');
                e.preventDefault();
                return false;
            }
        });

        // Fonction pour fermer le formulaire de filtre
        function fermerFormulaire() {
            document.getElementById('filtre').style.display = 'none';
            document.getElementById('overlay').classList.remove('show');
        }
    </script>
</body>
</html>