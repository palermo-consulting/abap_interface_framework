*&---------------------------------------------------------------------*
*&  Include           ZHRU_ADP_WFN_CA_PCL2_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  START_OF_SELECTION
*&---------------------------------------------------------------------*
*       Start of Selection
*----------------------------------------------------------------------*
FORM start_of_selection .

  PERFORM set_title_bar.
  PERFORM build_search.
  PERFORM read_directory.
  PERFORM display_directory.

ENDFORM.                    " START_OF_SELECTION
*&---------------------------------------------------------------------*
*&      Form  BUILD_SEARCH
*&---------------------------------------------------------------------*
*       Build search of cluster directory
*----------------------------------------------------------------------*
FORM build_search .

  LOOP AT p_pernr.
    MOVE-CORRESPONDING p_pernr TO gs_sortfield.
    gs_sortfield-low+8(4) = p_fldid.
    gs_sortfield-high+8(4) = p_fldid.
    APPEND gs_sortfield TO gt_sortfield.
  ENDLOOP.
  READ TABLE gt_sortfield INTO gs_sortfield INDEX 1.
  IF sy-subrc NE 0.
    gs_sortfield-low+0(8)  = '++++++++'.
    gs_sortfield-low+8(4)  = p_fldid.
    gs_sortfield-option    = 'CP'.
    gs_sortfield-sign      = 'I'.
    APPEND gs_sortfield TO gt_sortfield.
  ENDIF.

ENDFORM.                    " BUILD_SEARCH
*&---------------------------------------------------------------------*
*&      Form  READ_DIRECTORY
*&---------------------------------------------------------------------*
*       Read the PCL2 directory
*----------------------------------------------------------------------*
FORM read_directory .

  DATA: lv_personnel_number LIKE pernr-pernr,
        lv_found            TYPE i,
        ls_id_key           TYPE ts_id_key,
        ls_if_version       TYPE ts_if_version,
        ls_if_results       TYPE ts_if_results,
        lt_if_results       TYPE tt_if_results.

  SELECT * FROM zhr_pcl2 WHERE relid = 'ID'
                       AND srtfd IN gt_sortfield
                       AND srtf2 = '00'.
    CHECK zhr_pcl2-srtfd+8(4) = p_fldid.
    lv_personnel_number = zhr_pcl2-srtfd(8).
    lv_found = 0.
    CLEAR: p0001, p0001[].
    CALL FUNCTION 'HR_READ_INFOTYPE'
      EXPORTING
        pernr     = lv_personnel_number
        infty     = '0001'
      TABLES
        infty_tab = p0001
      EXCEPTIONS
        OTHERS    = 0.
    LOOP AT p0001.
      lv_found = 1.
      EXIT.
    ENDLOOP.
    CHECK lv_found = 1.
    ls_id_key-pernr = lv_personnel_number.
    ls_id_key-fldid = p_fldid.
    IMPORT if_version  TO ls_if_version
           if_results  TO lt_if_results
           FROM DATABASE zhr_pcl2(id) ID ls_id_key.
    CLEAR gs_display_table.
    gs_display_table-pernr = lv_personnel_number.
    LOOP AT lt_if_results INTO ls_if_results.
      MOVE-CORRESPONDING ls_if_results TO gs_display_table.
      APPEND gs_display_table TO gt_display_table.
    ENDLOOP.
  ENDSELECT.

ENDFORM.                    " READ_DIRECTORY
*&---------------------------------------------------------------------*
*&      Form  SET_TITLE_BAR
*&---------------------------------------------------------------------*
*       Set title bar
*----------------------------------------------------------------------*
FORM set_title_bar .

  SET TITLEBAR '001' WITH p_fldid.

ENDFORM.                    " SET_TITLE_BAR
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DIRECTORY
*&---------------------------------------------------------------------*
*       Display PCL2 directory
*----------------------------------------------------------------------*
FORM display_directory .

  DESCRIBE TABLE gt_display_table.
  IF sy-tfill = 0.
    MESSAGE s162(57).
*    LEAVE PROGRAM.
    EXIT.
  ENDIF.

  SORT gt_display_table BY pernr seqnr.
  PERFORM print_display_table.

  SET PF-STATUS 'MAIN'.

ENDFORM.                    " DISPLAY_DIRECTORY
*&---------------------------------------------------------------------*
*&      Form  PRINT_DISPLAY_TABLE
*&---------------------------------------------------------------------*
*       Write the display table to the screen
*----------------------------------------------------------------------*
FORM print_display_table .

  DATA: lv_col_switch   LIKE true,
        lv_old_pernr    LIKE pernr-pernr,
        lv_line_number  LIKE sy-staro.

  lv_line_number = sy-staro.
  IF sy-lsind > 0.
    sy-lsind = sy-lsind - 1.
  ENDIF.
  LOOP AT gt_display_table INTO gs_display_table.
    IF gs_display_table-pernr NE lv_old_pernr.
      lv_old_pernr = gs_display_table-pernr.
      PERFORM print_header USING lv_old_pernr.
      lv_col_switch = true.
    ENDIF.

    IF lv_col_switch = true.
      lv_col_switch = false.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    ELSE.
      lv_col_switch = true.
      FORMAT COLOR COL_NORMAL INTENSIFIED.
    ENDIF.

    WRITE:/1  sy-vline,
           2  gs_display_table-seqnr,
           11 sy-vline,
           12 gs_display_table-frper+4(2),
           14 '.',
           15 gs_display_table-frper(4),
           20 '(',
           21 gs_display_table-frbeg DD/MM/YYYY,
           32 '-',
           34 gs_display_table-frend DD/MM/YYYY,
           44 ')',
           45 sy-vline,
           46 gs_display_table-abkrs,
           51 sy-vline,
           52 gs_display_table-rundt DD/MM/YYYY,
           62 sy-vline,
           63 gs_display_table-runtm,
           71 sy-vline.

    HIDE: gs_display_table-pernr,
          gs_display_table-seqnr.
    AT END OF pernr.
      WRITE:/1 sy-vline, 2 sy-uline(69), 71 sy-vline.
      SKIP 1.
    ENDAT.
  ENDLOOP.
  IF sy-subrc NE 0.
    FORMAT COLOR OFF.
    WRITE: space.
  ENDIF.
  SCROLL LIST INDEX 1 TO FIRST PAGE LINE lv_line_number.


ENDFORM.                    " PRINT_DISPLAY_TABLE
*&---------------------------------------------------------------------*
*&      Form  PRINT_HEADER
*&---------------------------------------------------------------------*
*       Print header
*----------------------------------------------------------------------*
*      -->FV_PERNR  Employee number
*----------------------------------------------------------------------*
FORM print_header  USING    fv_pernr.

  FORMAT COLOR COL_NORMAL INTENSIFIED ON.
  WRITE:/1 sy-vline, 2 sy-uline(70), 71 sy-vline.
  WRITE:/1 sy-vline, 4 text-t01, fv_pernr, 71 sy-vline.

  FORMAT COLOR COL_HEADING INTENSIFIED.
  WRITE:/1 sy-vline, 2 sy-uline(70), 71 sy-vline.
  WRITE:/1  sy-vline,
         2  text-t02,
         11 sy-vline,
         12 text-t03,
         45 sy-vline,
         46 text-t04,
         51 sy-vline,
         52 text-t05,
         62 sy-vline,
         63 text-t06,
         71 sy-vline.
  WRITE:/1 sy-vline, 2 sy-uline(70), 71 sy-vline.

ENDFORM.                    " PRINT_HEADER
*&---------------------------------------------------------------------*
*&      Form  AT_LINE_SELECTION
*&---------------------------------------------------------------------*
*       At Line Selection Event
*----------------------------------------------------------------------*
FORM at_line_selection .

  CHECK gs_display_table-seqnr NE 0.

  PERFORM import_if USING gs_display_table-pernr gs_display_table-seqnr
                          p_fldid.
  PERFORM list_result.

  gs_display_table-seqnr = 0.

