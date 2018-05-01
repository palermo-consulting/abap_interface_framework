*----------------------------------------------------------------------*
***INCLUDE RPCIFU02F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  build_sort_tab_grid
*&---------------------------------------------------------------------*
FORM build_sort_tab_grid .

* create sort-table
  gt_sort_grid-spos = 1.
  gt_sort_grid-fieldname = 'PERNR'.
  gt_sort_grid-up = 'X'.
  gt_sort_grid-subtot = 'X'.
  APPEND gt_sort_grid.


ENDFORM.                    " build_sort_tab_grid
*&---------------------------------------------------------------------*
*&      Form  fill_fieldcat2000
*&---------------------------------------------------------------------*
FORM fill_fieldcat2000 .

* 1. PERNR
  CLEAR: gt_fieldcat.
  MOVE: 'PERNR'     TO gt_fieldcat-fieldname,
        'PERNR'     TO gt_fieldcat-ref_table,
        'PERNR'     TO gt_fieldcat-ref_field,
        '8'         TO gt_fieldcat-outputlen,
        'X'         TO gt_fieldcat-emphasize,
        'X'         TO gt_fieldcat-fix_column.
  APPEND gt_fieldcat.

ENDFORM.                    " fill_fieldcat2000
*&---------------------------------------------------------------------*
*&      Form  select_last_results
*&---------------------------------------------------------------------*
FORM select_last_results .

  LOOP AT delete_table WHERE dsign = '1'.
    gt_index_rows-index = sy-tabix.
    APPEND gt_index_rows.
  ENDLOOP.

ENDFORM.                    " select_last_results
*&---------------------------------------------------------------------*
*&      Form  check_marked_results
*&---------------------------------------------------------------------*
FORM check_marked_results .

  DATA: lines1 TYPE i,
        lines2 TYPE i.

  DESCRIBE TABLE gt_index_rows LINES lines1.
  DESCRIBE TABLE delete_table LINES lines2.

  loop at gt_index_rows.
    read table delete_table index gt_index_rows-index.
    if sy-subrc =  0.
      delete_table-marks = 'X'.
      modify delete_table index gt_index_rows-index.
    endif.
  endloop.

  CHECK lines2 GT lines1.
* Markiere alle Sätze die zusammen mit dem letzten Ergebnis (DSIGN = 1)erzeugt wurden.
  LOOP AT delete_table WHERE dsign = '1'
                         AND marks = 'X'.
    MODIFY delete_table FROM delete_table TRANSPORTING marks dsign WHERE pernr = delete_table-pernr
                                                                     AND inper = delete_table-inper
                                                                     AND rundt = delete_table-rundt
                                                                     AND runtm = delete_table-runtm.
  ENDLOOP.

* Falls nicht alle Einträge gelöscht werden, so dürfen nur DSIGN = 1 Sätze gelöscht werden.
  READ TABLE delete_table WITH KEY marks = 'X'
                                   dsign = '0'.
  IF sy-subrc = 0.
    delete_table-marks = space.
    MODIFY delete_table from delete_table TRANSPORTING marks where marks = 'X'.
    MESSAGE e001(3g) WITH text-e01.
  ENDIF.

ENDFORM.                    " check_marked_results