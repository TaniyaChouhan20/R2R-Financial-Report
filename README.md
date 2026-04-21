# Z_TANIYA_R2R_MAIN — Record-to-Report (R2R) SAP Project
## Author: Taniya Chouhan | Roll: 23053317 | SAP Data Analytics Engineer

---

## Project Overview
This project implements a complete Record-to-Report (R2R) scenario in SAP FI
using ABAP programming. It covers GL line item reporting, debit/credit analysis,
period-wise financial close reporting, and interactive ALV output.

---

## Files in This Project

| File | Description |
|------|-------------|
| Z_TANIYA_R2R_MAIN.abap | Main report program (entry point) |
| Z_TANIYA_R2R_TOP.abap  | Global type & data declarations (TOP include) |
| Z_TANIYA_R2R_SEL.abap  | Selection screen definition (SEL include) |
| Z_TANIYA_R2R_F01.abap  | All FORM subroutines — data fetch, calc, fieldcat |
| Z_TANIYA_R2R_O01.abap  | ALV output display & page header |

---

## SAP Tables Used

| Table | Description |
|-------|-------------|
| BKPF  | Accounting Document Header |
| BSEG  | Accounting Document Segment (Line Items) |
| SKA1  | G/L Account Master (Chart of Accounts) |
| SKAT  | G/L Account Master Record (Description) |
| T001  | Company Codes |

---

## How to Create in SAP (SE38)

### Step 1 — Create Main Program
1. Go to transaction **SE38**
2. Enter program name: `Z_TANIYA_R2R_MAIN`
3. Click **Create**
4. Select Type: **Executable Program**
5. Paste contents of `Z_TANIYA_R2R_MAIN.abap`
6. Save (Ctrl+S) and Activate (Ctrl+F3)

### Step 2 — Create Include Programs
Repeat the following for each include file:
1. SE38 → Enter include name → Create → Type: **Include Program**
2. Paste contents of the corresponding `.abap` file
3. Save and Activate

Order of creation:
1. `Z_TANIYA_R2R_TOP`
2. `Z_TANIYA_R2R_SEL`
3. `Z_TANIYA_R2R_F01`
4. `Z_TANIYA_R2R_O01`
5. `Z_TANIYA_R2R_MAIN` (last — after all includes are ready)

### Step 3 — Activate All
- In SE38, open `Z_TANIYA_R2R_MAIN`
- Menu: Program → Activate (or Ctrl+F3)
- Check for syntax errors using **Check (Ctrl+F2)**

### Step 4 — Execute
- Press **F8** to run
- Enter Company Code (e.g., 1000), Fiscal Year, Period
- Press Execute (F8 again)

---

## Selection Screen Fields

| Field | Description | Example |
|-------|-------------|---------|
| Company Code | SAP company code | 1000 |
| GL Account | Filter by account range | 100000 to 999999 |
| Fiscal Year | Financial year | 2024 |
| Fiscal Period | Month 01-12 | 01 to 12 |
| Posting Date | Filter by date range | 01.01.2024 to 31.12.2024 |
| Document Type | SA=G/L, KR=Vendor, DR=Customer | SA |
| Report Mode | Line Item Detail or Period Summary | Detail |
| Max Records | Limit output rows | 5000 |

---

## ALV Output Columns

Debit/Credit | Document | GL Account | Period | Cost Centre | Net Balance

- Debit rows highlighted in **blue**
- Credit rows highlighted in **red**
- Subtotals per GL Account and Period
- Grand Total of Debit, Credit, and Net Balance

---

## Key ABAP Concepts Demonstrated

1. INCLUDE programs for modular code structure
2. SELECT with WHERE IN ranges from selection screen
3. Nested SELECT inside LOOP for header-item join
4. DEFINE macro for efficient field catalog building
5. ALV layout with row coloring via INFO_FIELDNAME
6. ALV TOP-OF-PAGE event with REUSE_ALV_COMMENTARY_WRITE
7. Period summary calculation using READ TABLE + MODIFY
8. SY-SUBRC error handling throughout

---

*Submitted as Capstone Project — April 2026*
