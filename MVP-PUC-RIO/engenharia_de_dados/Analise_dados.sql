-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Título: Relação entre Condições Climáticas e Notificações de Síndrome Gripal em Brasília no ano de 2023
-- MAGIC
-- MAGIC **Introdução:**  Brasília, conhecida por seus longos períodos de estiagem no inverno, enfrenta desafios relacionados à saúde pública. Neste contexto, surge a pergunta: há uma correlação entre temperaturas e umidades baixas e a quantidade de notificações de síndrome gripal (SG) no Distrito Federal?
-- MAGIC
-- MAGIC **Definição da Síndrome Gripal:**  A síndrome gripal é caracterizada por sintomas como dor de cabeça, febre, dor de garganta, calafrios, tosse e coriza. A transmissão ocorre por meio do contato direto com secreções de pessoas infectadas ou indiretamente ao falar, espirrar ou tossir. Além disso, o contato com superfícies contaminadas pode levar à infecção quando tocamos boca, nariz ou olhos.
-- MAGIC
-- MAGIC **Critérios Climáticos:**  Consideraremos o clima como “frio” em Brasília quando a temperatura for igual ou inferior a 20°C. Quanto à umidade relativa do ar, consideraremos valores abaixo de 40% como baixos.
-- MAGIC
-- MAGIC ## Perguntas:
-- MAGIC
-- MAGIC Baixas temperaturas (abaixo de 20ºC) aumentam as notificações de síndrome gripal?  
-- MAGIC   
-- MAGIC A umidade relativa do ar baixa (abaixo de 40%) aumenta as notificações de síndrome gripal?
-- MAGIC
-- MAGIC Quais sintomas são mais comuns quando a temperatura está baixa?  
-- MAGIC   
-- MAGIC Quais sintomas são mais comuns quando a umidade está baixa?

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Total de notificações únicas

-- COMMAND ----------

SELECT count( DISTINCT f.notificacaoID) as Notificacoes FROM dw.factnotificacao f;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Mediana da temperatura e umidade 

-- COMMAND ----------

SELECT * FROM dw.dimclima;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Mediana da temparatura e umidade x quantidade de notificações por sintomas:

-- COMMAND ----------

SELECT 
    f.notificacaoID,
    c.Data,
    c.medianaTemperaturaArC,
    c.medianaUmidadeArPerc,
    s.Sintoma
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimsintomas s ON f.sintomaID = s.SintomaID
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Apuração da quantidade de notificações

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Notificações com temperatura igual ou menor que 20ºC

-- COMMAND ----------

SELECT 
    count(DISTINCT f.notificacaoID) as Notificacoes_frio
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
WHERE c.MedianaTemperaturaArC <= 20
GROUP BY ALL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Notificações com umidade do ar igual ou menor que 40%

-- COMMAND ----------

SELECT 
    count(DISTINCT f.notificacaoID) as Notificacoes_frio
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
WHERE c.medianaUmidadeArPerc <= 40
GROUP BY ALL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Notificações com temperatura superior à 20ºC

-- COMMAND ----------

SELECT 
    count(DISTINCT f.notificacaoID) as Notificacoes_calor
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
WHERE c.MedianaTemperaturaArC > 20
GROUP BY ALL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Notificações com umidade do ar superior à 40%

-- COMMAND ----------

SELECT 
    count(DISTINCT f.notificacaoID) as Notificacoes_calor
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
WHERE c.medianaUmidadeArPerc > 40
GROUP BY ALL;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Quantidade de sintomas por temperatura igual ou abaixo de 20ºC

-- COMMAND ----------

SELECT 
    s.sintoma,
    count(f.sintomaID)
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimsintomas s ON f.sintomaID = s.SintomaID
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
JOIN 
    dw.dimdatainiciosintoma dis ON dis.dataInicioSintomaID = f.dataInicioSintomasID
JOIN 
    dw.dimdatafimsintoma dfs ON dfs.dataFimSintomaID = f.dataFimSintomasID
JOIN 
    dw.dimdatanotificacao dn ON dn.datanotificacaoID = f.dataNotificacaoID
WHERE c.medianaTemperaturaArC <= 20
GROUP BY f.sintomaID, s.sintoma;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Quantidade de sintomas por temperatura superior à 20ºC

