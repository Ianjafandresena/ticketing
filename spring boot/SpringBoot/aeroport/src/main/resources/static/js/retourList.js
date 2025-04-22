var table = document.getElementById("info-body");
const closePopupButton = document.getElementById('closePopup');
const popup = document.getElementById('popup');
const overlay = document.getElementById('overlay');

var array;

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

async function getDetail(idRetour){
    const url1 = "http://localhost:8080/atelier_reparation/retour?action=detail&return=json&id="+idRetour;
    try{
        const response1 = await fetch(url1);
        if(!response1.ok){
            throw new Error('Une erreur est survenue');
        }
        const data1 = await response1.json();
        
        array = data1.listService;
    } catch(error){
        throw new Error(error);
    }
}

function setDetail(idRetour){
    getDetail(idRetour).then(function(){
        while (table.firstChild) {
            table.removeChild(table.firstChild);  // Supprime le premier enfant (un <tr>) jusqu'à ce qu'il n'en reste plus
        }
        array.forEach(element => {
            var tr = document.createElement("tr");
            var tdDes = document.createElement("td");
            var tdPrix = document.createElement("td");
            tdDes.textContent = element.service.designation;
            tdPrix = element.prix;
            tr.appendChild(tdDes);
            table.appendChild(tr);
        });
        popup.style.display = 'block'; // Afficher le popup
        overlay.style.display = 'block'; // Afficher le fond sombre
    });
}
