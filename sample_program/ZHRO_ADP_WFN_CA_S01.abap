*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_cp TYPE c RADIOBUTTON GROUP rb2 USER-COMMAND uc2 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(30) text-012.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_op TYPE c RADIOBUTTON GROUP rb2.
SELECTION-SCREEN COMMENT 3(30) text-013.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 10(12) text-014 FOR FIELD p_abkrs.
PARAMETERS: p_abkrs LIKE p0001-abkrs MATCHCODE OBJECT zh_t549a_ca.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 10(12) text-015 FOR FIELD p_pabrp.
PARAMETERS: p_pabrp TYPE c LENGTH 2.
PARAMETERS: p_pabrj TYPE c LENGTH 4.
SELECTION-SCREEN POSITION 34.
PARAMETERS: p_period TYPE c LENGTH 23.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-003.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_pc TYPE c RADIOBUTTON GROUP rb1 USER-COMMAND uc1.
SELECTION-SCREEN COMMENT 3(17) text-004.
PARAMETERS: p_pfile TYPE c LENGTH 255 VISIBLE LENGTH 80.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_srv TYPE c RADIOBUTTON GROUP rb1 DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(17) text-005.
PARAMETERS: p_sfile TYPE c LENGTH 255 VISIBLE LENGTH 80 LOWER CASE. "DEFAULT '\\SCB2FS\SAPDR1\\HCM\TemSeFile.txt'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-010.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(19) text-011 FOR FIELD p_backup.
PARAMETERS: p_backup TYPE c LENGTH 255 VISIBLE LENGTH 80 MODIF ID bop LOWER CASE.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b4.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_pfile.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    CHANGING
      filename             = gv_filename
      path                 = gv_path
      fullpath             = gv_fullpath
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

  IF gv_fullpath IS NOT INITIAL.

    gs_dynpfields-fieldname = 'P_PFILE'.
    gs_dynpfields-fieldvalue = gv_fullpath.
    APPEND gs_dynpfields TO gt_dynpfields.

    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = sy-repid
        dynumb               = sy-dynnr
      TABLES
        dynpfields           = gt_dynpfields
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        undefind_error       = 7
        OTHERS               = 8.

    p_pfile = gv_fullpath.

  ENDIF.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-name EQ 'P_PERIOD'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  IF p_pc EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name EQ 'P_SFILE'.
        screen-input = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name EQ 'P_PFILE'.
        screen-input = '1'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'BOP'.
        screen-input = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF p_srv EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name EQ 'P_PFILE'.
        screen-input = '0'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name EQ 'P_SFILE'.
        screen-input = '1'.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'BOP'.
        screen-input = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF p_cp EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name EQ 'P_ABKRS' OR
         screen-name EQ 'P_PABRP' OR
         screen-name EQ 'P_PABRJ'.
        screen-input = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF p_op EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name EQ 'P_ABKRS' OR
         screen-name EQ 'P_PABRP' OR
         screen-name EQ 'P_PABRJ'.
        screen-input = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF sy-slset EQ 'CUS&DEFAULT'.
    CONCATENATE gc_ca_path gc_filename INTO p_sfile.
    CONCATENATE gc_ca_path gc_archive '\' gc_filename INTO p_backup.
    CONCATENATE p_sfile '.' gc_ext INTO p_sfile.
    CONCATENATE p_backup '_' sy-datum '.' gc_ext INTO p_backup.
  ENDIF.

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'PNPTIMR1' OR
        'PNPTIMR2' OR
        'PNPTIMR3' OR
        'PNPTIMR4' OR
        'PNPTIMR5' OR
        'PNPTIMR6' OR
        'PNPBEGDA' OR
        'PNPENDDA' OR
        'PNPTBEG' OR
        '%FBIS112_1000' OR
        'PNPBLCKT'.
        screen-active = '0'.
        screen-invisible = '1'.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.

  pnptimr6 = 'X'.

AT SELECTION-SCREEN ON p_pfile.
  IF sy-ucomm NE 'UC1' AND sy-ucomm NE 'UC2'.
    IF p_pc EQ 'X' AND p_pfile IS INITIAL.
      MESSAGE e016(rp) WITH 'Please provide a full PC path and filename.'.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON p_sfile.
  IF sy-ucomm NE 'UC1' AND sy-ucomm NE 'UC2'.
    IF p_srv EQ 'X' AND p_sfile IS INITIAL.
      MESSAGE e016(rp) WITH 'Please provide a full server path and filename.'.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN.

  IF p_pc EQ 'X'.
    p_sfile = gv_sfile.
  ELSE.
    CLEAR p_pfile.
  ENDIF.

  IF p_op EQ 'X'.
    IF p_abkrs IS NOT INITIAL.
      pnpabkrs-sign = 'I'.
      pnpabkrs-option = 'EQ'.
      pnpabkrs-low = p_abkrs.
      APPEND pnpabkrs.
    ENDIF.
  ENDIF.

  IF p_op EQ 'X'.
    LOOP AT SCREEN.
      IF screen-name EQ 'P_ABKRS' OR
         screen-name EQ 'P_PABRP' OR
         screen-name EQ 'P_PABRJ'.
        screen-input = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    IF p_abkrs IS INITIAL.
      MESSAGE e016(rp) WITH 'Enter a payroll area'.
    ENDIF.
    IF p_pabrp IS INITIAL.
      MESSAGE e016(rp) WITH 'Enter a payroll period'.
    ENDIF.
    IF p_pabrj IS INITIAL.
      MESSAGE e016(rp) WITH 'Enter a payroll year'.
    ENDIF.

    CLEAR:  gv_frper, gv_frbeg, gv_frend.
    CONCATENATE p_pabrj p_pabrp INTO gv_frper.
    SELECT * FROM t549a WHERE
      abkrs EQ p_abkrs.

      SELECT * FROM t549q WHERE
        permo EQ t549a-permo AND
        pabrj EQ p_pabrj AND
        pabrp EQ p_pabrp.

        MOVE t549q-begda TO gv_frbeg.
        MOVE t549q-endda TO gv_frend.

        CONCATENATE gv_frbeg+4(2) '/' gv_frbeg+6(2) '/' gv_frbeg(4) ' - ' gv_frend+4(2) '/' gv_frend+6(2) '/' gv_frend(4)
          INTO p_period RESPECTING BLANKS.

      ENDSELECT.
      IF sy-subrc NE 0.
        MESSAGE e016(rp) WITH 'Period cannot be found'.
      ENDIF.

    ENDSELECT.


  ENDIF.