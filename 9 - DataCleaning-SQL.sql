/* Cleaning Data in SQL Queries */

SELECT *
FROM PortfolioProyect.dbo.NashvilleHousing

-------------------------------------------

-- Standarize Date Format (estandarizamos fechas o cambiar formato de fecha)

SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM PortfolioProyect.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

---------------------------------------------------

--Populate Property Address Data

SELECT *
FROM PortfolioProyect.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProyect.dbo.NashvilleHousing a
JOIN PortfolioProyect.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProyect.dbo.NashvilleHousing a
JOIN PortfolioProyect.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State) (Columna ADDRESS dividida en 3)

SELECT PropertyAddress
FROM PortfolioProyect.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM PortfolioProyect.dbo.NashvilleHousing

-- Modificando la tabla 'NASHVILLEHOUSING' para crear 3 columnas diferentes

ALTER TABLE NashvilleHousing
ADD PropiertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropiertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropiertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropiertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProyect.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProyect.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
FROM PortfolioProyect.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM dbo.NashvilleHousing


----------------------------------------------------------------------------

--Change Y and N to YES and NO in "Sold as Vacant" field (cambia letras 'Y' y 'N')

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProyect.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
,  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProyect.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant =
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

---------------------------------------------------------------------------------

--Remove Duplicates (elimine duplicados y utilice PARTITION que es una 'windows function')

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM PortfolioProyect.dbo.NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


---------------------------------------------------------------------------

-- Delete Unused Columns (elimine columnas inutile)

SELECT *
FROM PortfolioProyect.dbo.NashvilleHousing

ALTER TABLE PortfolioProyect.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate