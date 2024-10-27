# Ejercicios Windows Functions

## AVG

- Obtener el promedio de precios por cada categoría de producto. La cláusula OVER(PARTITION BY CategoryID) específica que se debe calcular el promedio de precios por cada valor único de CategoryID en la tabla.

```sql
select c.category_name , p.product_name , p.unit_price ,
avg(p.unit_price) over (partition by c.category_id) as avg_price_bycategory
from products p 
inner join categories c on p.category_id = c.category_id 
```

**Resultado:**

|category_name |product_name                    |unit_price|avg_price_bycategory|
|--------------|--------------------------------|----------|--------------------|
|Beverages     |Guaraná Fantástica              |4,5       |37,9791666667       |
|Beverages     |Ipoh Coffee                     |46        |37,9791666667       |
|Beverages     |Chartreuse verte                |18        |37,9791666667       |
|Beverages     |Côte de Blaye                   |263,5     |37,9791666667       |
|Beverages     |Steeleye Stout                  |18        |37,9791666667       |
|Beverages     |Sasquatch Ale                   |14        |37,9791666667       |
|Beverages     |Lakkalikööri                    |18        |37,9791666667       |
|Beverages     |Rhönbräu Klosterbier            |7,75      |37,9791666667       |
|Beverages     |Outback Lager                   |15        |37,9791666667       |
|Beverages     |Chai                            |18        |37,9791666667       |
|Beverages     |Laughing Lumberjack Lager       |14        |37,9791666667       |
|Beverages     |Chang                           |19        |37,9791666667       |
|Condiments    |Gula Malacca                    |19,45     |22,8541668256       |
|Condiments    |Original Frankfurter grüne Soße |13        |22,8541668256       |
|Condiments    |Northwoods Cranberry Sauce      |40        |22,8541668256       |
|Condiments    |Louisiana Hot Spiced Okra       |17        |22,8541668256       |

- Obtener el promedio de venta de cada cliente

```sql
select c.customer_id , c.contact_name , o.order_id , o.order_date ,
avg(od.quantity * p.unit_price) over (partition by c.customer_id) as avg_order_amount
from customers c 
inner join orders o on c.customer_id = o.customer_id 
inner join order_details od on o.order_id = od.order_id 
inner join products p on od.product_id = p.product_id 
```

**Resultado:**

|customer_id|contact_name      |order_id|order_date|avg_order_amount|
|-----------|------------------|--------|----------|----------------|
|ALFKI      |Maria Anders      |10.702  |1997-10-13|383,0166670481  |
|ALFKI      |Maria Anders      |10.643  |1997-08-25|383,0166670481  |
|ALFKI      |Maria Anders      |10.952  |1998-03-16|383,0166670481  |
|ALFKI      |Maria Anders      |11.011  |1998-04-09|383,0166670481  |
|ALFKI      |Maria Anders      |11.011  |1998-04-09|383,0166670481  |
|ALFKI      |Maria Anders      |10.692  |1997-10-03|383,0166670481  |
|ALFKI      |Maria Anders      |10.643  |1997-08-25|383,0166670481  |
|ALFKI      |Maria Anders      |10.643  |1997-08-25|383,0166670481  |
|ALFKI      |Maria Anders      |10.835  |1998-01-15|383,0166670481  |
|ALFKI      |Maria Anders      |10.952  |1998-03-16|383,0166670481  |
|ALFKI      |Maria Anders      |10.702  |1997-10-13|383,0166670481  |
|ALFKI      |Maria Anders      |10.835  |1998-01-15|383,0166670481  |
|ANATR      |Ana Trujillo      |10.308  |1996-09-18|142,5149991035  |
|ANATR      |Ana Trujillo      |10.926  |1998-03-04|142,5149991035  |
|ANATR      |Ana Trujillo      |10.625  |1997-08-08|142,5149991035  |
|ANATR      |Ana Trujillo      |10.625  |1997-08-08|142,5149991035  |
|ANATR      |Ana Trujillo      |10.625  |1997-08-08|142,5149991035  |
|ANATR      |Ana Trujillo      |10.926  |1998-03-04|142,5149991035  |
|ANATR      |Ana Trujillo      |10.926  |1998-03-04|142,5149991035  |
|ANATR      |Ana Trujillo      |10.926  |1998-03-04|142,5149991035  |
|ANATR      |Ana Trujillo      |10.759  |1997-11-28|142,5149991035  |
|ANATR      |Ana Trujillo      |10.308  |1996-09-18|142,5149991035  |
|ANTON      |Antonio Moreno    |10.365  |1996-11-27|448,0088213752  |
|ANTON      |Antonio Moreno    |10.535  |1997-05-13|448,0088213752  |

