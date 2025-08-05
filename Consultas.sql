--Cantidad Fabricados a la semana por Fabricante 
select 
nombre_fabricante,
count(*) as cantidad
from dou_tabla_final_tiempos
where state ='done' and tipo_producto <> 'log' and nombre_fabricante <> 'Juan Manuel Montoya Quiceno' and terminado_semana = true
group by 1
order by 2 desc 

--Cantidad Fabricados al Mes por Fabricante
select 
nombre_fabricante,
count(*) as cantidad
from dou_tabla_final_tiempos
where state ='done' and tipo_producto <> 'log' and nombre_fabricante <> 'Juan Manuel Montoya Quiceno' and  mes_fin = {{mes}}
group by 1
order by 2 desc 

--Cantidad Total Productos al Semana
Select count(*)
from dou_tabla_final_tiempos
where state = 'done' and tipo_producto <> 'log' and nombre_fabricante <> 'Juan Manuel Montoya Quiceno' and terminado_semana = true


--Producción historica por tipo
Select 
mes_fin,
count(*)
from dou_tabla_final_tiempos
where tipo_producto <> 'log' and  nombre_fabricante <> 'Juan Manuel Montoya Quiceno' and state = 'done'
group by 1
order by 2

--Tipo de producto a la semana
select 
tipo_producto,
count(*) as cantidad
from dou_tabla_final_tiempos
where state ='done' and tipo_producto <> 'log' and  terminado_semana = true and nombre_fabricante <> 'Juan Manuel Montoya Quiceno'
group by 1
order by 2 desc 

--Tipo de Producto al Mes
select 
tipo_producto,
count(*) as cantidad
from dou_tabla_final_tiempos
where state ='done' and tipo_producto <> 'log' and nombre_fabricante <> 'Juan Manuel Montoya Quiceno' and  mes_fin = {{mes}}
group by 1
order by 2 desc 
