SELECT * FROM [dbo].[NATIONALHOUSING]

--STANDARDIZE THE FORMAT
SELECT [SaleDate],CONVERT(DATE,[SaleDate]) 
FROM [dbo].[NATIONALHOUSING]

UPDATE [dbo].[NATIONALHOUSING] SET [SaleDate]=CONVERT(DATE,[SaleDate])

ALTER TABLE [dbo].[NATIONALHOUSING] ADD SaleDate2 DATE

UPDATE [dbo].[NATIONALHOUSING] SET [SaleDate2]=CONVERT(DATE,[SaleDate])



--POPULATE THE PROPERTY ADDRESS
SELECT [PropertyAddress] FROM [dbo].[NATIONALHOUSING]
WHERE [PropertyAddress] IS NULL


SELECT * FROM [dbo].[NATIONALHOUSING]
--WHERE [PropertyAddress] IS NULL
ORDER BY [ParcelID]


SELECT A.[ParcelID],A.[PropertyAddress],B.[ParcelID] ,B.[PropertyAddress],ISNULL(A.[PropertyAddress],B.[PropertyAddress])
FROM [dbo].[NATIONALHOUSING] A
JOIN [dbo].[NATIONALHOUSING] B
ON A.[ParcelID]=B.[ParcelID]
AND A.[UniqueID ]!=B.[UniqueID ]
WHERE A.[PropertyAddress] IS NULL


UPDATE A
SET [PropertyAddress]=ISNULL(A.[PropertyAddress],B.[PropertyAddress])
FROM [dbo].[NATIONALHOUSING] A
JOIN [dbo].[NATIONALHOUSING] B
ON A.[ParcelID]=B.[ParcelID]
AND A.[UniqueID ]!=B.[UniqueID ]
WHERE A.[PropertyAddress] IS NULL


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS,CITY,STATE)

SELECT [PropertyAddress] FROM [dbo].[NATIONALHOUSING]

SELECT SUBSTRING([PropertyAddress],1,CHARINDEX(',',[PropertyAddress])-1)AS ADDRESS,
SUBSTRING([PropertyAddress],CHARINDEX(',',[PropertyAddress])+1,LEN([PropertyAddress]))
FROM [dbo].[NATIONALHOUSING]

--ADD A CLOUMN PROPERTYSPLITADDRESS AND UPDATE

ALTER TABLE [dbo].[NATIONALHOUSING] ADD PROPERTYSPLITADDRESS NVARCHAR(255)
UPDATE [dbo].[NATIONALHOUSING] SET PROPERTYSPLITADDRESS=SUBSTRING([PropertyAddress],1,CHARINDEX(',',[PropertyAddress])-1)

--ADD A COLUMN PROPERTYSPLITCITY AND UPDATE IT

ALTER TABLE [dbo].[NATIONALHOUSING] ADD PROPERTYSPLITCITY NVARCHAR(255)

UPDATE [dbo].[NATIONALHOUSING] SET PROPERTYSPLITCITY=SUBSTRING([PropertyAddress],CHARINDEX(',',[PropertyAddress])+1,LEN([PropertyAddress]))


SELECT * FROM [dbo].[NATIONALHOUSING]

--owner address
select [OwnerAddress] from [dbo].[NATIONALHOUSING]

select
parsename([OwnerAddress],1) from [dbo].[NATIONALHOUSING]



select
parsename(replace([OwnerAddress],',','.'),1) ,
parsename(replace([OwnerAddress],',','.'),2) ,
parsename(replace([OwnerAddress],',','.'),3) 
from [dbo].[NATIONALHOUSING]


select
parsename(replace([OwnerAddress],',','.'),3) ,
parsename(replace([OwnerAddress],',','.'),2) ,
parsename(replace([OwnerAddress],',','.'),1) 
from [dbo].[NATIONALHOUSING]

--oweners streetname

ALTER TABLE [dbo].[NATIONALHOUSING] ADD owenersstreetname NVARCHAR(255)

UPDATE [dbo].[NATIONALHOUSING] SET owenersstreetname=parsename(replace([OwnerAddress],',','.'),3)

--oweners city name

ALTER TABLE [dbo].[NATIONALHOUSING] ADD owenerscityname NVARCHAR(255)

UPDATE [dbo].[NATIONALHOUSING] SET owenerscityname=parsename(replace([OwnerAddress],',','.'),2)

--owerers state name

ALTER TABLE [dbo].[NATIONALHOUSING] ADD owenersstatename NVARCHAR(255)

UPDATE [dbo].[NATIONALHOUSING] SET owenersstatename=parsename(replace([OwnerAddress],',','.'),1)

-------------------------------------------------------------------------------------------------------------------
--change Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD

SELECT * FROM [dbo].[NATIONALHOUSING]

 SELECT DISTINCT([SoldAsVacant]),COUNT(*) FROM [dbo].[NATIONALHOUSING]
 GROUP BY [SoldAsVacant]
 ORDER BY 2

 SELECT [SoldAsVacant],
 CASE 
 WHEN [SoldAsVacant]='Y' THEN 'Yes'
 WHEN [SoldAsVacant]='N' THEN 'No'
 ELSE [SoldAsVacant]
 END
 FROM [dbo].[NATIONALHOUSING]

 UPDATE [dbo].[NATIONALHOUSING] SET [SoldAsVacant]=CASE 
 WHEN [SoldAsVacant]='Y' THEN 'Yes'
 WHEN [SoldAsVacant]='N' THEN 'No'
 ELSE [SoldAsVacant]
 END
 -------------------------------------------------------------------------------------------------
 --REMOVE DUPLICATES
 WITH CTE AS
(
SELECT *,ROW_NUMBER()
OVER(PARTITION BY 
[ParcelID],
[PropertyAddress],
[SaleDate],
[SalePrice],
[LegalReference] ORDER BY [UniqueID ])AS ROW_NUM
FROM [dbo].[NATIONALHOUSING]
)
DELETE  FROM CTE
WHERE ROW_NUM>1

------------------------------------------------------------------------------------------
--DELETE USED COLUMNS
SELECT * FROM [dbo].[NATIONALHOUSING]


ALTER TABLE [dbo].[NATIONALHOUSING] DROP COLUMN [PropertyAddress],[OwnerAddress],[TaxDistrict]

ALTER TABLE [dbo].[NATIONALHOUSING] DROP COLUMN [SaleDate]



















