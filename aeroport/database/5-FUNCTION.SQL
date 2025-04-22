CREATE OR REPLACE FUNCTION get_id_users()
RETURNS TRIGGER AS $$
DECLARE 
    _id_users INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_users := NEXTVAL('seq_users');
    _new_id := 'USE'||LPAD(_id_users ::TEXT,6,'0');
    IF NEW.id_users IS NULL THEN 
        NEW.id_users := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------
CREATE OR REPLACE FUNCTION get_id_type_siege()
RETURNS TRIGGER AS $$
DECLARE 
    _id_type_siege INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_type_siege := NEXTVAL('seq_type_siege');
    _new_id := 'TYP'||LPAD(_id_type_siege ::TEXT,6,'0');
    IF NEW.id_type_siege IS NULL THEN 
        NEW.id_type_siege := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;
-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_avion()
RETURNS TRIGGER AS $$
DECLARE 
    _id_avion INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_avion := NEXTVAL('seq_avion');
    _new_id := 'AVI'||LPAD(_id_avion ::TEXT,6,'0');
    IF NEW.id_avion IS NULL THEN 
        NEW.id_avion := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_ville()
RETURNS TRIGGER AS $$
DECLARE 
    _id_ville INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_ville := NEXTVAL('seq_ville');
    _new_id := 'VIL'||LPAD(_id_ville ::TEXT,6,'0');
    IF NEW.id_ville IS NULL THEN 
        NEW.id_ville := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_vol()
RETURNS TRIGGER AS $$
DECLARE 
    _id_vol INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_vol := NEXTVAL('seq_vol');
    _new_id := 'VOL'||LPAD(_id_vol ::TEXT,6,'0');
    IF NEW.id_vol IS NULL THEN 
        NEW.id_vol := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_client()
RETURNS TRIGGER AS $$
DECLARE 
    _id_client INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_client := NEXTVAL('seq_client');
    _new_id := 'CLI'||LPAD(_id_client ::TEXT,6,'0');
    IF NEW.id_client IS NULL THEN 
        NEW.id_client := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_reservation()
RETURNS TRIGGER AS $$
DECLARE 
    _id_reservation INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_reservation := NEXTVAL('seq_reservation');
    _new_id := 'RES'||LPAD(_id_reservation ::TEXT,6,'0');
    IF NEW.id_reservation IS NULL THEN 
        NEW.id_reservation := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------
CREATE OR REPLACE FUNCTION get_id_promotion()
RETURNS TRIGGER AS $$
DECLARE 
    _id_promotion INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_promotion := NEXTVAL('seq_promotion');
    _new_id := 'PRM'||LPAD(_id_promotion ::TEXT,6,'0');
    IF NEW.id_promotion IS NULL THEN 
        NEW.id_promotion := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

-----------------------------------------------

CREATE OR REPLACE FUNCTION get_id_categorie_passager()
RETURNS TRIGGER AS $$
DECLARE 
    _id_categorie_passager INTEGER;
    _new_id VARCHAR(255);
BEGIN 
    _id_categorie_passager := NEXTVAL('seq_categorie_passager');
    _new_id := 'PRM'||LPAD(_id_categorie_passager ::TEXT,6,'0');
    IF NEW.id_categorie_passager IS NULL THEN 
        NEW.id_categorie_passager := _new_id;
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

