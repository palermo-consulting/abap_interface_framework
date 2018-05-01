*----------------------------------------------------------------------*
***INCLUDE RPCIFU02I01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  CASE ok_code.
    WHEN 'DELE'.
      CALL METHOD ALV2000->GET_SELECTED_ROWS
      IMPORTING ET_INDEX_ROWS = gt_index_ROWs[].
      perform check_marked_results.
      PERFORM delete_marked_results.
    WHEN 'MARK'.
      perform select_last_results.
      CALL METHOD alv2000->set_selected_rows
        EXPORTING it_index_rows = gt_index_rows[].
    WHEN 'BACK'.
      CALL METHOD g_custom_container2000->free.
      CLEAR: alv2000, g_custom_container2000.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO TRANSACTION ' '.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_2000  INPUT