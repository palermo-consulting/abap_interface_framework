*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_F05
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CONVERT_DATE
*&---------------------------------------------------------------------*
*       Convert Date
*----------------------------------------------------------------------*
*      -->FV_DATE     Original Date
*      <--FV_RETURN   Converted Date (m/d/yyyy)
*----------------------------------------------------------------------*
FORM convert_date  USING    fv_date
                   CHANGING fv_return.

  DATA: lv_month TYPE c LENGTH 2,
        lv_day   TYPE c LENGTH 2.

* Month (MM)
  MOVE fv_date+4(2) TO lv_month.
  SHIFT lv_month LEFT DELETING LEADING '0'.
* Day   (DD)
  MOVE fv_date+6(2) TO lv_day.
  SHIFT lv_day LEFT DELETING LEADING '0'.
*                                     Year  (YYYY)
  CONCATENATE lv_month '/' lv_day '/' fv_date(4) INTO fv_return.

ENDFORM.                    " CONVERT_DATE
*&---------------------------------------------------------------------*
*&      Form  CONVERT_TO_CSV
*&---------------------------------------------------------------------*
*       Convert a WFN record to a CSV string
*----------------------------------------------------------------------*
FORM convert_to_csv CHANGING fv_return.

  FIELD-SYMBOLS: <lv_field>.

  DO.
    ASSIGN COMPONENT sy-index OF STRUCTURE gs_employee_data TO <lv_field>.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
    IF sy-index EQ 1.
      fv_return = <lv_field>.
      CONTINUE.
    ENDIF.
    CONCATENATE fv_return ',' <lv_field> INTO fv_return.
  ENDDO.

ENDFORM.                    " CONVERT_TO_CSV
*&---------------------------------------------------------------------*
*&      Form  CREATE_FILE_ON_PC
*&---------------------------------------------------------------------*
*       Create the file on the local computer
*----------------------------------------------------------------------*
*      -->FV_FILE     Full file path
*      -->FT_DATATAB  Internal table of TemSe file
*----------------------------------------------------------------------*
FORM create_file_on_pc  USING    fv_file
                                 ft_datatab LIKE gt_file_out.

  DATA: lv_filename TYPE string.

  IF fv_file IS NOT INITIAL.

    MOVE fv_file TO lv_filename.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename                = lv_filename
        trunc_trailing_blanks   = 'X'
      CHANGING
        data_tab                = ft_datatab
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24.
    IF sy-subrc EQ 0.
      MESSAGE s016(rp) WITH 'TemSe file created on PC.'.
    ELSE.
      MESSAGE e016(rp) WITH 'Error creating TemSe file on PC.'.
    ENDIF.

  ENDIF.

ENDFORM.                    " CREATE_FILE_ON_PC
*&---------------------------------------------------------------------*
*&      Form  CREATE_FILE_ON_SRV
*&---------------------------------------------------------------------*
*       Create the file on the application server
*----------------------------------------------------------------------*
*      -->FV_FILE     Full file path
*      -->FT_DATATAB  Internal table of TemSe file
*----------------------------------------------------------------------*
FORM create_file_on_srv  USING    fv_file
                                  fv_backup
                                  ft_datatab LIKE gt_file_out.

  DATA: ls_datatab    TYPE p99st_raw,
        lv_file       TYPE c LENGTH 275.

  lv_file = fv_file.

  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc NE 0..
    MESSAGE e016(rp) WITH 'Server path could not be found.'.
  ENDIF.

  LOOP AT ft_datatab INTO ls_datatab.
    TRANSFER ls_datatab TO lv_file.
  ENDLOOP.

  CLOSE DATASET lv_file.

  IF sy-subrc EQ 0.
    MESSAGE s016(rp) WITH 'TemSe file created on server.'.
  ELSE.
    MESSAGE e016(rp) WITH 'Error creating TemSe file on server.'.
  ENDIF.

  IF fv_backup IS NOT INITIAL.
    OPEN DATASET fv_backup FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc NE 0..
      MESSAGE e016(rp) WITH 'Server path could not be found.'.
    ENDIF.

    LOOP AT ft_datatab INTO ls_datatab.
      TRANSFER ls_datatab TO fv_backup.
    ENDLOOP.

    CLOSE DATASET fv_backup.
  ENDIF.

  IF sy-subrc EQ 0.
    MESSAGE s016(rp) WITH 'TemSe file created on server.'.
  ELSE.
    MESSAGE e016(rp) WITH 'Error creating TemSe file on server.'.
  ENDIF.

ENDFORM.                    " CREATE_FILE_ON_SRV
*&---------------------------------------------------------------------*
*&      Form  ERROR
*&---------------------------------------------------------------------*
*       Write error to screen
*----------------------------------------------------------------------*
FORM error USING fv_etype fv_error_number fv_err_txt1 fv_err_txt2 fv_err_txt3 fv_err_txt4.

