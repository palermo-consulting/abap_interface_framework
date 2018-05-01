*AHRK061571
* after deletion set infotype 415 'exported until' and 'earliest master
* data change'

INCLUDE zhru_pcl2_delete_new_d01.
*INCLUDE zhru_adp_ev5_us_pcl2_del_d01.
*INCLUDE rpcifu02_top.

************************************************************************
* Tables                                                               *
************************************************************************

TABLES: zhr_pcl2,
        pernr.


************************************************************************
* Parameters and Select Options                                        *
************************************************************************

PARAMETERS:     fldid             LIKE t532a-fldid.
SELECT-OPTIONS: persons           FOR pernr-pernr.
SELECT-OPTIONS: abkrs             FOR pernr-abkrs.

************************************************************************
* Includes                                                             *
************************************************************************

INCLUDE rpc2if00.


************************************************************************
* Data                                                                 *
************************************************************************

RANGES: sortfield                 FOR zhr_pcl2-srtfd.

DATA: true(1)                     TYPE c VALUE '1',
      false                       LIKE true VALUE '0'.

DATA: personnel_number            LIKE pernr-pernr,
      hide_index                  LIKE sy-tabix,
      hide_marks(1)               TYPE c,
      hide_input                  LIKE true,
      dialog_return               LIKE sy-xcode.


DATA: BEGIN OF del_database_table OCCURS 20,
        relid                     LIKE zhr_pcl2-relid,
        srtfd                     LIKE zhr_pcl2-srtfd,
      END OF del_database_table.

INFOTYPES: 0001.
DATA: found TYPE i.

DATA: client_role TYPE c.                               "XJS note 389720

DATA: prot_mess LIKE balmi OCCURS 100 WITH HEADER LINE. "XJS note 390032

DATA: pernr_tab TYPE HASHED TABLE OF p_pernr WITH UNIQUE KEY table_line,
      count TYPE i,
      single_pernr LIKE pernr-pernr.

************************************************************************
START-OF-SELECTION.
************************************************************************

  DATA:   ls_id_key           TYPE ts_id_key,
          ls_if_version       TYPE ts_if_version,
          ls_if_results       TYPE ts_if_results,
          lt_if_results       TYPE tt_if_results.

  LOOP AT persons.
    MOVE-CORRESPONDING persons TO sortfield.
    sortfield-low+8(4) = fldid.
    sortfield-high+8(4) = fldid.
    APPEND sortfield.
  ENDLOOP.
  READ TABLE sortfield INDEX 1.
  IF sy-subrc NE 0.
    sortfield-low+0(8)  = '++++++++'.
    sortfield-low+8(4)  = fldid.
    sortfield-sign      = 'I'.
    sortfield-option    = 'CP'.
    APPEND sortfield.
  ENDIF.
  SELECT * FROM zhr_pcl2 WHERE relid = 'ID'
                       AND srtfd IN sortfield
                       AND srtf2 = '00'.
    CHECK zhr_pcl2-srtfd+8(4) = fldid.
    personnel_number = zhr_pcl2-srtfd(8).
    IF NOT abkrs IS INITIAL.
      found = 0.
      REFRESH p0001.
      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = personnel_number
          infty     = '0001'
        TABLES
          infty_tab = p0001
        EXCEPTIONS
          OTHERS    = 0.
      LOOP AT p0001.
        IF p0001-abkrs IN abkrs.
          found = 1.
          EXIT.
        ENDIF.
      ENDLOOP.
      CHECK found = 1.
    ENDIF.
    ls_id_key-pernr = personnel_number.
    ls_id_key-fldid = fldid.
    IMPORT if_version  TO ls_if_version
           if_results  TO lt_if_results
           FROM DATABASE zhr_pcl2(id) ID ls_id_key.
    CLEAR delete_table.
    delete_table-pernr = personnel_number.
    LOOP AT lt_if_results INTO ls_if_results.
      MOVE-CORRESPONDING ls_if_results TO delete_table.
      delete_table-tabindex = sy-tabix.
      APPEND delete_table.
    ENDLOOP.
  ENDSELECT.

  DESCRIBE TABLE delete_table.
  IF sy-tfill = 0.
    MESSAGE s162(57).
