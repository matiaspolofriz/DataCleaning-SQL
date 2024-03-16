Resumen de mis consultas

1- Selecciono toda la tabla para observar todos los datos que tengo

2- Estandarizo fechas y cambio formato de fecha

    ° CONVERT(date,SaleDate): --> cambio el formato a "SaleData"
    ° UPDATE: --> Actualizo "SaleDate"
    ° ALTER TABLE: --> Cambio la tabla
    
3- Busco nulos y completo el dato

    ° JOIN: --> con la misma tabla, igualando "ParcelID" y "UniqueID" --> [para encontrar los domicilios nulos]
    ° UPDATE: --> Actualizo la tabla para completar los domicilios nulos por los domicilios que tienen mismo "ParcelID" y "UniqueID" 
    
4- Separo la columna "PropertyAddress" en 3 diferentes:

    ° SUBSTRING | CHARINDEX: --> es una manera un poco mas rebuscada de separar columnas

    -- SUBSTRING --> (COLUMNA, INICIO, FINAL y -1 resta un caracter para quitar la coma)
    
    SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
    , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
    
    
    ° PARSENAME: --> una manera mas rapida e intuitiva de separar

    -- PARSENAME --> (REPLACE(COLUMNA, DELIMITADOR, ) ELEMENTO)
    SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
    ,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
    ,PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
    FROM PortfolioProyect.dbo.NashvilleHousing
    
5- Agrego cada columna --> ALTER TABLE ! ADD

6- Actualizo los datos en cada columna --> UPDATE | SET

7- Cambio letras "Y" y "N" por "YES" y "NO"

    ° CASE | WHEN:
    
    SELECT SoldAsVacant,  
        CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    	         WHEN SoldAsVacant = 'N' THEN 'No'
    	    ELSE SoldAsVacant
    	    END
    FROM PortfolioProyect.dbo.NashvilleHousing

8- Actualizo la tabla --> UPDATE | SET

9- Elimino duplicados --> ROW_NUMBER() [windows funtion]

    ° CTE | ROW_NUMBER():
    
    WITH RowNumCTE AS
    (
    SELECT *,
    	ROW_NUMBER() OVER(
    	PARTITION BY ParcelID,
    				 PropertyAddress,
    				 SalePrice,
    				 SaleDate,
    				 LegalReference
    	ORDER BY 
    					UniqueID) row_num
    FROM PortfolioProyect.dbo.NashvilleHousing
    )
    

    ° DELETE:
    
    DELETE
    FROM RowNumCTE
    WHERE row_num > 1        --> Elimino las filas duplicadas >1
    
10- Elimino columnas innecesarias --> DROP COLUMN

    ° DROP:
    
    SELECT *
    FROM PortfolioProyect.dbo.NashvilleHousing
    
    ALTER TABLE PortfolioProyect.dbo.NashvilleHousing
    DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