* Format color col_background intensified on.
  IF fv_etype EQ 'E'.
    FORMAT COLOR COL_NEGATIVE   INTENSIFIED ON.
  ELSE.
    FORMAT COLOR COL_TOTAL INTENSIFIED ON.
  ENDIF.
  WRITE:/ text-t01.
  WRITE:/ text-t02, pernr-pernr.
  IF fv_etype EQ 'E'.
    WRITE:/ text-t03, fv_error_number.
  ELSE.
    WRITE:/ text-t04, fv_error_number.
  ENDIF.
  WRITE:/ text-t01.
  FORMAT INTENSIFIED OFF.

  CASE fv_error_number.
    WHEN 'E001'.
      WRITE:/2 text-e01.
    WHEN 'E002'.
      WRITE:/2 fv_err_txt1.
      WRITE:/2 text-e02, fv_err_txt2.
    WHEN 'E003'.
      WRITE:/2 text-e03.
    WHEN 'E004'.
      WRITE:/2 text-e04.
    WHEN 'E005'.
      WRITE:/2 text-e05.
    WHEN 'E006'.
      WRITE:/2 text-e06.
    WHEN 'E007'.
      WRITE:/2 text-e07.
    WHEN 'E008'.
      WRITE:/2 text-e08.
    WHEN 'E009'.
      WRITE:/2 text-e09.
    WHEN 'E010'.
      WRITE:/2 text-e10.
    WHEN 'E011'.
      WRITE:/2 text-e11.
    WHEN 'E012'.
      WRITE:/2 text-e12.
    WHEN 'E013'.
      WRITE:/2 text-e13, 47 fv_err_txt1.
    WHEN 'W001'.
      WRITE:/2 text-w01.
    WHEN 'W002'.
      WRITE:/2 text-w02.
    WHEN 'W003'.
      WRITE:/2 text-w03.
    WHEN 'W004'.
      WRITE:/2 text-w04.
    WHEN 'W005'.
      WRITE:/2 text-w05.
    WHEN 'W006'.
      WRITE:/2 text-w06.
    WHEN 'W007'.
      WRITE:/2 text-w07.
    WHEN 'W008'.
      WRITE:/2 text-w08.
    WHEN 'W009'.
      WRITE:/2 text-w09.
    WHEN 'W010'.
      WRITE:/2 text-w10.
    WHEN 'W011'.
      WRITE:/2 text-w11.
    WHEN 'W012'.
      WRITE:/2 text-w12.
  ENDCASE.

  IF fv_etype EQ 'E'.
    gv_num_rejected_pernr = gv_num_rejected_pernr + 1.
    PERFORM dequeue_pernr.
    REJECT.
  ENDIF.

ENDFORM.                    "ERROR

*&---------------------------------------------------------------------*
*&      Form  EXPORT_SUMMARY
*&---------------------------------------------------------------------*
*       Write the export summary to the screen
*----------------------------------------------------------------------*
FORM export_summary.

  DATA: lv_file_name TYPE string.

  IF p_pc IS NOT INITIAL.
    lv_file_name = p_pfile.
  ELSE.
    lv_file_name = p_sfile.
  ENDIF.

  LOOP AT gt_file_out INTO gs_line_out.
    WRITE:/1 gs_line_out.
  ENDLOOP.

  FORMAT COLOR COL_TOTAL INTENSIFIED.

  SKIP 1.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE:/1 text-s01, 45 gv_num_selected_pernr.
  WRITE:/1 text-s02, 45 gv_num_rejected_pernr.
  WRITE:/1 text-s03, 45 gv_num_exported_pernr.
  SKIP 1.
  WRITE:/1 text-s04, 45 lv_file_name.
  SKIP 1.
  WRITE:/1 text-s05, 45 gv_number_of_records.
  SKIP 1.

ENDFORM.                    "EXPORT_SUMMARY
*&---------------------------------------------------------------------*
*&      Form  ENQUEUE_PERNR
*&---------------------------------------------------------------------*
*       Lock the employee from master data changes.
*----------------------------------------------------------------------*
FORM enqueue_pernr .

  DATA: ls_return       LIKE bapireturn1,
        lv_locking_user LIKE sy-uname,
        lv_message      TYPE bapi_msg.

  CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
    EXPORTING
      number       = pernr-pernr
    IMPORTING
      return       = ls_return
      locking_user = lv_locking_user.

  IF ls_return IS NOT INITIAL.

    IF ls_return-message IS NOT INITIAL.
      MOVE ls_return-message TO lv_message.
    ELSE.
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number
        WITH  ls_return-message_v1
              ls_return-message_v2
              ls_return-message_v3
              ls_return-message_v4
        INTO lv_message.
    ENDIF.

    PERFORM error
                USING
                   'E'
                   'E002'
                   lv_message
                   lv_locking_user
                   space
                   space.

  ENDIF.

ENDFORM.                    " ENQUEUE_PERNR
*&---------------------------------------------------------------------*
*&      Form  DEQUEUE_PERNR
*&---------------------------------------------------------------------*
*       Unlock the employee to allow master data changes
*----------------------------------------------------------------------*
FORM dequeue_pernr .

  CALL FUNCTION 'HR_EMPLOYEE_DEQUEUE'
    EXPORTING
      number = pernr-pernr.


ENDFORM.                    " DEQUEUE_PERNR