<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@page import="aeroport.vol.Vol" %>
<%
    Vol[] vols = (Vol[])request.getAttribute("list_vol");

    String errorMessage = "";
    if(request.getAttribute("errorMessage") != null){
        errorMessage = (String)request.getAttribute("errorMessage");
    }

    Map<String,ArrayList<String>> errors = new HashMap<>();
    if(request.getAttribute("error") != null){
        errors = (Map<String,ArrayList<String>>)request.getAttribute("error");
    }
    ArrayList<String> dateError = new ArrayList<>();
    if(errors.containsKey("limit_dateApplication")){
        dateError = errors.get("limit_dateApplication");
    }
    ArrayList<String> nbError = new ArrayList<>();      
    if(errors.containsKey("limit_nbHrs")){
        nbError = errors.get("limit_nbHrs");
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
    <title>Limite d'annulation</title>
</head>
<body>
    <div class="container-fluid" id="header">
    </div>

    <div class="container mt-5">
        <div class="row">
            <div class="col text-center">
                <h2>Limite d'annulation</h2>
                <p class="text-muted">Définir la limite de temps pour annuler une réservation avant le départ</p>
            </div>
        </div>
    </div>

    <div id="formulaireBloc" class="formulaire-vrai offset-3 mt-5">
        <form id="formAjout" action="setAnnul" method="POST">
            <div class="form-group mb-3">
                <label for="dateApplication" class="form-label">Date d'application <span class="text-danger">*</span></label>
                <input type="datetime-local" 
                       id="dateApplication" 
                       name="dateApplication" 
                       class="form-control" 
                       required 
                       value="${dateApplication}">
                <div class="form-text">Date à partir de laquelle cette règle s'applique</div>
                <% for(String err : dateError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group mb-3">
                <label for="hrs" class="form-label">Nombre d'heures avant le départ <span class="text-danger">*</span></label>
                <div class="input-group">
                    <input type="number" 
                           id="hrs" 
                           name="nbHrs" 
                           class="form-control" 
                           required 
                           step="0.01" 
                           min="0" 
                           value="${nbHrs}">
                    <span class="input-group-text">heures</span>
                </div>
                <div class="form-text">Temps minimum requis entre l'annulation et le départ du vol</div>
                <% for(String err : nbError) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <div class="form-group mb-3">
                <label for="vol" class="form-label">Vol concerné</label>
                <select name="idVol" id="vol" class="form-select">
                    <option value="">Règle générale (tous les vols)</option>
                    <% if(vols != null) {
                        for(Vol v : vols) { %>
                            <option value="<%= v.getIdVol() %>"><%= v.getIdVol() %></option>
                    <%  }
                    } %>
                </select>
                <div class="form-text">Laissez vide pour appliquer à tous les vols, ou sélectionnez un vol spécifique</div>
            </div>

            <div class="form-group d-flex gap-2">
                <button type="submit" class="btn btn-warning">
                    <i class="fas fa-save"></i> Enregistrer la limite
                </button>
                <a href="javascript:history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>

    <div id="errorMessage" data-value="<%=errorMessage %>"></div>
    
    <script src="./assets/js/header.js"></script>
    <script>
        window.onload = function(){
            setHeader('../header.html');
            var value = document.getElementById("errorMessage").dataset.value;
            if(value != undefined && value != ""){
                alert(value);
            }
            
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            
            const currentDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
            
            const dateInput = document.getElementById('dateApplication');
            if (!dateInput.value) {
                dateInput.value = currentDateTime;
            }
            
            document.getElementById('formAjout').addEventListener('submit', function(e) {
                const nbHrs = parseFloat(document.getElementById('hrs').value);
                const dateApplication = new Date(document.getElementById('dateApplication').value);
                const maintenant = new Date();
                
                if (nbHrs < 0) {
                    alert('Le nombre d\'heures ne peut pas être négatif.');
                    e.preventDefault();
                    return false;
                }
                
                if (nbHrs > 168) { 
                    if (!confirm('Vous avez défini une limite de plus de 7 jours. Voulez-vous continuer ?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                if (dateApplication < maintenant) {
                    if (!confirm('La date d\'application est dans le passé. Voulez-vous continuer ?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                const input = document.getElementById('hrs');
                input.value = parseFloat(input.value).toFixed(2);
                
                console.log('Limite d\'annulation configurée:');
                console.log('- Date application:', dateApplication);
                console.log('- Limite:', nbHrs + ' heures');
                console.log('- Vol:', document.getElementById('vol').value || 'Tous les vols');
            });
        }
    </script>
</body>
</html>