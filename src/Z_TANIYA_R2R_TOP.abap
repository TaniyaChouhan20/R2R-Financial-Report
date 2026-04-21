*&---------------------------------------------------------------------*
*& Include       : Z_TANIYA_R2R_TOP
*& Description   : Global Type Definitions and Data Declarations
*& Program       : Z_TANIYA_R2R_MAIN
*& Author        : Taniya Chouhan | Roll: 23053317
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& TYPE POOLS
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

*&---------------------------------------------------------------------*
*& TYPES: GL Balance Output Structure
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_gl_balance,
  bukrs      TYPE bkpf-bukrs,        " Company Code
  saknr      TYPE ska1-saknr,        " GL Account Number
  txt20      TYPE skat-txt20,        " GL Account Short Text
  txt50      TYPE skat-txt50,        " GL Account Long Text
  gjahr      TYPE bkpf-gjahr,        " Fiscal Year
  monat      TYPE bseg-monat,        " Fiscal Period (Month)
  blart      TYPE bkpf-blart,        " Document Type
  belnr      TYPE bkpf-belnr,        " Accounting Document Number
  budat      TYPE bkpf-budat,        " Posting Date
  bldat      TYPE bkpf-bldat,        " Document Date
  bktxt      TYPE bkpf-bktxt,        " Document Header Text
  buzei      TYPE bseg-buzei,        " Line Item Number
  shkzg      TYPE bseg-shkzg,        " Debit/Credit Indicator
  dmbtr      TYPE bseg-dmbtr,        " Amount in Local Currency
  waers      TYPE bkpf-waers,        " Currency Key
  sgtxt      TYPE bseg-sgtxt,        " Line Item Text
  kostl      TYPE bseg-kostl,        " Cost Centre
  aufnr      TYPE bseg-aufnr,        " Order Number
  debit      TYPE bseg-dmbtr,        " Debit Amount (calculated)
  credit     TYPE bseg-dmbtr,        " Credit Amount (calculated)
  net_bal    TYPE bseg-dmbtr,        " Net Balance (calculated)
  color_key  TYPE c LENGTH 4,        " ALV row color
END OF ty_gl_balance.

*&---------------------------------------------------------------------*
*& TYPES: Period Summary Structure
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_period_summary,
  bukrs      TYPE bkpf-bukrs,
  gjahr      TYPE bkpf-gjahr,
  monat      TYPE bseg-monat,
  saknr      TYPE ska1-saknr,
  txt20      TYPE skat-txt20,
  tot_debit  TYPE bseg-dmbtr,
  tot_credit TYPE bseg-dmbtr,
  net_bal    TYPE bseg-dmbtr,
  waers      TYPE bkpf-waers,
END OF ty_period_summary.

*&---------------------------------------------------------------------*
*& INTERNAL TABLES
*&---------------------------------------------------------------------*
DATA: gt_output     TYPE TABLE OF ty_gl_balance,
      gs_output     TYPE ty_gl_balance,
      gt_summary    TYPE TABLE OF ty_period_summary,
      gs_summary    TYPE ty_period_summary,
      gt_fieldcat   TYPE slis_t_fieldcat_alv,
      gs_fieldcat   TYPE slis_fieldcat_alv,
      gs_layout     TYPE slis_layout_alv,
      gt_sort       TYPE slis_t_sortinfo_alv,
      gs_sort       TYPE slis_sortinfo_alv,
      gs_variant    TYPE disvariant,
      gt_events     TYPE slis_t_event,
      gs_event      TYPE slis_alv_event.

*&---------------------------------------------------------------------*
*& WORK AREAS FOR DB TABLES
*&---------------------------------------------------------------------*
DATA: gs_bkpf  TYPE bkpf,
      gs_bseg  TYPE bseg,
      gs_ska1  TYPE ska1,
      gs_skat  TYPE skat,
      gs_t001  TYPE t001.

*&---------------------------------------------------------------------*
*& CONSTANTS
*&---------------------------------------------------------------------*
CONSTANTS: c_debit   TYPE c VALUE 'S',   " Debit indicator
           c_credit  TYPE c VALUE 'H',   " Credit indicator
           c_open    TYPE c VALUE 'O',   " Open item
           c_cleared TYPE c VALUE 'C'.   " Cleared item
