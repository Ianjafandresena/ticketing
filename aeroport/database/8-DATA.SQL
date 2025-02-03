INSERT INTO users(login,password) VALUES('admin',crypt('admin', gen_salt('bf')));
INSERT INTO users(login,password) VALUES('CLI1',crypt('test',gen_salt('bf')));

INSERT INTO client(nom,prenom,age) VALUES('test','test',25);

INSERT INTO role(designation) VALUES ('admin'),('client');

INSERT INTO users_role(id_users,id_role) VALUES ('USE000001',1), ('USE000002',2);

INSERT INTO type_siege(designation) VALUES ('business'), ('economique');

INSERT INTO categorie_passager(designation) VALUES ('Enfant'), ('Adulte');

INSERT INTO avion (model, date_fabrication) VALUES 
('Boeing 747', '2005-06-15'), 
('Airbus A320', '2010-09-20'), 
('Boeing 737', '2018-03-25');

INSERT INTO avion_place (id_type_siege, nb,id_avion) VALUES 
('TYP000001', 50,'AVI000001'), 
('TYP000002', 150,'AVI000001'), 
('TYP000001', 30,'AVI000002'), 
('TYP000002', 120,'AVI000002'), 
('TYP000001', 40,'AVI000003'), 
('TYP000002', 200,'AVI000003');

INSERT INTO ville (designation) VALUES 
('Paris'), 
('New York'), 
('Londres'), 
('Tokyo'), 
('Dubai');

INSERT INTO vol (destination, depart, date_depart, duree_vol) VALUES 
('VIL000002', 'VIL000001', '2025-03-10 00:00:00', '07:30:00'), 
('VIL000003', 'VIL000002', '2025-03-15 10:00:00', '06:45:00'), 
('VIL000004', 'VIL000003', '2025-04-05 13:30:00', '12:30:00'), 
('VIL000005', 'VIL000001', '2025-05-01 13:00:00', '06:00:00');

INSERT INTO vol_tarif (id_type_siege, id_vol, tarif) VALUES 
('TYP000001', 'VOL000001', 1500.00), 
('TYP000002', 'VOL000001', 500.00), 
('TYP000001', 'VOL000002', 1200.00), 
('TYP000002', 'VOL000002', 450.00), 
('TYP000001', 'VOL000003', 2200.00), 
('TYP000002', 'VOL000003', 800.00), 
('TYP000001', 'VOL000004', 1400.00), 
('TYP000002', 'VOL000004', 600.00);

INSERT INTO vol_avion (id_vol, id_avion) VALUES 
('VOL000001', 'AVI000001'), 
('VOL000002', 'AVI000002'), 
('VOL000003', 'AVI000003'), 
('VOL000004', 'AVI000001');

INSERT INTO reservation(id_vol,id_type_siege,nb_enfant,nb_adulte,prix,id_client) VALUES 
('VOL000001','TYP000001',1,2,300000,'CLI000001'),
('VOL000001','TYP000002',0,3,10000,'CLI000001');

INSERT INTO promotion(id_vol,pourcentage,id_type_siege,date_debut,date_fin,nb_siege) VALUES 
('VOL000001',20,'TYP000001','2025-03-07','2025-03-09',13);

INSERT INTO promotion(id_vol,pourcentage,id_type_siege,date_debut,date_fin,nb_siege) VALUES 
('VOL000001',20,'TYP000001','2025-03-05','2025-03-06',13);

UPDATE reservation SET date_reservation = '2025-03-08 10:00:00';

INSERT INTO reduction(pourcentage,id_categorie_passager,date_application) VALUES(10,'PRM000001','2024-01-01 00:00:00');