- Obtener el promedio de cantidad de productos vendidos por categoría(product_name,quantity_per_unit, unit_price, quantity, avgquantity) y ordenarlo por nombre de la categoría y nombre del producto

```sql
select p.product_name , c.category_name , p.quantity_per_unit ,p.unit_price , od.quantity,
avg(od.quantity) over (partition by c.category_id) as avg_quantity
from products p 
inner join categories c on p.category_id = c.category_id 
inner join order_details od on p.product_id = od.product_id 
order by c.category_name, p.product_name
```

**Resultado:**

|product_name      |category_name|quantity_per_unit |unit_price|quantity|avg_quantity |
|------------------|-------------|------------------|----------|--------|-------------|
|Chai              |Beverages    |10 boxes x 30 bags|18        |10      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |25      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |21      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |60      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |20      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |4       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |10      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |8       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |10      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |40      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |6       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |3       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |15      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |8       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |10      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |18      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |35      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |30      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |15      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |4       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |5       |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |20      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |12      |23,5940594059|
|Chai              |Beverages    |10 boxes x 30 bags|18        |45      |23,5940594059|

---

## MIN

- Selecciona el ID del cliente, la fecha de la orden y la fecha más antigua de la
orden para cada cliente de la tabla 'Orders'.

```sql
select c.customer_id , o.order_date ,
min(o.order_date) over (partition by c.customer_id) as earliest_order_date
from customers c 
inner join orders o on c.customer_id = o.customer_id
```

**Resultado:**

|customer_id|order_date|earliest_order_date|
|-----------|----------|-------------------|
|ALFKI      |1998-01-15|1997-08-25         |
|ALFKI      |1997-10-03|1997-08-25         |
|ALFKI      |1998-04-09|1997-08-25         |
|ALFKI      |1997-10-13|1997-08-25         |
|ALFKI      |1997-08-25|1997-08-25         |
|ALFKI      |1998-03-16|1997-08-25         |
|ANATR      |1997-08-08|1996-09-18         |
|ANATR      |1998-03-04|1996-09-18         |
|ANATR      |1996-09-18|1996-09-18         |
|ANATR      |1997-11-28|1996-09-18         |
|ANTON      |1997-09-22|1996-11-27         |
|ANTON      |1997-05-13|1996-11-27         |
|ANTON      |1998-01-28|1996-11-27         |
|ANTON      |1997-09-25|1996-11-27         |
|ANTON      |1997-04-15|1996-11-27         |
|ANTON      |1997-06-19|1996-11-27         |
|ANTON      |1996-11-27|1996-11-27         |
|AROUT      |1997-02-21|1996-11-15         |
|AROUT      |1997-11-17|1996-11-15         |
|AROUT      |1996-12-16|1996-11-15         |
|AROUT      |1998-03-16|1996-11-15         |
|AROUT      |1997-12-08|1996-11-15         |
|AROUT      |1998-03-03|1996-11-15         |
|AROUT      |1997-12-24|1996-11-15         |
|AROUT      |1997-06-04|1996-11-15         |
|AROUT      |1997-11-14|1996-11-15         |

---

## MAX

- Seleccione el id de producto, el nombre de producto, el precio unitario, el id de
categoría y el precio unitario máximo para cada categoría de la tabla Products.

```sql
select p.product_id , p.product_name , p.unit_price , p.category_id ,
max(p.unit_price) over (partition by p.category_id) as max_unit_price
from products p 
```

