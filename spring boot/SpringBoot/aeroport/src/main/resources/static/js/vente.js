var details;
var typeObject;
var table = document.getElementById("info-body");
var table = document.getElementById("info-head");
const closePopupButton = document.getElementById('closePopup');
const popup = document.getElementById('popup');
const overlay = document.getElementById('overlay');

closePopupButton.addEventListener('click', () => {
    popup.style.display = 'none'; // Masquer le popup
    overlay.style.display = 'none'; // Masquer le fond sombre
});

// Cacher le popup si on clique sur l'overlay
overlay.addEventListener('click', () => {
    popup.style.display = 'none';
    overlay.style.display = 'none';
    fermerFormulaire();
});

async function getDetail(type,id_object){
    typeObject = type;
    const url1 = "http://localhost:8080/atelier_reparation/vente?action=get&return=json&quoi="+type+"&id="+id_object;
    try{
        const response1 = await fetch(url1);
        if(!response1.ok){
            throw new Error('Une erreur est survenue');
        }
        const data1 = await response1.json();
        
        array = data1.details;
    } catch(error){
        throw new Error(error);
    }
}

function setDetail(idService){
    var innerHtml;
    var tr = document.createElement("tr");
    if(typeObject == "composant"){
        var td1 = document.createElement("td");
        td1.appendChild(document.createTextNode("prix unitaire"));
    }
    getDetail(idService).then(function(){
        while (table.firstChild) {
            table.removeChild(table.firstChild);  // Supprime le premier enfant (un <tr>) jusqu'à ce qu'il n'en reste plus
        }
        array.forEach(element => {
            var tr = document.createElement("tr");
            var tdDes = document.createElement("td");
            var tdQ = document.createElement("td");
            tdDes.textContent = element.designation;
            tdQ.textContent = element.qte;
            console.log(element.designation);
            tr.appendChild(tdDes);
            tr.appendChild(tdQ);
            table.appendChild(tr);
        });
        popup.style.display = 'block'; // Afficher le popup
        overlay.style.display = 'block'; // Afficher le fond sombre
    });
}

function showAddForm(idService){
    var id = document.getElementById("id");
    id.value = idService;
    overlay.style.display = 'block'; // Afficher le fond sombre
    formulaireBloc.classList.add('show');

}
function fermerFormulaire(){
    formulaireBloc.classList.remove('show');
    overlay.style.display = 'none'; 
}