*    LEAVE PROGRAM.
    EXIT.
  ENDIF.

  SORT delete_table BY pernr seqnr.

  PERFORM set_delete_sign.

*********  XMS
  CALL SCREEN 2000.
* PERFORM PRINT_DELETE_TABLE.

* XJS note 389720 {
  CALL FUNCTION 'TR_SYS_PARAMS'
    IMPORTING
      system_client_role = client_role.

  IF client_role = 'P'.
    SET PF-STATUS 'MAIN' EXCLUDING 'MALL'.
  ELSE.
    SET PF-STATUS 'MAIN'.
  ENDIF.
* XJS note 389720 }

************************************************************************
AT USER-COMMAND.
************************************************************************

  PERFORM maintain_list.
  CASE sy-ucomm.
    WHEN 'DELE'.
      PERFORM delete_marked_results.
    WHEN 'MARK'.
      PERFORM mark_all.
    WHEN 'MALL'.
      PERFORM mark_all_entries.
    WHEN 'DALL'.
      PERFORM deselect_all.
    WHEN OTHERS.
      PERFORM print_delete_table.
  ENDCASE.


************************************************************************
* FORMs                                                                *
************************************************************************


FORM set_delete_sign.

  DATA: set_sign LIKE true.

  LOOP AT delete_table.
    set_sign = false.
    AT END OF pernr.
      set_sign = true.
    ENDAT.
    delete_table-dsign = set_sign.
    MODIFY delete_table.
  ENDLOOP.

ENDFORM.                    "SET_DELETE_SIGN


*&--------------------------------------------------------------------*
*&      Form  MAINTAIN_LIST
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM maintain_list.

  DATA: save_pernr LIKE delete_table-pernr,
        save_inper LIKE delete_table-inper,
        save_inend LIKE delete_table-inend,
        save_inpty LIKE delete_table-inpty,
        save_inpid LIKE delete_table-inpid,
        save_statu LIKE delete_table-statu,
        save_rundt LIKE delete_table-rundt,
        save_runtm LIKE delete_table-runtm.

  DO.
    CLEAR: delete_table-pernr,
           delete_table-seqnr,
           delete_table-marks,
           hide_index,
           hide_input.
    READ LINE sy-index.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
    CHECK hide_index NE 0 AND
          hide_input = true.
    READ TABLE delete_table INDEX hide_index.
    delete_table-marks = sy-lisel+1(1).
    MODIFY delete_table INDEX hide_index.
    save_pernr = delete_table-pernr.
    save_inper = delete_table-inper.
    save_inend = delete_table-inend.
    save_inpty = delete_table-inpty.
    save_inpid = delete_table-inpid.
    save_statu = delete_table-statu.
    save_rundt = delete_table-rundt.
    save_runtm = delete_table-runtm.
    LOOP AT delete_table WHERE pernr = save_pernr
                           AND inper = save_inper
                           AND inend = save_inend
                           AND inpty = save_inpty
                           AND inpid = save_inpid
                           AND statu = save_statu
                           AND rundt = save_rundt
                           AND runtm = save_runtm.
      delete_table-marks = sy-lisel+1(1).
      MODIFY delete_table.
    ENDLOOP.
  ENDDO.

ENDFORM.                    "MAINTAIN_LIST


