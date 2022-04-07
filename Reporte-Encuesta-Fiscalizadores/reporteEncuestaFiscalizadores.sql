SELECT
/** 
Creación:  
06-04-2022. Andrés Del Río. Muestra los resultados de encuestas de fiscalizadores
Versión: 2.1.6.112
Ambiente: https://sigse.sernapesca.cl/
Panel de análisis: REPENCFIS - Reporte de Encuestas Fiscalizadores
        
Modificaciones: 
DD-MM-AAAA. Autor. Descripción.    
**/
        ENC.IDPROCESS ID_ENCUESTA,
        ENC.NMPROCESS TITULO_ENCUESTA,
        ENC.NMPROCESSMODEL NOMBRE_PROCESO,
        ENC.IDPROCESSTYPE TIPO_PROCESO,
        ENC.IDREVISION ID_REVISION_PROCESO,
        ENC.NMUSERSTART INICIADOR,
        CASE ENC.FGSTATUS                      
            WHEN 1 THEN '#{103131}'                      
            WHEN 2 THEN '#{107788}'                      
            WHEN 3 THEN '#{104230}'                      
            WHEN 4 THEN '#{100667}'                      
            WHEN 5 THEN '#{200712}'          
        END AS SITUACION,
        CASE                      
            WHEN ENC.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE                          
                WHEN ENC.FGCONCLUDEDSTATUS=1 THEN '#{100900}'                          
                WHEN ENC.FGCONCLUDEDSTATUS=2 THEN '#{100899}'                      
            END)                      
            ELSE (CASE                          
                WHEN (( ENC.DTESTIMATEDFINISH > (DATEADD(DAY,
                COALESCE((SELECT
                    QTDAYS                          
                FROM
                    ADMAILTASKEXEC                          
                WHERE
                    CDMAILTASKEXEC=(SELECT
                        TASK.CDAHEAD                              
                    FROM
                        ADMAILTASKREL TASK                              
                    WHERE
                        TASK.CDMAILTASKREL=(SELECT
                            TBL.CDMAILTASKSETTINGS                                  
                        FROM
                            CONOTIFICATION TBL))), 0), CAST(<!%TODAY%> AS DATETIME))))                          
                OR (ENC.DTESTIMATEDFINISH IS NULL)) THEN '#{100900}'                          
                WHEN (( ENC.DTESTIMATEDFINISH=CAST( dateadd(dd,
                datediff(dd,
                0,
                getDate()),
                0) AS DATETIME)                          
                AND ENC.NRTIMEESTFINISH >= (datepart(minute,
                getdate()) + datepart(hour,
                getdate()) * 60))                          
                OR (ENC.DTESTIMATEDFINISH > CAST( dateadd(dd,
                datediff(dd,
                0,
                getDate()),
                0) AS DATETIME))) THEN '#{201639}'                          
                ELSE '#{100899}'                      
            END)                  
        END AS PLAZO,
        CONVERT(DATETIME,
        ENC.DTSTART + ' ' + ENC.TMSTART,
        120) AS DTSTART,
        CONVERT(DATETIME,
        ENC.DTFINISH + ' ' + ENC.TMFINISH,
        120) AS DTFINISH,
        REGION.REGION,
        GRIDENC.IDACTIVIDAD PRESENCIA_TERRENO_COMETIDO,
        GRIDENC.FECHA,
        TIPOACT.TIPOACTIVIDAD TIPO_ACTIVIDAD,
        GRIDENC.NFUNCIONARIOS NUMERO_FUNCIONARIOS,
        GRIDENC.TOTALFISCALIZ TOTAL_FISCALIZADOS,
        CASE 
            WHEN GRIDENC.OTRASINSTITUCIO = 1 THEN 'SI' 
            WHEN GRIDENC.OTRASINSTITUCIO = 2 THEN 'NO' 
        END OTRAS_INSTITUCIONES,
        CASE 
            WHEN GRIDENC.CARABINEROS = 1 THEN 'SI' 
            ELSE 'NO' 
        END CARABINEROS,
        CASE 
            WHEN GRIDENC.ARMADA = 1 THEN 'SI' 
            ELSE 'NO' 
        END ARMADA,
        CASE 
            WHEN GRIDENC.SERVICIODESALUD = 1 THEN 'SI' 
            ELSE 'NO' 
        END SERVICIO_SALUD,
        CASE 
            WHEN GRIDENC.SERVICIOMEDIOAM = 1 THEN 'SI' 
            ELSE 'NO' 
        END SERVICIO_MEDIOAMBIENTAL,
        CASE 
            WHEN GRIDENC.OTRO = 1 THEN 'SI' 
            ELSE 'NO' 
        END OTRA_INSTITUCION,
		
		CASE 
            WHEN GRIDENC.HALLAZGOS = 1 THEN 'SI'  
            WHEN GRIDENC.HALLAZGOS = 2 THEN 'NO'  
        END HALLAZGOS,
		
        CASE 
            WHEN GRIDINCA.INCAUTACION = 1 THEN 'SI'  
            WHEN GRIDINCA.INCAUTACION = 2 THEN 'NO'  
        END INCAUTACION,
        ESPECIE.ESPECIE,
        GRIDINCA.ESPECIE OTRA_ESPECIE,
        GRIDINCA.CANTIDAD CANTIDAD_ESPECIE,
        CASE 
            WHEN GRIDINCA.INFRACTOR = 1 THEN 'SI' 
            WHEN GRIDINCA.INFRACTOR = 2 THEN 'NO' 
        END INFRACTOR_TIENE_ESPECIE,
        CASE 
            WHEN GRIDVEHI.VEHICULO = 1 THEN 'SI'  
            WHEN GRIDVEHI.VEHICULO = 2 THEN 'NO'  
        END VEHICULO_INCAUTADO,
        TIPOVEHI.VEHICULO TIPO_VEHICULO,
        GRIDVEHI.PATENTE,
        CASE 
            WHEN GRIDVEHI.PATE = 1 THEN 'SI' 
            WHEN GRIDVEHI.PATE = 2 THEN 'NO' 
        END INFRACTOR_TIENE_PATENTE,
        1 CANTIDAD                                                   
    FROM
        WFPROCESS ENC                                                                     
    JOIN
        GNASSOCFORMREG REG                                                                                                                                     
            ON ENC.CDASSOCREG = REG.CDASSOC                                                                     
    JOIN
        DYNENC FORMENC                           
            ON REG.OIDENTITYREG=FORMENC.OID                   
    LEFT JOIN
        DYNGRIDENC GRIDENC              
            ON GRIDENC.OIDABCG92P6TRVWZ09 = FORMENC.OID  
    LEFT JOIN
        DYNFORMREGION REGION    
            ON REGION.OID = GRIDENC.OIDABCIF5T4IG3738F  
    LEFT JOIN
        DYNFORMTIPOACTIVID TIPOACT    
            ON TIPOACT.OID = GRIDENC.OIDABC3OKBQSZGOLYR      
    LEFT JOIN
        DYNGRIDINCA GRIDINCA    
            ON GRIDINCA.OIDABCEKFHAFNNAQM9 = GRIDENC.OID      
    LEFT JOIN
        DYNFORMESPECIE ESPECIE    
            ON ESPECIE.OID = GRIDINCA.OIDABC9IO7306SPPT1      
    LEFT JOIN
        DYNGRIDVEHI GRIDVEHI    
            ON GRIDVEHI.OIDABC09LB1O9DIC76 = GRIDENC.OID      
    LEFT JOIN
        DYNFORMTIPOVEHICUL TIPOVEHI    
            ON TIPOVEHI.OID = GRIDVEHI.OIDABCY0L6NP1E9IQD
	WHERE
		ENC.FGSTATUS <= 5