ENDFORM.                    " AT_LINE_SELECTION
*&---------------------------------------------------------------------*
*&      Form  IMPORT_IF
*&---------------------------------------------------------------------*
*       Import interface results
*----------------------------------------------------------------------*
*      -->FV_PERNR  Employee number
*      -->FV_SEQNR  text
*      -->FV_FLDID  text
*----------------------------------------------------------------------*
FORM import_if  USING    fv_pernr
                         fv_seqnr
                         fv_fldid.

  DATA: ls_if_key       TYPE ts_if_key,
        ls_if_version   TYPE ts_if_version.

  MOVE: fv_pernr TO ls_if_key-pernr,
        fv_seqnr TO ls_if_key-seqnr,
        fv_fldid TO ls_if_key-fldid.

  CLEAR: gt_p0000[],
         gt_p0001[],
         gt_p0002[],
         gt_p0006[],
         gt_p0008[],
         gt_p0009[],
         gt_p0014[],
         gt_p0019[],
         gt_p0032[],
         gt_p0033[],
         gt_p0041[],
         gt_p0105[],
         gt_p0167[],
         gt_p0168[],
         gt_p0169[],
         gt_p0185[],
         gt_p0461[],
         gt_p0462[],
         gt_p0463[],
         gt_p0464[].

  IMPORT if_version TO ls_if_version
         p0000_exp  TO gt_p0000
         p0001_exp  TO gt_p0001
         p0002_exp  TO gt_p0002
         p0006_exp  TO gt_p0006
         p0008_exp  TO gt_p0008
         p0009_exp  TO gt_p0009
         p0014_exp  TO gt_p0014
         p0019_exp  TO gt_p0019
         p0032_exp  TO gt_p0032
         p0033_exp  TO gt_p0033
         p0041_exp  TO gt_p0041
         p0105_exp  TO gt_p0105
         p0167_exp  TO gt_p0167
         p0168_exp  TO gt_p0168
         p0169_exp  TO gt_p0169
         p0185_exp  TO gt_p0185
         p0461_exp  TO gt_p0461
         p0462_exp  TO gt_p0462
         p0463_exp  TO gt_p0463
         p0464_exp  TO gt_p0464
         FROM DATABASE zhr_pcl2(if) ID ls_if_key.



ENDFORM.                    " IMPORT_IF
*&---------------------------------------------------------------------*
*&      Form  LIST_RESULT
*&---------------------------------------------------------------------*
*       List the PCL2 results
*----------------------------------------------------------------------*
FORM list_result .

  DATA: lv_col_switch TYPE c LENGTH 1.
  DATA: ls_p0000 TYPE ts_p0000.
  DATA: ls_p0001 TYPE ts_p0001.
  DATA: ls_p0002 TYPE ts_p0002.
  DATA: ls_p0006 TYPE ts_p0006.
  DATA: ls_p0008 TYPE ts_p0008.
  DATA: ls_p0009 TYPE ts_p0009.
  DATA: ls_p0014 TYPE ts_p0014.
  DATA: ls_p0019 TYPE ts_p0019.
  DATA: ls_p0032 TYPE ts_p0032.
  DATA: ls_p0033 TYPE ts_p0033.
  DATA: ls_p0041 TYPE ts_p0041.
  DATA: ls_p0105 TYPE ts_p0105.
  DATA: ls_p0167 TYPE ts_p0167.
  DATA: ls_p0168 TYPE ts_p0168.
  DATA: ls_p0169 TYPE ts_p0169.
  DATA: ls_p0185 TYPE ts_p0185.
  DATA: ls_p0461 TYPE ts_p0461.
  DATA: ls_p0462 TYPE ts_p0462.
  DATA: ls_p0463 TYPE ts_p0463.
  DATA: ls_p0464 TYPE ts_p0464.

  PERFORM draw_header_p0000.
  IF gt_p0000[] IS NOT INITIAL.
    LOOP AT gt_p0000 INTO ls_p0000.
      PERFORM draw_entry_p0000 USING ls_p0000.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0000.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0001.
  IF NOT gt_p0001[] IS INITIAL.
    LOOP AT gt_p0001 INTO ls_p0001.
      PERFORM draw_entry_p0001 USING ls_p0001.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0001.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0002.
  IF NOT gt_p0002[] IS INITIAL.
    LOOP AT gt_p0002 INTO ls_p0002.
      PERFORM draw_entry_p0002 USING ls_p0002.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0002.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0006.
  IF NOT gt_p0006[] IS INITIAL.
    LOOP AT gt_p0006 INTO ls_p0006.
      PERFORM draw_entry_p0006 USING ls_p0006.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0006.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0008.
  IF NOT gt_p0008[] IS INITIAL.
    LOOP AT gt_p0008 INTO ls_p0008.
      PERFORM draw_entry_p0008 USING ls_p0008.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0008.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0009.
  IF NOT gt_p0009[] IS INITIAL.
    LOOP AT gt_p0009 INTO ls_p0009.
      PERFORM draw_entry_p0009 USING ls_p0009.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0009.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0014.
  IF NOT gt_p0014[] IS INITIAL.
    LOOP AT gt_p0014 INTO ls_p0014.
      PERFORM draw_entry_p0014 USING ls_p0014.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0014.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0019.
  IF NOT gt_p0019[] IS INITIAL.
    LOOP AT gt_p0019 INTO ls_p0019.
      PERFORM draw_entry_p0019 USING ls_p0019.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0019.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0032.
  IF NOT gt_p0032[] IS INITIAL.
    LOOP AT gt_p0032 INTO ls_p0032.
      PERFORM draw_entry_p0032 USING ls_p0032.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0032.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0033.
  IF NOT gt_p0033[] IS INITIAL.
    LOOP AT gt_p0033 INTO ls_p0033.
      PERFORM draw_entry_p0033 USING ls_p0033.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0033.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0041.
  IF NOT gt_p0041[] IS INITIAL.
    LOOP AT gt_p0041 INTO ls_p0041.
      PERFORM draw_entry_p0041 USING ls_p0041.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0041.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0105.
  IF NOT gt_p0105[] IS INITIAL.
    LOOP AT gt_p0105 INTO ls_p0105.
      PERFORM draw_entry_p0105 USING ls_p0105.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0105.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0167.
  IF NOT gt_p0167[] IS INITIAL.
    LOOP AT gt_p0167 INTO ls_p0167.
      PERFORM draw_entry_p0167 USING ls_p0167.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0167.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0168.
  IF NOT gt_p0168[] IS INITIAL.
    LOOP AT gt_p0168 INTO ls_p0168.
      PERFORM draw_entry_p0168 USING ls_p0168.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0168.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0169.
  IF NOT gt_p0169[] IS INITIAL.
    LOOP AT gt_p0169 INTO ls_p0169.
      PERFORM draw_entry_p0169 USING ls_p0169.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0169.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0185.
  IF NOT gt_p0185[] IS INITIAL.
    LOOP AT gt_p0185 INTO ls_p0185.
      PERFORM draw_entry_p0185 USING ls_p0185.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0185.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0461.
  IF NOT gt_p0461[] IS INITIAL.
    LOOP AT gt_p0461 INTO ls_p0461.
      PERFORM draw_entry_p0461 USING ls_p0461.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0461.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0462.
  IF NOT gt_p0462[] IS INITIAL.
    LOOP AT gt_p0462 INTO ls_p0462.
      PERFORM draw_entry_p0462 USING ls_p0462.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0462.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0463.
  IF NOT gt_p0463[] IS INITIAL.
    LOOP AT gt_p0463 INTO ls_p0463.
      PERFORM draw_entry_p0463 USING ls_p0463.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0463.
    ENDIF.
  ENDIF.
  SKIP 1.
  PERFORM draw_header_p0464.
  IF NOT gt_p0464[] IS INITIAL.
    LOOP AT gt_p0464 INTO ls_p0464.
      PERFORM draw_entry_p0464 USING ls_p0464.
    ENDLOOP.
    IF sy-subrc EQ 0.
      PERFORM draw_line_p0464.
    ENDIF.
  ENDIF.
  SKIP 1.
ENDFORM.                    " LIST_RESULT
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE
*&---------------------------------------------------------------------*
*       Draw a line of given length
*----------------------------------------------------------------------*
FORM draw_line  USING    value(fv_div)
                         value(fv_mod)
                         value(fv_vpos).

  WRITE:/001 sy-vline NO-GAP.
  IF fv_div > 0.
    DO fv_div TIMES.
      WRITE sy-uline(254) NO-GAP.
    ENDDO.
  ENDIF.
  IF fv_mod > 0.
    WRITE sy-uline(fv_mod) NO-GAP.
  ENDIF.
  WRITE AT fv_vpos sy-vline.

ENDFORM.                    " DRAW_LINE
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0000
*&---------------------------------------------------------------------*
*       Draw the header for P0000
*----------------------------------------------------------------------*
FORM draw_header_p0000 .

  IF gt_p0000[] IS INITIAL.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0083) 'P0000 - HR Master Record: Infotype 0000 (Actions)', 0085 sy-vline.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0083) text-042, 0085 sy-vline.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0083) text-041, 0085 sy-vline.
    PERFORM draw_line_p0000.
  ELSE.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0083) 'P0000 - HR Master Record: Infotype 0000 (Actions)', 0085 sy-vline.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0006) 'Action',
           0039 sy-vline, 0040(0010) 'Act.Reason',
           0050 sy-vline, 0051(0010) 'Employment',
           0061 sy-vline, 0062(0010) 'Chngd',
           0072 sy-vline, 0073(0012) 'By',
           0085 sy-vline.
    PERFORM draw_line_p0000.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.

ENDFORM.                    " DRAW_HEADER_P0000
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0000
*&---------------------------------------------------------------------*
*       Draw line for P0000
*----------------------------------------------------------------------*
FORM draw_line_p0000 .
  PERFORM draw_line USING 0000 0083 0085 .
