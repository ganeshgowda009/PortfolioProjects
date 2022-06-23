-- Cleaning Data in SQL Query.


Select * 
from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(DATE,SaleDate)

-------------------------------------------------------------------------------------------------------------------
--Populate Property Address Data

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
------------------------------------------------------------------------------------------------------------------
--where PropertyAddress is Null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

--------------------------------------------------------------------------------------------------------------------
--Breaking Address into individual Columns (Address, city, State)

Select PropertyAddress 
From PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', ','),1)
from PortfolioProject.dbo.NashvilleHousing
-------------------------------------------------------------------------------------------------------------------
-- Change Y & N to Yes and No in SoldAsVacant.

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes' 
	   when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes' 
	   when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END

--------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates.
WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num
From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress

SELECt * 
FROM PortfolioProject.dbo.NashvilleHousing






--------------------------------------------------------------------------------------------------------------------
-- Delete unused Columns

SELECt * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate