function changeView(){
    var vue = document.getElementById("vue");
    var password = document.getElementById("password-area");
    if(password.getAttribute("type") == "password"){
        password.setAttribute("type","text");
        vue.setAttribute("class","fas fa-eye-slash");
        return;
    }
    password.setAttribute("type","password");
    vue.setAttribute("class","fas fa-eye");
}

function transition(){
    var affiche = document.getElementById("actif");
    var non_affiche = document.getElementById("non-actif");
    affiche.classList.add("transit");
    setTimeout(function(){
        affiche.classList.remove("actif");
        affiche.classList.add("non-actif");
        affiche.classList.remove("transit");
        non_affiche.classList.remove("non-actif");
        non_affiche.classList.add("inverse");
        setTimeout(function(){
            non_affiche.classList.remove("inverse");
            non_affiche.classList.add("actif");
            non_affiche.setAttribute("id","actif");
            affiche.setAttribute("id","non-actif");
        },1000);
    },1000);
}

function display(){
    var vue = document.getElementById("vue");
    var affiche = document.getElementById("image_de_fond");
    var action = function(){
        changeView();
    }
    var action2 = function(){
        transition();
    }
    vue.addEventListener("click",action);
    var interval = setInterval(transition,7000);
}