ENDFORM.                    " DRAW_LINE_P0000

*&---------------------------------------------------------------------*
*&      Form  draw_entry_p0000
*&---------------------------------------------------------------------*
FORM draw_entry_p0000  USING    fs_p0000 TYPE ts_p0000.

  WRITE:/0001 sy-vline, 0002(0008) fs_p0000-pernr,
         0010 sy-vline, 0011(0010) fs_p0000-endda,
         0021 sy-vline, 0022(0010) fs_p0000-begda,
         0032 sy-vline, 0033(0006) fs_p0000-massn,
         0039 sy-vline, 0040(0010) fs_p0000-massg,
         0050 sy-vline, 0051(0010) fs_p0000-stat2,
         0061 sy-vline, 0062(0010) fs_p0000-aedtm,
         0072 sy-vline, 0073(0012) fs_p0000-uname,
         0085 sy-vline.

ENDFORM.                    " DRAW_ENTRY_P0000
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0001
*&---------------------------------------------------------------------*
FORM draw_line_p0001.
  PERFORM draw_line USING 0001 0016 0272 .
ENDFORM.                    "DRAW_LINE_P0001
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0001
*&---------------------------------------------------------------------*
FORM draw_header_p0001.
  IF gt_p0001[] IS INITIAL.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0270) 'P0001 - HR Master Record: Infotype 0001 (Org. Assignment)', 0272 sy-vline.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0270) text-042, 0272 sy-vline.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0270) text-041, 0272 sy-vline.
    PERFORM draw_line_p0001.
  ELSE.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0270) 'P0001 - HR Master Record: Infotype 0001 (Org. Assignment)', 0272 sy-vline.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0006) 'CoCode',
           0039 sy-vline, 0040(0009) 'Pers.area',
           0049 sy-vline, 0050(0008) 'EE group',
           0058 sy-vline, 0059(0009) 'EE subgrp',
           0068 sy-vline, 0069(0007) 'Subarea',
           0076 sy-vline, 0077(0009) 'Payr.area',
           0086 sy-vline, 0087(0010) 'Cost Ctr',
           0097 sy-vline, 0098(0009) 'Org. Unit',
           0107 sy-vline, 0108(0008) 'Position',
           0116 sy-vline, 0117(0008) 'Job',
           0125 sy-vline, 0126(0010) 'ADP CoCode',
           0136 sy-vline, 0137(0030) 'Lst/1stNam',
           0167 sy-vline, 0168(0040) 'Name',
           0208 sy-vline, 0209(0015) 'Yysupervisor_id',
           0224 sy-vline, 0225(0014) 'Yymanager_flag',
           0239 sy-vline, 0240(0008) 'Building',
           0248 sy-vline, 0249(0010) 'Chngd',
           0259 sy-vline, 0260(0012) 'By',
           0272 sy-vline.
    PERFORM draw_line_p0001.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0001
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0001
*&---------------------------------------------------------------------*
FORM draw_entry_p0001 USING fs_p0001 TYPE ts_p0001.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0001-pernr,
         0010 sy-vline, 0011(0010) fs_p0001-endda,
         0021 sy-vline, 0022(0010) fs_p0001-begda,
         0032 sy-vline, 0033(0006) fs_p0001-bukrs,
         0039 sy-vline, 0040(0009) fs_p0001-werks,
         0049 sy-vline, 0050(0008) fs_p0001-persg,
         0058 sy-vline, 0059(0009) fs_p0001-persk,
         0068 sy-vline, 0069(0007) fs_p0001-btrtl,
         0076 sy-vline, 0077(0009) fs_p0001-abkrs,
         0086 sy-vline, 0087(0010) fs_p0001-kostl,
         0097 sy-vline, 0098(0009) fs_p0001-orgeh,
         0107 sy-vline, 0108(0008) fs_p0001-plans,
         0116 sy-vline, 0117(0008) fs_p0001-stell,
         0125 sy-vline, 0126(0010) fs_p0001-sacha,
         0136 sy-vline, 0137(0030) fs_p0001-sname,
         0167 sy-vline, 0168(0040) fs_p0001-ename,
         0208 sy-vline, 0209(0015) fs_p0001-yysupervisor_id,
         0224 sy-vline, 0225(0014) fs_p0001-yymanager_flag,
         0239 sy-vline, 0240(0008) fs_p0001-yywork_location,
         0248 sy-vline, 0249(0010) fs_p0001-aedtm,
         0259 sy-vline, 0260(0012) fs_p0001-uname,
         0272 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0001
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0002
*&---------------------------------------------------------------------*
FORM draw_line_p0002.
  PERFORM draw_line USING 0001 0244 0500 .
ENDFORM.                    "DRAW_LINE_P0002
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0002
*&---------------------------------------------------------------------*
FORM draw_header_p0002.
  IF gt_p0002[] IS INITIAL.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0498) 'P0002 - HR Master Record: Infotype 0002 (Personal Data)', 0500 sy-vline.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0498) text-042, 0500 sy-vline.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0498) text-041, 0500 sy-vline.
    PERFORM draw_line_p0002.
  ELSE.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0498) 'P0002 - HR Master Record: Infotype 0002 (Personal Data)', 0500 sy-vline.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0010) 'Initials',
           0043 sy-vline, 0044(0040) 'Last name',
           0084 sy-vline, 0085(0040) 'First name',
           0125 sy-vline, 0126(0080) 'Name',
           0206 sy-vline, 0207(0015) 'Title',
           0222 sy-vline, 0223(0015) 'Prefix',
           0238 sy-vline, 0239(0040) 'Nickname',
           0279 sy-vline, 0280(0040) 'Mid. name',
           0320 sy-vline, 0321(0007) 'FoA key',
           0328 sy-vline, 0329(0006) 'Gender',
           0335 sy-vline, 0336(0010) 'Birth date',
           0346 sy-vline, 0347(0010) 'C.of birth',
           0357 sy-vline, 0358(0005) 'State',
           0363 sy-vline, 0364(0040) 'Birthplace',
           0404 sy-vline, 0405(0009) 'National.',
           0414 sy-vline, 0415(0008) 'Language',
           0423 sy-vline, 0424(0009) 'Mar.Stat.',
           0433 sy-vline, 0434(0010) 'Since',
           0444 sy-vline, 0445(0010) 'No. child.',
           0455 sy-vline, 0456(0020) 'ID number',
           0476 sy-vline, 0477(0010) 'Chngd',
           0487 sy-vline, 0488(0012) 'By',
           0500 sy-vline.
    PERFORM draw_line_p0002.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0002
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0002
*&---------------------------------------------------------------------*
FORM draw_entry_p0002 USING fs_p0002 TYPE ts_p0002.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0002-pernr,
         0010 sy-vline, 0011(0010) fs_p0002-endda,
         0021 sy-vline, 0022(0010) fs_p0002-begda,
         0032 sy-vline, 0033(0010) fs_p0002-inits,
         0043 sy-vline, 0044(0040) fs_p0002-nachn,
         0084 sy-vline, 0085(0040) fs_p0002-vorna,
         0125 sy-vline, 0126(0080) fs_p0002-cname,
         0206 sy-vline, 0207(0015) fs_p0002-titel,
         0222 sy-vline, 0223(0015) fs_p0002-vorsw,
         0238 sy-vline, 0239(0040) fs_p0002-rufnm,
         0279 sy-vline, 0280(0040) fs_p0002-midnm,
         0320 sy-vline, 0321(0007) fs_p0002-anred,
         0328 sy-vline, 0329(0006) fs_p0002-gesch,
         0335 sy-vline, 0336(0010) fs_p0002-gbdat,
         0346 sy-vline, 0347(0010) fs_p0002-gblnd,
         0357 sy-vline, 0358(0005) fs_p0002-gbdep,
         0363 sy-vline, 0364(0040) fs_p0002-gbort,
         0404 sy-vline, 0405(0009) fs_p0002-natio,
         0414 sy-vline, 0415(0008) fs_p0002-sprsl,
         0423 sy-vline, 0424(0009) fs_p0002-famst,
         0433 sy-vline, 0434(0010) fs_p0002-famdt,
         0444 sy-vline, 0445(0010) fs_p0002-anzkd,
         0455 sy-vline, 0456(0020) fs_p0002-perid,
         0476 sy-vline, 0477(0010) fs_p0002-aedtm,
         0487 sy-vline, 0488(0012) fs_p0002-uname,
         0500 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0002
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0006
*&---------------------------------------------------------------------*
FORM draw_line_p0006.
  PERFORM draw_line USING 0001 0148 0404 .
