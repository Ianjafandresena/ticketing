var head = document.getElementById("header");
var body = document.getElementById("body");

function setHeader(headerLoc){
    fetch("/aeroport/header.jsp")
        .then(response=>{
            if(!response.ok){
                throw new Error('Erreur http:',response.status);
            }
            return response.text() 
        })
        .then(data => {
            head.innerHTML = data;
            body.style.display = 'block';
        }) 
        .catch(error =>{
            console.error('Erreur:',error);
        });
    console.log(headerLoc);
}