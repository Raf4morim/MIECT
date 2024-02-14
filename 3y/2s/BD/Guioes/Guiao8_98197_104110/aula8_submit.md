# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1 | SELECT * from Production.WorkOrder | 72591 | 0.484 | 531 | 1171 | PK | Clustered Index Scan |  |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234 | 1 | 0.00328 | 220 | 66 | PK | Clustered Index Seek |  |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010 | 11 | 0.00329 | 220 | 80 | PK | Clustered Index Seek |  |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591 | 72591 | 0.47350 | 556 | 926 | PK | Clustered Index Seek |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2012-05-14' | 55 | 0.52286 | 530 | 33 | PK | Clustered Index Scan | |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757 | 9 | 0.03736 | 240 | 70 | ProductID | NonClustered Index Seek/ Clustered Key Lookup |  |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757 | 9 | 0.00329 | 226 | 21 | ProductID Covered (StartDate) | NonClustered Index Seek |  |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 | 1105 | 0.00603 | 230 | 74 | ProductID Covered (StartDate) | NonClustered Index Seek |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04'  | 1 | 0.00603 | 232 | 18 | ProductID Covered (StartDate) | NonClustered Index Seek |  |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' | 1 | .017 | 65 | 20 | ProductID and StartDate | Non Clustered Index Seek / Non Clustered Index Seek |  |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' | 1 | 0.00328 | 228 | 25 | Composite (ProductID, StartDate) | NonClustered Index Seek |  |

## ​8.2.

### a)

```
CREATE TABLE mytemp (
    rid BIGINT /*IDENTITY (1, 1)*/ NOT NULL,
    at1 INT NULL,
    at2 INT NULL,
    at3 INT NULL,
    lixo varchar(100) NULL
);

alter table mytemp add constraint PK primary key clustered (rid)
```

### b)

```
Milisegundos usados: 112813

Percentagem de fragmentação dos Índices: 98.93%
Ocupação das Páginas dos Índices: 68.21%
```

### c)

```
Fillfactor a 65: 
    Milliseconds used: 88866

Fillfactor a 80:
    Milliseconds used: 109883

Fillfactor a 90:
    Milliseconds used: 112813
```

### d)

```
Fillfactor 0:
    Milliseconds used: 111070
Fillfactor 65:
    Milliseconds used: 87183
Fillfactor 80:
    Milliseconds used: 111806
Fillfactor 90:
    Milliseconds used: 116260
```

### e)

```
Sem indices: 50997
Com indices: 63167

Com todos os indíces a eficiência de inserção dos tuplos na tabela diminui. Um índice introduz overhead ao nível do tempo de inserção.
```

## ​8.3.

```
i. create unique clustered index ssn on 

ii. create  clustered index index_fullname on employee(Fname, Lname);

iii. create clustered index index_Dno on employee(Dno);

iv. create clustered index index_Essn_Pno on works_on(Essn, Pno);

v. create clustered index index_Essn_DepName on dependent_(Essn, Dependent_name);

vi. create clustered index index_ProjDep on project(Dnum);

```