-- COMMAND ----------

SELECT 
    s.sintoma,
    count(f.sintomaID)
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimsintomas s ON f.sintomaID = s.SintomaID
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
JOIN 
    dw.dimdatainiciosintoma dis ON dis.dataInicioSintomaID = f.dataInicioSintomasID
JOIN 
    dw.dimdatafimsintoma dfs ON dfs.dataFimSintomaID = f.dataFimSintomasID
JOIN 
    dw.dimdatanotificacao dn ON dn.datanotificacaoID = f.dataNotificacaoID
WHERE c.medianaTemperaturaArC > 20
GROUP BY f.sintomaID, s.sintoma;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Quantidade de sintomas por umidade do ar igual ou abaixo de 40%

-- COMMAND ----------

SELECT 
    s.sintoma,
    count(f.sintomaID)
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimsintomas s ON f.sintomaID = s.SintomaID
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
JOIN 
    dw.dimdatainiciosintoma dis ON dis.dataInicioSintomaID = f.dataInicioSintomasID
JOIN 
    dw.dimdatafimsintoma dfs ON dfs.dataFimSintomaID = f.dataFimSintomasID
JOIN 
    dw.dimdatanotificacao dn ON dn.datanotificacaoID = f.dataNotificacaoID
WHERE c.medianaUmidadeArPerc <= 40
GROUP BY f.sintomaID, s.sintoma;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Quantidade de sintomas por umidade do ar superior a 40%

-- COMMAND ----------

SELECT 
    s.sintoma,
    count(f.sintomaID)
FROM 
    dw.factnotificacao f
JOIN 
    dw.dimsintomas s ON f.sintomaID = s.SintomaID
JOIN 
    dw.dimclima c ON c.ClimaID = f.climaID
JOIN 
    dw.dimdatainiciosintoma dis ON dis.dataInicioSintomaID = f.dataInicioSintomasID
JOIN 
    dw.dimdatafimsintoma dfs ON dfs.dataFimSintomaID = f.dataFimSintomasID
JOIN 
    dw.dimdatanotificacao dn ON dn.datanotificacaoID = f.dataNotificacaoID
WHERE c.medianaUmidadeArPerc > 40
GROUP BY f.sintomaID, s.sintoma;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # Resultado:
-- MAGIC
-- MAGIC Baixas temperaturas (abaixo de 20ºC) aumentam as notificações de síndrome gripal?
-- MAGIC
-- MAGIC Se fizermos um paralelo entre as temperaturas mais comuns durante o ano em Brasília e a temperatura nas datas de início de sintomas de SG das notificações, notaremos que existem mais notificações nos dias com temperaturas mais comuns e menos notificações em dias de temperaturas mais extremas. Isso pode ser facilmente observável ao compararmos o histograma C001 com o C003. Ambos possuem a mesma curva. Logo, chego à conclusão de que não há relação direta entre a temperatura e a quantidade de notificações.
-- MAGIC
-- MAGIC A umidade relativa do ar baixa (abaixo de 40%) aumenta as notificações de síndrome gripal?
-- MAGIC
-- MAGIC O mesmo fenômeno da temperatura pode ser observado na umidade do ar. Se compararmos o histograma C002 com o C004, veremos que os gráficos são proporcionalmente semelhantes. Logo, não parece haver ligação direta entre a umidade relativa do ar e qualquer aumento nos casos de SG em Brasília.
-- MAGIC
-- MAGIC Quais sintomas são mais comuns quando a temperatura está baixa?
-- MAGIC
-- MAGIC Os sintomas mais comuns são tosse e febre. Além disso, a incidência de qualquer sintoma se mantém proporcionalmente semelhante acima e abaixo de 20ºC. Vide gráficos em barras S001 e S002.
-- MAGIC
-- MAGIC Quais sintomas são mais comuns quando a umidade está baixa?
-- MAGIC
-- MAGIC Mais uma vez, o mesmo fenômeno pode ser observado com relação à umidade do ar. Tosse e febre são os sintomas mais comuns, e não há relação aparente entre a umidade alta ou baixa e a incidência maior ou menor dos sintomas. Vide gráficos de barras S003 e S004.
-- MAGIC  
