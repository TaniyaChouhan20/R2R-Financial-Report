*&---------------------------------------------------------------------*
*& Program     : Z_TANIYA_R2R_MAIN
*& Title       : Record-to-Report (R2R) - Financial Close & Reporting
*& Author      : Taniya Chouhan
*& Roll No     : 23053317
*& Batch       : SAP Data Analytics Engineer
*& Description : End-to-End R2R scenario covering GL account balances,
*&               open item clearing, period closing, and financial
*&               reporting using SAP FI module tables.
*& Tables Used : BKPF, BSEG, SKA1, SKAT, T001
*&---------------------------------------------------------------------*

REPORT z_taniya_r2r_main
  LINE-SIZE 255
  MESSAGE-ID z_msg.

*&---------------------------------------------------------------------*
*& INCLUDE FILES
*&---------------------------------------------------------------------*
INCLUDE z_taniya_r2r_top.    " Global declarations
INCLUDE z_taniya_r2r_sel.    " Selection screen
INCLUDE z_taniya_r2r_f01.    " Subroutines / Forms
INCLUDE z_taniya_r2r_o01.    " ALV output

*&---------------------------------------------------------------------*
*& INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM init_screen.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM fetch_gl_balances.
  PERFORM fetch_journal_entries.
  PERFORM calculate_period_totals.

*&---------------------------------------------------------------------*
*& END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  IF gt_output IS INITIAL.
    MESSAGE 'No financial data found for the selected criteria.' TYPE 'I'.
  ELSE.
    PERFORM build_field_catalog.
    PERFORM set_layout.
    PERFORM display_alv_report.
  ENDIF.
