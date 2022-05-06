SELECT
/** 
Creación:  
06-05-2022. Andrés Del Río. Lista las actividades relacionadas con una unidad técnica específica y con los agentes seleccionados
en el formulario de fiscalización regional de riesgos.
Versión: 2.1.7.129
Ambiente: https://sigse.sernapesca.cl/
Conjunto de datos: RIESGOS - Riesgos por Región y Unidad Técnica
        
Modificaciones: 
DD-MM-AAAA. Autor. Descripción.    
**/
        idmb.idmb,
        idmb.desconducta conducta,
        region.idregion id_region,
        region.region,
        unidad.idunidadtecnica id_unidad,
        unidad.unidadtecnica           
    FROM
        dynformidmb riesgo           
    LEFT JOIN
        dynformregion region                           
            ON region.OID = riesgo.OIDABCBKGY39WD8INV           
    LEFT JOIN
        dynformunidadtecni unidad                           
            ON unidad.OID = riesgo.OIDABC0KQ2JN6GG50X           
    LEFT JOIN
        dynidmb idmb                           
            ON idmb.OID = riesgo.OIDABCZD9V9SS81T3T           
    WHERE
        region.idregion = :paramIdRegion                   
        AND unidad.idunidadtecnica = :paramIdUnidad