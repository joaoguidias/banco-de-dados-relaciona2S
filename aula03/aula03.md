Aqui está o conteúdo da sua aula formatado em **Markdown (.md)**, seguindo uma estrutura hierárquica clara, com blocos de código destacados e tabelas organizadas para facilitar a leitura.

---

# Aula 03 — SQL e DDL: Definição de Estruturas

Os três comandos centrais da **DDL** (Data Definition Language) são `CREATE` (criar), `ALTER` (modificar) e `DROP` (remover). Eles operam sobre objetos de banco de dados como schemas, tabelas, índices, views e procedures. Nesta aula, o foco é na criação e manipulação de **schemas** e **tabelas**.

---

## 1. Convenções de Nomenclatura desta Disciplina

Convenções tornam o código legível, previsível e manutenível. As regras a seguir estão alinhadas com as boas práticas da indústria e serão cobradas nas avaliações.

* **Regra 1 — `snake_case` em tudo:** Todas as palavras são separadas por underline.
* *Exemplo:* `data_nascimento` (Correto) | `DataNascimento` (Errado).


* **Regra 2 — Minúsculas para nomes do usuário:** Tabelas, colunas e schemas devem ser sempre em letras minúsculas.
* **Regra 3 — Palavras reservadas em MAIÚSCULAS:** `SELECT`, `CREATE`, `TABLE`, etc. Isso cria contraste visual entre a linguagem e os dados.
* **Regra 4 — Nomes de tabelas no plural:** A tabela é uma coleção de registros.
* *Exemplo:* `clientes`, `pedidos`, `produtos`.


* **Regra 5 — Chave Primária (PK) como `id_nome_tabela_singular`:**
* *Exemplo:* Tabela `clientes` → PK `id_cliente`.


* **Regra 6 — Chave Estrangeira (FK) como `tabela_referencia_id`:**
* *Exemplo:* Na tabela `itens_pedidos`, a FK para produtos deve ser `produto_id`.


* **Regra 7 — FK pelo papel semântico:** Quando uma entidade exerce papéis diferentes, use o nome do papel.

#### Exemplo de aplicação das regras:

```sql
CREATE TABLE vendas (
    id_venda        INT          NOT NULL,
    cliente_id      INT          NOT NULL,  -- referencia pessoas (papel: cliente)
    funcionario_id  INT          NOT NULL,  -- referencia pessoas (papel: vendedor)
    data_venda      DATE         NOT NULL,
    PRIMARY KEY (id_venda),
    FOREIGN KEY (cliente_id)     REFERENCES pessoas (id_pessoa),
    FOREIGN KEY (funcionario_id) REFERENCES pessoas (id_pessoa)
);

```

---

## 2. Acessando o MariaDB via Terminal (XAMPP)

O XAMPP instala o MariaDB com configurações padrão que você deve conhecer:

| Parâmetro | Valor Padrão |
| --- | --- |
| **Host** | `127.0.0.1` ou `localhost` |
| **Porta** | `3306` |
| **Usuário root** | `root` |
| **Senha root** | (vazia — sem senha) |

### Comandos de Conexão

**Conexão padrão (Porta 3306 assumida):**

```bash
mysql -u root -p

```

*No Windows/XAMPP, navegue até `C:\xampp\mysql\bin\` antes de executar.*

**Conexão especificando porta e host:**

```bash
mysql -u root -p -P 3306 -h 127.0.0.1

```

> ⚠️ **Atenção:** No XAMPP padrão, a senha do root é vazia. Pressione **Enter** sem digitar nada quando solicitado. Em produção, sempre defina uma senha forte.

**Verificando a versão:**

```sql
SELECT VERSION(); -- Ex: 10.4.32-MariaDB

```

---

## 3. Criando um Database — Construção Gradual

### 3.1 Forma mínima (Não recomendada)

```sql
CREATE DATABASE loja_virtual;

```

*Problema: Delega o charset ao padrão do servidor.*

### 3.2 Proteção contra erros (Idempotência)

```sql
CREATE DATABASE IF NOT EXISTS loja_virtual;

```

### 3.3 Especificando o CHARACTER SET

O **Charset** define como os caracteres são armazenados.

```sql
CREATE DATABASE IF NOT EXISTS loja_virtual
    CHARACTER SET utf8mb4;

