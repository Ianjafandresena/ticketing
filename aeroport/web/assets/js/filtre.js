const filtre = document.getElementById("filtre");
const button = document.getElementById("fixButton");

var isTouched = false;

button.addEventListener("click",function(event){
    event.preventDefault();
    if(!isTouched){
        filtre.style.display = 'block'; // Cacher le popup
        overlay.style.display = 'block'; // Cacher le fond sombre
        isTouched = true;
    }else{
        isTouched = false;
        filtre.style.display = 'none'; // Afficher le popup
        overlay.style.display = 'none'; // Afficher le fond sombre
    }  
});

overlay.addEventListener("click",function(){
    filtre.style.display = 'none'; // Cacher le popup
    overlay.style.display = 'none'; // Cacher le fond sombre
});