*&--------------------------------------------------------------------*
*&      Form  DELETE_MARKED_RESULTS
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM delete_marked_results.

  DATA: old_pernr LIKE pernr-pernr.
  DATA: current_pernr LIKE pernr-pernr.                     "AHRK061571
  DATA: answer.
  DATA: text(80) TYPE c.

  CLEAR dialog_return.

  CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'        "AHRK026165 begin
       EXPORTING
            textline1    = text-001
            titel        = text-002
            start_column = 13
       IMPORTING
            answer       = answer.

  CHECK answer = 'J'.                                    "AHRK026165 end

  IF client_role = 'P'.
    PERFORM append_log TABLES delete_table.
  ENDIF.

  count = 0.
  LOOP AT delete_table WHERE NOT marks IS INITIAL.
    INSERT delete_table-pernr INTO TABLE pernr_tab.
    IF sy-subrc = 0.
      personnel_number = delete_table-pernr.
    ENDIF.
  ENDLOOP.
  DESCRIBE TABLE pernr_tab LINES count.
  IF count = 1.
    single_pernr = personnel_number.
  ENDIF.

  LOOP AT delete_table WHERE NOT marks IS INITIAL.

    IF delete_table-pernr NE old_pernr.

      current_pernr = delete_table-pernr.

      IF NOT old_pernr IS INITIAL.
        PERFORM delete_results USING old_pernr.
      ENDIF.
      old_pernr = delete_table-pernr.
      REFRESH del_database_table.
      del_database_table-relid = 'IF'.
      ls_id_key-pernr = delete_table-pernr.
      ls_id_key-fldid = fldid.
      IMPORT if_version  TO ls_if_version
             if_results  TO lt_if_results
             FROM DATABASE zhr_pcl2(id) ID ls_id_key.
    ENDIF.
    READ TABLE lt_if_results INTO ls_if_results WITH KEY delete_table-seqnr.
    IF sy-subrc = 0.
      DELETE lt_if_results INDEX sy-tabix.
    ENDIF.
    DELETE delete_table.
    CLEAR del_database_table-srtfd.
    del_database_table-srtfd(8) = delete_table-pernr.
    del_database_table-srtfd+8  = delete_table-seqnr.
    del_database_table-srtfd+17 = fldid.
    APPEND del_database_table.
  ENDLOOP.
  READ TABLE del_database_table INDEX 1.
  IF sy-subrc = 0.
    PERFORM delete_results USING old_pernr.
* XJS note 390032 {
    IF client_role = 'P'.
      PERFORM update_log.
    ENDIF.
* XJS note 390032 }
  ELSE.
    LEAVE PROGRAM.
  ENDIF.
  CLEAR old_pernr.
  LOOP AT delete_table.
    IF delete_table-pernr <> old_pernr.
      ls_id_key-pernr = delete_table-pernr.
      ls_id_key-fldid = fldid.
      IMPORT if_version  TO ls_if_version
             if_results  TO lt_if_results
             FROM DATABASE zhr_pcl2(id) ID ls_id_key.
    ENDIF.
    LOOP AT lt_if_results INTO ls_if_results WHERE seqnr = delete_table-seqnr.
      MOVE-CORRESPONDING ls_if_results TO delete_table.
      MODIFY delete_table.
    ENDLOOP.
  ENDLOOP.
  PERFORM set_delete_sign.
  flag_new = 'R'.                                     "Refresh
*  PERFORM print_delete_table.

ENDFORM.                    "DELETE_MARKED_RESULTS


*&--------------------------------------------------------------------*
*&      Form  MARK_ALL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM mark_all.

  LOOP AT delete_table WHERE dsign = true.
    delete_table-marks = 'X'.
    MODIFY delete_table.
  ENDLOOP.
  PERFORM print_delete_table.

ENDFORM.                    "MARK_ALL


*&--------------------------------------------------------------------*
*&      Form  MARK_ALL_ENTRIES
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM mark_all_entries.

  LOOP AT delete_table.
    delete_table-marks = 'X'.
    MODIFY delete_table.
  ENDLOOP.
  PERFORM print_delete_table.

ENDFORM.                    "MARK_ALL_ENTRIES


*&--------------------------------------------------------------------*
*&      Form  DESELECT_ALL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM deselect_all.

  LOOP AT delete_table.
    delete_table-marks = ' '.
    MODIFY delete_table.
  ENDLOOP.
  PERFORM print_delete_table.

ENDFORM.                    "DESELECT_ALL