```

| Charset | Bytes | Suporte | Quando usar |
| --- | --- | --- | --- |
| **latin1** | 1 | Apenas ocidentais | Legados |
| **utf8 (MySQL)** | 1–3 | Sem emojis | **Nunca** |
| **utf8mb4** | 1–4 | Unicode completo | **Sempre** |

### 3.4 Especificando o COLLATION

O **Collate** define como os caracteres são comparados e ordenados (Ex: `_ci` para Case Insensitive).

| Collation | Maiúsc./Minúsc. | Acentos | Uso |
| --- | --- | --- | --- |
| **utf8mb4_unicode_ci** | Não | Não | **Recomendado** |
| **utf8mb4_bin** | Sim | Sim | Campos técnicos |

---

## 4. Comando Final Completo e Comentado

Este é o padrão idiomático para projetos reais com suporte a caracteres da língua portuguesa e emojis:

```sql
-- Criação completa do banco de dados
CREATE DATABASE IF NOT EXISTS loja_virtual
    CHARACTER SET utf8mb4           -- UTF-8 completo
    COLLATE utf8mb4_unicode_ci;     -- Comparação case-insensitive (Padrão Unicode)

-- Selecionar o banco para uso
USE loja_virtual;

-- Confirmar configurações
SHOW CREATE DATABASE loja_virtual;

```

### Comparativo: PostgreSQL

Apenas para referência, no PostgreSQL a sintaxe difere:

```sql
CREATE DATABASE loja_virtual
    ENCODING    'UTF8'
    LC_COLLATE  'pt_BR.UTF-8'
    LC_CTYPE    'pt_BR.UTF-8';

```

---

**Gostaria que eu gerasse um script de exemplo criando algumas tabelas (como `clientes` e `pedidos`) seguindo todas essas regras de nomenclatura?**

Aqui está o conteúdo organizado e formatado em **Markdown (.md)**, ideal para seus estudos ou para o seu repositório no GitHub:

---

# SQL: Tipos de Dados Inteiros (MariaDB/MySQL)

Entender os tipos inteiros é, basicamente, entender quanto **espaço em disco** você quer reservar e qual o **tamanho máximo do número** que pretende guardar. Pense neles como "caixas" de tamanhos diferentes: usar uma caixa gigante para um dado pequeno desperdiça memória e performance.

## 1. Escala de Tipos Inteiros

| Tipo | Bytes | Valor Mínimo (Signed) | Valor Máximo (Signed) | Exemplo de Uso |
| --- | --- | --- | --- | --- |
| **TINYINT** | 1 | -128 | 127 | Idade, status (0 ou 1) |
| **SMALLINT** | 2 | -32.768 | 32.767 | Estoque pequeno |
| **MEDIUMINT** | 3 | -8.388.608 | 8.388.607 | População de cidades |
| **INT** | 4 | -2.147.483.648 | 2.147.483.647 | IDs de tabelas comuns |
| **BIGINT** | 8 | -9 trilhões... | +9 trilhões... | IDs globais (Twitter, YT) |

---

## 2. Conceitos Fundamentais

### Signed vs. Unsigned

Por padrão, os números são **Signed** (com sinal), aceitando valores negativos. Como raramente usamos "ID negativo" ou "idade negativa", aplicamos o modificador `UNSIGNED`.

* Isso elimina os negativos e **dobra** a capacidade positiva.
* **Exemplo:** `TINYINT UNSIGNED` vai de **0 a 255** (em vez de -128 a 127).

### O Mito do `INT(11)`

O número entre parênteses **não limita o valor armazenado**.

* Um `INT` sempre ocupará 4 bytes e sempre irá até 2 bilhões.
* O `(11)` é apenas uma instrução de **exibição** (espaçamento visual ou preenchimento de zeros), ignorada pela maioria das aplicações modernas.

---

## 3. Guia de Escolha (Boas Práticas)

* **Para IDs (Chaves Primárias):** Use `INT UNSIGNED` ou `BIGINT UNSIGNED`.
* **Para Booleanos (Verdadeiro/Falso):** O MariaDB usa `TINYINT(1)`, onde `0` é falso e `1` é verdadeiro.
* **Na dúvida?** Use `INT`. É o padrão da indústria para a maioria dos casos generalistas.

---

## 4. Exemplo Prático de DDL

Abaixo, um exemplo aplicando as convenções de nomenclatura e a escolha correta dos tipos:

```sql
CREATE TABLE produtos (
    id_produto      INT UNSIGNED AUTO_INCREMENT, -- Suporta até ~4 bilhões de itens
    estoque         SMALLINT UNSIGNED,           -- Suporta até 65.535 unidades
    status_ativo    TINYINT(1),                  -- Booleano (0 ou 1)
    PRIMARY KEY (id_produto)
);

```

---

**Agora que terminamos os inteiros, gostaria de converter também aquela explicação sobre o cálculo binário (bits e bytes) para .md ou prefere seguir para tipos de texto?**