ENDFORM.                    "DRAW_LINE_P0006
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0006
*&---------------------------------------------------------------------*
FORM draw_header_p0006.
  IF gt_p0006[] IS INITIAL.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0402) 'P0006 - HR Master Record: Infotype 0006 (Addresses)', 0404 sy-vline.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0402) text-042, 0404 sy-vline.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0402) text-041, 0404 sy-vline.
    PERFORM draw_line_p0006.
  ELSE.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0402) 'P0006 - HR Master Record: Infotype 0006 (Addresses)', 0404 sy-vline.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'Address',
           0040 sy-vline, 0041(0060) 'Street',
           0101 sy-vline, 0102(0040) 'City',
           0142 sy-vline, 0143(0010) 'PC/City',
           0153 sy-vline, 0154(0007) 'Country',
           0161 sy-vline, 0162(0014) 'Tel.no.',
           0176 sy-vline, 0177(0040) '2nd Add.Ln',
           0217 sy-vline, 0218(0006) 'Region',
           0224 sy-vline, 0225(0004) 'Type',
           0229 sy-vline, 0230(0020) 'Number',
           0250 sy-vline, 0251(0004) 'Type',
           0255 sy-vline, 0256(0020) 'Number',
           0276 sy-vline, 0277(0004) 'Type',
           0281 sy-vline, 0282(0020) 'Number',
           0302 sy-vline, 0303(0004) 'Type',
           0307 sy-vline, 0308(0020) 'Number',
           0328 sy-vline, 0329(0004) 'Type',
           0333 sy-vline, 0334(0020) 'Number',
           0354 sy-vline, 0355(0004) 'Type',
           0359 sy-vline, 0360(0020) 'Number',
           0380 sy-vline, 0381(0010) 'Chngd',
           0391 sy-vline, 0392(0012) 'By',
           0404 sy-vline.
    PERFORM draw_line_p0006.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0006
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0006
*&---------------------------------------------------------------------*
FORM draw_entry_p0006 USING fs_p0006 TYPE ts_p0006.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0006-pernr,
         0010 sy-vline, 0011(0010) fs_p0006-endda,
         0021 sy-vline, 0022(0010) fs_p0006-begda,
         0032 sy-vline, 0033(0007) fs_p0006-anssa,
         0040 sy-vline, 0041(0060) fs_p0006-stras,
         0101 sy-vline, 0102(0040) fs_p0006-ort01,
         0142 sy-vline, 0143(0010) fs_p0006-pstlz,
         0153 sy-vline, 0154(0007) fs_p0006-land1,
         0161 sy-vline, 0162(0014) fs_p0006-telnr,
         0176 sy-vline, 0177(0040) fs_p0006-locat,
         0217 sy-vline, 0218(0006) fs_p0006-state,
         0224 sy-vline, 0225(0004) fs_p0006-com01,
         0229 sy-vline, 0230(0020) fs_p0006-num01,
         0250 sy-vline, 0251(0004) fs_p0006-com02,
         0255 sy-vline, 0256(0020) fs_p0006-num02,
         0276 sy-vline, 0277(0004) fs_p0006-com03,
         0281 sy-vline, 0282(0020) fs_p0006-num03,
         0302 sy-vline, 0303(0004) fs_p0006-com04,
         0307 sy-vline, 0308(0020) fs_p0006-num04,
         0328 sy-vline, 0329(0004) fs_p0006-com05,
         0333 sy-vline, 0334(0020) fs_p0006-num05,
         0354 sy-vline, 0355(0004) fs_p0006-com06,
         0359 sy-vline, 0360(0020) fs_p0006-num06,
         0380 sy-vline, 0381(0010) fs_p0006-aedtm,
         0391 sy-vline, 0392(0012) fs_p0006-uname,
         0404 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0006
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0008
*&---------------------------------------------------------------------*
FORM draw_line_p0008.
  PERFORM draw_line USING 0000 0152 0154 .
ENDFORM.                    "DRAW_LINE_P0008
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0008
*&---------------------------------------------------------------------*
FORM draw_header_p0008.
  IF gt_p0008[] IS INITIAL.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0152) 'P0008 - HR Master Record: Infotype 0008 (Basic Pay)', 0154 sy-vline.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0152) text-042, 0154 sy-vline.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0152) text-041, 0154 sy-vline.
    PERFORM draw_line_p0008.
  ELSE.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0152) 'P0008 - HR Master Record: Infotype 0008 (Basic Pay)', 0154 sy-vline.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'PS type',
           0040 sy-vline, 0041(0007) 'PS Area',
           0048 sy-vline, 0049(0008) 'PS group',
           0057 sy-vline, 0058(0008) 'PS level',
           0066 sy-vline, 0067(0008) 'Currency',
           0075 sy-vline, 0076(0006) 'Bsgrd',
           0082 sy-vline, 0083(0010) 'WkHrs/per.',
           0093 sy-vline, 0094(0016) 'Ann.salary',
           0110 sy-vline, 0111(0004) 'WT',
           0115 sy-vline, 0116(0014) 'Amount',
           0130 sy-vline, 0131(0010) 'Chngd',
           0141 sy-vline, 0142(0012) 'By',
           0154 sy-vline.
    PERFORM draw_line_p0008.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0008
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0008
*&---------------------------------------------------------------------*
FORM draw_entry_p0008 USING fs_p0008 TYPE ts_p0008.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0008-pernr,
         0010 sy-vline, 0011(0010) fs_p0008-endda,
         0021 sy-vline, 0022(0010) fs_p0008-begda,
         0032 sy-vline, 0033(0007) fs_p0008-trfar,
         0040 sy-vline, 0041(0007) fs_p0008-trfgb,
         0048 sy-vline, 0049(0008) fs_p0008-trfgr,
         0057 sy-vline, 0058(0008) fs_p0008-trfst,
         0066 sy-vline, 0067(0008) fs_p0008-waers,
         0075 sy-vline, 0076(0006) fs_p0008-bsgrd,
         0082 sy-vline, 0083(0010) fs_p0008-divgv,
         0093 sy-vline, 0094(0016) fs_p0008-ansal,
         0110 sy-vline, 0111(0004) fs_p0008-lga01,
         0115 sy-vline, 0116(0014) fs_p0008-bet01,
         0130 sy-vline, 0131(0010) fs_p0008-aedtm,
         0141 sy-vline, 0142(0012) fs_p0008-uname,
         0154 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0008
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0009
*&---------------------------------------------------------------------*
FORM draw_line_p0009.
  PERFORM draw_line USING 0001 0033 0289 .
ENDFORM.                    "DRAW_LINE_P0009
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0009
*&---------------------------------------------------------------------*
FORM draw_header_p0009.
  IF gt_p0009[] IS INITIAL.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0287) 'P0009 - HR Master Record: Infotype 0009 (Bank Details)', 0289 sy-vline.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0287) text-042, 0289 sy-vline.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0287) text-041, 0289 sy-vline.
    PERFORM draw_line_p0009.
  ELSE.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0287) 'P0009 - HR Master Record: Infotype 0009 (Bank Details)', 0289 sy-vline.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0014) 'Std Value',
           0047 sy-vline, 0048(0010) 'Stand. Pct',
           0058 sy-vline, 0059(0004) 'Unit',
           0063 sy-vline, 0064(0007) 'BD type',
           0071 sy-vline, 0072(0010) 'Pmt method',
           0082 sy-vline, 0083(0040) 'Payee',
           0123 sy-vline, 0124(0010) 'PC/City',
           0134 sy-vline, 0135(0025) 'City',
           0160 sy-vline, 0161(0009) 'Bank Ctry',
           0170 sy-vline, 0171(0015) 'Bank Key',
           0186 sy-vline, 0187(0018) 'Bank acct',
           0205 sy-vline, 0206(0010) 'Check dig.',
           0216 sy-vline, 0217(0010) 'Ctrl key..',
           0227 sy-vline, 0228(0030) 'Street',
           0258 sy-vline, 0259(0006) 'Region',
           0265 sy-vline, 0266(0010) 'Chngd',
           0276 sy-vline, 0277(0012) 'By',
           0289 sy-vline.
    PERFORM draw_line_p0009.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0009
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0009
*&---------------------------------------------------------------------*
FORM draw_entry_p0009 USING fs_p0009 TYPE ts_p0009.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0009-pernr,
         0010 sy-vline, 0011(0010) fs_p0009-endda,
         0021 sy-vline, 0022(0010) fs_p0009-begda,
         0032 sy-vline, 0033(0014) fs_p0009-betrg,
         0047 sy-vline, 0048(0010) fs_p0009-anzhl,
         0058 sy-vline, 0059(0004) fs_p0009-zeinh,
         0063 sy-vline, 0064(0007) fs_p0009-bnksa,
         0071 sy-vline, 0072(0010) fs_p0009-zlsch,
         0082 sy-vline, 0083(0040) fs_p0009-emftx,
         0123 sy-vline, 0124(0010) fs_p0009-bkplz,
         0134 sy-vline, 0135(0025) fs_p0009-bkort,
         0160 sy-vline, 0161(0009) fs_p0009-banks,
         0170 sy-vline, 0171(0015) fs_p0009-bankl,
         0186 sy-vline, 0187(0018) fs_p0009-bankn,
         0205 sy-vline, 0206(0010) fs_p0009-bankp,
         0216 sy-vline, 0217(0010) fs_p0009-bkont,
         0227 sy-vline, 0228(0030) fs_p0009-stras,
         0258 sy-vline, 0259(0006) fs_p0009-state,
         0265 sy-vline, 0266(0010) fs_p0009-aedtm,
         0276 sy-vline, 0277(0012) fs_p0009-uname,
         0265 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0009
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0014
*&---------------------------------------------------------------------*
FORM draw_line_p0014.
  PERFORM draw_line USING 0000 0074 0076 .
