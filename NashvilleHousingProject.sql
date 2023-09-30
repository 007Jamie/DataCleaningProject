SELECT *
FROM NashvilleHousing

--Standardize date formats

SELECT SaleDate, CONVERT (Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD NewSaleDate Date

UPDATE NashvilleHousing
SET NewSaleDate = CONVERT (date,SaleDate)


--Populate empty PropertyAddress rows Using JOINS and the UPDATE command

SELECT PropertyAddress, ParcelID
FROM NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT A.PropertyAddress, B.PropertyAddress, A.ParcelID, B.ParcelID  
FROM NashVilleHousing as A
JOIN NashVilleHousing as B
ON  A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress is null

SELECT A.PropertyAddress, B.PropertyAddress, A.ParcelID, B.ParcelID, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM NashVilleHousing as A
JOIN NashVilleHousing as B
ON  A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress is null

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashVilleHousing as A
JOIN NashVilleHousing as B
ON  A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress is null

--Seperating Values In Property Address into different columns using SUBSTRING

SELECT PropertyAddress
FROM NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM NashvilleHousing

--Inputing New columns into the table

ALTER TABLE NashvilleHousing
ADD Address Varchar(255), City Varchar(255)

UPDATE NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

--Seperating Values in OwnerAddress using ParseName
SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as OwnerHomeAddress ,
PARSENAME(REPLACE(OwnerAddress, ',','.'),2) as OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1) OwnerState
FROM NashvilleHousing
--Creating  New columns and Inserting these New Values into the table

ALTER TABLE NashvilleHousing
ADD OwnerHomeAddress varchar(500),
OwnerCity varchar (255),
OwnerState varchar (255)

UPDATE NashvilleHousing
SET OwnerHomeAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
    OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
	OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 

	--Change Y and N to Yes  and No in the SoldAsVacant Column using the CASE function

	SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
	FROM NashvilleHousing
	GROUP BY SoldAsVacant
	ORDER BY 2

	SELECT SoldAsVacant
	,CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N'then 'No'
	 else SoldAsVacant
	 END 
	 FROM NashvilleHousing


	 UPDATE NashvilleHousing
	 SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N'then 'No'
	 else SoldAsVacant
	 END 
	
--Spotting and deleting Duplicate rows 

	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY SaleDate,
	            PropertyAddress, 
				LegalReference,
				ParcelID,
				SalePrice
				ORDER BY
				UniqueID) row_num
FROM NashvilleHousing

--Using CTE to filter out duplicate rows	            

WITH RowNumCTE as (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY SaleDate,
	            PropertyAddress, 
				LegalReference,
				ParcelID,
				SalePrice
				ORDER BY
				UniqueID) row_num
FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1

--Deleting unused columns

ALTER TABLE NashVilleHousing
DROP COLUMN SaleDate, OwnerAddress, PropertyAddress