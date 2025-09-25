# Comprehensive BikeStores Data Warehouse & Business Intelligence Project

## 1. Project Overview

This project showcases a complete, end-to-end data engineering and business intelligence solution. The core objective was to extract raw, transactional data from an **OLTP** (Online Transaction Processing) system and transform it into a robust **Data Warehouse (DWH)** optimized for analytical reporting and strategic decision-making. This project meticulously covers the entire data pipeline life cycle: from data source analysis and dimensional modeling to the development of an automated ETL process, in-depth data analysis, and the creation of insightful, interactive dashboards. The final solution provides stakeholders with a single source of truth for all business-related queries.

## 2. Project Architecture

The project is built on a scalable and modular data architecture, where each component plays a critical and well-defined role in the data flow.

* **Source System (OLTP):** The highly normalized `BikeStores` database is the starting point.
* **ETL Orchestration (SSIS):** SSIS manages the complex data transformations and incremental loads.
* **Data Warehouse (DWH):** The `BikeStoresDW` database, optimized with a Star Schema for analytical queries.
* **Analysis & Visualization:** **SQL** and **Power BI** are used to translate complex data into actionable business intelligence.

### Data Architecture Diagram

The following diagram illustrates the high-level architecture of the data pipeline, showing the flow from the OLTP source to the final BI dashboards.
![architecture-of-data-warehoue-image-data-warehouse](https://github.com/user-attachments/assets/a25cfd17-aacb-4f51-8f3b-5277cc3f77ed)


---

## 3. Database Modeling

A foundational element of this project is the transformation from a transactional database design to an analytical one.

### Source Database Schema (OLTP)

The source `BikeStores` database uses a normalized schema with multiple tables. This design prioritizes **transactional integrity** but requires many joins for analysis.

<img width="1369" height="882" alt="DB_ DIagram" src="https://github.com/user-attachments/assets/a392a831-d4a8-4843-92db-6dfd8379295f" />

### Data Warehouse Schema (Star Schema)

The DWH is designed using a **Star Schema**, which significantly simplifies data retrieval and improves query performance for analytical tasks by utilizing denormalization.

* **Fact Table:**
    * `FactSales`: This is a **transactional fact table**. It contains all quantitative measures, including `Quantity`, `ListPrice`, and the key business metric, **`NetSalesAmount`** (calculated as `list_price * quantity * (1 - discount)`).

* **Dimension Tables (Surrounding the Fact):**
    * `DimProduct`, `DimCustomer`, `DimStore`, `DimStaff`, and `DimDate`.

**Key Design Choice: Multi-Key Date Analysis:**
The `FactSales` table uses **three separate date keys** (`OrderDateKey`, `RequiredDateKey`, and `ShippedDateKey`), all linking to the `DimDate` table. This allows for powerful analytical comparisons, such as calculating average shipping time by store.

<img width="1072" height="421" alt="Fact Data" src="https://github.com/user-attachments/assets/5fca67f6-76ab-45f6-8a66-c507fac0fa24" />

---

## 4. Incremental ETL Process Using SSIS

The ETL pipeline was developed to perform an **incremental load**, ensuring only new or updated data is processed since the last execution, which is crucial for scalability.

### Loading Dimension Tables

The dimensions are loaded first to establish referential integrity.

* **`DimStore` and `DimStaff`:** These are simple dimensions (Type 0, or fixed attributes). The ETL flow is straightforward, checking for new keys before insertion.
<img width="999" height="379" alt="Dim Store" src="https://github.com/user-attachments/assets/e7711d5c-abe0-4329-9d90-d0aaa2f1775e" />

<img width="996" height="391" alt="Dim Staff" src="https://github.com/user-attachments/assets/89353262-272c-43f2-93d6-e0e9b7e0e5dc" />


* **`DimProduct` and `DimCustomer`:** These are modeled as **Slowly Changing Dimensions (SCD) Type 2**. The SSIS component is used to **preserve history** for changes to key attributes (e.g., customer location or product category). When an attribute changes, the old record is marked as inactive, and a new record is inserted with the updated information.
* 
<img width="1344" height="703" alt="DimProduct" src="https://github.com/user-attachments/assets/b4ef9f94-2e6e-4ff0-927a-a6a6bce197f9" />

<img width="1436" height="661" alt="DimCustomer" src="https://github.com/user-attachments/assets/7ef8227c-7e18-497a-b68f-b587878a09cb" />


### Loading the Fact Table

This is the final and most critical part of the ETL process.

* **Lookup Transformation:** The data flow uses multiple **`Lookup`** components in series. This is the fundamental process of replacing the original, non-unique natural keys (e.g., `customer_id`) with the unique, system-generated **surrogate keys** from the dimension tables (e.g., `CustomerKey`).
* **Calculation:** The `NetSalesAmount` is calculated within the data flow before insertion.

<img width="1417" height="650" alt="Fact Sales" src="https://github.com/user-attachments/assets/a93ac5b6-4973-42d3-b2d6-a53535fddd8e" />

---

## 5. Analysis and Visualization

With the DWH populated, the data is transformed into actionable business intelligence using Power BI.

### Power BI Dashboards

Interactive dashboards provide a visual and intuitive interface for key stakeholders.

* **Customer Analysis Dashboard:** This dashboard provides a deep dive into customer behavior and value, answering questions like, "Who are our most valuable customers?" and "How is our discounting strategy affecting customer loyalty?"
    * **KPIs:** `Total Customers`, `Total Net Sales`, `Average Customer Sales`.
    * **Visualizations:** Focuses on customer segmentation and spending habits.
<img width="1472" height="831" alt="Customer" src="https://github.com/user-attachments/assets/ecbade02-eb49-4088-969d-bb114fbf4de8" />


* **Product Analysis Dashboard:** This dashboard focuses on product and inventory performance, helping inform sales and restocking strategies.
    * **KPIs:** `Total Orders`, `Total Quantity Sold`, `Total Net Sales`.
    * **Visualizations:** Features a breakdown of sales by category and brand, identifying best-selling and underperforming products.

<img width="1471" height="837" alt="Product" src="https://github.com/user-attachments/assets/c0ad633e-efa3-4559-8ec0-21dad0e502c7" />
<img width="1483" height="841" alt="Sales" src="https://github.com/user-attachments/assets/2ebcacdc-f01f-4732-a34f-7abb1ab2df22" />

---

## 6. Tools and Technologies Used

* **Database:** SQL Server
* **ETL:** SQL Server Integration Services (SSIS)
* **Analysis:** SQL
* **Visualization:** Power BI
* **Streaming (Optional Extension):** Python for implementing real-time data processing concepts.