*&--------------------------------------------------------------------*
*&      Form  DELETE_RESULTS
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->$OLD_PERNR text
*---------------------------------------------------------------------*
FORM delete_results USING $old_pernr.


  LOOP AT del_database_table.
    DELETE FROM zhr_pcl2 WHERE relid = del_database_table-relid
                       AND srtfd = del_database_table-srtfd.
  ENDLOOP.

  ls_id_key-pernr = $old_pernr.
  ls_id_key-fldid = fldid.
  READ TABLE lt_if_results INTO ls_if_results INDEX 1.
  IF sy-subrc = 0.
    SORT lt_if_results BY seqnr.
    ls_if_version-cdate = sy-datum.
    ls_if_version-ctime = sy-uzeit.
    ls_if_version-cprog = sy-repid.
    ls_if_version-uname = sy-uname.
    EXPORT if_version  FROM ls_if_version
           if_results  FROM lt_if_results
    TO DATABASE zhr_pcl2(id) ID ls_id_key.
  ELSE.
    DELETE FROM DATABASE zhr_pcl2(id) ID ls_id_key.
  ENDIF.

ENDFORM.                    "DELETE_RESULTS


*&--------------------------------------------------------------------*
*&      Form  PRINT_DELETE_TABLE
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM print_delete_table.

  DATA: col_switch LIKE true,
        line_number LIKE sy-staro,
        input_on LIKE true,
        old_pernr LIKE pernr-pernr.

  line_number = sy-staro.
  IF sy-lsind > 0.
    sy-lsind = sy-lsind - 1.
  ENDIF.
  LOOP AT delete_table.
*    SUBMIT_RETURN = 0.
    IF delete_table-pernr NE old_pernr.
      old_pernr = delete_table-pernr.
*     FORMAT COLOR COL_NEGATIVE INTENSIFIED.
*     WRITE:/1 SY-VLINE, 2 SY-ULINE(78), 80 SY-VLINE.
*     WRITE:/1 SY-VLINE, 4 TEXT-T01, DELETE_TABLE-PERNR, 80 SY-VLINE.
*     WRITE:/1 SY-VLINE, 2 SY-ULINE(78), 80 SY-VLINE.
*     SKIP 1.
*     FORMAT COLOR COL_HEADING INTENSIFIED.
*     WRITE:/1 SY-VLINE, 2 SY-ULINE(73), 75 SY-VLINE.
*     WRITE:/1  SY-VLINE,
*            2  'L',
*            3  SY-VLINE,
*            4  'Für-Periode (Beginn - Ende)'(T02),
*            37 SY-VLINE,
*            38 'In-Periode (Beginn - Ende)'(T03),
*            71 SY-VLINE,
*            72 'S'(T04),
*            73 SY-VLINE,
*            74 'T'(T05),
*            75 SY-VLINE.
*     WRITE:/1 SY-VLINE, 2 SY-ULINE(73), 75 SY-VLINE.
      PERFORM print_header USING delete_table-pernr.
      col_switch = true.
    ENDIF.
    input_on = false.
    ON CHANGE OF delete_table-inper OR
                 delete_table-inend OR
                 delete_table-inpty OR
                 delete_table-inpid OR
                 delete_table-pernr OR
                 delete_table-statu.
      IF col_switch = true.
        col_switch = false.
        FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      ELSE.
        col_switch = true.
        FORMAT COLOR COL_NORMAL INTENSIFIED.
      ENDIF.
      IF delete_table-dsign = true.
        input_on = true.
      ENDIF.
    ENDON.
    IF delete_table-dsign = true.
      input_on = true.
    ENDIF.
    hide_marks = delete_table-marks.
    WRITE:/1  sy-vline.
    IF input_on = true.
      WRITE 2  hide_marks AS CHECKBOX.
    ELSE.
      WRITE 2  hide_marks AS CHECKBOX INPUT OFF.
    ENDIF.
    WRITE:3  sy-vline,
          4  delete_table-seqnr,
          13 sy-vline,
          14 delete_table-statu,
          15 sy-vline,
          16 sy-vline.
    IF delete_table-payty = space.
      WRITE:17(2) delete_table-frper+4(2),
            19(1) '.',
            20(4) delete_table-frper(4),
            25(1) '(',
            26    delete_table-frbeg DD/MM/YYYY,
            37    '-',
            39    delete_table-frend DD/MM/YYYY,
            49    ')'.
    ELSE.
      WRITE:17 delete_table-frbeg DD/MM/YYYY.
    ENDIF.
    WRITE:50 sy-vline,
          51 delete_table-payty,
          54 sy-vline,
          55 delete_table-payid,
          57 sy-vline,
          58 delete_table-abkrs,
          63 sy-vline,
          64 delete_table-permo,
          69 sy-vline,
          70 sy-vline.
    IF delete_table-inpty = space.
      WRITE:71(2) delete_table-inper+4(2),
            73(1) '.',
            74(4) delete_table-inper(4),
            79(1) '(',
            80    delete_table-inbeg DD/MM/YYYY,
            91    '-',
            93    delete_table-inend DD/MM/YYYY,
            103   ')'.
    ELSE.
      WRITE:71 delete_table-inend DD/MM/YYYY.
    ENDIF.
    WRITE:104 sy-vline,
          105 delete_table-inpty,
          108 sy-vline,
          109 delete_table-inpid,
          111 sy-vline,
          112 delete_table-iabkrs,
          117 sy-vline,
          118 delete_table-iperm,
          123 sy-vline.
    hide_index = sy-tabix.
    hide_input = input_on.
    HIDE: delete_table-pernr,
          delete_table-seqnr,
          hide_marks,
          hide_index,
          hide_input.
    AT END OF pernr.
      WRITE:/1 sy-vline, 2 sy-uline(121), 123 sy-vline.
      SKIP 1.
    ENDAT.
  ENDLOOP.
  IF sy-subrc NE 0.
    FORMAT COLOR OFF.
    WRITE: space.
  ENDIF.
  SCROLL LIST INDEX 1 TO FIRST PAGE LINE line_number.