**Resultado:**

|product_id|product_name                    |unit_price|category_id|max_unit_price|
|----------|--------------------------------|----------|-----------|--------------|
|24        |Guaraná Fantástica              |4,5       |1          |263,5         |
|43        |Ipoh Coffee                     |46        |1          |263,5         |
|39        |Chartreuse verte                |18        |1          |263,5         |
|38        |Côte de Blaye                   |263,5     |1          |263,5         |
|35        |Steeleye Stout                  |18        |1          |263,5         |
|34        |Sasquatch Ale                   |14        |1          |263,5         |
|76        |Lakkalikööri                    |18        |1          |263,5         |
|75        |Rhönbräu Klosterbier            |7,75      |1          |263,5         |
|70        |Outback Lager                   |15        |1          |263,5         |
|1         |Chai                            |18        |1          |263,5         |
|67        |Laughing Lumberjack Lager       |14        |1          |263,5         |
|2         |Chang                           |19        |1          |263,5         |
|44        |Gula Malacca                    |19,45     |2          |43,9          |
|77        |Original Frankfurter grüne Soße |13        |2          |43,9          |
|8         |Northwoods Cranberry Sauce      |40        |2          |43,9          |
|66        |Louisiana Hot Spiced Okra       |17        |2          |43,9          |
|15        |Genen Shouyu                    |13        |2          |43,9          |
|6         |Grandma's Boysenberry Spread    |25        |2          |43,9          |
|65        |Louisiana Fiery Hot Pepper Sauce|21,05     |2          |43,9          |
|63        |Vegie-spread                    |43,9      |2          |43,9          |

---

## ROW_NUMBER

- Obtener el ranking de los productos más vendidos

```sql
select p.product_name , sum(od.quantity) as total_quantity, row_number() over (order by sum(od.quantity) desc) as rank
from products p 
inner join order_details od on p.product_id = od.product_id 
group by p.product_name 
order by rank
```

**Resultado:**

|product_name                    |total_quantity|rank|
|--------------------------------|--------------|----|
|Camembert Pierrot               |1.577         |1   |
|Raclette Courdavault            |1.496         |2   |
|Gorgonzola Telino               |1.397         |3   |
|Gnocchi di nonna Alice          |1.263         |4   |
|Pavlova                         |1.158         |5   |
|Rhönbräu Klosterbier            |1.155         |6   |
|Guaraná Fantástica              |1.125         |7   |
|Boston Crab Meat                |1.103         |8   |
|Tarte au sucre                  |1.083         |9   |
|Chang                           |1.057         |10  |
|Flotemysost                     |1.057         |11  |
|Sir Rodney's Scones             |1.016         |12  |
|Jack's New England Clam Chowder |981           |13  |
|Lakkalikööri                    |981           |14  |
|Alice Mutton                    |978           |15  |
|Pâté chinois                    |903           |16  |
|Konbu                           |891           |17  |

- Asignar numeros de fila para cada cliente, ordenados por customer_id

```sql
select row_number () over (order by c.customer_id) as row_number, c.customer_id , c.company_name , c.contact_name , c.contact_title
from customers c
group by c.customer_id 
order by row_number
```

**Resultado:**