ENDFORM.                    "DRAW_LINE_P0014
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0014
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM draw_header_p0014.
  IF gt_p0014[] IS INITIAL.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0074) 'P0014 - HR Master Record: Infotype 0014 (Recur. Payments/Deds.)', 0076 sy-vline.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0074) text-042, 0076 sy-vline.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0074) text-041, 0076 sy-vline.
    PERFORM draw_line_p0014.
  ELSE.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0074) 'P0014 - HR Master Record: Infotype 0014 (Recur. Payments/Deds.)', 0076 sy-vline.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0004) 'WT',
           0037 sy-vline, 0038(0014) 'Amount',
           0052 sy-vline, 0053(0010) 'Chngd',
           0063 sy-vline, 0064(0012) 'By',
           0076 sy-vline.
    PERFORM draw_line_p0014.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0014
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0014
*&---------------------------------------------------------------------*
FORM draw_entry_p0014 USING fs_p0014 TYPE ts_p0014.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0014-pernr,
         0010 sy-vline, 0011(0010) fs_p0014-endda,
         0021 sy-vline, 0022(0010) fs_p0014-begda,
         0032 sy-vline, 0033(0004) fs_p0014-lgart,
         0037 sy-vline, 0038(0014) fs_p0014-betrg,
         0052 sy-vline, 0053(0010) fs_p0014-aedtm,
         0063 sy-vline, 0064(0012) fs_p0014-uname,
         0076 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0014
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0019
*&---------------------------------------------------------------------*
FORM draw_line_p0019.
  PERFORM draw_line USING 0000 0071 0073 .
ENDFORM.                    "DRAW_LINE_P0019
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0019
*&---------------------------------------------------------------------*
FORM draw_header_p0019.
  IF gt_p0019[] IS INITIAL.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0071) 'P0019 - HR Master Record: Infotype 0019 (Monitoring of Tasks)', 0073 sy-vline.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0071) text-042, 0073 sy-vline.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0071) text-041, 0073 sy-vline.
    PERFORM draw_line_p0019.
  ELSE.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0071) 'P0019 - HR Master Record: Infotype 0019 (Monitoring of Tasks)', 0073 sy-vline.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0005) 'SType',
           0016 sy-vline, 0017(0010) '-',
           0027 sy-vline, 0028(0010) 'Start',
           0038 sy-vline, 0039(0010) 'Task On',
           0049 sy-vline, 0050(0010) 'Chngd',
           0060 sy-vline, 0061(0012) 'By',
           0073 sy-vline.
    PERFORM draw_line_p0019.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0019
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0019
*&---------------------------------------------------------------------*
FORM draw_entry_p0019 USING fs_p0019 TYPE ts_p0019.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0019-pernr,
         0010 sy-vline, 0011(0005) fs_p0019-subty,
         0016 sy-vline, 0017(0010) fs_p0019-endda,
         0027 sy-vline, 0028(0010) fs_p0019-begda,
         0038 sy-vline, 0039(0010) fs_p0019-termn,
         0049 sy-vline, 0050(0010) fs_p0019-aedtm,
         0060 sy-vline, 0061(0012) fs_p0019-uname,
         0073 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0019
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0032
*&---------------------------------------------------------------------*
FORM draw_line_p0032.
  PERFORM draw_line USING 0000 0067 0069 .
ENDFORM.                    "DRAW_LINE_P0032
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0032
*&---------------------------------------------------------------------*
FORM draw_header_p0032.
  IF gt_p0032[] IS INITIAL.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0067) 'P0032 - HR Master Record: Infotype 0032 (Internal Data)', 0069 sy-vline.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0067) text-042, 0069 sy-vline.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0067) text-041, 0069 sy-vline.
    PERFORM draw_line_p0032.
  ELSE.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0067) 'P0032 - HR Master Record: Infotype 0032 (Internal Data)', 0069 sy-vline.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0012) 'PrevPersNo',
           0045 sy-vline, 0046(0010) 'Chngd',
           0056 sy-vline, 0057(0012) 'By',
           0069 sy-vline.
    PERFORM draw_line_p0032.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0032
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0032
*&---------------------------------------------------------------------*
FORM draw_entry_p0032 USING fs_p0032 TYPE ts_p0032.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0032-pernr,
         0010 sy-vline, 0011(0010) fs_p0032-endda,
         0021 sy-vline, 0022(0010) fs_p0032-begda,
         0032 sy-vline, 0033(0012) fs_p0032-pnalt,
         0045 sy-vline, 0046(0010) fs_p0032-aedtm,
         0056 sy-vline, 0057(0012) fs_p0032-uname,
         0069 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0032
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0033
*&---------------------------------------------------------------------*
FORM draw_line_p0033.
  PERFORM draw_line USING 0000 0110 0112 .
ENDFORM.                    "DRAW_LINE_P0033
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0033
*&---------------------------------------------------------------------*
FORM draw_header_p0033.
  IF gt_p0033[] IS INITIAL.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0110) 'P0033 - Infotype 0033: Statistics Exceptions', 0112 sy-vline.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0110) text-042, 0112 sy-vline.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0110) text-041, 0112 sy-vline.
    PERFORM draw_line_p0033.
  ELSE.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0110) 'P0033 - Infotype 0033: Statistics Exceptions', 0112 sy-vline.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0005) 'SType',
           0016 sy-vline, 0017(0010) '-',
           0027 sy-vline, 0028(0010) 'Start',
           0038 sy-vline, 0039(0009) 'Exception',
           0048 sy-vline, 0049(0009) 'Exception',
           0058 sy-vline, 0059(0009) 'Exception',
           0068 sy-vline, 0069(0009) 'Exception',
           0078 sy-vline, 0079(0009) 'Exception',
           0088 sy-vline, 0089(0010) 'Chngd',
           0099 sy-vline, 0100(0012) 'By',
           0112 sy-vline.
    PERFORM draw_line_p0033.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0033
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0033
*&---------------------------------------------------------------------*
FORM draw_entry_p0033 USING fs_p0033 TYPE ts_p0033.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0033-pernr,
         0010 sy-vline, 0011(0005) fs_p0033-subty,
         0016 sy-vline, 0017(0010) fs_p0033-endda,
         0027 sy-vline, 0028(0010) fs_p0033-begda,
         0038 sy-vline, 0039(0009) fs_p0033-aus01,
         0048 sy-vline, 0049(0009) fs_p0033-aus03,
         0058 sy-vline, 0059(0009) fs_p0033-aus04,
         0068 sy-vline, 0069(0009) fs_p0033-aus05,
         0078 sy-vline, 0079(0009) fs_p0033-aus06,
         0088 sy-vline, 0089(0010) fs_p0033-aedtm,
         0099 sy-vline, 0100(0012) fs_p0033-uname,
         0112 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0033
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0041
*&---------------------------------------------------------------------*
FORM draw_line_p0041.
  PERFORM draw_line USING 0001 0052 0308 .