ENDFORM.                    "PRINT_DELETE_TABLE


*&--------------------------------------------------------------------*
*&      Form  PRINT_HEADER
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->$PERNR     text
*---------------------------------------------------------------------*
FORM print_header USING $pernr.

  FORMAT COLOR COL_NEGATIVE INTENSIFIED.
  WRITE:/1 sy-vline, 2 sy-uline(121), 123 sy-vline.
  WRITE:/1 sy-vline, 4 text-t01, $pernr, 123 sy-vline.
  FORMAT COLOR COL_HEADING INTENSIFIED.
  WRITE:/1 sy-vline, 2 sy-uline(121), 123 sy-vline.
  WRITE:/1  sy-vline,
         2  ' ',
         3  sy-vline,
         4  'Lfd. Nr.'(t15),
         13 sy-vline,
         14 'S'(t12),
         15 sy-vline,
         16 sy-vline,
         17 'Für-Periode (Beginn - Ende)'(t13),
         50 sy-vline,
         51 'Typ'(t14),
         54 sy-vline,
         55 'ID'(t23),
         57 sy-vline,
         58 'AbKrs'(t16),
         63 sy-vline,
         64 'PerMo'(t17),
         69 sy-vline,
         70 sy-vline,
         71 'In-Periode (Beginn - Ende)'(t18),
        104 sy-vline,
        105 'Typ'(t19),
        108 sy-vline,
        109 'ID'(t20),
        111 sy-vline,
        112 'AbKrs'(t21),
        117 sy-vline,
        118 'PerMo'(t22),
        123 sy-vline.
  WRITE:/1 sy-vline, 2 sy-uline(121), 123 sy-vline.

ENDFORM.                    "PRINT_HEADER


*---------------------------------------------------------------------*
*  MODULE INIT_D2000 OUTPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE init_d2000 OUTPUT.

  SET PF-STATUS 'D2000'.
  SET TITLEBAR '001'.
  SET CURSOR FIELD 'BUTTON_DELETE'.

ENDMODULE.                    "INIT_D2000 OUTPUT


*---------------------------------------------------------------------*
*  MODULE FCODE_2000 INPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE fcode_2000 INPUT.

  CASE sy-xcode.
    WHEN 'DELE'. dialog_return = 'DELE'.
    WHEN 'CANC'. dialog_return = 'CANC'.
  ENDCASE.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.                    "FCODE_2000 INPUT