|row_number|customer_id|company_name|contact_name|contact_title|
|----------|-----------|------------|------------|-------------|
|1|92|Siemens|Engineer||
|2|ALFKI|Alfreds Futterkiste|Maria Anders|Sales Representative|
|3|ANATR|Ana Trujillo Emparedados y helados|Ana Trujillo|Owner|
|4|ANTON|Antonio Moreno Taquería|Antonio Moreno|Owner|
|5|AROUT|Around the Horn|Thomas Hardy|Sales Representative|
|6|BERGS|Berglunds snabbköp|Christina Berglund|Order Administrator|
|7|BLAUS|Blauer See Delikatessen|Hanna Moos|Sales Representative|
|8|BLONP|Blondesddsl père et fils|Frédérique Citeaux|Marketing Manager|
|9|BOLID|Bólido Comidas preparadas|Martín Sommer|Owner|
|10|BONAP|Bon app'|Laurence Lebihan|Owner|
|11|BOTTM|Bottom-Dollar Markets|Elizabeth Lincoln|Accounting Manager|
|12|BSBEV|B's Beverages|Victoria Ashworth|Sales Representative|
|13|CACTU|Cactus Comidas para llevar|Patricio Simpson|Sales Agent|
|14|CENTC|Centro comercial Moctezuma|Francisco Chang|Marketing Manager|
|15|CHOPS|Chop-suey Chinese|Yang Wang|Owner|
|16|COMMI|Comércio Mineiro|Pedro Afonso|Sales Associate|
|17|CONSH|Consolidated Holdings|Elizabeth Brown|Sales Representative|
|18|DRACD|Drachenblut Delikatessen|Sven Ottlieb|Order Administrator|
|19|DUMON|Du monde entier|Janine Labrune|Owner|
|20|EASTC|Eastern Connection|Ann Devon|Sales Agent|
|21|ERNSH|Ernst Handel|Roland Mendel|Sales Manager|
|22|FAMIA|Familia Arquibaldo|Aria Cruz|Marketing Assistant|
|23|FISSA|FISSA Fabrica Inter. Salchichas S.A.|Diego Roel|Accounting Manager|
|24|FOLIG|Folies gourmandes|Martine Rancé|Assistant Sales Agent|

- Obtener el ranking de los empleados más jóvenes () ranking, nombre y apellido del
empleado, fecha de nacimiento

```sql
select row_number () over (order by min(e.birth_date) desc) as ranking, e.first_name , e.last_name , e.birth_date 
from employees e 
group by e.employee_id 
order by ranking
```

**Resultado:**

|ranking|first_name|last_name|birth_date|
|-------|----------|---------|----------|
|1|Anne|Dodsworth|1966-01-27|
|2|Janet|Leverling|1963-08-30|
|3|Michael|Suyama|1963-07-02|
|4|Robert|King|1960-05-29|
|5|Laura|Callahan|1958-01-09|
|6|Steven|Buchanan|1955-03-04|
|7|Andrew|Fuller|1952-02-19|
|8|Nancy|Davolio|1948-12-08|
|9|Margaret|Peacock|1937-09-19|

---

## SUM

- Obtener la suma de venta de cada cliente

```sql
select sum(od.quantity * od.unit_price) over (order by c.customer_id) as sum_order_amount, o.order_id , c.customer_id , o.employee_id , o.order_date, o.required_date 
from customers c 
inner join orders o on c.customer_id = o.customer_id 
inner join order_details od on o.order_id = od.order_id 
```

**Resultado:**

|sum_order_amount|order_id|customer_id|employee_id|order_date|required_date|
|----------------|--------|-----------|-----------|----------|-------------|
|4596.200004577637|10702|ALFKI|4|1997-10-13|1997-11-24|
|4596.200004577637|10643|ALFKI|6|1997-08-25|1997-09-22|
|4596.200004577637|10952|ALFKI|1|1998-03-16|1998-04-27|
|4596.200004577637|11011|ALFKI|3|1998-04-09|1998-05-07|
|4596.200004577637|11011|ALFKI|3|1998-04-09|1998-05-07|
|4596.200004577637|10692|ALFKI|4|1997-10-03|1997-10-31|
|4596.200004577637|10643|ALFKI|6|1997-08-25|1997-09-22|
|4596.200004577637|10643|ALFKI|6|1997-08-25|1997-09-22|
|4596.200004577637|10835|ALFKI|1|1998-01-15|1998-02-12|
|4596.200004577637|10952|ALFKI|1|1998-03-16|1998-04-27|
|4596.200004577637|10702|ALFKI|4|1997-10-13|1997-11-24|
|4596.200004577637|10835|ALFKI|1|1998-01-15|1998-02-12|
|5999.149994850159|10308|ANATR|7|1996-09-18|1996-10-16|
|5999.149994850159|10926|ANATR|4|1998-03-04|1998-04-01|
|5999.149994850159|10625|ANATR|3|1997-08-08|1997-09-05|

