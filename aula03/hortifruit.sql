CREATE DATABASE IF NOT EXISTS hortifruit
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
    
USE hortifruit;

CREATE TABLE IF NOT EXISTS usuarios(
	id_usuario INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    ano_nascimento DATE NOT NULL,
    cpf CHAR (11) UNIQUE
) ENGINE = InnoDB
 DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
	
CREATE TABLE IF NOT EXISTS categorias(
	id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nome VARCHAR(100),
    ativo TINYINT(1) NOT NULL DEFAULT 1,
    
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
    
)ENGINE = InnoDB
 DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS produtos(
	id_produto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    categoria_id INT UNSIGNED NOT NULL,
    nome VARCHAR (255),
    qnt_estoque INT UNSIGNED,
    
    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id)
									REFERENCES categorias (id_categoria)

)ENGINE = InnoDB
 DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vendas(
	id_venda INT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,
    produto_id INT UNSIGNED NOT NULL,
    qnt INT NOT NULL, 
    preco_unit DECIMAL(10,2) NOT NULL, 
    
	CONSTRAINT pk_venda PRIMARY KEY (id_venda),

    CONSTRAINT fk_venda_usuario FOREIGN KEY (usuario_id)
								REFERENCES usuarios(id_usuario)
								ON DELETE RESTRICT
                                ON UPDATE CASCADE,
							
                                
	CONSTRAINT fk_venda_produto FOREIGN KEY (produto_id)
								REFERENCES produtos(id_produto)
                                ON DELETE RESTRICT
                                ON UPDATE CASCADE,
                                
	CONSTRAINT ck_venda_qnt CHECK (qnt >0),
    CONSTRAINT ck_venda_preco_unit CHECK (preco_unit >=0)

)ENGINE = InnoDB
 DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;