ENDFORM.                    "DRAW_LINE_P0041
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0041
*&---------------------------------------------------------------------*
FORM draw_header_p0041.
  IF gt_p0041[] IS INITIAL.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0306) 'P0041 - HR Master Record: Infotype 0041 (Date Specifications)', 0308 sy-vline.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0306) text-042, 0308 sy-vline.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0306) text-041, 0308 sy-vline.
    PERFORM draw_line_p0041.
  ELSE.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0306) 'P0041 - HR Master Record: Infotype 0041 (Date Specifications)', 0308 sy-vline.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0009) 'Date type',
           0042 sy-vline, 0043(0010) 'Date',
           0053 sy-vline, 0054(0009) 'Date type',
           0063 sy-vline, 0064(0010) 'Date',
           0074 sy-vline, 0075(0009) 'Date type',
           0084 sy-vline, 0085(0010) 'Date',
           0095 sy-vline, 0096(0009) 'Date type',
           0105 sy-vline, 0106(0010) 'Date',
           0116 sy-vline, 0117(0009) 'Date type',
           0126 sy-vline, 0127(0010) 'Date',
           0137 sy-vline, 0138(0009) 'Date type',
           0147 sy-vline, 0148(0010) 'Date',
           0158 sy-vline, 0159(0009) 'Date type',
           0168 sy-vline, 0169(0010) 'Date',
           0179 sy-vline, 0180(0009) 'Date type',
           0189 sy-vline, 0190(0010) 'Date',
           0200 sy-vline, 0201(0009) 'Date type',
           0210 sy-vline, 0211(0010) 'Date',
           0221 sy-vline, 0222(0009) 'Date type',
           0231 sy-vline, 0232(0010) 'Date',
           0242 sy-vline, 0243(0009) 'Date type',
           0252 sy-vline, 0253(0010) 'Date',
           0263 sy-vline, 0264(0009) 'Date type',
           0273 sy-vline, 0274(0010) 'Date',
           0284 sy-vline, 0285(0010) 'Chngd',
           0295 sy-vline, 0296(0012) 'By',
           0308 sy-vline.
    PERFORM draw_line_p0041.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0041
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0041
*&---------------------------------------------------------------------*
FORM draw_entry_p0041 USING fs_p0041 TYPE ts_p0041.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0041-pernr,
         0010 sy-vline, 0011(0010) fs_p0041-endda,
         0021 sy-vline, 0022(0010) fs_p0041-begda,
         0032 sy-vline, 0033(0009) fs_p0041-dar01,
         0042 sy-vline, 0043(0010) fs_p0041-dat01,
         0053 sy-vline, 0054(0009) fs_p0041-dar02,
         0063 sy-vline, 0064(0010) fs_p0041-dat02,
         0074 sy-vline, 0075(0009) fs_p0041-dar03,
         0084 sy-vline, 0085(0010) fs_p0041-dat03,
         0095 sy-vline, 0096(0009) fs_p0041-dar04,
         0105 sy-vline, 0106(0010) fs_p0041-dat04,
         0116 sy-vline, 0117(0009) fs_p0041-dar05,
         0126 sy-vline, 0127(0010) fs_p0041-dat05,
         0137 sy-vline, 0138(0009) fs_p0041-dar06,
         0147 sy-vline, 0148(0010) fs_p0041-dat06,
         0158 sy-vline, 0159(0009) fs_p0041-dar07,
         0168 sy-vline, 0169(0010) fs_p0041-dat07,
         0179 sy-vline, 0180(0009) fs_p0041-dar08,
         0189 sy-vline, 0190(0010) fs_p0041-dat08,
         0200 sy-vline, 0201(0009) fs_p0041-dar09,
         0210 sy-vline, 0211(0010) fs_p0041-dat09,
         0221 sy-vline, 0222(0009) fs_p0041-dar10,
         0231 sy-vline, 0232(0010) fs_p0041-dat10,
         0242 sy-vline, 0243(0009) fs_p0041-dar11,
         0252 sy-vline, 0253(0010) fs_p0041-dat11,
         0263 sy-vline, 0264(0009) fs_p0041-dar12,
         0273 sy-vline, 0274(0010) fs_p0041-dat12,
         0284 sy-vline, 0285(0010) fs_p0041-aedtm,
         0295 sy-vline, 0296(0012) fs_p0041-uname,
         0308 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0041
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0105
*&---------------------------------------------------------------------*
FORM draw_line_p0105.
  PERFORM draw_line USING 0001 0078 0334 .
ENDFORM.                    "DRAW_LINE_P0105
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0105
*&---------------------------------------------------------------------*
FORM draw_header_p0105.
  IF gt_p0105[] IS INITIAL.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0332) 'P0105 - HR Master Record: Infotype 0105 (Communications)', 0334 sy-vline.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0332) text-042, 0334 sy-vline.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0332) text-041, 0334 sy-vline.
    PERFORM draw_line_p0105.
  ELSE.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0332) 'P0105 - HR Master Record: Infotype 0105 (Communications)', 0334 sy-vline.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0004) 'Type',
           0037 sy-vline, 0038(0030) 'System ID',
           0068 sy-vline, 0069(0241) 'Long ID',
           0310 sy-vline, 0311(0010) 'Chngd',
           0321 sy-vline, 0322(0012) 'By',
           0334 sy-vline.
    PERFORM draw_line_p0105.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0105
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0105
*&---------------------------------------------------------------------*
FORM draw_entry_p0105 USING fs_p0105 TYPE ts_p0105.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0105-pernr,
         0010 sy-vline, 0011(0010) fs_p0105-endda,
         0021 sy-vline, 0022(0010) fs_p0105-begda,
         0032 sy-vline, 0033(0004) fs_p0105-usrty,
         0037 sy-vline, 0038(0030) fs_p0105-usrid,
         0068 sy-vline, 0069(0241) fs_p0105-usrid_long,
         0310 sy-vline, 0311(0010) fs_p0105-aedtm,
         0321 sy-vline, 0322(0012) fs_p0105-uname,
         0334 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0105
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0167
*&---------------------------------------------------------------------*
FORM draw_line_p0167.
  PERFORM draw_line USING 0000 0167 0169 .
ENDFORM.                    "DRAW_LINE_P0167
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0167
*&---------------------------------------------------------------------*
FORM draw_header_p0167.
  IF gt_p0167[] IS INITIAL.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0167) 'P0167 - HR Master Record: Infotype 0167 (Health Plans)', 0169 sy-vline.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0167) text-042, 0169 sy-vline.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0167) text-041, 0169 sy-vline.
    PERFORM draw_line_p0167.
  ELSE.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0167) 'P0167 - HR Master Record: Infotype 0167 (Health Plans)', 0169 sy-vline.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'BenArea',
           0040 sy-vline, 0041(0009) 'Plan type',
           0050 sy-vline, 0051(0004) 'Plan',
           0055 sy-vline, 0056(0009) '1st PGrpg',
           0065 sy-vline, 0066(0009) '2nd PGrpg',
           0075 sy-vline, 0076(0010) 'Eligible',
           0086 sy-vline, 0087(0010) 'Override',
           0097 sy-vline, 0098(0010) 'Part.date',
           0108 sy-vline, 0109(0006) 'Option',
           0115 sy-vline, 0116(0014) 'Alt.',
           0130 sy-vline, 0131(0014) 'Costs',
           0145 sy-vline, 0146(0010) 'Chngd',
           0156 sy-vline, 0157(0012) 'By',
           0169 sy-vline.
    PERFORM draw_line_p0167.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0167
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0167
*&---------------------------------------------------------------------*
FORM draw_entry_p0167 USING fs_p0167 TYPE ts_p0167.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0167-pernr,
         0010 sy-vline, 0011(0010) fs_p0167-endda,
         0021 sy-vline, 0022(0010) fs_p0167-begda,
         0032 sy-vline, 0033(0007) fs_p0167-barea,
         0040 sy-vline, 0041(0009) fs_p0167-pltyp,
         0050 sy-vline, 0051(0004) fs_p0167-bplan,
         0055 sy-vline, 0056(0009) fs_p0167-bengr,
         0065 sy-vline, 0066(0009) fs_p0167-bstat,
         0075 sy-vline, 0076(0010) fs_p0167-elidt,
         0086 sy-vline, 0087(0010) fs_p0167-eldto,
         0097 sy-vline, 0098(0010) fs_p0167-pardt,
         0108 sy-vline, 0109(0006) fs_p0167-bopti,
         0115 sy-vline, 0116(0014) fs_p0167-cstov,
         0130 sy-vline, 0131(0014) fs_p0167-eecst,
         0145 sy-vline, 0146(0010) fs_p0167-aedtm,
         0156 sy-vline, 0157(0012) fs_p0167-uname,
         0169 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0167
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0168
*&---------------------------------------------------------------------*
FORM draw_line_p0168.
  PERFORM draw_line USING 0000 0227 0229 .