- Obtener la suma total de ventas por categoría de producto

```sql
select  c.category_name,  p.product_name ,od.unit_price , od.quantity , SUM(od.quantity * od.unit_price) over (partition by c.category_name, p.product_name) as total_sales_by_category
FROM products p
inner join categories c ON c.category_id = p.category_id
inner join order_details od ON p.product_id = od.product_id
```

**Resultado:**

|category_name|product_name|unit_price|quantity|total_sales_by_category|
|-------------|------------|----------|--------|-----------------------|
|Beverages|Chai|18.0|8|14277.599933624268|
|Beverages|Chai|18.0|40|14277.599933624268|
|Beverages|Chai|18.0|80|14277.599933624268|
|Beverages|Chai|18.0|8|14277.599933624268|
|Beverages|Chai|14.4|15|14277.599933624268|
|Beverages|Chai|18.0|40|14277.599933624268|
|Beverages|Chai|18.0|45|14277.599933624268|
|Beverages|Chai|14.4|18|14277.599933624268|
|Beverages|Chai|18.0|6|14277.599933624268|
|Beverages|Chai|18.0|25|14277.599933624268|
|Beverages|Chai|18.0|3|14277.599933624268|
|Beverages|Chai|18.0|25|14277.599933624268|
|Beverages|Chai|14.4|20|14277.599933624268|
|Beverages|Chai|18.0|10|14277.599933624268|
|Beverages|Chai|14.4|10|14277.599933624268|
|Beverages|Chai|18.0|20|14277.599933624268|
|Beverages|Chai|14.4|15|14277.599933624268|
|Beverages|Chai|18.0|60|14277.599933624268|
|Beverages|Chai|18.0|35|14277.599933624268|
|Beverages|Chai|14.4|15|14277.599933624268|
|Beverages|Chai|18.0|20|14277.599933624268|
|Beverages|Chai|18.0|4|14277.599933624268|
|Beverages|Chai|14.4|45|14277.599933624268|
|Beverages|Chai|18.0|5|14277.599933624268|
|Beverages|Chai|14.4|24|14277.599933624268|
|Beverages|Chai|18.0|10|14277.599933624268|
|Beverages|Chai|18.0|10|14277.599933624268|
|Beverages|Chai|18.0|4|14277.599933624268|
|Beverages|Chai|18.0|2|14277.599933624268|
|Beverages|Chai|14.4|12|14277.599933624268|
|Beverages|Chai|18.0|21|14277.599933624268|
|Beverages|Chai|18.0|15|14277.599933624268|
|Beverages|Chai|18.0|30|14277.599933624268|

- Calcular la suma total de gastos de envío por país de destino, luego ordenarlo por país
y por orden de manera ascendente

```sql
select c.country , o.order_id , o.shipped_date , o.freight , sum(o.freight) over (partition by c.country order by o.order_id) as total_shipping_cost
from orders o 
inner join customers c on c.customer_id = o.customer_id 
order by c.country asc, o.order_id  asc
```

**Resultado:**

|country|order_id|shipped_date|freight|total_shipping_cost|
|-------|--------|------------|-------|-------------------|
|Argentina|10409|1997-01-14|29.83|29.83|
|Argentina|10448|1997-02-24|38.82|68.65|
|Argentina|10521|1997-05-02|17.22|85.87|
|Argentina|10531|1997-05-19|8.12|93.990005|
|Argentina|10716|1997-10-27|22.57|116.560005|
|Argentina|10782|1997-12-22|1.1|117.66|
|Argentina|10819|1998-01-16|19.76|137.42|
|Argentina|10828|1998-02-04|90.85|228.26999|
|Argentina|10881|1998-02-18|2.84|231.10999|
|Argentina|10898|1998-03-06|1.27|232.37999|
|Argentina|10916|1998-03-09|63.77|296.15|
|Argentina|10937|1998-03-13|31.51|327.66|
|Argentina|10958|1998-03-27|49.56|377.22|
|Argentina|10986|1998-04-21|217.86|595.08|
|Argentina|11019||3.17|598.25|
|Argentina|11054||0.33|598.58|
|Austria|10258|1996-07-23|140.51|140.51|
|Austria|10263|1996-07-31|146.06|286.57|
|Austria|10351|1996-11-20|162.33|448.90002|
|Austria|10353|1996-11-25|360.63|809.53|
|Austria|10368|1996-12-02|101.95|911.48004|
|Austria|10382|1996-12-16|94.77|1006.25006|
|Austria|10390|1996-12-26|126.38|1132.63|
|Austria|10392|1997-01-01|122.46|1255.09|
|Austria|10402|1997-01-10|67.88|1322.97|
|Austria|10403|1997-01-09|73.79|1396.76|
|Austria|10427|1997-03-03|31.29|1428.05|

