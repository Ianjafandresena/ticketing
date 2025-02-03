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
    <title>Limite de réservation</title>
</head>
<body>
    <div class="container-fluid" id="header">
    </div>

    <div class="container mt-5">
        <div class="row">
            <div class="col text-center">
                <h2>Limite de réservation</h2>
                <p class="text-muted">Définir la limite de temps pour effectuer une réservation avant le départ</p>
            </div>
        </div>
    </div>

    <div id="formulaireBloc" style="max-width:600px; margin:40px auto; border:1px solid black; padding:20px;">
    <h2 style="margin-bottom:5px;">Limite de réservation</h2>
    <p style="margin-top:0; font-size:14px;">Définir la limite de temps pour effectuer une réservation avant le départ</p>

    <form id="formAjout" action="setReserv" method="POST">
        <!-- Date d'application -->
        <div style="margin-bottom:15px;">
            <label for="dateApplication"><b>Date d'application *</b></label><br>
            <input type="datetime-local" 
                   id="dateApplication" 
                   name="dateApplication" 
                   required 
                   value="${dateApplication}" 
                   style="width:100%; padding:5px; border:1px solid black;">
            <div style="font-size:12px;">Date à partir de laquelle cette règle s'applique</div>
            <% for(String err : dateError) { %>
                <div style="color:red; font-size:12px;"><%= err %></div>
            <% } %>
        </div>

        <!-- Nombre d'heures -->
        <div style="margin-bottom:15px;">
            <label for="hrs"><b>Nombre d'heures avant le départ *</b></label><br>
            <input type="number" 
                   id="hrs" 
                   name="nbHrs" 
                   required 
                   step="0.01" 
                   min="0" 
                   value="${nbHrs}" 
                   style="width:calc(100% - 60px); padding:5px; border:1px solid black;">
            <span> heures</span>
            <div style="font-size:12px;">Temps minimum requis entre la réservation et le départ du vol</div>
            <% for(String err : nbError) { %>
                <div style="color:red; font-size:12px;"><%= err %></div>
            <% } %>
        </div>

        <!-- Sélection du vol -->
        <div style="margin-bottom:15px;">
            <label for="vol"><b>Vol concerné</b></label><br>
            <select name="idVol" id="vol" style="width:100%; padding:5px; border:1px solid black;">
                <option value="">Règle générale (tous les vols)</option>
                <% if(vols != null) {
                    for(Vol v : vols) { %>
                        <option value="<%= v.getIdVol() %>"><%= v.getIdVol() %></option>
                <%  }
                } %>
            </select>
            <div style="font-size:12px;">Laissez vide pour appliquer à tous les vols, ou sélectionnez un vol spécifique</div>
        </div>

        <!-- Boutons -->
        <div style="margin-top:20px;">
            <button type="submit" style="padding:6px 12px; border:1px solid black; background:black; color:white;">
                💾 Enregistrer la limite
            </button>
            <a href="javascript:history.back()" style="padding:6px 12px; border:1px solid black; background:white; color:black; text-decoration:none; margin-left:10px;">
                ← Retour
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
                
                console.log('Limite de réservation configurée:');
                console.log('- Date application:', dateApplication);
                console.log('- Limite:', nbHrs + ' heures');
                console.log('- Vol:', document.getElementById('vol').value || 'Tous les vols');
            });
        }
    </script>
</body>
</html>