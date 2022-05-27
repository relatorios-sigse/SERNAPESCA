SELECT
        /**  
		Creación:   27-05-2022. Andrés Del Río. Muestra los resultados de las instancias Reporte de Fiscalización Nacional 
		Versión: 2.1.7.129 
		Ambiente: https://sigse.sernapesca.cl/ 
		Panel de análisis: REPRFR - Reporte Registro de Fiscalización Regional (RFR)          
		
		Modificaciones:  
		DD-MM-AAAA. Autor. Descripción.     
		**/         
		WFP.IDPROCESS,
        WFP.NMPROCESS,
        CASE                      
            WHEN WFP.FGCONCLUDEDSTATUS IS NOT NULL THEN (CASE                          
                WHEN WFP.FGCONCLUDEDSTATUS=1 THEN '#{100900}'                          
                WHEN WFP.FGCONCLUDEDSTATUS=2 THEN '#{100899}'                      
            END)                      
            ELSE (CASE                          
                WHEN (( WFP.DTESTIMATEDFINISH > (DATEADD(DAY,
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
                OR (WFP.DTESTIMATEDFINISH IS NULL)) THEN '#{100900}'                          
                WHEN (( WFP.DTESTIMATEDFINISH=CAST( dateadd(dd,
                datediff(dd,
                0,
                getDate()),
                0) AS DATETIME)                          
                AND WFP.NRTIMEESTFINISH >= (datepart(minute,
                getdate()) + datepart(hour,
                getdate()) * 60))                          
                OR (WFP.DTESTIMATEDFINISH > CAST( dateadd(dd,
                datediff(dd,
                0,
                getDate()),
                0) AS DATETIME))) THEN '#{201639}'                          
                ELSE '#{100899}'                      
            END)                  
        END AS NMDEADLINE,
        CASE WFP.FGSTATUS                      
            WHEN 1 THEN '#{103131}'                      
            WHEN 2 THEN '#{107788}'                      
            WHEN 3 THEN '#{104230}'                      
            WHEN 4 THEN '#{100667}'                      
            WHEN 5 THEN '#{200712}'                  
        END AS IDSITUATION,
        CONVERT(DATETIME,
        WFP.DTSTART + ' ' + WFP.TMSTART,
        120) AS DTSTART,
        CONVERT(DATETIME,
        WFP.DTFINISH + ' ' + WFP.TMFINISH,
        120) AS DTFINISH,
        WFP.IDREVISION,
        WFP.NMPROCESSMODEL,
        WFP.NMUSERSTART,
        RFR.nreg AS Id_Actividad,
        RFR.fechareg AS Fecha,
        RFR.horareg AS Hora,
        REGION.region  AS Region_responsable_Actividad,
        OFICINA.oficina AS Oficina_Responsable,
        UNIDTECN.unidadtecnica  AS Unidad_tecnica_Responsable,
        RFR.fechaactividad AS Fecha_Actividad,
        CASE                                        
            WHEN RFR.chkdocumental = 1 THEN 'Documental'                                        
            ELSE ''                            
        END AS Tipo_Actividad_Documental,
        CASE                                        
            WHEN RFR.chkremotodiferi = 1 THEN 'Remoto en Tiempo Diferido'                                        
            ELSE ''                            
        END AS Tipo_Actividad_Remoto_Tiempo_Diferido,
        CASE                                        
            WHEN RFR.chkremotiempore = 1 THEN 'Remoto en Tiempo Real'                                        
            ELSE ''                            
        END AS Tipo_Actividad_Remoto_Tiempo_Real,
        CASE                                        
            WHEN RFR.chkterreno = 1 THEN 'Terreno'                                        
            ELSE ''                            
        END AS Tipo_Actividad_Terreno,
        EQUIPO.nmuser AS Nombre_Funcionario,
        COMETIDO.tipocometido AS Tipo_Cometido,
        EQUIPO.fechacometido AS Fecha_Cometido,
        EQUIPO.numcometido AS No_Cometido,
        RIESGO.idenid AS Id_MB,
        RIESGO.descconducta AS Descripcion_Conducta,
        RIESGO.detaconducta AS Detalle_Conducta,
        TIPOAGEN.tipoagente AS Tipo_Agente,
        AGENTE.codagentenum AS Cod_Agente_Numerico,
        AGENTE.codagentealfa AS Cod_Agente_Alfanumerico,
        AGENTE.nombreagente AS Nombre_Agente,
        HALLAZGO.hallazgo AS Hallazgo,
        LINEA.lineadeelaborac AS Linea_Elaboracion,
        ESPECIE.especierfr AS Especie,
        DETAHALL.cantidad AS Cantidad_Ton,
        ACTIVIDAD.actividad AS Actividad,
        TIPOMEVE.medioverificaci AS Tipo_Medio_Verificacion,
        MEDIVERI.mediotipo AS Medio_Verificacion_Folio,
        MEDIVERI.antecedentesmed AS Antecedentes_Referencia_Medio_Verificacion,
        RFR.obsgral AS Observacion_General,
        1 CANTIDAD       
    FROM
        WFPROCESS WFP                                                                               
    LEFT JOIN
        GNASSOCFORMREG REG                                                                                                                                                               
            ON WFP.CDASSOCREG = REG.CDASSOC                                                                               
    LEFT JOIN
        DYNgridrfrppal RFR                                                                                                                                                               
            ON REG.OIDENTITYREG=RFR.OID                           
    LEFT JOIN
        DYNformregion REGION                                                          
            ON REGION.OID = RFR.OIDABCAW9UQJ6RX1W4                        
    LEFT JOIN
        DYNoficina OFICINA                                                          
            ON OFICINA.OID = RFR.OIDABCFAL508L0OEHM                        
    LEFT JOIN
        DYNformunidadtecni UNIDTECN                                                          
            ON UNIDTECN.OID = RFR.OIDABCVGEWMOXIYCQV                 
    LEFT JOIN
        DYNgridequipofisca EQUIPO                                           
            ON EQUIPO.OIDABC5KW6QXTUB9G3 = RFR.OID                 
    LEFT JOIN
        DYNtipocometido COMETIDO                                           
            ON COMETIDO.OID = EQUIPO.OIDABC48RAY59NB9VG                 
    LEFT JOIN
        DYNgridanteriesgo RIESGO                                           
            ON RIESGO.OIDABCJ6KPCC5TIMPR = RFR.OID                 
    LEFT JOIN
        DYNgridanteagenfis AGENTE                                           
            ON AGENTE.OIDABC4JF1M27CLVIP = RFR.OID                 
    LEFT JOIN
        DYNrfrunidadtecni2 TIPOAGEN                                           
            ON TIPOAGEN.OID = AGENTE.OIDABC55YQ8PX8VRN3                 
    LEFT JOIN
        DYNhallazgo HALLAZGO                                           
            ON HALLAZGO.OID = AGENTE.OIDABCQLNF6TAJVS5O       
    LEFT JOIN
        DYNgridhallazgos DETAHALL             
            ON DETAHALL.OIDABC9F8560JX99HO = AGENTE.OID     
    LEFT JOIN
        DYNlineadeelaborac LINEA             
            ON LINEA.OID = DETAHALL.OIDABC7T81LA1R2KYW     
    LEFT JOIN
        DYNespecierfr ESPECIE             
            ON ESPECIE.OID = DETAHALL.OIDABCJ3EDHSE1N260              
    LEFT JOIN
        DYNgridantedelacti ACTIVIDAD                              
            ON ACTIVIDAD.OIDABCTP1HNCPBP7XV = RFR.OID            
    LEFT JOIN
        DYNgridmediosverif MEDIVERI                              
            ON MEDIVERI.OIDABCMAWZ8NEY6BX1 = RFR.OID            
    LEFT JOIN
        DYNmedioverificaci TIPOMEVE                              
            ON TIPOMEVE.OID = MEDIVERI.OIDABC3UYTQBOGZC40            
    WHERE
        WFP.FGSTATUS <= 5        
		AND WFP.CDPROCESSMODEL = 2163