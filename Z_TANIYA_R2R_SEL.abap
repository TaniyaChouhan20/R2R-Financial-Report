*&---------------------------------------------------------------------*
*& Include       : Z_TANIYA_R2R_SEL
*& Description   : Selection Screen Definition
*& Program       : Z_TANIYA_R2R_MAIN
*& Author        : Taniya Chouhan | Roll: 23053317
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.

  " Company Code
  SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs OBLIGATORY DEFAULT '1000'.

  " GL Account Range
  SELECT-OPTIONS: s_saknr FOR bseg-saknr.

  " Fiscal Year
  SELECT-OPTIONS: s_gjahr FOR bkpf-gjahr OBLIGATORY
                  DEFAULT sy-datum+0(4).

  " Fiscal Period (Month)
  SELECT-OPTIONS: s_monat FOR bseg-monat
                  DEFAULT '01' TO '12'.

  " Posting Date Range
  SELECT-OPTIONS: s_budat FOR bkpf-budat.

  " Document Type
  SELECT-OPTIONS: s_blart FOR bkpf-blart.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b02.

  " Report Mode
  PARAMETERS: p_detail  RADIOBUTTON GROUP rp1 DEFAULT 'X',  " Line Item Detail
              p_summary RADIOBUTTON GROUP rp1.               " Period Summary

  " Include Cleared Items
  PARAMETERS: p_clear TYPE c AS CHECKBOX DEFAULT 'X'.

  " Max Records
  PARAMETERS: p_max TYPE i DEFAULT 5000.

SELECTION-SCREEN END OF BLOCK b2.

*&---------------------------------------------------------------------*
*& TEXT SYMBOLS (set in SE38 -> Goto -> Text Elements -> Text Symbols)
*& b01 = 'FI Posting Selection Criteria'
*& b02 = 'Report Options'
*&---------------------------------------------------------------------*
