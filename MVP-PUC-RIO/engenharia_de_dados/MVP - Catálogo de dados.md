
#### PUC-RIO 
#### MVP -  Sprint: Engenharia de Dados (40530010057_20240_01)

#### Aluno: Andrieles de Souza Rodrigues



# Modelo, catálogo de dados e dicionário de termos
## Modelo do DW (Esquema Estrela)
![Modelo DW](https://github.com/Andrieles/datascience/blob/main/imagens/DW_MVP_Engenharia_de_dados.png?raw=true)

## Catálogo dos dados
---
### Tabela FactNotificacoes
*Descrição: Tabela fato que agrupa as notificações de SG.* 

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| notificacaoID | Intenger | Identificador único das notificações de SG | Gerado de forma incremental |
| climaID | Intenger | Identificador único do registro do clima em um determinado dia do ano | Formado por "dia do ano" & "ano em 4 posições" |
| sintomaID | Intenger | Identificador único dos sintomas | 1 à 10 |
| dataNotificacaoID | Intenger | Identificador único da data de notificação | Formado por “dia do ano” & “ano em 4 posições” |
| dataInicioSintomaID | Intenger | Identificador único da data de inicio dos sintomas | Formado por “dia do ano” & “ano em 4 posições” |
| dataFimSintomaID | Intenger | Identificador único da data de fim dos sintomas | Formado por “dia do ano” & “ano em 4 posições” / Aceita valore nulos|
| estado | String | Estado de domicilio do paciente | Nome do estado ou Distrito Federal |
| municipio | String | Município de domicílio do paciente  | Nome do município |
| sexo | String | Sexo do paciente | Feminino, Masculino
| idade | Intenger | Idade do paciente | Aceita valores nulos|
| classificacaoFinal | String | Classifica o paciente com base nos testes de COVID | Confirmado por Critério Clínico, Confirmado Clínico-Epidemiológico, Confirmado Laboratorial, Síndrome Gripal Não Especificada, Confirmado Clínico-Imagem, Descartado / Aceita valore nulos|
| evolucaoCaso | String | Situação do paciente na data de notificação| Cancelado, Ignorado, Internado, Óbito, Internado em UTI, Em tratamento domiciliar, Cura / Aceita valore nulos |

---
### Tabela DimClima
*Descrição: Tabela dimensão do clima (temperatura e umidade) em uma determinada data.*

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| climaID | Intenger |Identificador único do registro do clima em um determinado dia do ano | Formado por "dia do ano" & "ano em 4 posições" |
| data | DATE | Data do aferimento da temperatura | AAAA-MM-DD |
| medianaTemperaturaArC | Float | Mediana da temperatura obtida da medição de 24 horas | Temperatura em Celcius |
| medianaUmidadeArPerc | Integer | Mediana da umidade relativa do ar obtida da medição de 24 horas  | Umidade em % |

---
### Tabela DimSintomas
*Descrição: Tabela dimensão dos sintomas de uma SG.*

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| sintomaID | Intenger |Identificador único dos sintomas | 1 à 10 |
| sintoma | String | Sintoma relativo ao SG | Outros, Dor de Garganta, Febre, Coriza, Distúrbios Olfativos, Assintomático, Distúrbios Gustativos, Tosse, Dor de Cabeça, Dispneia, Dor de Garganta |

---
### Tabela DimDataNotificacao
*Descrição: Tabela dimensão das datas de notificação das SG.*

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| dataNotificacaoID | Intenger |Identificador único da data de notificação | Formado por “dia do ano” & “ano em 4 posições” |
| data | DATA | Data da notificação| AAAA-MM-DD |
| ano | Integer | Ano da notificação | AAAA |
| mes | Integer | Mês da notificação | MM |
| dia | Integer | Dia da notificação | DD |
| diaSemana | String | Dia da semana da notificação | Notação em inglês |

---
### Tabela DimDataInicioSintoma
*Descrição: Tabela dimensão das datas de inicio dos sintomas da SG.*

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| dataInicioSintomaID | Intenger |Identificador único da data de inicio dos sintomas | Formado por “dia do ano” & “ano em 4 posições” |
| data | DATA | Data de inicio dos sintomas| AAAA-MM-DD |
| ano | Integer | Ano de inicio dos sintomas | AAAA |
| mes | Integer | Mês de inicio dos sintomas | MM |
| dia | Integer | Dia de inicio dos sintomas | DD |
| diaSemana | String | Dia da semana de inicio dos sintomas | Notação em inglês |

---
### Tabela DimDataFimSintoma
*Descrição: Tabela dimensão das datas de fim dos sintomas da SG.*

| Coluna | Tipo | Descrição | Detalhes|
|--|--|--|--|
| dataFimSintomaID | Intenger |Identificador único da data de fim dos sintomas | Formado por “dia do ano” & “ano em 4 posições” |
| data | DATA | Data de fim dos sintomas| AAAA-MM-DD |
| ano | Integer | Ano de fim dos sintomas | AAAA |
| mes | Integer | Mês de fim dos sintomas | MM |
| dia | Integer | Dia de fim dos sintomas | DD |
| diaSemana | String | Dia da semana de fim dos sintomas | Notação em inglês |

## Dicionário de termos

|Termo|Descrição  |
|--|--|
| SG | Síndrome Gripal |
| AAAA | Ano em quatro posições numéricas|
| MM | Mês em duas posições numéricas|
| DD | Dia em duas posições numéricas|

> Written with [StackEdit](https://stackedit.io/).

