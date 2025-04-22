CREATE TRIGGER trg_insert_users
BEFORE INSERT ON users 
FOR EACH ROW 
EXECUTE FUNCTION get_id_users();

------------------------------------------

CREATE TRIGGER trg_insert_type_siege
BEFORE INSERT ON type_siege 
FOR EACH ROW 
EXECUTE FUNCTION get_id_type_siege();

------------------------------------------

CREATE TRIGGER trg_insert_avion
BEFORE INSERT ON avion 
FOR EACH ROW 
EXECUTE FUNCTION get_id_avion();

------------------------------------------

CREATE TRIGGER trg_insert_ville
BEFORE INSERT ON ville 
FOR EACH ROW 
EXECUTE FUNCTION get_id_ville();

------------------------------------------

CREATE TRIGGER trg_insert_vol
BEFORE INSERT ON vol 
FOR EACH ROW 
EXECUTE FUNCTION get_id_vol();

------------------------------------------
CREATE TRIGGER trg_insert_client
BEFORE INSERT ON client 
FOR EACH ROW 
EXECUTE FUNCTION get_id_client();

------------------------------------------

CREATE TRIGGER trg_insert_reservation
BEFORE INSERT ON reservation 
FOR EACH ROW 
EXECUTE FUNCTION get_id_reservation();

------------------------------------------

CREATE TRIGGER trg_insert_promotion
BEFORE INSERT ON promotion 
FOR EACH ROW 
EXECUTE FUNCTION get_id_promotion();

------------------------------------------
CREATE TRIGGER trg_insert_categorie_passager
BEFORE INSERT ON categorie_passager 
FOR EACH ROW 
EXECUTE FUNCTION get_id_categorie_passager();