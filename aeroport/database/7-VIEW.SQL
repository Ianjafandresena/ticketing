CREATE OR REPLACE VIEW limit_annulation_actu AS 
SELECT * FROM limit_annulation 
ORDER BY date_application DESC 
LIMIT 1;

CREATE OR REPLACE VIEW limit_reservation_actu AS 
SELECT * FROM limit_reservation 
ORDER BY date_application DESC 
LIMIT 1;