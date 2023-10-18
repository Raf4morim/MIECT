--------------------------------IDX------------------------------------
go

CREATE INDEX index_preco_designacao ON material(preco, designacao);
CREATE INDEX index_nome ON pessoa(nome);

-- Usados para consulta e filtro, não sendo estes PK

