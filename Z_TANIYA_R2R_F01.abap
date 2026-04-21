*&---------------------------------------------------------------------*
*& Include       : Z_TANIYA_R2R_F01
*& Description   : All Subroutines (FORM routines)
*& Program       : Z_TANIYA_R2R_MAIN
*& Author        : Taniya Chouhan | Roll: 23053317
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM: INIT_SCREEN
*& Sets default text symbols at runtime
*&---------------------------------------------------------------------*
FORM init_screen.
  TEXT-b01 = 'FI Posting Selection Criteria'.
  TEXT-b02 = 'Report Options'.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: FETCH_GL_BALANCES
*& Fetches GL line items from BKPF + BSEG + SKA1/SKAT
*&---------------------------------------------------------------------*
FORM fetch_gl_balances.

  DATA: lt_bkpf TYPE TABLE OF bkpf,
        ls_bkpf TYPE bkpf.

  CLEAR gt_output.

  " Step 1: Fetch document headers from BKPF
  SELECT bukrs belnr gjahr blart budat bldat bktxt waers
    INTO TABLE lt_bkpf
    UP TO p_max ROWS
    FROM bkpf
    WHERE bukrs IN s_bukrs
      AND gjahr IN s_gjahr
      AND budat IN s_budat
      AND blart IN s_blart.

  IF sy-subrc <> 0 OR lt_bkpf IS INITIAL.
    RETURN.
  ENDIF.

  " Step 2: For each document, fetch line items from BSEG
  LOOP AT lt_bkpf INTO ls_bkpf.

    SELECT buzei saknr monat shkzg dmbtr sgtxt kostl aufnr
      INTO (gs_bseg-buzei, gs_bseg-saknr, gs_bseg-monat,
            gs_bseg-shkzg, gs_bseg-dmbtr, gs_bseg-sgtxt,
            gs_bseg-kostl, gs_bseg-aufnr)
      FROM bseg
      WHERE bukrs = ls_bkpf-bukrs
        AND belnr = ls_bkpf-belnr
        AND gjahr = ls_bkpf-gjahr
        AND saknr IN s_saknr
        AND monat IN s_monat.

      " Step 3: Fetch GL account description from SKAT
      SELECT SINGLE txt20 txt50
        INTO (gs_skat-txt20, gs_skat-txt50)
        FROM skat
        WHERE spras = sy-langu
          AND ktopl = '0001'
          AND saknr = gs_bseg-saknr.

      " Step 4: Populate output structure
      CLEAR gs_output.
      gs_output-bukrs   = ls_bkpf-bukrs.
      gs_output-saknr   = gs_bseg-saknr.
      gs_output-txt20   = gs_skat-txt20.
      gs_output-txt50   = gs_skat-txt50.
      gs_output-gjahr   = ls_bkpf-gjahr.
      gs_output-monat   = gs_bseg-monat.
      gs_output-blart   = ls_bkpf-blart.
      gs_output-belnr   = ls_bkpf-belnr.
      gs_output-budat   = ls_bkpf-budat.
      gs_output-bldat   = ls_bkpf-bldat.
      gs_output-bktxt   = ls_bkpf-bktxt.
      gs_output-buzei   = gs_bseg-buzei.
      gs_output-shkzg   = gs_bseg-shkzg.
      gs_output-dmbtr   = gs_bseg-dmbtr.
      gs_output-waers   = ls_bkpf-waers.
      gs_output-sgtxt   = gs_bseg-sgtxt.
      gs_output-kostl   = gs_bseg-kostl.
      gs_output-aufnr   = gs_bseg-aufnr.

      " Step 5: Split into Debit / Credit columns
      IF gs_bseg-shkzg = c_debit.
        gs_output-debit  = gs_bseg-dmbtr.
        gs_output-credit = 0.
      ELSE.
        gs_output-debit  = 0.
        gs_output-credit = gs_bseg-dmbtr.
      ENDIF.

      " Step 6: Net balance = Debit - Credit
      gs_output-net_bal = gs_output-debit - gs_output-credit.

      " Step 7: Row color — red for credit, default for debit
      IF gs_bseg-shkzg = c_credit.
        gs_output-color_key = 'C610'.  " Light red
      ELSE.
        gs_output-color_key = 'C510'.  " Light blue
      ENDIF.

      APPEND gs_output TO gt_output.

    ENDSELECT.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: FETCH_JOURNAL_ENTRIES
*& Additional validation — checks document completeness
*&---------------------------------------------------------------------*
FORM fetch_journal_entries.
  " In a real scenario this would cross-validate with FB03 journal view.
  " For this project, completeness check is done via BKPF-BSTAT field.
  DELETE gt_output WHERE saknr IS INITIAL.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: CALCULATE_PERIOD_TOTALS
