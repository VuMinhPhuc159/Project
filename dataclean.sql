Select *
From Sheet1$

Select SaleDate, CAST(SaleDate as date)
From Sheet1$

Alter Table Sheet1$
Add SaleDate2 DATE

Update Sheet1$
Set SaleDate2 = CAST(SaleDate as date)

--boi vi co mot so PropertyAddress bi null nen se dc update vao voi cung 1 ParcelID
Update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From Sheet1$ a
Join Sheet1$ b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--tach du lieu dc phan cach boi dau , thanh cac cot
Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as City
From Sheet1$

Alter Table Sheet1$
Add Address nvarchar(255),
City nvarchar(255)

Update Sheet1$
set Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1),
City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

--tach du lieu kieu de
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from Sheet1$

Alter Table Sheet1$
Add
OwnerSplitAddress nvarchar(255),
OwnerCity nvarchar(255),
OwnerState nvarchar(255)
Update Sheet1$
Set
OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- doi Y,N sang Yes No
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Sheet1$
Group By SoldAsVacant

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End
From Sheet1$

Update Sheet1$
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' then 'No'
						Else SoldAsVacant
					End

--remove duplicate
With RowNumCTE As
(
Select *, ROW_NUMBER() OVER (Partition By ParcelID,
										PropertyAddress,
										SalePrice,
										SaleDate,
										LegalReference
										Order By UniqueID) row_num
From Sheet1$
)
Delete
From RowNumCTE
Where row_num > 1

--bo cot
ALter table Sheet1$
Drop Column OwnerAddress, PropertyAddress

----------------

Alter Table Sheet1$
Add PropertyAddress nvarchar(255),
PropertyCity nvarchar(255)

Update Sheet1$
set PropertyAddress = Address,
PropertyCity = City

ALTER TABLE dbo.[Sheet1$]
DROP COLUMN Address, City