CREATE TYPE Strutturato AS enum ('Ricercatore','Professore Associato','Professore Ordinario');
CREATE TYPE LavoroProgetto AS enum ('Ricerca e Sviluppo','Dimostrazione','Managment','Altro');
CREATE TYPE LavoroNonProgettuale AS enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro',
'Accademico', 'Altro');
CREATE TYPE CausaAssenza AS enum ('Chiusura Universitaria','Maternita','Malattia');
CREATE DOMAIN PosInteger AS INTEGER DEFAULT 0 CHECK (VALUE >= 0);
CREATE DOMAIN StringaM AS VARCHAR(100) DEFAULT '';
CREATE DOMAIN NumeroOre AS INTEGER DEFAULT 0 CHECK (VALUE >= 0 AND VALUE <= 8);
CREATE DOMAIN Denaro AS REAL DEFAULT 0 CHECK (VALUE >= 0);

CREATE TABLE Persona (
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    cognome StringaM NOT NULL,
    posizione Strutturato NOT NULL,
    stipendio Denaro NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Progetto (
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    inizio DATE NOT NULL,
    fine DATE NOT NULL,
    budget Denaro NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (nome),
    CHECK (inizio < fine)
);

CREATE TABLE WP (
    progetto PosInteger NOT NULL,
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    inizio DATE NOT NULL,
    fine DATE NOT NULL,
    PRIMARY KEY (progetto,id),
    UNIQUE (progetto,nome),
    CHECK (inizio < fine),
    FOREIGN KEY (progetto) REFERENCES Progetto(id)
);

CREATE TABLE AttivitaProgetto (
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    progetto PosInteger NOT NULL,
    wp PosInteger NOT NULL,
    giorno DATE NOT NULL,
    tipo LavoroProgetto NOT NULL,
    oreDurata NumeroOre NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (persona) REFERENCES Persona(id),
    FOREIGN KEY (progetto,wp) REFERENCES WP(progetto,id)
);

CREATE TABLE AttivitaNonProgettuale (
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    tipo LavoroNonProgettuale NOT NULL,
    giorno DATE NOT NULL,
    oreDurata NumeroOre NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (persona) REFERENCES Persona(id)
);

CREATE TABLE Assenza (
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    tipo CausaAssenza NOT NULL,
    giorno DATE NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (persona,giorno),
    FOREIGN KEY (persona) REFERENCES Persona(id)
)
--Query su tabella singola
--Query 1
SELECT DISTINCT cognome
FROM Persona;

--Query 2
SELECT nome,cognome
FROM Persona
WHERE posizione = 'Ricercatore';

--Query 3
SELECT cognome
FROM Persona
WHERE posizione = 'Professore Associato' AND UPPER(cognome) LIKE 'V%';

--Query 4
SELECT cognome
FROM Persona
WHERE (posizione = 'Professore Associato' OR posizione = 'Professore Ordinario') AND UPPER(cognome) LIKE 'V%';

--Query 5
SELECT *
FROM Progetto
WHERE fine <= NOW();

--Query 6
SELECT nome
FROM Progetto
ORDER BY inizio ASC;

--Query 7
SELECT nome
FROM WP
ORDER BY nome ASC;

--Query 8
SELECT DISTINCT tipo
FROM Assenza;

--Query 9
SELECT DISTINCT tipo
FROM AttivitaProgetto;

--Query 10
SELECT DISTINCT giorno
FROM AttivitaNonProgettuale
WHERE tipo = 'Didattica'
GROUP BY giorno ASC;


--Query su tabelle multiple
--Query 1
SELECT wp.nome, wp.inizio, wp.fine
FROM Progetto as p, WP as wp
WHERE p.nome = 'Pegasus'
    AND wp.progetto = p.id;

--Query 2
SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
FROM Persona, AttivitaProgetto, Progetto
WHERE Persona.id = AttivitaProgetto.persona AND Progetto.id = AttivitaProgetto.progetto AND Progetto.nome = 'Pegasus'
ORDER BY Persona.cognome DESC;

--Query 3
SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
FROM Persona, AttivitaProgetto as a1, AttivitaProgetto as a2, Progetto
WHERE Persona.id = a1.persona 
AND Persona.id = a2.persona 
AND Progetto.id = a1.progetto 
AND Progetto.id = a2.progetto 
AND Progetto.nome = 'Pegasus'
AND a1.id <> a2.id;