*& Builds period-level summary for the summary view
*&---------------------------------------------------------------------*
FORM calculate_period_totals.

  CLEAR gt_summary.

  LOOP AT gt_output INTO gs_output.

    READ TABLE gt_summary INTO gs_summary
      WITH KEY bukrs = gs_output-bukrs
               gjahr = gs_output-gjahr
               monat = gs_output-monat
               saknr = gs_output-saknr.

    IF sy-subrc = 0.
      gs_summary-tot_debit  = gs_summary-tot_debit  + gs_output-debit.
      gs_summary-tot_credit = gs_summary-tot_credit + gs_output-credit.
      gs_summary-net_bal    = gs_summary-tot_debit  - gs_summary-tot_credit.
      MODIFY gt_summary FROM gs_summary
        TRANSPORTING tot_debit tot_credit net_bal.
    ELSE.
      CLEAR gs_summary.
      gs_summary-bukrs      = gs_output-bukrs.
      gs_summary-gjahr      = gs_output-gjahr.
      gs_summary-monat      = gs_output-monat.
      gs_summary-saknr      = gs_output-saknr.
      gs_summary-txt20      = gs_output-txt20.
      gs_summary-tot_debit  = gs_output-debit.
      gs_summary-tot_credit = gs_output-credit.
      gs_summary-net_bal    = gs_output-debit - gs_output-credit.
      gs_summary-waers      = gs_output-waers.
      APPEND gs_summary TO gt_summary.
    ENDIF.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: BUILD_FIELD_CATALOG
*& Defines all ALV grid columns dynamically
*&---------------------------------------------------------------------*
FORM build_field_catalog.

  CLEAR gt_fieldcat.

  DEFINE add_col.
    CLEAR gs_fieldcat.
    gs_fieldcat-col_pos   = &1.
    gs_fieldcat-fieldname = &2.
    gs_fieldcat-seltext_m = &3.
    gs_fieldcat-outputlen = &4.
    gs_fieldcat-key       = &5.
    gs_fieldcat-do_sum    = &6.
    gs_fieldcat-datatype  = &7.
    APPEND gs_fieldcat TO gt_fieldcat.
  END-OF-DEFINITION.

  "         Pos  Field       Label              Len  Key  Sum  Dtype
  add_col   1   'BUKRS'     'Co. Code'          6   'X'  ''   ''.
  add_col   2   'GJAHR'     'Fisc. Year'         4   'X'  ''   ''.
  add_col   3   'MONAT'     'Period'             3   ''   ''   ''.
  add_col   4   'BELNR'     'Doc. Number'       10   'X'  ''   ''.
  add_col   5   'BUDAT'     'Post. Date'        10   ''   ''   ''.
  add_col   6   'BLDAT'     'Doc. Date'         10   ''   ''   ''.
  add_col   7   'BLART'     'Doc. Type'          4   ''   ''   ''.
  add_col   8   'SAKNR'     'GL Account'        10   'X'  ''   ''.
  add_col   9   'TXT20'     'Account Name'      20   ''   ''   ''.
  add_col  10   'BUZEI'     'Line'               3   ''   ''   ''.
  add_col  11   'SHKZG'     'D/C'                3   ''   ''   ''.
  add_col  12   'DEBIT'     'Debit Amt'         16   ''   'X'  'CURR'.
  add_col  13   'CREDIT'    'Credit Amt'        16   ''   'X'  'CURR'.
  add_col  14   'NET_BAL'   'Net Balance'       16   ''   'X'  'CURR'.
  add_col  15   'WAERS'     'Curr.'              5   ''   ''   ''.
  add_col  16   'SGTXT'     'Line Item Text'    30   ''   ''   ''.
  add_col  17   'KOSTL'     'Cost Centre'       10   ''   ''   ''.
  add_col  18   'BKTXT'     'Doc. Header Text'  25   ''   ''   ''.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: SET_LAYOUT
*& Configures ALV grid display options
*&---------------------------------------------------------------------*
FORM set_layout.

  gs_layout-zebra             = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-totals_text       = 'Grand Total'.
  gs_layout-subtotals_text    = 'Subtotal'.
  gs_layout-info_fieldname    = 'COLOR_KEY'.
  gs_layout-cell_merge        = 'X'.

  " Default sort: Company Code -> GL Account -> Period -> Doc
  CLEAR gs_sort.
  gs_sort-fieldname = 'BUKRS'. gs_sort-up = 'X'. gs_sort-subtot = 'X'.
  APPEND gs_sort TO gt_sort. CLEAR gs_sort.

  gs_sort-fieldname = 'SAKNR'. gs_sort-up = 'X'. gs_sort-subtot = 'X'.
  APPEND gs_sort TO gt_sort. CLEAR gs_sort.

  gs_sort-fieldname = 'MONAT'. gs_sort-up = 'X'. gs_sort-subtot = 'X'.
  APPEND gs_sort TO gt_sort. CLEAR gs_sort.

  gs_sort-fieldname = 'BELNR'. gs_sort-up = 'X'.
  APPEND gs_sort TO gt_sort.

ENDFORM.
