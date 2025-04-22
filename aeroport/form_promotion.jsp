<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.ArrayList" %>
<%@page import="aeroport.vol.Vol" %>
<%@page import="aeroport.avion.Type_siege" %>
<%
    Vol[] vols = (Vol[])request.getAttribute("list_vol");
    Type_siege[] sieges = (Type_siege[])request.getAttribute("list_siege");

    String errorMessage = "";
    if(request.getAttribute("errorMessage") != null){
        errorMessage = (String)request.getAttribute("errorMessage");
    }

    Map<String,ArrayList<String>> errors = new HashMap<>();
    if(request.getAttribute("error") != null){
        errors = (Map<String,ArrayList<String>>)request.getAttribute("error");
    }

    ArrayList<String> dateErrorF = new ArrayList<>();
    if(errors.containsKey("promotion_dateFin")){
        dateErrorF = errors.get("promotion_dateFin");
    }

    ArrayList<String> nbErrorS = new ArrayList<>();      
    if(errors.containsKey("promotion_nbSiege")){
        nbErrorS = errors.get("promotion_nbSiege");
    }

    ArrayList<String> prixErrorP = new ArrayList<>();      
    if(errors.containsKey("promotion_prixPromotion")){
        prixErrorP = errors.get("promotion_prixPromotion");
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
    <title>Promotion</title>
    <style>
        .price-input {
            background: linear-gradient(135deg, #e8f5e8, #f0f9ff);
            border: 2px solid #28a745;
            font-weight: bold;
            font-size: 1.1em;
        }
        .price-input:focus {
            border-color: #1e7e34;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        .promotion-card {
            background: linear-gradient(135deg, #fff3cd, #d1ecf1);
            border-left: 4px solid #ffc107;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .exemple-prix {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 0.5rem;
            font-size: 0.9em;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container-fluid" id="header">
    </div>

    <div class="container mt-5">
        <div class="row">
            <div class="col text-center">
                <h2><i class="fas fa-tags"></i> Créer une promotion</h2>
                <p class="text-muted">Définissez un prix promotionnel fixe pour un vol</p>
            </div>
        </div>
    </div>

    

    <div id="formulaireBloc" class="formulaire-vrai offset-2 mt-4">
        <form id="formAjout" action="makePromo" method="POST">
            
            <!-- Vol -->
            <div class="form-group mb-3">
                <label for="vol" class="form-label">Vol <span class="text-danger">*</span></label>
                <select name="idVol" id="vol" class="form-select" required onchange="afficherPrixNormal()">
                    <option value="">Choisir un vol</option>
                    <% if(vols != null) {
                        for(Vol v : vols) { %>
                            <option value="<%= v.getIdVol() %>"><%= v.getIdVol() %> - <%= v.getDepart() %> → <%= v.getDestination() %></option>
                    <%  }
                    } %>
                </select>
                <div class="form-text">Sélectionnez le vol concerné par la promotion</div>
            </div>

            <!-- Classe -->
            <div class="form-group mb-3">
                <label for="cl" class="form-label">Classe <span class="text-danger">*</span></label>
                <select name="idTypeSiege" id="cl" class="form-select" required onchange="afficherPrixNormal()">
                    <option value="">Choisir une classe</option>
                    <% if(sieges != null) {
                        for(Type_siege v : sieges) { %>
                            <option value="<%= v.getId_type_siege() %>"><%= v.getDesignation() %></option>
                    <%  }
                    } %>
                </select>
                <div class="form-text">Sélectionnez la classe de siège concernée</div>
            </div>

            <!-- Prix promotion -->
            <div class="form-group mb-3">
                <label for="prixPromo" class="form-label">Prix promotionnel <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-euro-sign"></i></span>
                    <input type="number" 
                           id="prixPromo" 
                           name="prixPromotion" 
                           class="form-control price-input" 
                           required 
                           step="0.01" 
                           min="0.01" 
                           placeholder="Ex: 150.00"
                           value="${prixPromotion}">
                    <span class="input-group-text">€</span>
                </div>
                <div class="form-text">
                    Entrez le nouveau prix promotionnel (doit être inférieur au prix normal)
                    <div id="prixComparaison" class="exemple-prix mt-2" style="display: none;">
                        <strong>Prix normal :</strong> <span id="prixNormal">-</span> €<br>
                        <strong>Économie :</strong> <span id="economie">-</span> € (<span id="pourcentageEco">-</span>%)
                    </div>
                </div>
                <% for(String err : prixErrorP) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <!-- Date de fin -->
            <div class="form-group mb-3">
                <label for="dateFin" class="form-label">Date de fin de la promotion <span class="text-danger">*</span></label>
                <input type="datetime-local" 
                       id="dateFin" 
                       name="dateFin" 
                       class="form-control" 
                       required 
                       value="${dateFin}">
                <div class="form-text">
                    La promotion sera active de maintenant jusqu'à cette date
                    <br><small class="text-muted">La date doit être avant le départ du vol</small>
                </div>
                <% for(String err : dateErrorF) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <!-- Nombre de sièges -->
            <div class="form-group mb-3">
                <label for="siege" class="form-label">Nombre de sièges en promotion <span class="text-danger">*</span></label>
                <input type="number" 
                       id="siege" 
                       name="nbSiege" 
                       class="form-control" 
                       required 
                       min="1" 
                       placeholder="Ex: 10"
                       value="${nbSiege}">
                <div class="form-text">
                    Nombre de sièges qui bénéficieront de ce prix promotionnel
                    <br><small class="text-muted">Une fois ce quota atteint, le prix normal s'appliquera</small>
                </div>
                <% for(String err : nbErrorS) { %>
                    <div class="text-danger small"><%= err %></div>
                <% } %>
            </div>

            <!-- Boutons -->
            <div class="form-group d-flex gap-2">
                <button type="submit" class="btn btn-success btn-lg">
                    <i class="fas fa-check"></i> Créer la promotion
                </button>
                <a href="javascript:history.back()" class="btn btn-secondary btn-lg">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>

    <div id="errorMessage" data-value="<%=errorMessage %>"></div>
    
    <script src="./assets/js/header.js"></script>
    <script>
        // Prix normaux fictifs pour la démonstration (à remplacer par des données réelles)
        const prixNormaux = {
            'VOL000001': {
                'TYP000001': 1500.00,  // Business
                'TYP000002': 800.00    // Économique
            },
            'VOL000002': {
                'TYP000001': 2000.00,
                'TYP000002': 1200.00
            }
            // Ajouter d'autres vols...
        };

        function afficherPrixNormal() {
            const volSelect = document.getElementById('vol');
            const classeSelect = document.getElementById('cl');
            const prixInput = document.getElementById('prixPromo');
            const prixComparaison = document.getElementById('prixComparaison');
            
            if (volSelect.value && classeSelect.value) {
                const vol = volSelect.value;
                const classe = classeSelect.value;
                
                if (prixNormaux[vol] && prixNormaux[vol][classe]) {
                    const prixNormal = prixNormaux[vol][classe];
                    document.getElementById('prixNormal').textContent = prixNormal.toFixed(2);
                    prixComparaison.style.display = 'block';
                    
                    // Calculer l'économie quand le prix promo change
                    prixInput.addEventListener('input', function() {
                        calculerEconomie(prixNormal, parseFloat(this.value) || 0);
                    });
                } else {
                    prixComparaison.style.display = 'none';
                }
            } else {
                prixComparaison.style.display = 'none';
            }
        }

        function calculerEconomie(prixNormal, prixPromo) {
            if (prixPromo > 0 && prixPromo < prixNormal) {
                const economie = prixNormal - prixPromo;
                const pourcentage = (economie / prixNormal * 100).toFixed(1);
                
                document.getElementById('economie').textContent = economie.toFixed(2);
                document.getElementById('pourcentageEco').textContent = pourcentage;
                
                // Changer la couleur selon l'économie
                const prixInput = document.getElementById('prixPromo');
                if (pourcentage > 30) {
                    prixInput.style.borderColor = '#28a745'; // Vert
                } else if (pourcentage > 15) {
                    prixInput.style.borderColor = '#ffc107'; // Jaune
                } else {
                    prixInput.style.borderColor = '#6c757d'; // Gris
                }
            } else {
                document.getElementById('economie').textContent = '-';
                document.getElementById('pourcentageEco').textContent = '-';
            }
        }

        window.onload = function(){
            setHeader('../header.html');
            var value = document.getElementById("errorMessage").dataset.value;
            if(value != undefined && value != ""){
                alert(value);
            }
            
            // Définir la date minimale à maintenant
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.getElementById('dateFin').min = now.toISOString().slice(0, 16);
            
            document.getElementById('formAjout').addEventListener('submit', function(e) {
                const dateFin = new Date(document.getElementById('dateFin').value);
                const maintenant = new Date();
                
                if (dateFin <= maintenant) {
                    alert('La date de fin doit être dans le futur.');
                    e.preventDefault();
                    return false;
                }
                
                const prixPromo = parseFloat(document.getElementById('prixPromo').value);
                if (prixPromo <= 0) {
                    alert('Le prix promotionnel doit être supérieur à 0.');
                    e.preventDefault();
                    return false;
                }
                
                const nbSieges = parseInt(document.getElementById('siege').value);
                if (nbSieges < 1) {
                    alert('Le nombre de sièges doit être au moins 1.');
                    e.preventDefault();
                    return false;
                }
                
                console.log('Promotion créée:');
                console.log('- Prix promotionnel:', prixPromo + '€');
                console.log('- Fin:', dateFin);
                console.log('- Sièges:', nbSieges);
            });
        }
    </script>
</body>
</html>