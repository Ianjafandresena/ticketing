<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%
    String client = (String)session.getAttribute("id_client");
    String reservation = (String)request.getAttribute("id_reservation");

    Map<String,ArrayList<String>> errors = new HashMap<>();
    if(request.getAttribute("error") != null){
        errors = (Map<String,ArrayList<String>>)request.getAttribute("error");
    }
    ArrayList<String> dateError = new ArrayList<>();
    if(errors.containsKey("dateAnnulation")){
        dateError = errors.get("dateAnnulation");
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./assets/css/header.css">
    <link rel="stylesheet" href="./assets/css/form.css">
    <link rel="stylesheet" href="assets/css/bootstrap-5.3.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/fontawesome-5/css/all.min.css">
    <script src="assets/css/bootstrap-5.3.2-dist/js/bootstrap.bundle.min.js"></script>
    <title>Annulation de réservation</title>
</head>
<body>
    <div class="container-fluid" id="header">
    </div>

    <div class="container mt-5">
        <div class="row">
            <div class="col text-center">
                <h2>Annulation de la réservation</h2>
                <% if(reservation != null && !reservation.isEmpty()) { %>
                    <p class="text-muted">Réservation: <%= reservation %></p>
                <% } %>
            </div>
        </div>
    </div>

    <div id="formulaireBloc" class="formulaire-vrai offset-3 mt-5">
        <form id="formAjout" action="annulerReservation" method="POST">
            <input type="hidden" name="idReservation" value="<%= reservation %>">
            
            <div class="form-group mb-3">
                <label for="dateAnnulation" class="form-label">Date d'annulation <span class="text-danger">*</span></label>
                <input type="datetime-local" 
                       id="dateAnnulation" 
                       name="dateAnnulation" 
                       class="form-control" 
                       required 
                       value="${requestScope.dateAnnulation}">
                <div class="form-text">Sélectionnez la date et l'heure de l'annulation</div>
                <% for(String err : dateError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>
            
            <div class="form-group d-flex gap-2">
                <button type="submit" class="btn btn-danger">
                    <i class="fas fa-times"></i> Confirmer l'annulation
                </button>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>
    
    <script src="./assets/js/header.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            
            const currentDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
            
            const dateInput = document.getElementById('dateAnnulation');
            if (!dateInput.value) {
                dateInput.value = currentDateTime;
            }
            
            document.getElementById('formAjout').addEventListener('submit', function(e) {
                const dateAnnulation = new Date(document.getElementById('dateAnnulation').value);
                const maintenant = new Date();
                
                if (dateAnnulation > maintenant) {
                    if (!confirm('Vous avez sélectionné une date d\'annulation dans le futur. Voulez-vous continuer ?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                if (!confirm('Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.')) {
                    e.preventDefault();
                    return false;
                }
            });
        }
    </script>
</body>
</html>