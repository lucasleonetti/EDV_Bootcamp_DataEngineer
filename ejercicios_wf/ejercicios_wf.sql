/* 
 Obtener el promedio de precios por cada categoría de producto.La cláusula OVER(PARTITION BY CategoryID) específica que se debe calcular el promedio de precios por cada valor único de CategoryID en la tabla.
 */
select c.category_name,
    p.product_name,
    p.unit_price,
    avg(p.unit_price) over (partition by c.category_id) as avg_price_bycategory
from products p
    inner join categories c on p.category_id = c.category_id
    /* 
     Obtener el promedio de venta de cada cliente
     */
select c.customer_id,
    c.contact_name,
    o.order_id,
    o.order_date,
    avg(od.quantity * p.unit_price) over (partition by c.customer_id) as avg_order_amount
from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join order_details od on o.order_id = od.order_id
    inner join products p on od.product_id = p.product_id
    /* 
     Obtener el promedio de cantidad de productos vendidos por categoría(
     product_name,
     quantity_per_unit,
     unit_price,
     quantity,
     avgquantity
     ) y ordenarlo por nombre de la categoría y nombre del producto
     */
select p.product_name,
    c.category_name,
    p.quantity_per_unit,
    p.unit_price,
    od.quantity,
    avg(od.quantity) over (partition by c.category_id) as avg_quantity
from products p
    inner join categories c on p.category_id = c.category_id
    inner join order_details od on p.product_id = od.product_id
order by c.category_name,
    p.product_name
    /* 
     Selecciona el ID del cliente,
     la fecha de la orden y la fecha más antigua de la orden para cada cliente de la tabla 'Orders'.
     */
select c.customer_id,
    o.order_date,
    min(o.order_date) over (partition by c.customer_id) as earliest_order_date
from customers c
    inner join orders o on c.customer_id = o.customer_id
    /* 
     Seleccione el id de producto,
     el nombre de producto,
     el precio unitario,
     el id de categoría y el precio unitario máximo para cada categoría de la tabla Products.
     */
select p.product_id,
    p.product_name,
    p.unit_price,
    p.category_id,
    max(p.unit_price) over (partition by p.category_id) as max_unit_price
from products p
    /* 
     Obtener el ranking de los productos más vendidos
     */
select p.product_name,
    sum(od.quantity) as total_quantity,
    row_number() over (
        order by sum(od.quantity) desc
    ) as rank
from products p
    inner join order_details od on p.product_id = od.product_id
group by p.product_name
order by rank
    /* 
     Asignar numeros de fila para cada cliente,
     ordenados por customer_id
     */
select row_number () over (
        order by c.customer_id
    ) as row_number,
    c.customer_id,
    c.company_name,
    c.contact_name,
    c.contact_title
from customers c
group by c.customer_id
order by row_number
    /* 
     Obtener el ranking de los empleados más jóvenes () ranking,
     nombre y apellido del empleado,
     fecha de nacimiento
     */
select row_number () over (
        order by min(e.birth_date) desc
    ) as ranking,
    e.first_name,
    e.last_name,
    e.birth_date
from employees e
group by e.employee_id
order by ranking
    /* 
     Obtener la suma de venta de cada cliente
     */
select sum(od.quantity * od.unit_price) over (
        order by c.customer_id
    ) as sum_order_amount,
    o.order_id,
    c.customer_id,
    o.employee_id,
    o.order_date,
    o.required_date
from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join order_details od on o.order_id = od.order_id
    /* 
     Obtener la suma total de ventas por categoría de producto
     */
select c.category_name,
    p.product_name,
    od.unit_price,
    od.quantity,
    SUM(od.quantity * od.unit_price) over (partition by c.category_name, p.product_name) as total_sales_by_category
FROM products p
    inner join categories c ON c.category_id = p.category_id
    inner join order_details od ON p.product_id = od.product_id
    /* 
     Calcular la suma total de gastos de envío por país de destino,
     luego ordenarlo por país y por orden de manera ascendente
     */
select c.country,
    o.order_id,
    o.shipped_date,
    o.freight,
    sum(o.freight) over (
        partition by c.country
        order by o.order_id
    ) as total_shipping_cost
from orders o
    inner join customers c on c.customer_id = o.customer_id
order by c.country asc,
    o.order_id asc
    /* 
     Ranking de ventas por cliente
     */
select c.customer_id,
    c.company_name,
    sum(od.quantity * od.unit_price) as total_sales,
    rank() over (
        order by sum(od.quantity * od.unit_price) desc
    ) as sales_rank
from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join order_details od on o.order_id = od.order_id
group by c.customer_id,
    c.company_name
order by sales_rank
    /* 
     Ranking de empleados por fecha de contratacion
     */
select e.employee_id,
    e.first_name,
    e.last_name,
    e.hire_date,
    rank() over (
        order by min(e.hire_date)
    ) as rank
from employees e
group by e.employee_id
order by rank
    /* 
     Ranking de productos por precio unitario
     */
select p.product_id,
    p.product_name,
    p.unit_price,
    rank() over (
        order by p.unit_price desc
    ) as rank
from products p
group by p.product_id
order by rank asc
    /* 
     Mostrar por cada producto de una orden,
     la cantidad vendida y la cantidad vendida del producto previo.
     */
select od.order_id,
    p.product_id,
    od.quantity,
    lag (od.quantity) over (
        order by od.order_id
    ) as prev_quantity
from products p
    inner join order_details od on p.product_id = od.product_id
order by od.order_id
    /* 
     Obtener un listado de ordenes mostrando el id de la orden,
     fecha de orden,
     id del cliente y última fecha de orden.
     */
select o.order_id,
    o.order_date,
    c.customer_id,
    lag(o.order_date) over (
        partition by c.customer_id
        order by o.order_id
    ) as last_order_date
from orders o
    inner join customers c on c.customer_id = o.customer_id
    /* 
     Obtener un listado de productos que contengan: id de producto,
     nombre del producto,
     precio unitario,
     precio del producto anterior,
     diferencia entre el precio del producto y precio del producto anterior.
     */
select p.product_id,
    p.product_name,
    p.unit_price,
    lag(p.unit_price) over (
        order by p.product_id
    ) as last_unit_price,
    (
        p.unit_price - lag(p.unit_price) over (
            order by p.product_id
        )
    ) as price_difference
from products p
    /* 
     Obtener un listado que muestra el precio de un producto junto con el precio del producto siguiente:
     */
select p.product_name,
    p.unit_price,
    lead (p.unit_price) over (
        order by p.product_id
    ) as next_price
from products p
    /* 
     Obtener un listado que muestra el total de ventas por categoría de producto junto con el total de ventas de la categoría siguiente
     */
select c.category_name,
    sum(od.quantity * od.unit_price) as total_sales,
    lead(sum(od.quantity * od.unit_price)) over (
        order by c.category_name
    ) as next_category_sales
from products p
    inner join categories c on p.category_id = c.category_id
    inner join order_details od on p.product_id = od.product_id
group by c.category_name