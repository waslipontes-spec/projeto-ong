-- Projeto ONG - Banco de dados para assistência social
-- Atividade 2 - Projeto Integrador Extensionista II
-- Banco: MySQL 8.0.16+ ou MariaDB com suporte a CHECK

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS ong_assistencia;
CREATE DATABASE ong_assistencia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ong_assistencia;

CREATE TABLE doador (
    id_doador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE beneficiario (
    id_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ativo',
    CONSTRAINT chk_beneficiario_status
        CHECK (status IN ('ativo', 'inativo'))
);

CREATE TABLE voluntario (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ativo',
    CONSTRAINT chk_voluntario_status
        CHECK (status IN ('ativo', 'inativo'))
);

CREATE TABLE campanha (
    id_campanha INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'planejada',
    CONSTRAINT chk_campanha_datas
        CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_campanha_status
        CHECK (status IN ('planejada', 'ativa', 'encerrada', 'cancelada'))
);

CREATE TABLE doacao (
    id_doacao INT AUTO_INCREMENT PRIMARY KEY,
    id_doador INT NOT NULL,
    id_campanha INT NULL,
    data_doacao DATE NOT NULL,
    observacao VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'recebida',
    CONSTRAINT chk_doacao_status
        CHECK (status IN ('recebida', 'em_separacao', 'distribuida', 'cancelada')),
    CONSTRAINT fk_doacao_doador
        FOREIGN KEY (id_doador) REFERENCES doador (id_doador)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_doacao_campanha
        FOREIGN KEY (id_campanha) REFERENCES campanha (id_campanha)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE item (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    categoria VARCHAR(80) NOT NULL,
    descricao VARCHAR(255),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE doacao_item (
    id_doacao INT NOT NULL,
    id_item INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_doacao, id_item),
    CONSTRAINT chk_doacao_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_doacao_item_doacao
        FOREIGN KEY (id_doacao) REFERENCES doacao (id_doacao)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_doacao_item_item
        FOREIGN KEY (id_item) REFERENCES item (id_item)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE campanha_voluntario (
    id_campanha INT NOT NULL,
    id_voluntario INT NOT NULL,
    data_vinculo DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_campanha, id_voluntario),
    CONSTRAINT fk_campanha_voluntario_campanha
        FOREIGN KEY (id_campanha) REFERENCES campanha (id_campanha)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_campanha_voluntario_voluntario
        FOREIGN KEY (id_voluntario) REFERENCES voluntario (id_voluntario)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE campanha_beneficiario (
    id_campanha INT NOT NULL,
    id_beneficiario INT NOT NULL,
    data_atendimento DATE NOT NULL DEFAULT (CURRENT_DATE),
    observacao VARCHAR(255),
    PRIMARY KEY (id_campanha, id_beneficiario),
    CONSTRAINT fk_campanha_beneficiario_campanha
        FOREIGN KEY (id_campanha) REFERENCES campanha (id_campanha)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_campanha_beneficiario_beneficiario
        FOREIGN KEY (id_beneficiario) REFERENCES beneficiario (id_beneficiario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
