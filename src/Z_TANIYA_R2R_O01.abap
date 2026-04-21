*&---------------------------------------------------------------------*
*& Include       : Z_TANIYA_R2R_O01
*& Description   : ALV Grid Display Output
*& Program       : Z_TANIYA_R2R_MAIN
*& Author        : Taniya Chouhan | Roll: 23053317
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM: DISPLAY_ALV_REPORT
*& Calls REUSE_ALV_GRID_DISPLAY to show output
*&---------------------------------------------------------------------*
FORM display_alv_report.

  gs_variant-report = sy-repid.
  gs_variant-handle = 'DEFAULT'.

  " Register TOP-OF-PAGE event for report header
  CLEAR gs_event.
  gs_event-name    = slis_ev_top_of_page.
  gs_event-form    = 'ALV_TOP_OF_PAGE'.
  APPEND gs_event TO gt_events.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_top_of_page  = 'ALV_TOP_OF_PAGE'
      is_layout               = gs_layout
      it_fieldcat             = gt_fieldcat
      it_sort                 = gt_sort
      it_events               = gt_events
      is_variant              = gs_variant
      i_save                  = 'A'
      i_default               = 'X'
    TABLES
      t_outtab                = gt_output
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
    MESSAGE 'ALV display error. Please check field catalog.' TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM: ALV_TOP_OF_PAGE
*& Prints a header at the top of each ALV page
*&---------------------------------------------------------------------*
FORM alv_top_of_page.

  DATA: lt_header TYPE slis_t_listheader,
        ls_header TYPE slis_listheader,
        lv_date   TYPE char10,
        lv_time   TYPE char8.

  WRITE sy-datum TO lv_date.
  WRITE sy-uzeit TO lv_time.

  " Report Title
  ls_header-typ  = 'H'.
  ls_header-info = 'Record-to-Report (R2R) - Financial Close & GL Analysis'.
  APPEND ls_header TO lt_header. CLEAR ls_header.

  " Sub-title
  ls_header-typ  = 'S'.
  ls_header-key  = 'Program :'.
  ls_header-info = 'Z_TANIYA_R2R_MAIN'.
  APPEND ls_header TO lt_header. CLEAR ls_header.

  ls_header-typ  = 'S'.
  ls_header-key  = 'Author  :'.
  ls_header-info = 'Taniya Chouhan | Roll: 23053317 | SAP Data Analytics Engineer'.
  APPEND ls_header TO lt_header. CLEAR ls_header.

  ls_header-typ  = 'S'.
  ls_header-key  = 'Run On  :'.
  ls_header-info = lv_date.
  APPEND ls_header TO lt_header. CLEAR ls_header.

  ls_header-typ  = 'S'.
  ls_header-key  = 'Records :'.
  ls_header-info = sy-dbcnt.
  APPEND ls_header TO lt_header. CLEAR ls_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.

ENDFORM.
