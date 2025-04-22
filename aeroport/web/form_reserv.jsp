<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@page import="aeroport.avion.Type_siege" %>
<%
    String client = "";
    if(session.getAttribute("id_client") != null){
        client = (String)session.getAttribute("id_client");
    }
    String vol = (String)request.getAttribute("id_vol");
    String errorMessage = "";
    if(request.getAttribute("errorMessage") != null){
        errorMessage = (String)request.getAttribute("errorMessage");
    }

    Map<String,ArrayList<String>> errors = new HashMap<>();
    if(request.getAttribute("error") != null){
        errors = (Map<String,ArrayList<String>>)request.getAttribute("error");
    }
    
    ArrayList<String> nbEnfantError = new ArrayList<>();
    ArrayList<String> nbAdulteError = new ArrayList<>();
    ArrayList<String> dateError = new ArrayList<>();
    ArrayList<String> classeError = new ArrayList<>();
    
    if(errors.containsKey("reservation_nbEnfant")){
        nbEnfantError = errors.get("reservation_nbEnfant");
    }
    if(errors.containsKey("reservation_nbAdulte")){
        nbAdulteError = errors.get("reservation_nbAdulte");
    }
    if(errors.containsKey("reservation_dateReservation")){
        dateError = errors.get("reservation_dateReservation");
    }
    if(errors.containsKey("reservation_idTypeSiege")){
        classeError = errors.get("reservation_idTypeSiege");
    }

    Type_siege[] sieges = (Type_siege[])request.getAttribute("list_siege");
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
    <title>Réservation de vol</title>
</head>
<body>
    <div class="container-fluid" id="header">
    </div>

    <div id="errorMessage" data-value="<%=errorMessage %>"></div>

    <div class="container mt-5">
        <div class="row">
            <div class="col text-center">
                <h2>Réservation de vols</h2>
                <% if(vol != null && !vol.isEmpty()) { %>
                    <p class="text-muted">Vol: <%= vol %></p>
                <% } %>
            </div>
        </div>
    </div>

    <div id="formulaireBloc" class="formulaire-vrai offset-3 mt-5">
        <form id="formAjout" action="makeReservation" method="POST">
            <input type="hidden" name="idVol" value="<%= vol != null ? vol : "" %>">
            <input type="hidden" name="idClient" value="<%= client %>">
            
            <div class="form-group mb-3">
                <label for="typeComposant" class="form-label">Classe <span class="text-danger">*</span></label>
                <select name="idTypeSiege" id="typeComposant" class="form-select" required>
                    <option value="">Sélectionnez une classe</option>
                    <% if(sieges != null) {
                        for(Type_siege siege : sieges) { %>
                            <option value="<%= siege.getId_type_siege() %>"><%= siege.getDesignation() %></option>
                    <%  }
                    } else { %>
                        <option value="TYP000001">Business</option>
                        <option value="TYP000002">Économique</option>
                    <% } %>
                </select>
                <% for(String err : classeError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group mb-3">
                <label for="nbEnfant" class="form-label">Nombre d'enfants <span class="text-danger">*</span></label>
                <input type="number" 
                       id="nbEnfant" 
                       name="nbEnfant" 
                       class="form-control" 
                       min="0" 
                       max="10" 
                       required 
                       value="${requestScope.reservation_nbEnfant}">
                <% for(String err : nbEnfantError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group mb-3">
                <label for="nbAdulte" class="form-label">Nombre d'adultes <span class="text-danger">*</span></label>
                <input type="number" 
                       id="nbAdulte" 
                       name="nbAdulte" 
                       class="form-control" 
                       min="1" 
                       max="10" 
                       required 
                       value="${requestScope.reservation_nbAdulte}">
                <% for(String err : nbAdulteError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group mb-3">
                <label for="dateReservation" class="form-label">Date de réservation <span class="text-danger">*</span></label>
                <input type="datetime-local" 
                       id="dateReservation" 
                       name="dateReservation" 
                       class="form-control" 
                       required 
                       value="${requestScope.reservation_dateReservation}">
                <% for(String err : dateError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i> Confirmer la réservation
                </button>
                <a href="listVol?vol_idVol=&dureeMax_heure=0&dureeMin_heure=0" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>

    <script src="./assets/js/header.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            var value = document.getElementById("errorMessage").dataset.value;
            if(value != undefined && value != ""){
                alert(value);
            }
            
            document.getElementById('formAjout').addEventListener('submit', function(e) {
                var nbAdulte = parseInt(document.getElementById('nbAdulte').value) || 0;
                var nbEnfant = parseInt(document.getElementById('nbEnfant').value) || 0;
                
                if(nbAdulte < 1) {
                    alert('Au moins un adulte est requis pour la réservation.');
                    e.preventDefault();
                    return false;
                }
                
                if(nbAdulte + nbEnfant < 1) {
                    alert('Au moins une personne doit être incluse dans la réservation.');
                    e.preventDefault();
                    return false;
                }
                
                var dateReserv = new Date(document.getElementById('dateReservation').value);
                var maintenant = new Date();
                
                if(dateReserv <= maintenant) {
                    alert('La date de réservation doit être dans le futur.');
                    e.preventDefault();
                    return false;
                }
                
                console.log('Formulaire soumis avec:');
                console.log('- Nb Adultes:', nbAdulte);
                console.log('- Nb Enfants:', nbEnfant);
                console.log('- Date:', document.getElementById('dateReservation').value);
                console.log('- Type siège:', document.getElementById('typeComposant').value);
            });
        }
    </script>
</body>
</html>