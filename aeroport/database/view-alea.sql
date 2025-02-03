-- Insertion des avions
INSERT INTO avion (id_avion, model, date_fabrication) VALUES
('AV001', 'Air Madagascar', '2020-01-01'),
('AV002', 'Air France', '2019-01-01');

-- Insertion des villes
INSERT INTO ville (id_ville, designation) VALUES
('ANT', 'Antananarivo'),
('CDG', 'Paris CDG'),
('MRU', 'Mauritius'),
('ADD', 'Addis Abeba');

-- Insertion des types de sièges
INSERT INTO type_siege (id_type_siege, designation) VALUES
('ECO', 'Economique'),
('AFF', 'Affaire');

-- AJOUT CRUCIAL: Insertion des capacités d'avion par type de siège
INSERT INTO avion_place (id_avion, id_type_siege, nb) VALUES
('AV001', 'ECO', 150),    -- Air Madagascar: 150 places économiques
('AV001', 'AFF', 20),     -- Air Madagascar: 20 places affaires
('AV002', 'ECO', 200),    -- Air France: 200 places économiques
('AV002', 'AFF', 30);     -- Air France: 30 places affaires

-- Insertion des vols
INSERT INTO vol (id_vol, depart, destination, date_depart, duree_vol) VALUES
('VOL1', 'ANT', 'ADD', '2025-09-05 08:00:00', '6 hours'),
('VOL2', 'CDG', 'MRU', '2025-09-15 21:00:00', '12 hours');

-- Insertion des tarifs par vol et classe
INSERT INTO vol_tarif (id_vol, id_type_siege, tarif) VALUES
('VOL1', 'ECO', 200.00),
('VOL1', 'AFF', 300.00),
('VOL2', 'ECO', 350.00),
('VOL2', 'AFF', 400.00);

-- Association vol-avion
INSERT INTO vol_avion (id_vol, id_avion) VALUES
('VOL1', 'AV001'),
('VOL2', 'AV002');

-- Insertion des promotions selon les paramètres donnés
-- Pour VOL1: 4 places à 200€ jusqu'au 27 août, puis 2 places à 300€ jusqu'au 3 septembre
INSERT INTO promotion (id_promotion, id_vol, id_type_siege, date_fin, nb_siege, prix_promotion) VALUES
('PROMO_VOL1_1', 'VOL1', 'ECO', '2025-08-27 23:59:59', 4, 200.00),
('PROMO_VOL1_2', 'VOL1', 'ECO', '2025-09-03 23:59:59', 2, 300.00);

-- Pour VOL2: 3 places à 350€ jusqu'au 5 septembre, puis 1 place à 400€ jusqu'au 13 septembre
INSERT INTO promotion (id_promotion, id_vol, id_type_siege, date_fin, nb_siege, prix_promotion) VALUES
('PROMO_VOL2_1', 'VOL2', 'ECO', '2025-09-05 23:59:59', 3, 350.00),
('PROMO_VOL2_2', 'VOL2', 'ECO', '2025-09-13 23:59:59', 1, 400.00);

-- Insertion des réservations
-- VOL1 réservations
INSERT INTO reservation (id_reservation, id_vol, id_type_siege, date_reservation, nb_adulte, nb_enfant, prix, status) VALUES
('RES1', 'VOL1', 'ECO', '2025-08-20 10:00:00', 1, 0, 200.00, 'confirmed'),    -- Payé, promotion 200€
('RES2', 'VOL1', 'ECO', '2025-08-21 10:00:00', 1, 0, 200.00, 'pending'),      -- Non payé, promotion 200€
('RES3', 'VOL1', 'ECO', '2025-08-21 14:00:00', 1, 0, 200.00, 'confirmed'),    -- Payé, promotion 200€
('RES4', 'VOL1', 'ECO', '2025-08-28 10:00:00', 1, 0, 300.00, 'confirmed'),    -- Payé, promotion 300€
('RES5', 'VOL1', 'ECO', '2025-08-29 10:00:00', 1, 0, 300.00, 'confirmed'),    -- Payé, promotion 300€
('RES6', 'VOL1', 'ECO', '2025-09-01 10:00:00', 1, 0, 300.00, 'pending'),      -- Non payé, prix normal (promotion épuisée)
('RES7', 'VOL1', 'ECO', '2025-09-02 10:00:00', 1, 0, 300.00, 'confirmed');    -- Payé, prix normal

