<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%
  String role = (String)session.getAttribute("role");
  String urlRes = "listReservation?errorMessage=";
  if(role != null && role.equals("admin")){
    urlRes = "listAllReservation?errorMessage=";
  }
%>
    
<div class="row">
    <nav class="navbar navbar-expand-lg w-100" id="mainNavbar">
        <div class="container-fluid">
            <!-- Logo Section -->
            <div class="col-md-2">
                <a class="navbar-brand d-flex align-items-center" href="home.html">
                    <img src="./assets/image/logo.png" width="50" height="50" alt="Logo" class="img-fluid me-2">
                    <span class="brand-text d-none d-md-inline">Aéroport</span>
                </a>
            </div>

            <!-- Mobile Menu Toggle -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon">
                    <i class="fas fa-bars"></i>
                </span>
            </button>

            <!-- Navigation Links -->
            <div class="col-md-8">
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto">
                        <!-- Home -->
                        <li class="nav-item">
                            <a class="nav-link" href="home.html">
                                <i class="fas fa-home me-1"></i>
                                Accueil
                            </a>
                        </li>

                        <!-- Vol Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-plane me-1"></i>
                                Vols
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="listVol?vol_idVol=&dureeMax_heure=0&dureeMin_heure=0">
                                        <i class="fas fa-list me-2"></i>
                                        Liste des vols
                                    </a>
                                </li>
                                <% if(role != null && role.equals("admin")) { %>
                                <li>
                                    <a class="dropdown-item" href="formInsertV">
                                        <i class="fas fa-plus me-2"></i>
                                        Ajouter un vol
                                    </a>
                                </li>
                                <% } %>
                            </ul>
                        </li>

                        <!-- Reservation Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-ticket-alt me-1"></i>
                                Réservations
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="<%= urlRes %>">
                                        <i class="fas fa-list me-2"></i>
                                        Mes réservations
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <!-- Admin Dropdown (only for admins) -->
                        <% if(role != null && role.equals("admin")) { %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-cog me-1"></i>
                                Administration
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="formReservR?errorMessage=">
                                        <i class="fas fa-clock me-2"></i>
                                        Limite de réservation
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="formAnnulR?errorMessage=">
                                        <i class="fas fa-ban me-2"></i>
                                        Limite d'annulation
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="formPromo?errorMessage=">
                                        <i class="fas fa-percent me-2"></i>
                                        Promotions
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <% } %>
                    </ul>
                </div>
            </div>

            <!-- User Section -->
            <div class="col-md-2 d-flex justify-content-end">
                <div class="user-section d-flex align-items-center">
                    <% if(role != null) { %>
                    <span class="user-role me-3 d-none d-lg-inline">
                        <i class="fas fa-user-circle me-1"></i>
                        <%= role.equals("admin") ? "Administrateur" : "Utilisateur" %>
                    </span>
                    <% } %>
                    <a href="logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt me-1"></i>
                        <span class="d-none d-md-inline">Déconnexion</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>
</div>

<style>
/* Styles spécifiques pour le header modernisé */
#mainNavbar {
    background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%) !important;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    backdrop-filter: blur(10px);
    padding: 0.75rem 0;
}

.navbar-brand {
    font-weight: 700;
    color: white !important;
    transition: all 0.2s ease;
}

.navbar-brand:hover {
    transform: scale(1.05);
    color: white !important;
}

.brand-text {
    font-size: 1.25rem;
    letter-spacing: -0.025em;
}

.navbar-nav .nav-link {
    color: rgba(255, 255, 255, 0.9) !important;
    font-weight: 500;
    transition: all 0.2s ease;
    position: relative;
    padding: 0.75rem 1rem !important;
    border-radius: 0.375rem;
    margin: 0 0.25rem;
}

.navbar-nav .nav-link:hover {
    color: white !important;
    background: rgba(255, 255, 255, 0.1);
    transform: translateY(-1px);
}

.dropdown-menu {
    background: white;
    border: none;
    border-radius: 0.5rem;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    opacity: 0;
    transform: translateY(-10px);
    visibility: hidden;
    transition: all 0.2s ease;
    padding: 0.5rem 0;
    margin-top: 0.5rem;
    min-width: 200px;
}

.nav-item.dropdown:hover .dropdown-menu {
    opacity: 1;
    transform: translateY(0);
    visibility: visible;
}

.dropdown-item {
    color: #1e293b;
    font-weight: 500;
    padding: 0.75rem 1.5rem;
    transition: all 0.2s ease;
    border: none;
    display: flex;
    align-items: center;
}

.dropdown-item:hover {
    background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
    color: white;
    transform: translateX(5px);
}

.user-section {
    gap: 1rem;
}

.user-role {
    color: rgba(255, 255, 255, 0.8);
    font-size: 0.875rem;
    font-weight: 500;
}

.btn-logout {
    background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    text-decoration: none;
    font-weight: 600;
    font-size: 0.875rem;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-logout:hover {
    background: linear-gradient(135deg, #b91c1c 0%, #991b1b 100%);
    color: white;
    transform: translateY(-1px);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.navbar-toggler {
    border: none;
    padding: 0.25rem 0.5rem;
    border-radius: 0.375rem;
    background: rgba(255, 255, 255, 0.1);
}

.navbar-toggler:focus {
    box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.25);
}

.navbar-toggler-icon i {
    color: white;
    font-size: 1.25rem;
}

/* Responsive */
@media (max-width: 991.98px) {
    .navbar-collapse {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 0.5rem;
        margin-top: 1rem;
        padding: 1rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        backdrop-filter: blur(10px);
    }
    
    .navbar-nav .nav-link {
        color: #1e293b !important;
        margin: 0.25rem 0;
    }
    
    .navbar-nav .nav-link:hover {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        color: white !important;
    }
    
    .dropdown-menu {
        position: static !important;
        background: transparent !important;
        border: none !important;
        box-shadow: none !important;
        padding-left: 1rem;
        opacity: 1;
        visibility: visible;
        transform: none;
    }
    
    .dropdown-item {
        color: #64748b !important;
        padding: 0.5rem 1rem !important;
    }
    
    .dropdown-item:hover {
        background: #f1f5f9 !important;
        color: #1e293b !important;
    }
    
    .user-section {
        margin-top: 1rem;
        justify-content: center;
    }
}
</style>