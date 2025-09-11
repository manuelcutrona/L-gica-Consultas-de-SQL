-- 1. Crea el esquema de la base de datos
-- (Este se entrega como imagen/diagrama, no como query)

-- 2. Muestra los nombres de todas las películas con una clasificación por
-- edades de ‘R’.

 SELECT F.title, F.rating
FROM film f 
WHERE F.rating = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
-- y 40.

SELECT CONCAT
(a.first_name, ' ', a.last_name), a.actor_id 
FROM actor a
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original

SELECT title, language_id, original_language_id
FROM film
WHERE language_id = original_language_id;

--5. Ordena las películas por duración de forma ascendente

SELECT f.title, f.length 
FROM film f 
ORDER BY f.length  ASC ;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
--apellido.

SELECT a.first_name , a.last_name 
FROM actor a 
WHERE a.last_name = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla
--“film” y muestra la clasificación junto con el recuento.

SELECT f.rating, COUNT(f.title) AS t
FROM film f
GROUP BY f.rating;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
--duración mayor a 3 horas en la tabla film.

SELECT f.title 
FROM film f 
WHERE f.rating = 'PG-13' OR f.length > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT VARIANCE(replacement_cost) AS COSTE
FROM film f;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD

SELECT MIN(f.length)min, MAX(f.length)max
FROM film f; 

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT amount AS a
FROM Payment AS P
ORDER BY P.payment_date DESC
LIMIT 1 OFFSET 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.

SELECT f.title
FROM film f 
WHERE f.rating NOT IN ('NC-17','G');

--13. Encuentra el promedio de duración de las películas para cada
--clasificación de la tabla film y muestra la clasificación junto con el
--promedio de duración.

SELECT f.rating , AVG(length)AS average
FROM film f 
GROUP  BY f.rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor
--a 180 minutos.

SELECT f.title 
FROM film f 
WHERE f.length > 180;

--15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(amount)AS total
FROM payment AS p;

--16. Muestra los 10 clientes con mayor valor de id.

SELECT CONCAT(first_name, ' ',last_name) AS customers,
c.customer_id 
FROM customer c 
ORDER BY c.customer_id DESC
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la
--película con título ‘Egg Igby’.

SELECT a.first_name , a.last_name 
FROM actor a  
INNER JOIN  film_actor fa
ON a.actor_id = fa.actor_id 
INNER JOIN film f 
ON fa.film_id  = f.film_id 
WHERE  f.title = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos

SELECT DISTINCT f.title 
FROM film f;

--19. Encuentra el título de las películas que son comedias y tienen una
--duración mayor a 180 minutos en la tabla “film”

SELECT   f.title
FROM film f
INNER JOIN  film_category fc
ON f.film_id = fc.film_id 
INNER JOIN category c 
ON fc.category_id = c.category_id 
WHERE  f.length > 180
AND c.name = 'Comedy'; 

--20. Encuentra las categorías de películas que tienen un promedio de
--duración superior a 110 minutos y muestra el nombre de la categoría
--junto con el promedio de duración.

SELECT c.name AS category_name, AVG(f.length) AS average_length
FROM   film f
INNER JOIn    film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
GROUP BY    c.name
HAVING AVG(f.length) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(return_date-r.rental_date ) AS media_duracion
FROM rental r;

--22. Crea una columna con el nombre y apellidos de todos los actores y
--actrices

SELECT CONCAT(first_name,' ',last_name) AS Actors
FROM actor;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de
--forma descendente.

SELECT
    DATE(r.rental_date) AS fecha_alquiler,
    COUNT(r.rental_date) AS cantidad
FROM
    rental r
GROUP BY
    DATE(r.rental_date) 
ORDER BY
    cantidad DESC;      

--24. Encuentra las películas con una duración superior al promedio.

SELECT f.title , f.length 
FROM film f 
WHERE f.length > (SELECT AVG(length) FROM film);

--25. Averigua el número de alquileres registrados por mes

SELECT 
 EXTRACT(YEAR FROM r.rental_date) AS year, --La función extract no figura en material
 EXTRACT(MONTH FROM r.rental_date) AS month,
 COUNT(*) AS cantidad
FROM rental r
GROUP BY year, month
ORDER BY cantidad DESC;

--26. Encuentra el promedio, la desviación estándar y varianza del total
--pagado.

SELECT 
    ROUND(AVG(amount), 2)      AS promedio,
    ROUND(STDDEV(amount), 2)   AS desviacion,
    ROUND(VARIANCE(amount), 2) AS varianza
FROM payment p;

--27. ¿Qué películas se alquilan por encima del precio medio?

