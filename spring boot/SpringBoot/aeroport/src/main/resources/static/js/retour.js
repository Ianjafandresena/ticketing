var table_body = document.getElementById("table-body");
var reparation_form = document.getElementById("typeReparation");
var ordinateur = document.getElementById("listeReparations");
var date = document.getElementById("dateReparation");
var personnel = document.getElementById("personnel");
var add = document.getElementById("add");
var heure = document.getElementById("heure");
var minute = document.getElementById("minute");

var form = document.getElementById("formAjout");

const now = new Date().toLocaleTimeString();

var reparationList = []
var selectedReparation;

heure.value = now.split(":")[0];
minute.value = now.split(":")[1];

reparation_form.addEventListener("change",function(){
    selectedReparation = reparation_form.options[reparation_form.selectedIndex];
});

add.addEventListener("click",function(event){
    event.preventDefault();
    add_reparation();
});


form.addEventListener("submit",function(event){
    event.preventDefault();
    if(ordinateur.options[ordinateur.selectedIndex] == undefined){
        alert("Veuillez selectionner un ordinateur");
        return;
    }
    if(date.value == ""){
        alert("Veuillez definir une date");
        return;
    }
    if(heure.value == ""){
        heure.value = "00";
    }
    if(minute.value == ""){
        minute.value = "00";
    }
    sendRetour();
})



function add_reparation(){
    if(selectedReparation == undefined){
        alert("Veuillez selectionner une reparation");
        return;
    }
    let value = selectedReparation.value;
    let libelle = selectedReparation.textContent;
    
    if(!reparationList.includes(value)){
        reparationList.push(value);
        let tr = document.createElement("tr");
        let td = document.createElement("td");
        let buttonTd = document.createElement("td");
        let button = document.createElement("button");
        button.classList.add("btn");
        button.classList.add("btn-danger");
        button.textContent = "Effacer";
        button.addEventListener("click",function(event){
            event.preventDefault();
            delete_reparation(value);
        })
        buttonTd.appendChild(button);
        td.textContent = libelle;
        tr.id = "rep"+value;
        tr.appendChild(td);
        tr.appendChild(buttonTd);
        table_body.appendChild(tr);
    } 
    else{
        alert("Cette reparation a deja ete effectué");
    }
    console.log(reparationList);
}

function delete_reparation(id_reparation){
    reparationList = reparationList.filter(value => value !== id_reparation);
    var line = document.getElementById("rep"+id_reparation);
    line.remove();
}

function sendRetour(){
    const url = "http://localhost:8080/atelier_reparation/retour"

    let dateV = date.value;
    let oV = ordinateur.value;
    let time = heure.value+":"+minute.value+":00";
    let dateF = dateV + " " +time;
    let idpers = personnel.value;

    const data ={
        "date":dateF,
        "idOrdinateurClient":oV,
        "listService":reparationList,
        "idPersonnel":idpers
    };

    fetch(url, {
        method: 'POST', // Méthode HTTP
        headers: {
          'Content-Type': 'application/json' // Spécifie que les données sont en JSON
        },
        body: JSON.stringify(data) // Convertir les données en JSON
      })
        .then(response => {
          if (!response.ok) {
            throw new Error(`Erreur : ${response.status}`);
          }
          alert("Les données ont été envoyés avec succès");
          location.reload();
           // Convertir la réponse JSON en objet JavaScript
        })
        .then(result => {
          console.log('Réponse du serveur :', result);
        })
        .catch(error => {
          console.error('Erreur :', error);
        });

}

function resetAll(){
    reparation_form.selectedIndex = 0;
    reparation_form.value = "";
    ordinateur.selectedIndex = 0;
    ordinateur.value = "";
    date.value = "";

}