* XJS note 390032 {
FORM append_log TABLES $del_tab STRUCTURE delete_table.

  DATA: text(7) TYPE c,
        datetime(10) TYPE c.

  prot_mess-msgty     = 'I'.
  prot_mess-msgid     = '57'.
  prot_mess-msgno     = '332'.
  prot_mess-probclass = '1'.

  LOOP AT $del_tab WHERE NOT marks IS INITIAL.
    CONCATENATE $del_tab-pernr $del_tab-seqnr fldid
      INTO prot_mess-msgv1 SEPARATED BY space.
    prot_mess-msgv2 = text-004.
    CONCATENATE $del_tab-frper+4(2) '/' $del_tab-frper(4)
      INTO text.
    REPLACE '&1' WITH text INTO prot_mess-msgv2.
    CONCATENATE $del_tab-inper+4(2) '/' $del_tab-inper(4)
      INTO text.
    REPLACE '&2' WITH text INTO prot_mess-msgv2.
    prot_mess-msgv3 = text-005.
    REPLACE '&1' WITH $del_tab-statu INTO prot_mess-msgv3.
    prot_mess-msgv4 = text-006.
    WRITE $del_tab-rundt TO datetime DD/MM/YYYY.
    REPLACE '&1' WITH datetime INTO prot_mess-msgv4.
    WRITE $del_tab-runtm TO datetime.
    REPLACE '&2' WITH datetime INTO prot_mess-msgv4.
    APPEND prot_mess.
  ENDLOOP.

ENDFORM.                    "append_log

*&--------------------------------------------------------------------*
*&      Form  update_log
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM update_log.

  DATA: prot_obj LIKE balhdr-object VALUE 'HRPU12',
        sub_obj LIKE balhdr-subobject VALUE 'DELETE_IF'.

  DATA: BEGIN OF prot_nr OCCURS 1.
          INCLUDE STRUCTURE balnri.
  DATA: END OF prot_nr.

  DATA: BEGIN OF prot_head.
          INCLUDE STRUCTURE balhdri.
  DATA: END OF prot_head.

  CALL FUNCTION 'APPL_LOG_INIT'
    EXPORTING
      object    = prot_obj
      subobject = sub_obj
    EXCEPTIONS
      OTHERS    = 0.

  prot_head-object     = prot_obj.
  prot_head-subobject  = sub_obj.
  IF NOT single_pernr IS INITIAL.
    prot_head-extnumber = single_pernr.
  ENDIF.
  prot_head-aldate     = sy-datum.
  prot_head-altime     = sy-uzeit.
  prot_head-aluser     = sy-uname.
  prot_head-altcode    = sy-tcode.
  prot_head-alprog     = sy-repid.
  prot_head-aldate_del = sy-datum + 100.
  prot_head-del_before = 'X'.

  CALL FUNCTION 'APPL_LOG_WRITE_HEADER'
    EXPORTING
      header = prot_head
    EXCEPTIONS
      OTHERS = 0.

  CALL FUNCTION 'APPL_LOG_WRITE_MESSAGES'
    TABLES
      messages         = prot_mess
    EXCEPTIONS
      object_not_found = 0.

  CALL FUNCTION 'APPL_LOG_WRITE_DB'
    TABLES
      object_with_lognumber = prot_nr
    EXCEPTIONS
      OTHERS                = 0.

ENDFORM.                    "update_log
* XJS note 390032 }

INCLUDE zhru_pcl2_delete_new_o01.
*INCLUDE zhru_adp_ev5_us_pcl2_del_o01.
*INCLUDE rpcifu02o01.

INCLUDE zhru_pcl2_delete_new_i01.
*INCLUDE zhru_adp_ev5_us_pcl2_del_i01.
*INCLUDE rpcifu02i01.

INCLUDE zhru_pcl2_delete_new_f01.
*INCLUDE zhru_adp_ev5_us_pcl2_del_f01.
*INCLUDE rpcifu02f01.