SELECT DISTINCT  f.title AS titulo
FROM   film f
INNER JOIN  inventory i 
ON f.film_id = i.film_id 
INNER JOIN  rental r 
ON i.inventory_id = r.inventory_id 
INNER JOIN  payment p 
ON r.rental_id = p.rental_id 
WHERE   p.amount > (SELECT AVG(amount) FROM payment);

--28. Muestra el id de los actores que hayan participado en más de
-- 40 películas.

SELECT COUNT (fa.film_id) AS numero_peliculas, fa.actor_id 
FROM film_actor fa 
INNER JOIN film f 
ON fa.film_id = f.film_id 
GROUP BY fa.actor_id 
HAVING COUNT (f.film_id ) > 40; 

--29. Obtener todas las películas y, si están disponibles en el inventario,
--mostrar la cantidad disponible.

SELECT f.title AS titulos, COUNT(i.inventory_id) AS cantidad
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.title;

--30. Obtener los actores y el número de películas en las que ha actuado.

SELECT CONCAT(a.first_name,' ',a.last_name) AS nombre, COUNT (f.film_id ) AS numero_peliculas
FROM actor a 
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id 
INNER JOIN film f 
ON f.film_id = fa.film_id
GROUP BY nombre
ORDER BY numero_peliculas; 

--31. Obtener todas las películas y mostrar los actores que han actuado en
--ellas, incluso si algunas películas no tienen actores asociados.

SELECT f.title, CONCAT(a.first_name,' ',a.last_name) AS actores
FROM film f 
LEFT JOIN film_actor fa 
ON f.film_id = fa.film_id 
LEFT JOIN actor a 
ON fa.actor_id = a.actor_id 
ORDER BY f.title; 

 --32. Obtener todos los actores y mostrar las películas en las que han
--actuado, incluso si algunos actores no han actuado en ninguna película.
 
SELECT CONCAT(a.first_name,' ',a.last_name) AS actores,f.title 
FROM actor a 
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id 
LEFT JOIN film f 
ON fa.film_id = f.film_id 
ORDER BY actores;

--33. Obtener todas las películas que tenemos y todos los registros de
--alquiler.

SELECT f.title AS pelis, rental_id 
FROM film f 
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT CONCAT(c.first_name ,' ',c.last_name ) AS clientes, SUM(p.amount) AS gasto_total
FROM customer c 
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, clientes
ORDER BY gasto_total DESC
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'

SELECT CONCAT(a.first_name ,' ',a.last_name ) AS actor
FROM actor a 
WHERE a.first_name = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como
--Apellido.

SELECT a.first_name AS "Nombre", a.last_name AS "Apellido"
FROM actor a;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor

SELECT MAX(a.actor_id ), MIN(a.actor_id )
FROM actor a;

--38. Cuenta cuántos actores hay en la tabla “actor”

SELECT COUNT (DISTINCT actor_id)
FROM actor a;

--39. Selecciona todos los actores y ordénalos por apellido en orden
--ascendente.

SELECT CONCAT(a.first_name ,' ',a.last_name ) AS actor
FROM actor a 
ORDER BY actor ASC;

--40. Selecciona las primeras 5 películas de la tabla “film”.

SELECT f.title 
FROM film f 
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
--mismo nombre. ¿Cuál es el nombre más repetido?

SELECT COUNT(a.first_name) AS total, a.first_name 
FROM actor a 
GROUP BY a.first_name 
ORDER BY total  DESC;--Kenneth,Penelope,Julia

--42. Encuentra todos los alquileres y los nombres de los clientes que los
--realizaron.

SELECT r.rental_id AS alquiler, CONCAT(c.first_name,' ',c.last_name) AS cliente
FROM rental r 
INNER JOIN customer c 
ON r.customer_id = c.customer_id 

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo
--aquellos que no tienen alquileres.

SELECT CONCAT(c.first_name,' ',c.last_name) AS cliente, r.rental_id AS alquiler
FROM customer c
LEFT JOIN rental r 
ON c.customer_id = r.customer_id 

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
--esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT f.title, c.name 
FROM film f
CROSS JOIN category c --No, porque mas alla de multiplicar por 16 los resultados de cada valor, no se encuentra ningun sentido util de la operacion.

--45. Encuentra los actores que han participado en películas de la categoría
--'Action'.

SELECT 
 CONCAT(a.first_name, ' ', a.last_name) AS nombre
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film_category fc
ON fa.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

--46. Encuentra todos los actores que no han participado en películas

SELECT CONCAT(a.first_name,' ',a.last_name) AS nombre
FROM actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las
--que han participado.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_pelis
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
--de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_pelis
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;

--49. Calcula el número total de alquileres realizados por cada cliente.

SELECT CONCAT (c.first_name,' ', c.last_name) AS nombre, COUNT (r.rental_id ) AS total_alquilado
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
GROUP BY r.customer_id, nombre 

