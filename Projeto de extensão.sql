CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);


INSERT INTO Categories (CategoryID, CategoryName)
VALUES
(1, 'Salários'),
(2, 'Manutenção'),
(3, 'Suprimentos'),
(4, 'Marketing'),
(5, 'Utilidades');

CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    CategoryID INT,
    Date DATE,
    Amount DECIMAL(10, 2),
    Description VARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Expenses (ExpenseID, CategoryID, Date, Amount, Description)
VALUES
(1, 1, '2024-01-15', 15000.00, 'Pagamento de Salários'),
(2, 2, '2024-01-20', 2000.00, 'Reparação de Equipamentos'),
(3, 3, '2024-01-25', 500.00, 'Compra de Papel e Toner'),
(4, 4, '2024-01-30', 3000.00, 'Anúncio no Facebook'),
(5, 5, '2024-02-10', 1000.00, 'Conta de Energia'),
(6, 1, '2024-02-15', 15000.00, 'Pagamento de Salários'),
(7, 2, '2024-02-18', 2500.00, 'Manutenção do Sistema de Ar Condicionado'),
(8, 3, '2024-02-25', 600.00, 'Compra de Materiais de Escritório'),
(9, 4, '2024-02-28', 3500.00, 'Campanha de Marketing no Google'),
(10, 5, '2024-03-10', 1200.00, 'Conta de Água'),
(11, 1, '2024-03-15', 15500.00, 'Pagamento de Salários'),
(12, 2, '2024-03-20', 2200.00, 'Substituição de Filtros de Água'),
(13, 3, '2024-03-25', 700.00, 'Compra de Papelaria'),
(14, 4, '2024-03-28', 4000.00, 'Publicidade no Instagram'),
(15, 5, '2024-04-10', 1100.00, 'Conta de Gás'),
(16, 1, '2024-04-15', 16000.00, 'Pagamento de Salários'),
(17, 2, '2024-04-20', 3000.00, 'Reparação de Infraestrutura'),
(18, 3, '2024-04-25', 800.00, 'Compra de Cartuchos de Impressora'),
(19, 4, '2024-04-30', 4500.00, 'Anúncio em Revista Local'),
(20, 5, '2024-05-10', 1300.00, 'Conta de Internet');


-- Total de gastos por categoria
SELECT c.CategoryName, SUM(e.Amount) AS TotalGasto
FROM Expenses e
JOIN Categories c ON e.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalGasto DESC;

-- Gastos mensais por categoria
SELECT c.CategoryName, MONTH(e.Date) AS Mes, SUM(e.Amount) AS TotalGastoMensal
FROM Expenses e
JOIN Categories c ON e.CategoryID = c.CategoryID
GROUP BY c.CategoryName, MONTH(e.Date)
ORDER BY Mes, c.CategoryName;

-- Crescimento dos custos em comparação entre meses consecutivos
SELECT c.CategoryName, 
       SUM(CASE WHEN MONTH(e.Date) = 3 THEN e.Amount ELSE 0 END) AS GastoMar,
       SUM(CASE WHEN MONTH(e.Date) = 4 THEN e.Amount ELSE 0 END) AS GastoAbr,
       (SUM(CASE WHEN MONTH(e.Date) = 4 THEN e.Amount ELSE 0 END) -
        SUM(CASE WHEN MONTH(e.Date) = 3 THEN e.Amount ELSE 0 END)) AS Crescimento
FROM Expenses e
JOIN Categories c ON e.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING Crescimento > 0
ORDER BY Crescimento DESC;

-- Identificação de gastos repetitivos
SELECT c.CategoryName, e.Description, COUNT(*) AS Frequencia, SUM(e.Amount) AS TotalGasto
FROM Expenses e
JOIN Categories c ON e.CategoryID = c.CategoryID
GROUP BY c.CategoryName, e.Description
HAVING COUNT(*) > 1
ORDER BY Frequencia DESC, TotalGasto DESC;


-- Criação de uma View para monitoramento mensal de gastos
CREATE VIEW MonthlyExpenses AS
SELECT c.CategoryName, MONTH(e.Date) AS Mes, SUM(e.Amount) AS TotalGastoMensal
FROM Expenses e
JOIN Categories c ON e.CategoryID = c.CategoryID
GROUP BY c.CategoryName, MONTH(e.Date);

SELECT * FROM MonthlyExpenses