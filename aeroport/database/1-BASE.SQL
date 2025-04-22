CREATE ROLE aeroport LOGIN PASSWORD 'aeroport';
ALTER ROLE aeroport CREATEDB;
CREATE DATABASE aeroport;
ALTER DATABASE aeroport OWNER TO aeroport;
\c aeroport

--connexion 
--psql -U aeroport -d aeroport -h localhost -W