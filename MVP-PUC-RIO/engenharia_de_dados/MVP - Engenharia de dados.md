
#### PUC-RIO 
#### MVP -  Sprint: Engenharia de Dados (40530010057_20240_01)

#### Aluno: Andrieles de Souza Rodrigues

# Objetivo:

**Título: Relação entre Condições Climáticas e Notificações de Síndrome Gripal em Brasília**

**Introdução:**  Brasília, conhecida por seus longos períodos de estiagem no inverno, enfrenta desafios relacionados à saúde pública. Neste contexto, surge a pergunta: há uma correlação entre temperaturas e umidades baixas e a quantidade de notificações de síndrome gripal (SG) no Distrito Federal?

**Definição da Síndrome Gripal:**  A síndrome gripal é caracterizada por sintomas como dor de cabeça, febre, dor de garganta, calafrios, tosse e coriza. A transmissão ocorre por meio do contato direto com secreções de pessoas infectadas ou indiretamente ao falar, espirrar ou tossir. Além disso, o contato com superfícies contaminadas pode levar à infecção quando tocamos boca, nariz ou olhos.

**Critérios Climáticos:**  Consideraremos o clima como “frio” em Brasília quando a temperatura for igual ou inferior a 20°C. Quanto à umidade relativa do ar, consideraremos valores abaixo de 40% como baixos.

## Perguntas:

Baixas temperaturas (abaixo de 20ºC) aumentam as notificações de síndrome gripal?  
  
A umidade relativa do ar baixa (abaixo de 40%) aumenta as notificações de síndrome gripal?

Quais sintomas são mais comuns quando a temperatura está baixa?  
  
Quais sintomas são mais comuns quando a umidade está baixa?

# Plataforma:
1.  **Databricks Community Edition:**
    
    -   A escolha da plataforma Databricks foi baseada em sua robustez e facilidade de uso. A versão Community Edition oferece recursos essenciais para nosso projeto.
    -   A interface simples e a integração com o ecossistema Spark tornam o Databricks uma opção ideal para ETL.
    - 
2.  **Processo de ETL:**
    
    -   **Extração:**  Coletei dados brutos de duas fontes: o INMET e o openDataSUS.
    -   **Transformação:**  Utilizei o Spark para processar e limpar os dados extraídos. Realizamos operações como filtragem, agregação, junção e criação de novas colunas.
    -   **Carga:**  Os dados transformados são carregados no DBFS no formato parquet, onde estarão disponíveis para análises futuras.
    - 
3.  **Data Warehouse:**
    
    -   Utilizei SQL para consultas e manipulação dos dados. A linguagem SQL é amplamente adotada e permite expressar transformações de forma concisa.

**Conclusão:**  A combinação do Databricks Community Edition com Spark e SQL nos permite criar um DW eficiente, pronto para suportar análises necessárias. 


# Detalhamento:

## 1 - Busca pelo dados:

Para alcançar o objetivo desse exercício precisei buscar uma fonte com informações relativas a síndromes gripais e uma fonte com informações meteorológicas. Para manter o foco no processo em si, irei analisar dados relativo somente ao ano de 2023.

O Ministério da Saúde, por meio da Secretaria de Vigilância em Saúde e Ambiente (SVSA), implementou, devido à pandemia, a vigilância da Síndrome Gripal (SG) devido a pandemia de COVID. No endereço https://opendatasus.saude.gov.br/dataset/ é possível encontrar dezenas de datasets com infomações relativos a essa vigilância. No caso o dataset que nos interessa é o ## [Notificações de Síndrome Gripal - 2023](https://opendatasus.saude.gov.br/dataset/notificacoes-de-sindrome-gripal-leve-2023 "Notificações de Síndrome Gripal - 2023").

Já para os dados meteorológicos usarei medições realizadas pelo instituto Nacional de Meteorologia (INMET). A instituição mantem uma base histórica com medições de várias estações de agrupados por ano em https://portal.inmet.gov.br/dadoshistoricos.

## 2 - Coleta

No site do openDataSUS os dados escolhidos estão disponíveis no formato CSV e possui um "Dicionário de dados". Mas, tive de efetuar um web scraping básico porque os links para o arquivo mudam com frequência. 
  
Já os dados do INMET possuem um link fixo para baixar os arquivos em CSV. Mas, o arquivo de interesse (medição meteorológica de Brasília) está compactado junto com arquivos com medições de dezenas de outras localidades, sendo então necessário etapas de descompactação e localização e cópia do arquivo de interesse. 

## 3 - Modelagem

Para a construção do meu Data Warehouse no exercício, optei pelo **Esquema em Estrela**. Inicialmente, a abordagem dimensional pareceu-me vantajosa para o controle dos dados. No entanto, posteriormente, percebi que um esquema baseado em um **Data Lake** também seria uma escolha adequada.

## 4 - Carga

Para contornar a ausência de um pipeline ativo na plataforma Databricks Community Edition, desenvolvi um pipeline improvisado utilizando um notebook que invoca outros notebooks de ETL. Ao final da execução desses processos, persisto três arquivos no DBFS no formato Parquet. Esses arquivos correspondem a uma tabela de fatos para as notificações, uma tabela de dimensão para os sintomas e outra tabela de dimensão para os dados meteorológicos.

Além disso, criei três tabelas adicionais para representar a dimensão temporal. Embora pudesse ter sido consolidada em uma única tabela, optei por manter três tabelas separadas para proporcionar maior clareza ao modelo.

## 5 - Análise dos dados

