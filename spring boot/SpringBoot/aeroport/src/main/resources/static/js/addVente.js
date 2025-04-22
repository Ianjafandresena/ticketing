var deH = document.getElementById("desH");
var deM = document.getElementById("desM");
var deS = document.getElementById("desS");
var body = document.getElementById("body");

const now = new Date().toLocaleTimeString();

deH.value = now.split(":")[0];
deM.value = now.split(":")[1];
deS.value = now.split(":")[2];

var qteF = document.getElementById("qte");
var usersF = document.getElementById("users");
var dateF = document.getElementById("date");
var prixF = document.getElementById("prix");

var composant = document.getElementById("composant");

var table_body = document.getElementById("tab_body");
var add_button = document.getElementById("add");

add_button.addEventListener("click",function(event){
    event.preventDefault();
    add_composant();

})

function initiate_form(){
   body.style.display = "block";
}

function add_composant(){
    var qteV = qteF.value;
    var prixV = prixF.value;
    var compV = composant.textContent;

    var tr = document.createElement("tr");
    var td1 = document.createElement("td");
    var td2 = document.createElement("td");
    var td3 = document.createElement("td");

    td1.textContent = compV;
    td2.textContent = qteV;
    td3.textContent = prixV;
}

function setPrice(){
    
}

function getComposant(){
    
}

