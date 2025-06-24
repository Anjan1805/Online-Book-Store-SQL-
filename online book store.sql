-- creating a data base 
CREATE DATABASE ONLINBOOKSTORE; 
-- using THE DATABASE
USE ONLINEBOOKSTORE;
-- creating tables books,customers,orders
drop table if exists books;
create table books(
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID), 
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
        Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';

-- Import Data into BOOKS Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

-- Import Data into Customers Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Customer_ID, Name, Email, Phone, City, Country);



-- Import Data into Orders Table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



-- 1) Retrieve all books in the "Fiction" genre:
SELECT* FROM Books
where genre = 'Fiction';

-- 2) Find books published after the year 1950:
select* from Books
where Published_Year >1950;

-- 3) List all customers from the Canada
 select* from customers
where country = 'canada';

-- 4) Show orders placed in November 2023:
select* from orders
where order_Date between '2023-01-01' and '2023-12-31'; 

-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock
from Books;


-- 6) Find the details of the most expensive book:
select* from books
order by price DESC
Limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select* from orders
where Quantity > 1 ;

-- 9) List all genres available in the Books table:
select distinct genre
from Books; 

-- 10) Find the book with the lowest stock:
select* from books
order by stock 
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_Amount) as revenue_generated 
from Orders;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select b.genre , sum(o.Quantity) as total_no_books
from orders o
join Books b on b.Book_ID = o.Book_ID
group by genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(Price) 
from books 
where Genre = "Fantasy";

-- 3) List customers who have placed at least 2 orders:
select o.Quantity , c.Name 
from orders o
join customers c on c.Customer_ID = o.customer_ID
where o.quantity >= 2;


-- 4) Find the most frequently ordered book:
select b.Title ,o.Book_ID,count(o.order_id) as ORDER_COUNT
from orders o
join books b on o.Book_ID = b.Book_ID
group by o.book_id, b.title
order by ORDER_COUNT
;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT Title,Price 
from Books
where Genre = "Fantasy"
order by price desc
limit 3;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 6) Retrieve the total quantity of books sold by each author:
select b.Author , sum(o.Quantity) as sold_books
from Orders o
Join Books b on b.Book_ID = o.Book_ID
group by B.Author;

-- 7) List the cities where customers who spent over $30 are located:
select c.City, o.total_amount
from Orders o
join Customers c on c.customer_ID = o.Customer_ID
where o.Total_amount > 30;

-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id -- LEFT JOIN ensures that all books are included, even if they haven't been ordered.
GROUP BY b.book_id 
ORDER BY b.book_id;

-- The end

