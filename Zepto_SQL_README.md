
# 🛒 Zepto Product Data Analysis using SQL

This SQL project analyzes product-level data from Zepto, an online grocery delivery platform. The dataset includes product information such as name, MRP, discount, availability, and quantity. The goal is to clean, transform, and extract business insights using SQL.

---

## 📁 Dataset Structure

The `zepto` table includes the following columns:

| Column Name             | Description |
|-------------------------|-------------|
| sku_id                  | Unique identifier for each product (Primary Key) |
| category                | Product category |
| name                    | Product name |
| mrp                     | Maximum Retail Price |
| discountPercent         | Discount offered on the product |
| availableQuantity       | Quantity currently available in stock |
| discountedSellingPrice  | Final selling price after discount |
| weightInGms             | Weight of the product in grams |
| outOfStock              | Original status in string format |
| quantity                | Quantity sold or ordered |
| outstock                | Converted stock status (Boolean) |

---

## 🧪 Data Exploration

### 1. View Sample Data
```sql
SELECT * FROM zepto;
```
➡️ Displays sample rows to understand the dataset structure.

### 2. Count total rows
```sql
SELECT COUNT(*) FROM zepto;
```
➡️ Total number of records in the table.

### 3. Add boolean stock column
```sql
ALTER TABLE zepto ADD COLUMN outstock BOOLEAN;
UPDATE zepto SET outstock = CASE 
    WHEN outofstock = "FALSE" THEN FALSE 
    WHEN outofstock = "TRUE" THEN TRUE 
END;
```
➡️ Converts `outOfStock` string values to a boolean field `outstock`.

### 4. Check for NULLs
```sql
SELECT * FROM zepto
WHERE category IS NULL OR name IS NULL OR ...;
```
➡️ Checks for missing values in the dataset.

### 5. Distinct product categories
```sql
SELECT DISTINCT category FROM zepto ORDER BY category;
```
➡️ Lists all unique product categories.

### 6. Count of in-stock vs out-of-stock products
```sql
SELECT COUNT(sku_id), 
       CASE WHEN outstock = FALSE THEN "available" 
            WHEN outstock = TRUE THEN "notavailable" END AS stock_status
FROM zepto
GROUP BY outstock;
```
➡️ Groups product counts based on stock status.

### 7. Products listed more than once
```sql
SELECT name, COUNT(sku_id) 
FROM zepto 
GROUP BY name 
HAVING COUNT(sku_id) > 1 
ORDER BY COUNT(sku_id) DESC;
```
➡️ Detects duplicate product entries.

---

## 🧹 Data Cleaning

### 1. Check for MRP or discounted price being 0
```sql
SELECT * FROM zepto WHERE mrp = 0 OR discountedSellingPrice = 0;
```
➡️ Detects invalid pricing records.

### 2. Remove such invalid entries
```sql
DELETE FROM zepto WHERE mrp = 0 OR discountedSellingPrice = 0;
```
➡️ Cleans out erroneous product data.

### 3. Convert price from paisa to rupees
```sql
UPDATE zepto 
SET mrp = mrp / 100.0, discountedSellingPrice = discountedSellingPrice / 100.0;
```
➡️ Adjusts price format for better analysis.

---

## 📊 Business Insights

### Q1: Top 10 best-value products by discount
```sql
SELECT DISTINCT * FROM zepto ORDER BY discountPercent DESC LIMIT 10;
```
➡️ Products offering the highest discounts.

### Q2: High MRP products that are out of stock
```sql
SELECT DISTINCT name, mrp 
FROM zepto 
WHERE outstock IS TRUE AND mrp > 300 
ORDER BY mrp DESC;
```
➡️ Identifies expensive but unavailable products.

### Q3: Estimated revenue by category
```sql
SELECT SUM(discountedSellingPrice * availableQuantity) AS total_revenue, category 
FROM zepto 
GROUP BY category 
ORDER BY total_revenue DESC;
```
➡️ Calculates revenue potential for each category.

### Q4: Products with high MRP but low discount
```sql
SELECT DISTINCT name, mrp, discountPercent 
FROM zepto 
WHERE mrp > 500 AND discountPercent < 10 
ORDER BY mrp DESC, discountPercent DESC;
```
➡️ Filters premium products with small discounts.

### Q5: Top 5 categories by average discount
```sql
SELECT DISTINCT ROUND(AVG(discountPercent), 2) AS avg_dis_price, category 
FROM zepto 
GROUP BY category 
ORDER BY avg_dis_price DESC 
LIMIT 5;
```
➡️ Shows which categories give highest average discounts.

### Q6: Price per gram for products >100g
```sql
SELECT DISTINCT name, ROUND((discountedSellingPrice / weightInGms), 2) AS price_per_grams 
FROM zepto 
WHERE weightInGms >= 100 
ORDER BY price_per_grams;
```
➡️ Helps assess cost efficiency per gram.

### Q7: Classify product sizes
```sql
SELECT name, weightInGms, 
       CASE 
           WHEN weightInGms < 1000 THEN "low"
           WHEN weightInGms < 5000 THEN "medium"
           ELSE "bulk" 
       END AS category_quantity 
FROM zepto;
```
➡️ Categorizes product size into low, medium, or bulk.

### Q8: Total inventory weight by category
```sql
SELECT SUM(weightInGms * availableQuantity) AS total_weight, category 
FROM zepto 
GROUP BY category 
ORDER BY total_weight DESC;
```
➡️ Total stock weight for each category.

---

## ✅ Conclusion

This project shows how to clean and analyze product data using SQL, focusing on stock availability, pricing insights, and revenue potential.

---

## 🛠 Tools Used
- MySQL
- SQL Workbench / DBeaver
- GitHub

---

## 👨‍💻 Author

**Praveen S R**    
SQL | Data Analytics | Machine Learning  