--50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT SUM(f.length) AS suma 
FROM film f
INNER JOIN  film_category fc 
ON f.film_id = fc.film_id 
INNER JOIN category c
ON fc.category_id = c.category_id 
WHERE c.name = 'Action'

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
--almacenar el total de alquileres por cliente.

CREATE TEMPORARY TABLE  cliente_rentas_temporal AS
SELECT COUNT (r.rental_id) AS alquiler, CONCAT(c.first_name,' ',c.last_name) AS cliente
FROM rental r 
INNER JOIN customer c 
ON r.customer_id = c.customer_id 
GROUP BY cliente;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
--películas que han sido alquiladas al menos 10 veces

CREATE TEMPORARY TABLE  peliculas_alquiladas AS
SELECT f.title AS titulo, COUNT(r.rental_id) AS veces_alquilada
FROM film f 
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id 
GROUP BY titulo
HAVING COUNT (r.rental_id) > 10

--53. Encuentra el título de las películas que han sido alquiladas por el cliente
--con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
--los resultados alfabéticamente por título de película.

SELECT f.title 
FROM film f 
INNER JOIN  inventory i 
ON f.film_id = i.film_id 
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
INNER JOIN customer c 
ON r.customer_id = c.customer_id
WHERE r.return_date IS NULL AND  c.first_name = 'TAMMY' AND  c.last_name = 'SANDERS'
ORDER BY f.title DESC; 

--54. Encuentra los nombres de los actores que han actuado en al menos una
--película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
--alfabéticamente por apellido.

SELECT DISTINCT a.first_name ,a.last_name 
FROM actor a 
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id 
INNER JOIN film_category fc 
ON f.film_id = fc.film_id 
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name 

--55. Encuentra el nombre y apellido de los actores que han actuado en
--películas que se alquilaron después de que la película ‘Spartacus
--Cheaper’ se alquilara por primera vez. Ordena los resultados
--alfabéticamente por apellido.

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa 
  ON a.actor_id = fa.actor_id
INNER JOIN film f 
  ON fa.film_id = f.film_id
INNER JOIN inventory i 
  ON f.film_id = i.film_id
INNER JOIN rental r 
  ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    INNER JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    INNER JOIN film f2 ON i2.film_id = f2.film_id
    WHERE UPPER(f2.title) = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name;

--56. Encuentra el nombre y apellido de los actores que no han actuado en
--ninguna película de la categoría ‘Music’.

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f ON fa.film_id = f.film_id
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

--57. Encuentra el título de todas las películas que fueron alquiladas por más
--de 8 días.

WITH duraciones AS (
    SELECT i.film_id
    FROM rental r
    INNER JOIN inventory i 
      ON r.inventory_id = i.inventory_id 
    WHERE EXTRACT(DAY FROM (r.return_date - r.rental_date)) > 8
)
SELECT DISTINCT f.title AS titulo
FROM film f 
INNER JOIN duraciones d ON f.film_id = d.film_id;


--58. Encuentra el título de todas las películas que son de la misma categoría
--que ‘Animation’.

SELECT f.title 
FROM film f 
INNER JOIN film_category fc 
ON f.film_id = fc.film_id 
INNER JOIN category c 
ON fc.category_id = c.category_id 
WHERE c.name = 'Animation'

--59. Encuentra los nombres de las películas que tienen la misma duración
--que la película con el título ‘Dancing Fever’. Ordena los resultados
--alfabéticamente por título de película.

SELECT title AS titulo_pelicula
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title ASC;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7
--películas distintas. Ordena los resultados alfabéticamente por apellido

SELECT c.first_name AS nombre, c.last_name AS apellido
FROM customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id 
GROUP BY nombre ,apellido 
HAVING COUNT(DISTINCT i.film_id ) >= 7
ORDER BY apellido ASC;

--61. Encuentra la cantidad total de películas alquiladas por categoría y
--muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name AS categoria, COUNT(r.rental_id) AS recuento
FROM category c 
INNER JOIN film_category fc 
ON c.category_id = fc.category_id 
INNER JOIN film f 
ON fc.film_id = f.film_id
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id  
GROUP BY c.name 

--62. Encuentra el número de películas por categoría estrenadas en 2006

SELECT c."name" AS categoria, COUNT(f.film_id) AS films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year = 2006 
GROUP BY c."name"
ORDER BY c."name";

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
--que tenemos

SELECT CONCAT(s.first_name,' ',s.last_name) AS empleado, s2.store_id 
FROM staff s 
CROSS JOIN store s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.

SELECT c.customer_id AS id, CONCAT(c.first_name,' ',c.last_name ) AS nombre, COUNT(r.rental_id ) AS alquileres
FROM customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id
INNER JOIN payment p 
ON r.rental_id = p.rental_id 
GROUP BY id, nombre 
ORDER BY id;