-- VOL2 réservations
INSERT INTO reservation (id_reservation, id_vol, id_type_siege, date_reservation, nb_adulte, nb_enfant, prix, status) VALUES
('RES8', 'VOL2', 'ECO', '2025-09-01 10:00:00', 1, 0, 350.00, 'confirmed'),    -- Payé, promotion 350€
('RES9', 'VOL2', 'ECO', '2025-09-02 10:00:00', 1, 0, 350.00, 'pending'),      -- Non payé, promotion 350€
('RES10', 'VOL2', 'ECO', '2025-09-08 10:00:00', 1, 0, 400.00, 'confirmed'),   -- Payé, promotion 400€
('RES11', 'VOL2', 'ECO', '2025-09-10 10:00:00', 1, 0, 400.00, 'confirmed');   -- Payé, prix normal (promotion épuisée)

-- Mise à jour des promotions pour refléter l'utilisation
-- PROMO_VOL1_1: 4 places -> 2 utilisées (RES1, RES3) -> 2 restantes
UPDATE promotion SET nb_siege = 2 WHERE id_promotion = 'PROMO_VOL1_1';

-- PROMO_VOL1_2: 2 places -> 2 utilisées (RES4, RES5) -> 0 restantes
UPDATE promotion SET nb_siege = 0 WHERE id_promotion = 'PROMO_VOL1_2';

-- PROMO_VOL2_1: 3 places -> 2 utilisées (RES8, RES9) -> 1 restante
UPDATE promotion SET nb_siege = 1 WHERE id_promotion = 'PROMO_VOL2_1';

-- PROMO_VOL2_2: 1 place -> 1 utilisée (RES10) -> 0 restantes
UPDATE promotion SET nb_siege = 0 WHERE id_promotion = 'PROMO_VOL2_2';

-- Vérifications des données insérées
SELECT 'AVIONS ET CAPACITES' as section;
SELECT a.id_avion, a.model, ap.id_type_siege, ap.nb as capacite 
FROM avion a 
JOIN avion_place ap ON a.id_avion = ap.id_avion 
ORDER BY a.id_avion, ap.id_type_siege;

SELECT 'VOLS' as section;
SELECT v.id_vol, v.depart, v.destination, v.date_depart, va.id_avion 
FROM vol v 
JOIN vol_avion va ON v.id_vol = va.id_vol;

SELECT 'PROMOTIONS ACTIVES' as section;
SELECT id_promotion, id_vol, id_type_siege, prix_promotion, nb_siege, date_fin 
FROM promotion 
WHERE nb_siege > 0 
ORDER BY id_vol, date_fin;

SELECT 'RESERVATIONS PAR STATUS' as section;
SELECT status, COUNT(*) as nombre, SUM(prix) as total_prix 
FROM reservation 
GROUP BY status;

-- Test de disponibilité des sièges
SELECT 'DISPONIBILITE SIEGES' as section;
SELECT 
    v.id_vol,
    ap.id_type_siege,
    ap.nb as capacite_totale,
    COALESCE(SUM(CASE WHEN r.status != 'cancelled' THEN r.nb_adulte + r.nb_enfant ELSE 0 END), 0) as reserves,
    ap.nb - COALESCE(SUM(CASE WHEN r.status != 'cancelled' THEN r.nb_adulte + r.nb_enfant ELSE 0 END), 0) as disponibles
FROM vol v
JOIN vol_avion va ON v.id_vol = va.id_vol
JOIN avion_place ap ON va.id_avion = ap.id_avion
LEFT JOIN reservation r ON v.id_vol = r.id_vol AND ap.id_type_siege = r.id_type_siege
GROUP BY v.id_vol, ap.id_type_siege, ap.nb
ORDER BY v.id_vol, ap.id_type_siege;


SELECT 
    'VOL1' as vol,
    COUNT(*) as nb_reservations,
    SUM(nb_adulte + nb_enfant) as nb_passagers,
    SUM(prix) as chiffre_affaires
FROM reservation 
WHERE id_vol = 'VOL1' 
AND status = 'confirmed'
AND date_reservation <= '2025-09-15 23:59:59';

SELECT 
    'VOL2' as vol,
    COUNT(*) as nb_reservations,
    SUM(nb_adulte + nb_enfant) as nb_passagers,
    SUM(prix) as chiffre_affaires
FROM reservation 
WHERE id_vol = 'VOL2' 
AND status = 'confirmed'
AND date_reservation <= '2025-09-15 23:59:59';