ENDFORM.                    "DRAW_LINE_P0168
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0168
*&---------------------------------------------------------------------*
FORM draw_header_p0168.
  IF gt_p0168[] IS INITIAL.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0227) 'P0168 - HR Master Record: Infotype 0168 (Insurance Plans)', 0229 sy-vline.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0227) text-042, 0229 sy-vline.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0227) text-041, 0229 sy-vline.
    PERFORM draw_line_p0168.
  ELSE.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0227) 'P0168 - HR Master Record: Infotype 0168 (Insurance Plans)', 0229 sy-vline.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'BenArea',
           0040 sy-vline, 0041(0009) 'Plan type',
           0050 sy-vline, 0051(0004) 'Plan',
           0055 sy-vline, 0056(0009) '1st PGrpg',
           0065 sy-vline, 0066(0009) '2nd PGrpg',
           0075 sy-vline, 0076(0010) 'Eligible',
           0086 sy-vline, 0087(0010) 'Override',
           0097 sy-vline, 0098(0010) 'Part.date',
           0108 sy-vline, 0109(0006) 'Option',
           0115 sy-vline, 0116(0016) 'Override',
           0132 sy-vline, 0133(0016) 'Alternat.',
           0149 sy-vline, 0150(0010) 'Number',
           0160 sy-vline, 0161(0014) 'Alt.',
           0175 sy-vline, 0176(0014) 'Bonus Cost',
           0190 sy-vline, 0191(0014) 'Costs',
           0205 sy-vline, 0206(0010) 'Chngd',
           0216 sy-vline, 0217(0012) 'By',
           0229 sy-vline.
    PERFORM draw_line_p0168.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0168
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0168
*&---------------------------------------------------------------------*
FORM draw_entry_p0168 USING fs_p0168 TYPE ts_p0168.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0168-pernr,
         0010 sy-vline, 0011(0010) fs_p0168-endda,
         0021 sy-vline, 0022(0010) fs_p0168-begda,
         0032 sy-vline, 0033(0007) fs_p0168-barea,
         0040 sy-vline, 0041(0009) fs_p0168-pltyp,
         0050 sy-vline, 0051(0004) fs_p0168-bplan,
         0055 sy-vline, 0056(0009) fs_p0168-bengr,
         0065 sy-vline, 0066(0009) fs_p0168-bstat,
         0075 sy-vline, 0076(0010) fs_p0168-elidt,
         0086 sy-vline, 0087(0010) fs_p0168-eldto,
         0097 sy-vline, 0098(0010) fs_p0168-pardt,
         0108 sy-vline, 0109(0006) fs_p0168-bcovr,
         0115 sy-vline, 0116(0016) fs_p0168-salov,
         0132 sy-vline, 0133(0016) fs_p0168-covov,
         0149 sy-vline, 0150(0010) fs_p0168-addno,
         0160 sy-vline, 0161(0014) fs_p0168-cstov,
         0175 sy-vline, 0176(0014) fs_p0168-bncst,
         0190 sy-vline, 0191(0014) fs_p0168-eecst,
         0205 sy-vline, 0206(0010) fs_p0168-aedtm,
         0216 sy-vline, 0217(0012) fs_p0168-uname,
         0229 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0168
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0169
*&---------------------------------------------------------------------*
FORM draw_line_p0169.
  PERFORM draw_line USING 0000 0208 0210 .
ENDFORM.                    "DRAW_LINE_P0169
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0169
*&---------------------------------------------------------------------*
FORM draw_header_p0169.
  IF gt_p0169[] IS INITIAL.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0208) 'P0169 - HR Master Record: Infotype 0169 (Savings Plans)', 0210 sy-vline.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0208) text-042, 0210 sy-vline.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0208) text-041, 0210 sy-vline.
    PERFORM draw_line_p0169.
  ELSE.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0208) 'P0169 - HR Master Record: Infotype 0169 (Savings Plans)', 0210 sy-vline.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'BenArea',
           0040 sy-vline, 0041(0009) 'Plan type',
           0050 sy-vline, 0051(0004) 'Plan',
           0055 sy-vline, 0056(0009) '1st PGrpg',
           0065 sy-vline, 0066(0009) '2nd PGrpg',
           0075 sy-vline, 0076(0010) 'Eligible',
           0086 sy-vline, 0087(0010) 'Override',
           0097 sy-vline, 0098(0010) 'Part.date',
           0108 sy-vline, 0109(0014) 'Pre-Tax',
           0123 sy-vline, 0124(0007) 'Pre-Tax',
           0131 sy-vline, 0132(0010) 'Pre-Tax',
           0142 sy-vline, 0143(0014) 'Post-Tax',
           0157 sy-vline, 0158(0008) 'Post-Tax',
           0166 sy-vline, 0167(0010) 'Post-Tax',
           0177 sy-vline, 0178(0008) 'Post-Tax',
           0186 sy-vline, 0187(0010) 'Chngd',
           0197 sy-vline, 0198(0012) 'By',
           0210 sy-vline.
    PERFORM draw_line_p0169.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0169
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0169
*&---------------------------------------------------------------------*
FORM draw_entry_p0169 USING fs_p0169 TYPE ts_p0169.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0169-pernr,
         0010 sy-vline, 0011(0010) fs_p0169-endda,
         0021 sy-vline, 0022(0010) fs_p0169-begda,
         0032 sy-vline, 0033(0007) fs_p0169-barea,
         0040 sy-vline, 0041(0009) fs_p0169-pltyp,
         0050 sy-vline, 0051(0004) fs_p0169-bplan,
         0055 sy-vline, 0056(0009) fs_p0169-bengr,
         0065 sy-vline, 0066(0009) fs_p0169-bstat,
         0075 sy-vline, 0076(0010) fs_p0169-elidt,
         0086 sy-vline, 0087(0010) fs_p0169-eldto,
         0097 sy-vline, 0098(0010) fs_p0169-pardt,
         0108 sy-vline, 0109(0014) fs_p0169-eeamt,
         0123 sy-vline, 0124(0007) fs_p0169-eepct,
         0131 sy-vline, 0132(0010) fs_p0169-eeunt,
         0142 sy-vline, 0143(0014) fs_p0169-ptamt,
         0157 sy-vline, 0158(0008) fs_p0169-ptpct,
         0166 sy-vline, 0167(0010) fs_p0169-ptunt,
         0177 sy-vline, 0178(0008) fs_p0169-psttx,
         0186 sy-vline, 0187(0010) fs_p0169-aedtm,
         0197 sy-vline, 0198(0012) fs_p0169-uname,
         0210 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0169
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0185
*&---------------------------------------------------------------------*
FORM draw_line_p0185.
  PERFORM draw_line USING 0000 0093 0095 .
ENDFORM.                    "DRAW_LINE_P0185
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0185
*&---------------------------------------------------------------------*
FORM draw_header_p0185.
  IF gt_p0185[] IS INITIAL.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0093) 'P0185 - Personnel Master Record Infotype 0185 (Identification SEA)', 0095 sy-vline.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0093) text-042, 0095 sy-vline.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0093) text-041, 0095 sy-vline.
    PERFORM draw_line_p0185.
  ELSE.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0093) 'P0185 - Personnel Master Record Infotype 0185 (Identification SEA)', 0095 sy-vline.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0007) 'IC Type',
           0040 sy-vline, 0041(0030) 'ID No',
           0071 sy-vline, 0072(0010) 'Chngd',
           0082 sy-vline, 0083(0012) 'By',
           0095 sy-vline.
    PERFORM draw_line_p0185.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0185
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0185
*&---------------------------------------------------------------------*
FORM draw_entry_p0185 USING fs_p0185 TYPE ts_p0185.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0185-pernr,
         0010 sy-vline, 0011(0010) fs_p0185-endda,
         0021 sy-vline, 0022(0010) fs_p0185-begda,
         0032 sy-vline, 0033(0007) fs_p0185-ictyp,
         0040 sy-vline, 0041(0030) fs_p0185-icnum,
         0071 sy-vline, 0072(0010) fs_p0185-aedtm,
         0082 sy-vline, 0083(0012) fs_p0185-uname,
         0095 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0185
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0461
*&---------------------------------------------------------------------*
FORM draw_line_p0461.
  PERFORM draw_line USING 0000 0065 0067 .
ENDFORM.                    "DRAW_LINE_P0461
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0461
*&---------------------------------------------------------------------*
FORM draw_header_p0461.
  IF gt_p0461[] IS INITIAL.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0065) 'P0461 - HR Master Record for Infotype 0461', 0067 sy-vline.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0065) text-042, 0067 sy-vline.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0065) text-041, 0067 sy-vline.
    PERFORM draw_line_p0461.
  ELSE.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0065) 'P0461 - HR Master Record for Infotype 0461', 0067 sy-vline.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0010) 'Prov.empl.',
           0043 sy-vline, 0044(0010) 'Chngd',
           0054 sy-vline, 0055(0012) 'By',
           0067 sy-vline.
    PERFORM draw_line_p0461.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0461
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0461
*&---------------------------------------------------------------------*
FORM draw_entry_p0461 USING fs_p0461 TYPE ts_p0461.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0461-pernr,
         0010 sy-vline, 0011(0010) fs_p0461-endda,
         0021 sy-vline, 0022(0010) fs_p0461-begda,
         0032 sy-vline, 0033(0010) fs_p0461-wrkar,
         0043 sy-vline, 0044(0010) fs_p0461-aedtm,
         0054 sy-vline, 0055(0012) fs_p0461-uname,
         0067 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0461
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0462
*&---------------------------------------------------------------------*
FORM draw_line_p0462.
  PERFORM draw_line USING 0000 0098 0100 .
