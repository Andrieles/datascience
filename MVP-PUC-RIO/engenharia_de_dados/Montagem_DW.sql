-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Cria Data Warehouse

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Cria database

-- COMMAND ----------

CREATE DATABASE IF NOT EXISTS DW

-- COMMAND ----------

USE DW

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Cria tabelas geradas por ETL

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS FactNotificacao
USING parquet
OPTIONS (
  'path' 'dbfs:/FileStore/tables/DW/FactNotificacao.parquet',
  'header' 'true',
  'inferSchema' 'true'
);


-- COMMAND ----------

convert to delta FactNotificacao;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DimClima
USING parquet
OPTIONS (
  path "dbfs:/FileStore/tables/DW/DimClima.parquet",
  header "true",
  inferSchema "true"
);

-- COMMAND ----------

convert to delta DimClima;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DimSintomas
USING parquet
OPTIONS (
  path "dbfs:/FileStore/tables/DW/DimSintomas.parquet",
  header "true",
  inferSchema "true"
);

-- COMMAND ----------

convert to delta DimSintomas

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Cria tabelas de data

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm("dbfs:/user/hive/warehouse/dw.db/dimdatainiciosintoma", recurse=True)
-- MAGIC dbutils.fs.rm("dbfs:/user/hive/warehouse/dw.db/dimdatafimsintoma", recurse=True)
-- MAGIC dbutils.fs.rm("dbfs:/user/hive/warehouse/dw.db/dimdatanotificacao", recurse=True)

-- COMMAND ----------

DROP TABLE IF EXISTS DimDataInicioSintoma;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DimDataInicioSintoma (
    dataInicioSintomaID INT,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    diaSemana STRING
);

-- COMMAND ----------

WITH datas AS (
    SELECT explode(sequence(to_date('2023-01-01'), to_date('2023-12-31'), interval 1 day)) AS data
)

-- Inserir dados na tabela DimData
INSERT INTO DimDataInicioSintoma
SELECT
    CONCAT(dayofyear(data), year(data)) AS DataInicioSintomaID,
    data,
    year(data) AS Ano,
    month(data) AS Mes,
    day(data) AS Dia,
    date_format(data, 'EEEE') AS DiaSemana
FROM datas;

-- COMMAND ----------

DROP TABLE IF EXISTS DimDataFimSintoma;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DimDataFimSintoma (
    dataFimSintomaID INT,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    diaSemana STRING
);

-- COMMAND ----------

WITH datas AS (
    SELECT explode(sequence(to_date('2023-01-01'), to_date('2023-12-31'), interval 1 day)) AS data
)

-- Inserir dados na tabela DimData
INSERT INTO DimDataFimSintoma
SELECT
    CONCAT(dayofyear(data), year(data)) AS DataFimSintomaID,
    data,
    year(data) AS Ano,
    month(data) AS Mes,
    day(data) AS Dia,
    date_format(data, 'EEEE') AS DiaSemana
FROM datas;

-- COMMAND ----------

DROP TABLE IF EXISTS DimDataNotificacao;

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS DimDataNotificacao (
    dataNotificacaoID INT,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    diaSemana STRING
);

-- COMMAND ----------

WITH datas AS (
    SELECT explode(sequence(to_date('2023-01-01'), to_date('2023-12-31'), interval 1 day)) AS data
)

-- Inserir dados na tabela DimData
INSERT INTO DimDataNotificacao
SELECT
    CONCAT(dayofyear(Data), year(Data)) AS DataNotificacaoID,
    data,
    year(data) AS Ano,
    month(data) AS Mes,
    day(data) AS Dia,
    date_format(data, 'EEEE') AS DiaSemana
FROM datas;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC

-- COMMAND ----------

CONVERT TO DELTA DimDataInicioSintoma;
CONVERT TO DELTA DimDataFimSintoma;
CONVERT TO DELTA DimDataNotificacao;