---

## RANK

- Ranking de ventas por cliente

```sql
select c.customer_id , c.company_name , sum(od.quantity * od.unit_price) as total_sales ,rank() over (order by sum(od.quantity * od.unit_price)desc) as sales_rank 
from customers c
inner join orders o on c.customer_id = o.customer_id 
inner join order_details od on o.order_id = od.order_id 
group by c.customer_id , c.company_name 
order by sales_rank
```

**Resultado:**

|customer_id|company_name|total_sales|sales_rank|
|-----------|------------|-----------|----------|
|QUICK|QUICK-Stop|117483.390147686|1|
|SAVEA|Save-a-lot Markets|115673.38964271545|2|
|ERNSH|Ernst Handel|113236.67978191376|3|
|HUNGO|Hungry Owl All-Night Grocers|57317.39016246796|4|
|RATTC|Rattlesnake Canyon Grocery|52245.90034675598|5|
|HANAR|Hanari Carnes|34101.149973869324|6|
|FOLKO|Folk och fä HB|32555.55001926422|7|
|MEREP|Mère Paillarde|32203.900234222412|8|
|KOENE|Königlich Essen|31745.749893188477|9|
|QUEEN|Queen Cozinha|30226.10017967224|10|
|WHITC|White Clover Markets|29073.449927330017|11|
|FRANK|Frankenversand|28722.70993900299|12|
|BERGS|Berglunds snabbköp|26968.149930477142|13|
|PICCO|Piccolo und mehr|26259.95008468628|14|
|SUPRD|Suprêmes délices|24704.400303840637|15|
|BONAP|Bon app'|23850.949985980988|16|
|HILAA|HILARION-Abastos|23611.579944610596|17|
|BOTTM|Bottom-Dollar Markets|22607.699960708618|18|
|LEHMS|Lehmanns Marktstand|21282.019976615906|19|
|RICSU|Richter Supermarkt|20033.199929237366|20|
|GREAL|Great Lakes Food Market|19711.12999534607|21|
|BLONP|Blondesddsl père et fils|19088.000093460083|22|
|SIMOB|Simons bistro|18138.45011329651|23|

- Ranking de empleados por fecha de contratacion

```sql
select e.employee_id , e.first_name , e.last_name , e.hire_date , rank() over (order by min(e.hire_date)) as rank
from employees e 
group by e.employee_id 
order by rank
```

**Resultado:**

|employee_id|first_name|last_name|hire_date|rank|
|-----------|----------|---------|---------|----|
|3|Janet|Leverling|1992-04-01|1|
|1|Nancy|Davolio|1992-05-01|2|
|2|Andrew|Fuller|1992-08-14|3|
|4|Margaret|Peacock|1993-05-03|4|
|5|Steven|Buchanan|1993-10-17|5|
|6|Michael|Suyama|1993-10-17|5|
|7|Robert|King|1994-01-02|7|
|8|Laura|Callahan|1994-03-05|8|
|9|Anne|Dodsworth|1994-11-15|9|

- Ranking de productos por precio unitario

```sql
select p.product_id , p.product_name , p.unit_price , rank() over (order by p.unit_price desc) as rank
from products p 
group by p.product_id 
order by rank asc
```

**Resultado:**

