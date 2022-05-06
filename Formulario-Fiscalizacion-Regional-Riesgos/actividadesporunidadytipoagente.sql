SELECT
/** 
Creación:  
06-05-2022. Andrés Del Río. Lista las actividades relacionadas con una unidad técnica específica y con los agentes seleccionados
en el formulario de fiscalización regional de riesgos.
Versión: 2.1.7.129
Ambiente: https://sigse.sernapesca.cl/
Conjunto de datos: ACTIVIDADES - Actividades por Unidad Técnica y Tipo de Agente
        
Modificaciones: 
DD-MM-AAAA. Autor. Descripción.    
**/
        actividad.actividad,
        agente.tipoagente 
    FROM
        dynactividad grid 
    LEFT JOIN
        dynformunidadtecni unidad 
            ON unidad.OID = grid.OIDABCBL5XGFOZBWV9 
    LEFT JOIN
        dynrfrunidadtecni2 agente 
            ON agente.OID = grid.OIDABCQWAXXA6CLB2B 
    LEFT JOIN
        dynactividadregist actividad 
            ON actividad.OID = grid.OIDABCFFNZTY2QPI6N 
    WHERE
        unidad.idunidadtecnica = :paramIdUnidad 
        AND agente.idtipoagen IN (
            SELECT
                GRIDAGEN.idtipoagen  
            FROM
                WFPROCESS WFP                                               
            JOIN
                GNASSOCFORMREG REG 
                    ON WFP.CDASSOCREG = REG.CDASSOC                                               
            JOIN
                DYNgridrfrppal GRIDFISC 
                    ON REG.OIDENTITYREG=GRIDFISC.OID  
            LEFT JOIN
                DYNgridanteagenfis GRIDAGEN 
                    ON GRIDFISC.OID = GRIDAGEN.OIDABC4JF1M27CLVIP 
            WHERE
                WFP.idprocess = :paramIdWorkflow 
        )