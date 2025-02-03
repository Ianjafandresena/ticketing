SELECT * from users WHERE password = crypt('test',password) AND login = 'CLI1';

SELECT * from vol WHERE duree_vol <= '48:00:00'; --par exemple

SELECT COALESCE(SUM(r.nb),0) as nb
FROM vol v 
JOIN vol_avion va ON v.id_vol = va.id_vol
JOIN avion a ON va.id_avion = a.id_avion
JOIN avion_place ap ON a.id_avion = ap.id_avion AND r.id_type_siege = 
JOIN reservation r ON r.id_vol = v.id_vol
WHERE r.id_type_siege = 'TYP000002'
AND r.id_vol = 'VOL000002';

SELECT COALESCE(SUM(r.nb),0) as nb
FROM reservation r 
JOIN vol v ON v.id_vol = r.id_vol
JOIN vol_avion va ON va.id_vol = v.id_vol
JOIN avion a ON a.id_avion = va.id_avion
WHERE r.id_type_siege = 'TYP000002'
AND r.id_vol = 'VOL000002';


select COALESCE(SUM(reservation.nb),0) as nb from reservation 
JOIN vol ON reservation.id_vol=vol.id_vol 
JOIN vol_avion ON reservation.vol.id_vol=vol_avion.id_vol J
OIN avion ON reservation.vol_avion.id_avion=avion.id_avion 
where 1=1 
and reservation.id_vol = ? 
and reservation.id_type_siege = ? 

select COALESCE(SUM(reservation.nb),0) as nb 
from reservation 
JOIN vol ON reservation.id_vol=vol.id_vol 
JOIN vol_avion ON reservation.vol.id_vol=vol_avion.id_vol 
JOIN avion ON reservation.vol_avion.id_avion=avion.id_avion 
where 1=1 
and reservation.id_vol = ? 
and reservation.id_type_siege = ?

select COALESCE(SUM(reservation.nb),0) as nb from reservation JOIN vol ON reservation.id_vol=vol.id_vol JOIN vol_avion ON vol.id_vol=vol_avion.id_vol JOIN avion ON vol_avion.id_avion=avion.id_avion where 1=1 and reservation.id_vol = 'VOL000001' and reservation.id_type_siege = 'TYP000001';


SELECT (EXTRACT(HOUR FROM date_depart - '2025-03-08 18:00:00'::TIMESTAMP) < COALESCE(nb_hrs,9999)) as ecart
FROM vol v
LEFT JOIN limit_annulation_actu la ON 1 = 1
WHERE id_vol = 'VOL000001';

select * from vol_tarif where 1=1 and id_vol = 'VOL000001';

select * from vol JOIN vol_avion ON vol.id_vol=vol_avion.id_vol JOIN avion ON vol_avion.id_avion=avion.id_avion JOIN avion_place ON avion.id_avion=avion_place.id_avion JOIN reservation ON vol.id_vol=reservation.id_vol where 1=1 and vol.id_vol = 'VOL000001' and avion_place.id_type_siege = 'TYP000001'; 

select vol.id_vol,(COALESCE(SUM(avion_place.nb) - COALESCE(SUM(reservation.nb),0))) as nb from vol JOIN vol_avion ON vol.id_vol=vol_avion.id_vol JOIN avion ON vol_avion.id_avion=avion.id_avion JOIN avion_place ON avion.id_avion=avion_place.id_avion LEFT JOIN reservation ON vol.id_vol=reservation.id_vol AND avion_place.id_type_siege=reservation.id_type_siege where 1=1 and avion_place.id_type_siege = 'TYP000001' 
GROUP BY vol.id_vol;

select (COALESCE(avion_place.nb - COALESCE(SUM(reservation.nb),0))) as nb from vol  JOIN vol_avion ON vol.id_vol=vol_avion.id_vol  JOIN avion ON vol_avion.id_avion=avion.id_avion  JOIN avion_place ON avion.id_avion=avion_place.id_avion LEFT JOIN reservation ON vol.id_vol=reservation.id_vol AND avion_place.id_type_siege=reservation.id_type_siege where 1=1 and vol.id_vol = 'VOL000001' and avion_place.id_type_siege = 'TYP000002'

SELECT a.id_avion,ap.id_type_siege,ap.nb,r.id_reservation FROM vol v
JOIN vol_avion va ON v.id_vol = va.id_vol
JOIN avion a ON a.id_avion = va.id_avion
JOIN avion_place ap ON ap.id_avion = a.id_avion 
LEFT JOIN reservation r ON v.id_vol = r.id_vol AND ap.id_type_siege = r.id_type_siege
WHERE ap.id_type_siege = 'TYP000002' AND v.id_vol = 'VOL000001';
select * from limit_reservation where 1=1 and date_application <= '2025-03-10 00:00:00'  ORDER BY date_application DESC LIMIT 1;

select (COALESCE(avion_place.nb - COALESCE(SUM(reservation.nb_enfant + reservation.nb_adulte),0))) as nb from vol  JOIN vol_avion ON vol.id_vol=vol_avion.id_vol  JOIN avion ON vol_avion.id_avion=avion.id_avion  JOIN avion_place ON avion.id_avion=avion_place.id_avion LEFT JOIN reservation ON vol.id_vol=reservation.id_vol AND avion_place.id_type_siege=reservation.id_type_siege where 1=1 and vol.id_vol = ? and avion_place.id_type_siege = ?  GROUP BY avion_place.nb