|product_id|product_name|unit_price|rank|
|----------|------------|----------|----|
|38|Côte de Blaye|263.5|1|
|29|Thüringer Rostbratwurst|123.79|2|
|9|Mishi Kobe Niku|97.0|3|
|20|Sir Rodney's Marmalade|81.0|4|
|18|Carnarvon Tigers|62.5|5|
|59|Raclette Courdavault|55.0|6|
|51|Manjimup Dried Apples|53.0|7|
|62|Tarte au sucre|49.3|8|
|43|Ipoh Coffee|46.0|9|
|28|Rössle Sauerkraut|45.6|10|
|63|Vegie-spread|43.9|11|
|27|Schoggi Schokolade|43.9|11|
|8|Northwoods Cranberry Sauce|40.0|13|
|17|Alice Mutton|39.0|14|
|12|Queso Manchego La Pastora|38.0|15|
|56|Gnocchi di nonna Alice|38.0|15|
|69|Gudbrandsdalsost|36.0|17|
|72|Mozzarella di Giovanni|34.8|18|
|60|Camembert Pierrot|34.0|19|
|64|Wimmers gute Semmelknödel|33.25|20|
|53|Perth Pasties|32.8|21|
|32|Mascarpone Fabioli|32.0|22|

---

## LAG

- Mostrar por cada producto de una orden, la cantidad vendida y la cantidad
vendida del producto previo.

```sql
select od.order_id , p.product_id , od.quantity , lag (od.quantity) over (order by od.order_id) as prev_quantity
from products p 
inner join order_details od  on p.product_id = od.product_id 
order by od.order_id 
```

**Resultado:**

|order_id|product_id|quantity|prev_quantity|
|--------|----------|--------|-------------|
|10248|11|12||
|10248|42|10|12|
|10248|72|5|10|
|10249|14|9|5|
|10249|51|40|9|
|10250|41|10|40|
|10250|51|35|10|
|10250|65|15|35|
|10251|22|6|15|
|10251|57|15|6|
|10251|65|20|15|
|10252|20|40|20|
|10252|33|25|40|
|10252|60|40|25|
|10253|31|20|40|
|10253|39|42|20|
|10253|49|40|42|
|10254|24|15|40|
|10254|55|21|15|
|10254|74|21|21|
|10255|2|20|21|
|10255|16|35|20|
|10255|36|25|35|

- Obtener un listado de ordenes mostrando el id de la orden, fecha de orden, id del cliente
y última fecha de orden.

```sql
select o.order_id , o.order_date , c.customer_id , lag(o.order_date) over (partition by c.customer_id order by o.order_id) as last_order_date
from orders o 
inner join customers c on c.customer_id = o.customer_id 
```

**Resultado:**

|order_id|order_date|customer_id|last_order_date|
|--------|----------|-----------|---------------|
|10643|1997-08-25|ALFKI||
|10692|1997-10-03|ALFKI|1997-08-25|
|10702|1997-10-13|ALFKI|1997-10-03|
|10835|1998-01-15|ALFKI|1997-10-13|
|10952|1998-03-16|ALFKI|1998-01-15|
|11011|1998-04-09|ALFKI|1998-03-16|
|10308|1996-09-18|ANATR||
|10625|1997-08-08|ANATR|1996-09-18|
|10759|1997-11-28|ANATR|1997-08-08|
|10926|1998-03-04|ANATR|1997-11-28|
|10365|1996-11-27|ANTON||
|10507|1997-04-15|ANTON|1996-11-27|
|10535|1997-05-13|ANTON|1997-04-15|
|10573|1997-06-19|ANTON|1997-05-13|
|10677|1997-09-22|ANTON|1997-06-19|
|10682|1997-09-25|ANTON|1997-09-22|
|10856|1998-01-28|ANTON|1997-09-25|
|10355|1996-11-15|AROUT||
|10383|1996-12-16|AROUT|1996-11-15|
|10453|1997-02-21|AROUT|1996-12-16|

- Obtener un listado de productos que contengan: id de producto, nombre del producto,
precio unitario, precio del producto anterior, diferencia entre el precio del producto y
precio del producto anterior.

