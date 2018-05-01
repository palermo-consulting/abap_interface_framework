*----------------------------------------------------------------------*
***INCLUDE RPCIFU02O01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
  SET PF-STATUS 'MAIN2000'.
  SET TITLEBAR '2000'.

ENDMODULE.                 " STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  alv_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_2000 OUTPUT.

  IF g_custom_container2000 IS INITIAL.
*   build sort_tab_grid
    PERFORM build_sort_tab_grid.
    PERFORM fill_fieldcat2000.
    gs_layout-sel_mode = 'A'.
    gs_layout-zebra      = 'X'.
    gs_layout-no_toolbar = 'X'.
    CREATE OBJECT g_custom_container2000
         EXPORTING container_name = c_container_delete_tab.
    CREATE OBJECT alv2000
         EXPORTING i_parent = g_custom_container2000.
  ENDIF.
  if flag_new = 'X'.
    CALL METHOD alv2000->set_table_for_first_display
      EXPORTING
        i_structure_name = 'HRRPCIFU02_DEL_TAB'
        is_layout        = gs_layout
      CHANGING
        it_sort          = gt_sort_grid[]
        it_outtab        = delete_table[]
        it_fieldcatalog  = gt_fieldcat[].
    flag_new = space.
  elseif flag_new = 'R'.
    CALL METHOD alv2000->refresh_table_display.
  endif.
  CALL METHOD cl_gui_control=>set_focus
    EXPORTING
      control = alv2000.

ENDMODULE.                 " alv_2000  OUTPUT