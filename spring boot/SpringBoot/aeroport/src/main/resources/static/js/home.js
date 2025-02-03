var meilleur_comp = document.getElementById('meilleur_comp');
var ca = document.getElementById('ca');
var meilleur_jour = document.getElementById('meilleur_date');
var meilleur_chiffre = document.getElementById('meilleur_chiffre');
var icone_evol =  document.getElementById('icone_evol');

var cav;
var a_ca;

var mj;
var mc;

var qtes;
var designation;

function setChiffreAffaire(mois,annee){
    icone_evol.classList.remove("fa-arrow-alt-circle-up");
    icone_evol.classList.remove("text-success");
    icone_evol.classList.add("fa-minus-circle");
    icone_evol.classList.add("text-primary");
    var ancien_m = mois - 1;
    var ancien_a = annee;
    if(mois == 1){
        ancien_m = 12;
        ancien_a = annee - 1;
    }
    getChiffreAffaire(mois,annee,ancien_m,ancien_a).then(function(){
        if(a_ca > cav){
            icone_evol.classList.remove("fa-minus-circle");
            icone_evol.classList.remove("text-primary");
            icone_evol.classList.add("fa-arrow-alt-circle-down");
            icone_evol.classList.add("text-danger");
        } else if(a_ca < cav){
            icone_evol.classList.remove("fa-minus-circle");
            icone_evol.classList.remove("text-primary");
            icone_evol.classList.add("fa-arrow-alt-circle-up");
            icone_evol.classList.add("text-success");
        }
        console.log(cav+"AR");
        ca.textContent = cav+"AR";
    });

    
}
async function getChiffreAffaire(mois,annee,a_m,a_a){
    const url1 = "http://localhost:8080/atelier_reparation/adminService?return=json&annee="+annee+"&mois="+mois+"&quoi=ca&dataType=autre";
    const url2 ="http://localhost:8080/atelier_reparation/adminService?return=json&annee="+a_a+"&mois="+a_m+"&quoi=ca&dataType=autre";

    try{
        const response1 = await fetch(url1);
        if(!response1.ok){
            throw new Error('Une erreur est survenue');
        }
        const data1 = await response1.json();
        const response2 = await fetch(url2);
        if(!response2.ok){
            throw new Error('Une erreur est survenue');
        }
        const data2 = await response2.json();
        a_ca = data2.data;
        console.log(a_ca);
        cav = data1.data;
        console.log(cav);
    } catch(error){
        throw new Error(error);
    }
}

function setMeilleurJour(mois,annee){
    getMeilleurJour(mois,annee).then(function(){
        meilleur_jour.textContent = mj;
        meilleur_chiffre.textContent = mc + "AR";
    });
}

async function getMeilleurJour(mois,annee){
    const url1 = "http://localhost:8080/atelier_reparation/adminService?return=json&annee="+annee+"&mois="+mois+"&quoi=mj&dataType=autre";

    try{
        const response1 = await fetch(url1);
        if(!response1.ok){
            throw new Error('Une erreur est survenue');
        }
        const data1 = await response1.json();
        var date = Object.keys(data1.data)[0];
        var chiffre = Object.values(data1.data)[0];
        mj = date;
        mc = chiffre;
    } catch(error){
        throw new Error(error);
    }
}

function setMeilleurVente(mois,annee){
    getMeilleurVente(mois,annee).then(function(){
        var value = designation+" - "+qtes;
        meilleur_comp.textContent = value;
    });
}

async function getMeilleurVente(mois,annee){
    const url1 = "http://localhost:8080/atelier_reparation/adminService?return=json&annee="+annee+"&mois="+mois+"&quoi=mv&dataType=autre";

    try{
        const response1 = await fetch(url1);
        if(!response1.ok){
            throw new Error('Une erreur est survenue');
        }
        const data1 = await response1.json();
        designation = data1.data.composant.designation;
        qtes = data1.data.qte;
    } catch(error){
        throw new Error(error);
    }
}

function get(){
    console.log("get appelé");
}