```sql
select p.product_id , p.product_name , p.unit_price , lag(p.unit_price) over (order by p.product_id) as last_unit_price, (p.unit_price - lag(p.unit_price) over (order by p.product_id)) as price_difference
from products p
```

**Resultado:**

|product_id|product_name|unit_price|last_unit_price|price_difference|
|----------|------------|----------|---------------|----------------|
|1|Chai|18.0|||
|2|Chang|19.0|18.0|1.0|
|3|Aniseed Syrup|10.0|19.0|-9.0|
|4|Chef Anton's Cajun Seasoning|22.0|10.0|12.0|
|5|Chef Anton's Gumbo Mix|21.35|22.0|-0.6499996|
|6|Grandma's Boysenberry Spread|25.0|21.35|3.6499996|
|7|Uncle Bob's Organic Dried Pears|30.0|25.0|5.0|
|8|Northwoods Cranberry Sauce|40.0|30.0|10.0|
|9|Mishi Kobe Niku|97.0|40.0|57.0|
|10|Ikura|31.0|97.0|-66.0|
|11|Queso Cabrales|21.0|31.0|-10.0|
|12|Queso Manchego La Pastora|38.0|21.0|17.0|
|13|Konbu|6.0|38.0|-32.0|
|14|Tofu|23.25|6.0|17.25|
|15|Genen Shouyu|13.0|23.25|-10.25|
|16|Pavlova|17.45|13.0|4.450001|
|17|Alice Mutton|39.0|17.45|21.55|
|18|Carnarvon Tigers|62.5|39.0|23.5|
|19|Teatime Chocolate Biscuits|9.2|62.5|-53.3|
|20|Sir Rodney's Marmalade|81.0|9.2|71.8|
|21|Sir Rodney's Scones|10.0|81.0|-71.0|
|22|Gustaf's Knäckebröd|21.0|10.0|11.0|
|23|Tunnbröd|9.0|21.0|-12.0|

---

## LEAD

- Obtener un listado que muestra el precio de un producto junto con el precio del producto
siguiente:

```sql
select p.product_name , p.unit_price , lead (p.unit_price) over (order by p.product_id) as next_price
from products p
```

**Resultado:**

|product_name|unit_price|next_price|
|------------|----------|----------|
|Chai|18.0|19.0|
|Chang|19.0|10.0|
|Aniseed Syrup|10.0|22.0|
|Chef Anton's Cajun Seasoning|22.0|21.35|
|Chef Anton's Gumbo Mix|21.35|25.0|
|Grandma's Boysenberry Spread|25.0|30.0|
|Uncle Bob's Organic Dried Pears|30.0|40.0|
|Northwoods Cranberry Sauce|40.0|97.0|
|Mishi Kobe Niku|97.0|31.0|
|Ikura|31.0|21.0|
|Queso Cabrales|21.0|38.0|
|Queso Manchego La Pastora|38.0|6.0|
|Konbu|6.0|23.25|
|Tofu|23.25|13.0|
|Genen Shouyu|13.0|17.45|
|Pavlova|17.45|39.0|

- Obtener un listado que muestra el total de ventas por categoría de producto junto con el
total de ventas de la categoría siguiente

```sql
select c.category_name , sum(od.quantity * od.unit_price) as total_sales, lead(sum(od.quantity * od.unit_price)) over (order by c.category_name) as next_category_sales
from products p 
inner join categories c on p.category_id = c.category_id 
inner join order_details od on p.product_id = od.product_id 
group by c.category_name
```

**Resultado:**

|category_name|total_sales|next_category_sales|
|-------------|-----------|-------------------|
|Beverages|286526.95009565353|113694.74968147278|
|Condiments|113694.74968147278|177099.10060071945|
|Confections|177099.10060071945|251330.4997959137|
|Dairy Products|251330.4997959137|100726.7999253273|
|Grains/Cereals|100726.7999253273|178188.80098581314|
|Meat/Poultry|178188.80098581314|105268.6001739502|
|Produce|105268.6001739502|141623.08918237686|
|Seafood|141623.08918237686||