### A - Qualidade dos dados:

Não enfrentei problemas com a qualidade dos dados. Nos dois arquivos de origem, os atributos com formato de data estavam corretamente formatados. No arquivo do openDataSUS, existem vários atributos descritivos no formato de string, mas todos estavam consistentes. Quanto ao arquivo do INMET, notei uma estrutura incomum: duas colunas com oito linhas no início do arquivo contendo dados da estação meteorológica. No entanto, bastou excluir essas linhas para que o arquivo ficasse limpo o suficiente.

### B - Solução dos problemas:

Finalmente, vamos às respostas as perguntas colocadas no *objetivo*. Para tanto, vou separar a analise final por pergunta:

_Baixas temperaturas (abaixo de 20ºC) aumentam as notificações de síndrome gripal?_

Se fizermos um paralelo entre as temperaturas mais comuns durante o ano em Brasília e a temperatura nas datas de início de sintomas de SG das notificações, notaremos que existem mais notificações nos dias com temperaturas mais comuns e menos notificações em dias de temperaturas mais extremas. Isso pode ser facilmente observável ao compararmos o histograma C001 com o C003. Ambos possuem a mesma curva. Logo, chego à conclusão de que não há relação direta entre a temperatura e a quantidade de notificações.

##### Gráfico C001 - Histograma - Temperatura x dias:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/C001.png?raw=true)

##### Gráfico C003 - Histograma - Temperatura x quantidade de notificações:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/C003.png?raw=true)

_A umidade relativa do ar baixa (abaixo de 40%) aumenta as notificações de síndrome gripal?_

O mesmo fenômeno da temperatura pode ser observado na umidade do ar. Se compararmos o histograma C002 com o C004, veremos que os gráficos são proporcionalmente semelhantes. Logo, não parece haver ligação direta entre a umidade relativa do ar e qualquer aumento nos casos de SG em Brasília.

##### Gráfico C002 - Histograma - Umidade x dias:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/C002.png?raw=true)

##### Gráfico C004 - Histograma - Umidade x Quantidade de notificações:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/C004.png?raw=true)

_Quais sintomas são mais comuns quando a temperatura está baixa?_

Os sintomas mais comuns são tosse e febre. Além disso, a incidência de qualquer sintoma se mantém proporcionalmente semelhante acima e abaixo de 20ºC. Vide gráficos em barras S001 e S002.

##### Gráfico S001 - Gráfico de barras - Quantidade de sintomas abaixo ou igual a 20ºC:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/S001.png?raw=true)

##### Gráfico S002 - Gráfico de barras - Quantidade de sintomas superior a 20ºC::
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/S002.png?raw=true)

_Quais sintomas são mais comuns quando a umidade está baixa?_

Mais uma vez, o mesmo fenômeno pode ser observado com relação à umidade do ar. Tosse e febre são os sintomas mais comuns, e não há relação aparente entre a umidade alta ou baixa e a incidência maior ou menor dos sintomas. Vide gráficos de barras S003 e S004.

##### Gráfico S003 - Gráfico de barras - Quantidade de sintomas abaixo ou igual 40% de umidade do ar:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/S003.png?raw=true)

##### Gráfico S004 - Gráfico de barras - Quantidade de sintomas superior a 40% de umidade do ar:
![enter image description here](https://github.com/Andrieles/datascience/blob/main/imagens/S004.png?raw=true)

# Autoavaliação


**Resumo:**
Neste estudo, investiguei a relação entre notificações de síndromes gripais e características climáticas em Brasília. Utilizamos dados disponíveis no openDataSUS e informações climáticas do INMET para realizar uma análise exploratória. Embora minhas expectativas iniciais sugerissem uma possível associação entre o clima e o aumento de casos de síndromes gripais, não encontrrei evidências significativas para corroborar essa hipótese.

1. **Coleta de Dados:**
   - Coletei dados de notificações de síndromes gripais do openDataSUS. Implentando um pequeno web scraping para obter os links que diarimante atualizados.
   - Trabalhei com arquivos compactados do INMET para obter dados climáticos relevantes. Um pequeno desafio, superado pelo uso comandos básicos de shell do Linux. 

2. **Processo de ETL (Extração, Transformação e Carga):**
   - Utilizamos o Spark para processar os dados, mesmo sendo usuário frequente do Pandas.
   - Criei um Data Warehouse (DW) utilizando tabelas DELTA para armazenar os dados processados.

3. **Análise dos Dados:**
   - Realizei consultas SQL para explorar as relações entre notificações de síndromes gripais e variáveis climáticas.
   - Utilizei recursos de plotagem do Databricks para visualizar os resultados.

4. **Considerações Finais:**
   - O uso do Databricks foi uma experiência positiva, apesar da limitação da versão community em relação ao Workflow.
   -  Em vista do item acima, criei meu próprio flow improvisado com um notebook e comandos mágicos "%run".
   - Agora, planejo expandir nosso escopo temporal, buscando dados de anos anteriores a fim de enriquecer os resultados.
   - Futuramente, pretendemos criar um Data Lake, explorar os dados com o PowerBI e aplicar técnicas de machine learning.

Em suma, embora não tenha encontrado uma correlação direta entre o clima e as notificações de síndromes gripais em Brasília, a jornada de aprendizado e as habilidades adquiridas durante o processo foram inestimáveis.

Observação.: Evidências de uso do Databricks podem ser encontradas na pasta "/evidencias". 



> Written with [StackEdit](https://stackedit.io/).