ENDFORM.                    "DRAW_LINE_P0462
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0462
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM draw_header_p0462.
  IF gt_p0462[] IS INITIAL.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0098) 'P0462 - HR Master Record for Infotype 0462', 0100 sy-vline.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0098) text-042, 0100 sy-vline.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0098) text-041, 0100 sy-vline.
    PERFORM draw_line_p0462.
  ELSE.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0098) 'P0462 - HR Master Record for Infotype 0462', 0100 sy-vline.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0010) 'Prov.empl.',
           0043 sy-vline, 0044(0010) 'Tot credit',
           0054 sy-vline, 0055(0010) 'TotCredit',
           0065 sy-vline, 0066(0010) 'Tot non-in',
           0076 sy-vline, 0077(0010) 'Chngd',
           0087 sy-vline, 0088(0012) 'By',
           0100 sy-vline.
    PERFORM draw_line_p0462.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0462
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0462
*&---------------------------------------------------------------------*
FORM draw_entry_p0462 USING fs_p0462 TYPE ts_p0462.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0462-pernr,
         0010 sy-vline, 0011(0010) fs_p0462-endda,
         0021 sy-vline, 0022(0010) fs_p0462-begda,
         0032 sy-vline, 0033(0010) fs_p0462-wrkar,
         0043 sy-vline, 0044(0010) fs_p0462-totcq,
         0054 sy-vline, 0055(0010) fs_p0462-totcp,
         0065 sy-vline, 0066(0010) fs_p0462-tninp,
         0076 sy-vline, 0077(0010) fs_p0462-aedtm,
         0087 sy-vline, 0088(0012) fs_p0462-uname,
         0100 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0462
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0463
*&---------------------------------------------------------------------*
FORM draw_line_p0463.
  PERFORM draw_line USING 0000 0076 0078 .
ENDFORM.                    "DRAW_LINE_P0463
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0463
*&---------------------------------------------------------------------*
FORM draw_header_p0463.
  IF gt_p0463[] IS INITIAL.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0076) 'P0463 - HR Master Record for Infotype 0463', 0078 sy-vline.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0076) text-042, 0078 sy-vline.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0076) text-041, 0078 sy-vline.
    PERFORM draw_line_p0463.
  ELSE.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0076) 'P0463 - HR Master Record for Infotype 0463', 0078 sy-vline.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0010) 'Tot credit',
           0043 sy-vline, 0044(0010) 'Tot non-in',
           0054 sy-vline, 0055(0010) 'Chngd',
           0065 sy-vline, 0066(0012) 'By',
           0078 sy-vline.
    PERFORM draw_line_p0463.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0463
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0463
*&---------------------------------------------------------------------*
FORM draw_entry_p0463 USING fs_p0463 TYPE ts_p0463.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0463-pernr,
         0010 sy-vline, 0011(0010) fs_p0463-endda,
         0021 sy-vline, 0022(0010) fs_p0463-begda,
         0032 sy-vline, 0033(0010) fs_p0463-totcr,
         0043 sy-vline, 0044(0010) fs_p0463-tnind,
         0054 sy-vline, 0055(0010) fs_p0463-aedtm,
         0065 sy-vline, 0066(0012) fs_p0463-uname,
         0078 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0463
*&---------------------------------------------------------------------*
*&      Form  DRAW_LINE_P0464
*&---------------------------------------------------------------------*
FORM draw_line_p0464.
  PERFORM draw_line USING 0001 0100 0356 .
ENDFORM.                    "DRAW_LINE_P0464
*&---------------------------------------------------------------------*
*&      Form  DRAW_HEADER_P0464
*&---------------------------------------------------------------------*
FORM draw_header_p0464.
  IF gt_p0464[] IS INITIAL.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0354) 'P0464 - HR Master Record for Infotype 0464', 0356 sy-vline.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_HEADING INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0354) text-042, 0356 sy-vline.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:/0001 sy-vline, 0002(0354) text-041, 0356 sy-vline.
    PERFORM draw_line_p0464.
  ELSE.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_NORMAL INTENSIFIED ON.
    WRITE:/0001 sy-vline, 0002(0354) 'P0464 - HR Master Record for Infotype 0464', 0356 sy-vline.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_HEADING INTENSIFIED.
    WRITE:/0001 sy-vline, 0002(0008) 'Pers.No.',
           0010 sy-vline, 0011(0010) '-',
           0021 sy-vline, 0022(0010) 'Start',
           0032 sy-vline, 0033(0008) 'Tax auth',
           0041 sy-vline, 0042(0010) 'Tax Indic.',
           0052 sy-vline, 0053(0008) 'Tax auth',
           0061 sy-vline, 0062(0010) 'Tax Indic.',
           0072 sy-vline, 0073(0008) 'Tax auth',
           0081 sy-vline, 0082(0010) 'Tax Indic.',
           0092 sy-vline, 0093(0008) 'Tax auth',
           0101 sy-vline, 0102(0010) 'Tax Indic.',
           0112 sy-vline, 0113(0008) 'Tax auth',
           0121 sy-vline, 0122(0010) 'Tax Indic.',
           0132 sy-vline, 0133(0008) 'Tax auth',
           0141 sy-vline, 0142(0010) 'Tax Indic.',
           0152 sy-vline, 0153(0008) 'Tax auth',
           0161 sy-vline, 0162(0010) 'Tax Indic.',
           0172 sy-vline, 0173(0008) 'Tax auth',
           0181 sy-vline, 0182(0010) 'Tax Indic.',
           0192 sy-vline, 0193(0008) 'Tax auth',
           0201 sy-vline, 0202(0010) 'Tax Indic.',
           0212 sy-vline, 0213(0008) 'Tax auth',
           0221 sy-vline, 0222(0010) 'Tax Indic.',
           0232 sy-vline, 0233(0008) 'Tax auth',
           0241 sy-vline, 0242(0010) 'Tax Indic.',
           0252 sy-vline, 0253(0008) 'Tax auth',
           0261 sy-vline, 0262(0010) 'Tax Indic.',
           0272 sy-vline, 0273(0008) 'Tax auth',
           0281 sy-vline, 0282(0010) 'Tax Indic.',
           0292 sy-vline, 0293(0008) 'Tax auth',
           0301 sy-vline, 0302(0010) 'Tax Indic.',
           0312 sy-vline, 0313(0008) 'Tax auth',
           0321 sy-vline, 0322(0010) 'Tax Indic.',
           0332 sy-vline, 0333(0010) 'Chngd',
           0343 sy-vline, 0344(0012) 'By',
           0356 sy-vline.
    PERFORM draw_line_p0464.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  ENDIF.
ENDFORM.                    "DRAW_HEADER_P0464
*&---------------------------------------------------------------------*
*&      Form  DRAW_ENTRY_P0464
*&---------------------------------------------------------------------*
FORM draw_entry_p0464 USING fs_p0464 TYPE ts_p0464.
  WRITE:/0001 sy-vline, 0002(0008) fs_p0464-pernr,
         0010 sy-vline, 0011(0010) fs_p0464-endda,
         0021 sy-vline, 0022(0010) fs_p0464-begda,
         0032 sy-vline, 0033(0008) fs_p0464-tax01,
         0041 sy-vline, 0042(0010) fs_p0464-exi01,
         0052 sy-vline, 0053(0008) fs_p0464-tax02,
         0061 sy-vline, 0062(0010) fs_p0464-exi02,
         0072 sy-vline, 0073(0008) fs_p0464-tax03,
         0081 sy-vline, 0082(0010) fs_p0464-exi03,
         0092 sy-vline, 0093(0008) fs_p0464-tax04,
         0101 sy-vline, 0102(0010) fs_p0464-exi04,
         0112 sy-vline, 0113(0008) fs_p0464-tax05,
         0121 sy-vline, 0122(0010) fs_p0464-exi05,
         0132 sy-vline, 0133(0008) fs_p0464-tax06,
         0141 sy-vline, 0142(0010) fs_p0464-exi06,
         0152 sy-vline, 0153(0008) fs_p0464-tax07,
         0161 sy-vline, 0162(0010) fs_p0464-exi07,
         0172 sy-vline, 0173(0008) fs_p0464-tax08,
         0181 sy-vline, 0182(0010) fs_p0464-exi08,
         0192 sy-vline, 0193(0008) fs_p0464-tax09,
         0201 sy-vline, 0202(0010) fs_p0464-exi09,
         0212 sy-vline, 0213(0008) fs_p0464-tax10,
         0221 sy-vline, 0222(0010) fs_p0464-exi10,
         0232 sy-vline, 0233(0008) fs_p0464-tax11,
         0241 sy-vline, 0242(0010) fs_p0464-exi11,
         0252 sy-vline, 0253(0008) fs_p0464-tax12,
         0261 sy-vline, 0262(0010) fs_p0464-exi12,
         0272 sy-vline, 0273(0008) fs_p0464-tax13,
         0281 sy-vline, 0282(0010) fs_p0464-exi13,
         0292 sy-vline, 0293(0008) fs_p0464-tax14,
         0301 sy-vline, 0302(0010) fs_p0464-exi14,
         0312 sy-vline, 0313(0008) fs_p0464-tax15,
         0321 sy-vline, 0322(0010) fs_p0464-exi15,
         0332 sy-vline, 0333(0010) fs_p0464-aedtm,
         0343 sy-vline, 0344(0012) fs_p0464-uname,
         0356 sy-vline.
ENDFORM.                    "DRAW_ENTRY_P0464