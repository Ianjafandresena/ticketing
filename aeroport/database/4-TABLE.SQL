CREATE TABLE users(
    id_users VARCHAR(255) PRIMARY KEY,
    login VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE role(
    id_role SERIAL PRIMARY KEY,
    designation VARCHAR(255)
);

CREATE TABLE users_role(
    id_role INTEGER REFERENCES role(id_role),
    id_users VARCHAR (255) REFERENCES users(id_users),
    UNIQUE(id_role,id_users)
);

-------------------------------

CREATE TABLE categorie_passager(
    id_categorie_passager VARCHAR(255) PRIMARY KEY,
    designation VARCHAR(255)
);

CREATE TABLE type_siege(
    id_type_siege VARCHAR(255) PRIMARY KEY,
    designation VARCHAR(255) NOT NULL
);

CREATE TABLE avion(
    id_avion VARCHAR(255) PRIMARY KEY,
    model VARCHAR(255) NOT NULL,
    date_fabrication DATE
);  

CREATE TABLE avion_place(
    id_avion_place SERIAL PRIMARY KEY,
    id_type_siege VARCHAR(255) REFERENCES type_siege(id_type_siege),
    nb INTEGER
);
ALTER TABLE avion_place ADD column id_avion VARCHAR(255) REFERENCES avion(id_avion);

CREATE TABLE ville(
    id_ville VARCHAR(255) PRIMARY KEY,
    designation VARCHAR(255) NOT NULL
);

CREATE TABLE vol(
    id_vol VARCHAR(255) PRIMARY KEY,
    destination VARCHAR(255) REFERENCES ville(id_ville),
    depart VARCHAR(255) REFERENCES ville(id_ville),
    date_debut DATE,
    date_fin DATE,
    duree_vol INTERVAL
);
ALTER TABLE vol drop column date_debut;
ALTER TABLE vol DROP column date_fin;
ALTER TABLE vol ADD COLUMN date_depart TIMESTAMP;

CREATE TABLE vol_tarif(
    id_vol_tarif SERIAL PRIMARY KEY,
    id_type_siege VARCHAR(255) REFERENCES type_siege(id_type_siege),
    id_vol VARCHAR(255) REFERENCES vol(id_vol),
    tarif NUMERIC(15,2) NOT NULL
);
ALTER TABLE vol_tarif ADD COLUMN age INTEGER;

CREATE TABLE vol_avion(
    id_vol_avion SERIAL PRIMARY KEY,
    id_vol VARCHAR(255) REFERENCES vol(id_vol),
    id_avion VARCHAR(255) REFERENCES avion(id_avion)
);

CREATE TABLE client(
    id_client VARCHAR(255) PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    age INTEGER
);
ALTER TABLE client ADD COLUMN id_users VARCHAR REFERENCES users(id_users);

CREATE TABLE reservation(
    id_reservation VARCHAR(255) PRIMARY KEY,
    id_vol VARCHAR(255) REFERENCES vol(id_vol),
    id_type_siege VARCHAR(255) REFERENCES  type_siege(id_type_siege),
    nb INTEGER DEFAULT 1,
    prix NUMERIC(15,2) NOT NULL,
    id_client VARCHAR(255) REFERENCES client(id_client)
);
ALTER TABLE reservation ADD column date_reservation DATE;
ALTER TABLE reservation DROP column date_reservation;
ALTER TABLE reservation ADD column date_reservation TIMESTAMP;
ALTER TABLE reservation DROP column nb;
ALTER TABLE reservation ADD column nb_enfant INTEGER DEFAULT 0;
ALTER TABLE reservation ADD column nb_adulte INTEGER DEFAULT 0;

--------------------------------------------------------

CREATE TABLE promotion(
    id_promotion VARCHAR(255) PRIMARY KEY,
    id_vol VARCHAR(255) REFERENCES vol(id_vol),
    pourcentage NUMERIC(3,1) NOT NULL,
    id_type_siege VARCHAR(255) REFERENCES type_siege(id_type_siege)
);
ALTER TABLE promotion ADD COLUMN date_debut TIMESTAMP;
ALTER TABLE promotion ADD COLUMN date_fin TIMESTAMP;
ALTER TABLE promotion ADD COLUMN nb_siege INTEGER;

CREATE TABLE reduction(
    id_reduction SERIAL PRIMARY KEY,
    pourcentage NUMERIC(3,1) NOT NULL,
    id_categorie_passager VARCHAR(255) REFERENCES categorie_passager(id_categorie_passager),
    date_application TIMESTAMP
);

-----------------------------------------------------
CREATE TABLE limit_reservation(
    id_limit SERIAL PRIMARY KEY,
    nb_hrs NUMERIC(5,2),
    date_application TIMESTAMP
);
ALTER TABLE limit_reservation ADD COLUMN id_vol VARCHAR(255) REFERENCES vol(id_vol);

CREATE TABLE limit_annulation(
    id_limit SERIAL PRIMARY KEY,
    nb_hrs NUMERIC(5,2),
    date_application TIMESTAMP
);
ALTER TABLE limit_annulation ADD COLUMN id_vol VARCHAR(255) REFERENCES vol(id_vol);


-- Ajout de la colonne status à la table reservation
ALTER TABLE reservation ADD COLUMN status VARCHAR(20) DEFAULT 'pending';

-- Mise à jour des réservations existantes pour avoir le status 'pending'
UPDATE reservation SET status = 'pending' WHERE status IS NULL;

-- Optionnel: Ajouter une contrainte pour limiter les valeurs possibles
ALTER TABLE reservation ADD CONSTRAINT chk_reservation_status 
CHECK (status IN ('pending', 'confirmed', 'cancelled'));

-- Créer un index pour améliorer les performances de recherche par status
CREATE INDEX idx_reservation_status ON reservation(status);


-- Supprimer la colonne pourcentage et ajouter prix_promotion
ALTER TABLE promotion DROP COLUMN pourcentage;
ALTER TABLE promotion ADD COLUMN prix_promotion NUMERIC(15,2) NOT NULL;

-- Supprimer la colonne date_debut (ne garder que date_fin)
ALTER TABLE promotion DROP COLUMN date_debut;

-- Vérifier la structure finale
-- La table promotion aura maintenant :
-- id_promotion, id_vol, id_type_siege, date_fin, nb_siege, prix_promotion