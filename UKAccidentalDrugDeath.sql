----adding the unique id column
ALTER TABLE AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
	ADD ID INT identity(1,1)
  
 -- total number of deaths due to drug-related incidents
 SELECT
    COUNT(*) AS totaldrugdeaths
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021 

 
 --average age of those dead from these cases reported
 SELECT AVG(age) AS AverageAge
  FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021 


 --age brackets most affected
 SELECT 
    Age_Brackets,
	COUNT(*) AS AgeBracketCount,
	CONCAT(CEILING(COUNT(*) * 100.0 / (SELECT COUNT (*) 
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021)), '%') AS PERCENTAGE
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
WHERE Age_Brackets IS NOT NULL
GROUP BY Age_Brackets
 ORDER BY 2 DESC


  -- percentage of deaths per race
SELECT race,
	COUNT(*) AS deathcount,
	CONCAT(CEILING(COUNT(*) * 100.0 / (SELECT COUNT (*) 
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021)), '%') AS PERCENTAGE
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
GROUP BY race
ORDER BY 2 DESC
  

 --distribution of deaths across different years
 SELECT
     YEAR(date) AS Year,
	 COUNT(*) AS deathcount
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
GROUP BY YEAR(date)
ORDER BY 2

--distribution of deaths by month
SELECT  
    MONTH(date) AS Month,
	COUNT(*) AS  deathcount
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
GROUP BY MONTH(date)
ORDER BY 2 DESC

---	 proportion of male to female deaths in percentages
SELECT 
	 sex,
	COUNT(*) AS deathcount,
	CONCAT(CEILING(COUNT(*) * 100.0 / (SELECT COUNT (*) 
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021)), '%') AS PERCENTAGE
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
GROUP BY sex
 


--	distribution of deaths by city
select Death_City, DeathCityGeo, count(*) as deathcount
from AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
group by Death_City, DeathCityGeo
ORDER BY 3 DESC


--  top 5 drugs involved in reported deaths
SELECT 
	TOP 5 DrugName, 
	COUNT(*) AS deathcount
FROM
(
SELECT
	CASE
		WHEN Cocaine = 'Y' THEN 'Cocaine'
		WHEN Fentanyl = 'Y' THEN 'Fentanyl'
		WHEN Fentanyl_Analogue = 'Y' THEN 'Fentanyl_Analogue'
		WHEN Oxycodone ='Y' THEN  'Oxycodone'
        WHEN Oxymorphone = 'Y' THEN 'Oxymorphone'
		WHEN Ethanol = 'Y' THEN 'Ethanol'
		WHEN Hydrocodone = 'Y' THEN 'Hydrocodone'
		WHEN Benzodiazepine = 'Y' THEN 'Benzodiazepine'
		WHEN Methadone = 'Y' THEN 'Methadone'
		WHEN Meth_Amphetamine = 'Y' THEN 'Meth_Amphetamine'
		WHEN Amphet = 'Y' THEN 'Amphet'
		WHEN Tramad = 'Y' THEN 'Tramad'
		WHEN Hydromorphone = 'Y' THEN 'Hydromorphone'
		WHEN Morphine_Not_Heroin = 'Y' THEN 'Morphine_Not_Heroin'
		WHEN Xylazine = 'Y' THEN 'Xylazine'
		WHEN Gabapentin = 'Y' THEN 'Gabapentin'
		WHEN Opiate_NOS = 'Y' THEN 'Opiate_NOS'
		WHEN Heroin_Morph_Codeine = 'Y' THEN 'Heroin_Morph_Codeine'
		WHEN Other_Opioid = 'Y' THEN  'Other_Opioid'
		WHEN Any_Opioid = 'Y' THEN  'Any_Opioid'
		ELSE NULL
END AS DrugName
FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021)
AS DrugCount
WHERE DrugName IS NOT NULL
GROUP  BY DrugName
ORDER BY deathcount DESC



--Drug combinations with highest death count
SELECT TOP 5
	  SUBSTRING(drug_combination, 1, LEN(drug_combination) - 1) AS drug_combination,
      COUNT(*) AS death_count
FROM (
  SELECT
    (
      SELECT 
       CASE WHEN Heroin ='Y' THEN  'Heroin,' ELSE '' END +
		CASE WHEN Cocaine = 'Y' THEN 'Cocaine, ' ELSE '' END +
		CASE WHEN Fentanyl = 'Y' THEN 'Fentanyl,' ELSE '' END +
		CASE WHEN Fentanyl_Analogue = 'Y' then 'Fentanyl_Analogue,' ELSE '' END +
		CASE WHEN Oxycodone ='Y' THEN  'Oxycodone,' ELSE '' END +
		CASE WHEN Oxymorphone = 'Y' THEN 'Oxymorphone,' ELSE '' END +
		CASE WHEN Ethanol = 'Y' THEN 'Ethanol,' ELSE '' END +
		CASE WHEN Hydrocodone = 'Y' THEN 'Hydrocodone,' ELSE '' END +
		CASE WHEN Benzodiazepine = 'Y' THEN 'Benzodiazepine, ' ELSE '' END +
		CASE WHEN Methadone = 'Y' THEN 'Methadone, ' ELSE '' END +
		CASE WHEN Meth_Amphetamine = 'Y' THEN 'Meth_Amphetamine,' ELSE '' END + 
		CASE WHEN Amphet = 'Y' THEN 'Amphet, ' ELSE '' END +
		CASE WHEN Tramad = 'Y' THEN 'Tramad, ' ELSE '' END +
		CASE WHEN Hydromorphone = 'Y' THEN 'Hydromorphone,' ELSE ''END +
		CASE WHEN Morphine_Not_Heroin = 'Y' THEN 'Morphine_Not_Heroin,' ELSE '' END +
		CASE WHEN Xylazine = 'Y' THEN 'Xylazine, ' ELSE '' END +
		CASE WHEN Gabapentin = 'Y' THEN 'Gabapentin, ' ELSE '' END +
		CASE WHEN Opiate_NOS = 'Y' THEN 'Opiate_NOS, ' ELSE '' END +
		CASE WHEN Heroin_Morph_Codeine = 'Y' THEN 'Heroin_Morph_Codeine,' ELSE '' END +
		CASE WHEN Other_Opioid = 'Y' THEN  'Other_Opioid, ' ELSE '' END +
		CASE WHEN Any_Opioid = 'Y' THEN  'Any_Opioid, ' ELSE '' END +
		''     
      FOR XML PATH('')
    ) AS drug_combination
 FROM AccidentalDrugDeaths.dbo.DrugDeaths2012_2021
) AS drug_count
WHERE drug_combination <> ''
GROUP BY drug_combination
ORDER BY death_count DESC;

	
