# Excel Cleaning Log

Raw exports are in `data/raw/`. Clean each in Excel (Power Query or
manual formulas) and export to `data/cleaned/` using the same column
names. This log documents every issue found and the fix applied.

## Dim_Customer_raw.csv -> Dim_Customer.csv
| Issue | Fix |
|---|---|
| Extra spaces + inconsistent casing in `customer_name` | `TRIM()` + `PROPER()` |
| Lowercase `segment` values | `PROPER()` |
| Duplicate customer rows (~2%) | Data tab -> Remove Duplicates on `customer_id` |

## Dim_Product_raw.csv -> Dim_Product.csv
| Issue | Fix |
|---|---|
| Inconsistent casing in `sub_category` | `PROPER()` |
| Missing `category` (~4%) | Filled by looking up the category for that `sub_category` elsewhere in the sheet (VLOOKUP/XLOOKUP) |
| Duplicate product rows | Remove Duplicates on `product_id` |

## Dim_Location_raw.csv -> Dim_Location.csv
| Issue | Fix |
|---|---|
| Leading spaces + lowercase `city` | `TRIM()` + `PROPER()` |
| Misspelled city ("Banglore") | Find & Replace -> "Bengaluru" |

## Dim_Shipping.csv
Already a clean lookup table (ship_mode x payment_method x order_status combinations) -- no cleaning needed, used as-is.

## Fact_Orders_raw.csv -> Fact_Orders.csv
| Issue | Fix |
|---|---|
| Fully blank rows (~10) | Filtered out (blank `order_id`) |
| Currency symbol in `sales` (e.g. `₹45230.50`) | Find & Replace `₹` with blank, convert column to Number |
| Missing `discount` (~4%) | Filled with column median |
| Negative / text `quantity` ("-3", "three") | Text-to-number conversion + `ABS()`; text values mapped manually |
| Missing `profit` (~3%) | Filled using the average profit-to-sales ratio from complete rows, applied to that row's sales |
| Duplicate order lines (~1.5%) | Remove Duplicates on `order_id` + `product_id` |
| Mixed `order_date` formats (DD/MM/YYYY vs YYYY-MM-DD) | Power Query "Change Type -> Date" after splitting/reordering the slash-format rows |

## Row count check
| Table | Raw rows | Clean rows |
|---|---|---|
| Dim_Customer | 510 | 500 |
| Dim_Product | 101 | 99 |
| Dim_Location | 17 | 17 |
| Dim_Shipping | 27 | 27 |
| Fact_Orders | 7,115 | 7,000 |
