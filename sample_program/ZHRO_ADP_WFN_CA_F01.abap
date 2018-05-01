*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  EXPORT_NEW_DATA
*&---------------------------------------------------------------------*
*       Export new data
*----------------------------------------------------------------------*
FORM export_new_data .

  DATA: lv_seqnr TYPE n LENGTH 9.

  PERFORM export_directory CHANGING lv_seqnr.
  PERFORM export_data USING lv_seqnr.

ENDFORM.                    " EXPORT_NEW_DATA
*&---------------------------------------------------------------------*
*&      Form  EXPORT_DIRECTORY
*&---------------------------------------------------------------------*
*       Export directory
*----------------------------------------------------------------------*
FORM export_directory CHANGING fv_seqnr.

  DATA: ls_id_key            TYPE ts_id_key,
        ls_if_version        TYPE ts_if_version,
        ls_if_results        TYPE ts_if_results,
        lt_if_results        TYPE tt_if_results.

  MOVE:  pernr-pernr TO ls_id_key-pernr,
         gc_if_name  TO ls_id_key-fldid.

  IMPORT if_version  TO ls_if_version
         if_results  TO lt_if_results
         FROM DATABASE zhr_pcl2(id) ID ls_id_key.

  ls_if_version-cdate = sy-datum.
  ls_if_version-ctime = sy-uzeit.
  ls_if_version-cprog = sy-repid.
  ls_if_version-uname = sy-uname.

  SORT lt_if_results BY seqnr DESCENDING.
  READ TABLE lt_if_results INTO ls_if_results INDEX 1.

  ls_if_results-seqnr = fv_seqnr = ls_if_results-seqnr + 1.
  ls_if_results-frper = gv_frper.
  ls_if_results-frbeg = gv_frbeg.
  ls_if_results-frend = gv_frend.
  ls_if_results-rundt = sy-datum.
  ls_if_results-runtm = sy-uzeit.
  ls_if_results-abkrs = pernr-abkrs.
  SORT lt_if_results BY seqnr ASCENDING.
  APPEND ls_if_results TO lt_if_results.

  zhr_pcl2-aedtm = sy-datum.
  zhr_pcl2-uname = sy-uname.
  zhr_pcl2-pgmid = sy-repid.
  zhr_pcl2-versn = gc_if_version.
  EXPORT if_version FROM ls_if_version
         if_results FROM lt_if_results
         TO DATABASE zhr_pcl2(id) ID ls_id_key.

ENDFORM.                    " EXPORT_DIRECTORY
*&---------------------------------------------------------------------*
*&      Form  GET_NEW_DATA
*&---------------------------------------------------------------------*
*       Get new data
*----------------------------------------------------------------------*
FORM get_new_data .

  DATA: ls_new_p0000 TYPE ts_p0000,
        ls_new_p0001 TYPE ts_p0001,
        ls_new_p0002 TYPE ts_p0002,
        ls_new_p0006 TYPE ts_p0006,
        ls_new_p0008 TYPE ts_p0008,
        ls_new_p0009 TYPE ts_p0009,
        ls_new_p0014 TYPE ts_p0014,
        ls_new_p0019 TYPE ts_p0019,
        ls_new_p0032 TYPE ts_p0032,
        ls_new_p0033 TYPE ts_p0033,
        ls_new_p0041 TYPE ts_p0041,
        ls_new_p0105 TYPE ts_p0105,
        ls_new_p0167 TYPE ts_p0167,
        ls_new_p0168 TYPE ts_p0168,
        ls_new_p0169 TYPE ts_p0169,
        ls_new_p0185 TYPE ts_p0185,
        ls_new_p0461 TYPE ts_p0461,
        ls_new_p0462 TYPE ts_p0462,
        ls_new_p0463 TYPE ts_p0463,
        ls_new_p0464 TYPE ts_p0464.


  LOOP AT p0000
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0000 TO ls_new_p0000.
    APPEND ls_new_p0000 TO gt_new_p0000.
  ENDLOOP.
  LOOP AT p0001
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0001 TO ls_new_p0001.
    APPEND ls_new_p0001 TO gt_new_p0001.
  ENDLOOP.
  LOOP AT p0002
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0002 TO ls_new_p0002.
    APPEND ls_new_p0002 TO gt_new_p0002.
  ENDLOOP.
  LOOP AT p0006
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg
      AND anssa EQ gc_permanent_address..
    MOVE-CORRESPONDING p0006 TO ls_new_p0006.
    APPEND ls_new_p0006 TO gt_new_p0006.
  ENDLOOP.
  LOOP AT p0008
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0008 TO ls_new_p0008.
    APPEND ls_new_p0008 TO gt_new_p0008.
  ENDLOOP.
  LOOP AT p0009
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0009 TO ls_new_p0009.
    APPEND ls_new_p0009 TO gt_new_p0009.
  ENDLOOP.
  LOOP AT p0014
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0014 TO ls_new_p0014.
    APPEND ls_new_p0014 TO gt_new_p0014.
  ENDLOOP.
  LOOP AT p0019
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg
      AND tmart EQ gc_end_of_leave.
    MOVE-CORRESPONDING p0019 TO ls_new_p0019.
    APPEND ls_new_p0019 TO gt_new_p0019.
  ENDLOOP.
  LOOP AT p0032
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0032 TO ls_new_p0032.
    APPEND ls_new_p0032 TO gt_new_p0032.
  ENDLOOP.
  LOOP AT p0033
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg
      AND subty EQ gc_wfn_stats.
    MOVE-CORRESPONDING p0033 TO ls_new_p0033.
    APPEND ls_new_p0033 TO gt_new_p0033.
  ENDLOOP.
  LOOP AT p0041
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0041 TO ls_new_p0041.
    APPEND ls_new_p0041 TO gt_new_p0041.
  ENDLOOP.
  LOOP AT p0105
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg
      AND usrty EQ gc_email_address.
    MOVE-CORRESPONDING p0105 TO ls_new_p0105.
    APPEND ls_new_p0105 TO gt_new_p0105.
  ENDLOOP.
  LOOP AT p0167
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0167 TO ls_new_p0167.
    APPEND ls_new_p0167 TO gt_new_p0167.
  ENDLOOP.
  LOOP AT p0168
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0168 TO ls_new_p0168.
    APPEND ls_new_p0168 TO gt_new_p0168.
  ENDLOOP.
  LOOP AT p0169
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0169 TO ls_new_p0169.
    APPEND ls_new_p0169 TO gt_new_p0169.
  ENDLOOP.
  LOOP AT p0185
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg
      AND ictyp EQ gc_wfn_payroll_id.
    MOVE-CORRESPONDING p0185 TO ls_new_p0185.
    APPEND ls_new_p0185 TO gt_new_p0185.
  ENDLOOP.
  LOOP AT p0461
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0461 TO ls_new_p0461.
    APPEND ls_new_p0461 TO gt_new_p0461.
  ENDLOOP.
  LOOP AT p0462
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0462 TO ls_new_p0462.
    APPEND ls_new_p0462 TO gt_new_p0462.
  ENDLOOP.
  LOOP AT p0463
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0463 TO ls_new_p0463.
    APPEND ls_new_p0463 TO gt_new_p0463.
  ENDLOOP.
  LOOP AT p0464
    WHERE begda LE gv_frend
      AND endda GE gv_frbeg.
    MOVE-CORRESPONDING p0464 TO ls_new_p0464.
    APPEND ls_new_p0464 TO gt_new_p0464.
  ENDLOOP.

ENDFORM.                    " GET_NEW_DATA
*&---------------------------------------------------------------------*
*&      Form  INIT_GLOBALS
*&---------------------------------------------------------------------*
*       Initialize global variables
*----------------------------------------------------------------------*
FORM init_globals .

  CLEAR:  gt_old_p0000[],
          gt_old_p0001[],
          gt_old_p0002[],
          gt_old_p0006[],
          gt_old_p0008[],
          gt_old_p0009[],
          gt_old_p0014[],
          gt_old_p0019[],
          gt_old_p0032[],
          gt_old_p0033[],
          gt_old_p0041[],
          gt_old_p0105[],
          gt_old_p0167[],
          gt_old_p0168[],
          gt_old_p0169[],
          gt_old_p0185[],
          gt_old_p0461[],
          gt_old_p0462[],
          gt_old_p0463[],
          gt_old_p0464[].

  CLEAR:  gt_new_p0000[],
          gt_new_p0001[],
          gt_new_p0002[],
          gt_new_p0006[],
          gt_new_p0008[],
          gt_new_p0009[],
          gt_new_p0014[],
          gt_new_p0019[],
          gt_new_p0032[],
          gt_new_p0033[],
          gt_new_p0041[],
          gt_new_p0105[],
          gt_new_p0167[],
          gt_new_p0168[],
          gt_new_p0169[],
          gt_new_p0185[],
          gt_new_p0461[],
          gt_new_p0462[],
          gt_new_p0463[],
          gt_new_p0464[].

  CLEAR:  gs_old_p0000,
          gs_old_p0001,
          gs_old_p0002,
          gs_old_p0006,
          gs_old_p0008,
          gs_old_p0009,
          gs_old_p0014,
          gs_old_p0019,
          gs_old_p0032,
          gs_old_p0033,
          gs_old_p0041,
          gs_old_p0105,
          gs_old_p0167,
          gs_old_p0168,
          gs_old_p0169,
          gs_old_p0185,
          gs_old_p0461,
          gs_old_p0462,
          gs_old_p0463,
          gs_old_p0464.

  CLEAR:  gs_new_p0000,
          gs_new_p0001,
          gs_new_p0002,
          gs_new_p0006,
          gs_new_p0008,
          gs_new_p0009,
          gs_new_p0014,
          gs_new_p0019,
          gs_new_p0032,
          gs_new_p0033,
          gs_new_p0041,
          gs_new_p0105,
          gs_new_p0167,
          gs_new_p0168,
          gs_new_p0169,
          gs_new_p0185,
          gs_new_p0461,
          gs_new_p0462,
          gs_new_p0463,
          gs_new_p0464.

  CLEAR:  zhr_pcl2, t569v, t549a, t549q.

  IF p_cp EQ 'X'. "Period is employee dependent, unless running for other period and one payroll area.
    CLEAR:  gv_frper, gv_frbeg, gv_frend.
  ENDIF.

  CLEAR:  gs_employee_data,
          gs_old_employee_data,
          gs_new_employee_data.

  CLEAR:  gv_effective_date,
          gv_transfer_date,
          gv_comp_change_date.

  CLEAR:  gv_same_tax_form,
          gs_bank,
          gs_exemptions.

  CLEAR:  gs_change_blocks.

* clear: gv_time_iteration.

  CLEAR:  gv_date_01,
          gv_date_06,
          gv_date_07,
          gv_date_08,
          gv_date_09,
          gv_date_11,
          gv_date_12,
          gv_date_98,
          gv_date_99.

  CLEAR:  gv_abart,
          gv_trfkz,
          gv_zeinh.

  MOVE '0' TO gs_export_flags-ed_export.        "Reset the export flag for the employee data record

ENDFORM.                    " INIT_GLOBALS
*&---------------------------------------------------------------------*
*&      Form  EXPORT_DATA
*&---------------------------------------------------------------------*
*       Export data
*----------------------------------------------------------------------*
FORM export_data USING fv_seqnr.

  DATA: ls_if_key       TYPE ts_if_key,
        ls_if_version   TYPE ts_if_version.

  MOVE: pernr-pernr TO ls_if_key-pernr,
        fv_seqnr    TO ls_if_key-seqnr,
        gc_if_name  TO ls_if_key-fldid.

  ls_if_version-cdate = sy-datum.
  ls_if_version-ctime = sy-uzeit.
  ls_if_version-cprog = sy-repid.
  ls_if_version-uname = sy-uname.

  zhr_pcl2-aedtm = sy-datum.
  zhr_pcl2-uname = sy-uname.
  zhr_pcl2-pgmid = sy-repid.
  zhr_pcl2-versn = gc_if_version.

  EXPORT if_version FROM ls_if_version
         p0000_exp  FROM gt_new_p0000
         p0001_exp  FROM gt_new_p0001
         p0002_exp  FROM gt_new_p0002
         p0006_exp  FROM gt_new_p0006
         p0008_exp  FROM gt_new_p0008
         p0009_exp  FROM gt_new_p0009
         p0014_exp  FROM gt_new_p0014
         p0019_exp  FROM gt_new_p0019
         p0032_exp  FROM gt_new_p0032
         p0033_exp  FROM gt_new_p0033
         p0041_exp  FROM gt_new_p0041
         p0105_exp  FROM gt_new_p0105
         p0167_exp  FROM gt_new_p0167
         p0168_exp  FROM gt_new_p0168
         p0169_exp  FROM gt_new_p0169
         p0185_exp  FROM gt_new_p0185
         p0461_exp  FROM gt_new_p0461
         p0462_exp  FROM gt_new_p0462
         p0463_exp  FROM gt_new_p0463
         p0464_exp  FROM gt_new_p0464
         TO DATABASE zhr_pcl2(if) ID ls_if_key.

ENDFORM.                    " EXPORT_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_CURRENT_PERIOD
*&---------------------------------------------------------------------*
*       Get Current Period
*----------------------------------------------------------------------*
*      <--FV_FRPER  Current Period
*      <--FV_FRBEG  Period Begin Date
*      <--FV_FREND  Period End Date
*----------------------------------------------------------------------*
FORM get_current_period  CHANGING fv_frper
                                  fv_frbeg
                                  fv_frend.

  SELECT  * FROM t569v WHERE
    abkrs EQ pernr-abkrs AND
    vwsaz EQ '1'.

    SELECT * FROM t549a WHERE
      abkrs EQ pernr-abkrs.

      SELECT * FROM t549q WHERE
        permo EQ t549a-permo AND
        pabrj EQ t569v-pabrj AND
        pabrp EQ t569v-pabrp.

        CONCATENATE t569v-pabrj t569v-pabrp INTO fv_frper.
        MOVE t549q-begda TO fv_frbeg.
        MOVE t549q-endda TO fv_frend.

      ENDSELECT.

    ENDSELECT.

  ENDSELECT.

ENDFORM.                    " GET_CURRENT_PERIOD
*&---------------------------------------------------------------------*
*&      Form  GET_OLD_DATA
*&---------------------------------------------------------------------*
*       Get old data from ZHR_PCL2 cluster table
*----------------------------------------------------------------------*
FORM get_old_data .

  DATA: lv_seqnr      TYPE n LENGTH 9,
        ls_if_key     TYPE ts_if_key,
        ls_if_version TYPE ts_if_version.

  PERFORM get_last_seqnr CHANGING lv_seqnr.

  MOVE: pernr-pernr TO ls_if_key-pernr,
        lv_seqnr    TO ls_if_key-seqnr,
        gc_if_name  TO ls_if_key-fldid.

  IMPORT if_version TO ls_if_version
         p0000_exp  TO gt_old_p0000
         p0001_exp  TO gt_old_p0001
         p0002_exp  TO gt_old_p0002
         p0006_exp  TO gt_old_p0006
         p0008_exp  TO gt_old_p0008
         p0009_exp  TO gt_old_p0009
         p0014_exp  TO gt_old_p0014
         p0019_exp  TO gt_old_p0019
         p0032_exp  TO gt_old_p0032
         p0033_exp  TO gt_old_p0033
         p0041_exp  TO gt_old_p0041
         p0105_exp  TO gt_old_p0105
         p0167_exp  TO gt_old_p0167
         p0168_exp  TO gt_old_p0168
         p0169_exp  TO gt_old_p0169
         p0185_exp  TO gt_old_p0185
         p0461_exp  TO gt_old_p0461
         p0462_exp  TO gt_old_p0462
         p0463_exp  TO gt_old_p0463
         p0464_exp  TO gt_old_p0464
         FROM DATABASE zhr_pcl2(if) ID ls_if_key.

ENDFORM.                    " GET_OLD_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_LAST_SEQNR
*&---------------------------------------------------------------------*
*       Get the latest sequence number
*----------------------------------------------------------------------*
*      <--FV_SEQNR  Sequence number
*----------------------------------------------------------------------*
FORM get_last_seqnr  CHANGING fv_seqnr.

  DATA: ls_id_key       TYPE ts_id_key,
        ls_if_version   TYPE ts_if_version,
        ls_if_results   TYPE ts_if_results,
        lt_if_results   TYPE tt_if_results.

  ls_id_key-pernr = pernr-pernr.
  ls_id_key-fldid = gc_if_name.
  IMPORT if_version  TO ls_if_version
         if_results  TO lt_if_results
         FROM DATABASE zhr_pcl2(id) ID ls_id_key.

  SORT lt_if_results BY seqnr DESCENDING.
  READ TABLE lt_if_results INTO ls_if_results INDEX 1.
  fv_seqnr = ls_if_results-seqnr.

ENDFORM.                    " GET_LAST_SEQNR
*&---------------------------------------------------------------------*
*&      Form  BEGIN
*&---------------------------------------------------------------------*
*       Begiin of interface
*----------------------------------------------------------------------*
FORM begin .

  DATA: ls_column_names TYPE ts_column_names.

  go_structdescr_ed ?= cl_abap_typedescr=>describe_by_name( 'TS_EMPLOYEE_DATA'  ).

  MOVE: 'POSITION_ID' TO ls_column_names-field, 'Position ID' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'CHANGE_EFFECTIVE' TO ls_column_names-field, 'Change Effective On' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'IS_PAID_BY_WFN' TO ls_column_names-field, 'Is Paid By WFN' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'POS_USES_TIME' TO ls_column_names-field, 'Position Uses Time' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'CO_CODE' TO ls_column_names-field, 'Co Code' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'FILE_NUMBER' TO ls_column_names-field, 'File Number' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'HIRE_DATE' TO ls_column_names-field, 'Hire Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SENIORITY_DATE' TO ls_column_names-field, 'Seniority Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'CREDITED_SERVICE_DATE' TO ls_column_names-field, 'Credited Service Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADJUSTED_SERVICE_DATE' TO ls_column_names-field, 'Adjusted Service Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'EMPLOYEE_STATUS' TO ls_column_names-field, 'Employee Status' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TERMINATION_DATE' TO ls_column_names-field, 'Termination Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TERM_REASON' TO ls_column_names-field, 'Termination Reason' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'REHIRE_DATE' TO ls_column_names-field, 'Rehire Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'REHIRE_REASON' TO ls_column_names-field, 'Rehire Reason' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LOA_START_DATE' TO ls_column_names-field, 'Leave of Absence Start Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LOA_EXP_RET_DATE' TO ls_column_names-field, 'Leave of Absence Expected Return Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LOA_RETURN_DATE' TO ls_column_names-field, 'Leave of Absence Return Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LOA_REASON' TO ls_column_names-field, 'Leave of Absence Reason' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'POS_START_DATE' TO ls_column_names-field, 'Position Start Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'REPORTS_TO_ID' TO ls_column_names-field, 'Reports to Position ID' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'HOME_COST_NUMBER' TO ls_column_names-field, 'Home Cost Number' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'HOME_DEPARTMENT' TO ls_column_names-field, 'Home Department' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LOCATION_CODE' TO ls_column_names-field, 'Location Code' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PAY_GROUP' TO ls_column_names-field, 'Pay Group' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LAST_NAME' TO ls_column_names-field, 'Last Name' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'FIRST_NAME' TO ls_column_names-field, 'First Name' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ACTUAL_MAR_STA' TO ls_column_names-field, 'Actual Marital Status' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TAX_ID_NUMBER' TO ls_column_names-field, 'Tax ID Number' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TAX_ID_EXPY_DATE' TO ls_column_names-field, 'Tax ID Expiry Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'BIRTH_DATE' TO ls_column_names-field, 'Birth Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'CORRESP_LANG' TO ls_column_names-field, 'Correspondence Language' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'GENDER' TO ls_column_names-field, 'Gender' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDR1_USE_AS_LEG' TO ls_column_names-field, 'Address 1 Use as Legal' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_LINE_1' TO ls_column_names-field, 'Address Line 1' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_LINE_2' TO ls_column_names-field, 'Address Line 2' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_1_PROV' TO ls_column_names-field, 'Address 1 Province' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_1_CITY' TO ls_column_names-field, 'Address 1 City' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_1_PSTLCD' TO ls_column_names-field, 'Address 1 Postal Code' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'ADDRESS_1_CNTRY' TO ls_column_names-field, 'Address 1 Country' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'RECEIVE_SCHD_PAY' TO ls_column_names-field, 'Receive Scheduled Payment' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'STANDARD_HOURS' TO ls_column_names-field, 'Standard Hours' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'RATE_TYPE' TO ls_column_names-field, 'Rate Type' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'RATE_AMOUNT' TO ls_column_names-field, 'Rate Amount' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'COMP_CHNGE_REASN' TO ls_column_names-field, 'Compensation Change Reason' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SAME_TAX_FORM' TO ls_column_names-field, 'Same Tax Form' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TRANSFER_DATE' TO ls_column_names-field, 'Transfer Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PAYMENT_METHOD' TO ls_column_names-field, 'Payment Method' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PRIMARY_BANK' TO ls_column_names-field, 'Primary Bank' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PRIMARY_BRANCH' TO ls_column_names-field, 'Primary Branch' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PRIMARY_ACCNT_NO' TO ls_column_names-field, 'Primary Account Number' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SECONDARY_BANK' TO ls_column_names-field, 'Secondary Bank' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SECONDARY_BRANCH' TO ls_column_names-field, 'Secondary Branch' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SECOND_ACCNT_NO' TO ls_column_names-field, 'Secondary Account Number' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SECOND_DEP_AMNT' TO ls_column_names-field, 'Secondary Deposit Amount' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PROV_OF_EMPLYMNT' TO ls_column_names-field, 'Province of Employment' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'CRA_PA_RQ_ID' TO ls_column_names-field, 'CRA PA / RQ ID' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'FEDTAX_CRDT_TYPE' TO ls_column_names-field, 'Fed Tax Credit Type' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'FEDTAX_CRDT_OAMT' TO ls_column_names-field, 'Fed Tax Credit Other Amount' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PRVTAX_CRDT_TYPE' TO ls_column_names-field, 'Prov Tax Credit Type' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'PRVTAX_CRDT_OAMT' TO ls_column_names-field, 'Prov Tax Credit Other Amount' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'DONT_CALC_FEDTAX' TO ls_column_names-field, 'Do Not Calc Federal Tax' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'DONT_CALC_C_QPP' TO ls_column_names-field, 'Do Not Calc C/QPP' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'DO_NOT_CALC_EI' TO ls_column_names-field, 'Do Not Calc EI' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'REASON_FOR_ISSUE' TO ls_column_names-field, 'Reason for Issue' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'COMMENTS_ON_ROE' TO ls_column_names-field, 'Comments on ROE' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'EMPLOYEE_OCCUP' TO ls_column_names-field, 'Employee Occupation' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
  MOVE: 'FIRST_DAY_WORKED' TO ls_column_names-field, 'First Day Worked' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'LAST_DAY_PAID' TO ls_column_names-field, 'Last Day Paid' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'EXPECTED_RECALL' TO ls_column_names-field, 'Expected Recall' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'EXPD_RECALL_DATE' TO ls_column_names-field, 'Expected Recall Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'READY_TO_ISSUE' TO ls_column_names-field, 'Ready to Issue' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'BADGE' TO ls_column_names-field, 'BADGE' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'PAYCLASS' TO ls_column_names-field, 'PAYCLASS' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'BEGDA_TRACK_TIME' TO ls_column_names-field, 'Start Date for Tracking Time' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
*  MOVE: 'ENDDA_TRACK_TIME' TO ls_column_names-field, 'Stop Date for Tracking Time' TO ls_column_names-name.
*  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SUPERVISORFLAG' TO ls_column_names-field, 'SUPERVISORFLAG' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'SUPERVISORID' TO ls_column_names-field, 'SUPERVISORID' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TIMEZONE' TO ls_column_names-field, 'TimeZone' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'XFERTOPAYROLL' TO ls_column_names-field, 'TRANSFERTOPAYROLL' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TO_POLICY_NAME' TO ls_column_names-field, 'Time Off Policy Name' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'TO_PLCYASS_BEGDA' TO ls_column_names-field, 'Time Off Policy Assignment Start Date' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'WORK_EMAIL' TO ls_column_names-field, 'Work Email' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'UNION_CODE' TO ls_column_names-field, 'Union Code' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.
  MOVE: 'WORKER_CATEGORY' TO ls_column_names-field, 'Worker Category' TO ls_column_names-name.
  APPEND ls_column_names TO gt_column_names.

  PERFORM get_header CHANGING gs_header.
  APPEND gs_header TO gt_file_1.

ENDFORM.                    " BEGIN
*&---------------------------------------------------------------------*
*&      Form  GET_HEADER
*&---------------------------------------------------------------------*
*       Get the header line
*----------------------------------------------------------------------*
*      <--FS_HEADER  Header line
*----------------------------------------------------------------------*
FORM get_header  CHANGING fs_header TYPE ts_raw_line.

  DATA: lv_index        TYPE i,
        ls_component    TYPE abap_compdescr,
        ls_column_names TYPE ts_column_names.

  LOOP AT go_structdescr_ed->components INTO ls_component.

    lv_index = lv_index + 1.
    READ TABLE gt_column_names INTO ls_column_names WITH KEY field = ls_component-name.
    IF lv_index EQ 1.
      fs_header = ls_column_names-name.
      CONTINUE.
    ENDIF.
    CONCATENATE fs_header ',' ls_column_names-name INTO fs_header.

  ENDLOOP.

ENDFORM.                    " GET_HEADER
*&---------------------------------------------------------------------*
*&      Form  CHANGE_VALIDATION
*&---------------------------------------------------------------------*
*       Change validation logic
*----------------------------------------------------------------------*
FORM change_validation .

* Set change block flags to get old/new data.  Then clear again after.
  PERFORM set_cb_flags.

* Process old data
  PERFORM set_old_data_records.
  PERFORM get_dates.
  PERFORM get_comp_details.
  PERFORM get_bank_details.
  PERFORM get_exemptions.
  PERFORM get_wfn_data USING gc_part.

* Process new data
  PERFORM set_new_data_records.
  PERFORM get_dates.
  PERFORM get_comp_details.
  PERFORM get_bank_details.
  PERFORM get_exemptions.
  PERFORM get_wfn_data USING gc_part.

* Check if secondary bank has been deleted (delimited)
  PERFORM check_for_bank_deletion.

  CLEAR: gs_change_blocks.   "Clear the change block flags

* Check for changes and there respective effective dates.
  PERFORM check_for_changes.

  PERFORM get_comp_change_date CHANGING gv_comp_change_date.
  PERFORM get_transfers CHANGING gv_same_tax_form gv_transfer_date.


ENDFORM.                    " CHANGE_VALIDATION
*&---------------------------------------------------------------------*
*&      Form  SET_CB_FLAGS
*&---------------------------------------------------------------------*
*       Set the change block flags for getting old/new results
*----------------------------------------------------------------------*
FORM set_cb_flags .

  MOVE 'X' TO : gs_change_blocks-cb_1,
                gs_change_blocks-cb_2,
                gs_change_blocks-cb_3,
                gs_change_blocks-cb_4,
                gs_change_blocks-cb_5,
                gs_change_blocks-cb_6,
                gs_change_blocks-cb_7,
                gs_change_blocks-cb_8,
                gs_change_blocks-cb_9,
                gs_change_blocks-cb_10,
                gs_change_blocks-cb_11,
                gs_change_blocks-cb_12,
                gs_change_blocks-cb_13,
                gs_change_blocks-cb_14,
                gs_change_blocks-cb_15,
                gs_change_blocks-cb_16,
                gs_change_blocks-cb_17,
                gs_change_blocks-cb_18,
                gs_change_blocks-cb_19,
                gs_change_blocks-cb_20,
                gs_change_blocks-cb_21,
                gs_change_blocks-cb_22,
                gs_change_blocks-cb_23,
                gs_change_blocks-cb_24,
                gs_change_blocks-cb_25,
                gs_change_blocks-cb_26,
                gs_change_blocks-cb_27,
                gs_change_blocks-cb_28,
*                gs_change_blocks-cb_29
                gs_change_blocks-cb_30,
                gs_change_blocks-cb_31,
                gs_change_blocks-cb_32.

ENDFORM.                    " SET_CB_FLAGS
*&---------------------------------------------------------------------*
*&      Form  SET_OLD_DATA_RECORDS
*&---------------------------------------------------------------------*
*       Set old data records
*----------------------------------------------------------------------*
FORM set_old_data_records .

  DATA: lr_p0000 TYPE REF TO data,
        lr_p0001 TYPE REF TO data,
        lr_p0002 TYPE REF TO data,
        lr_p0006 TYPE REF TO data,
        lr_p0008 TYPE REF TO data,
        lr_p0009 TYPE REF TO data,
        lr_t0009 TYPE REF TO data,
        lr_p0019 TYPE REF TO data,
        lr_p0032 TYPE REF TO data,
        lr_p0033 TYPE REF TO data,
        lr_t0033 TYPE REF TO data,
        lr_p0041 TYPE REF TO data,
        lr_p0105 TYPE REF TO data,
        lr_p0185 TYPE REF TO data,
        lr_p0461 TYPE REF TO data,
        lr_p0462 TYPE REF TO data,
        lr_p0463 TYPE REF TO data,
        lr_p0464 TYPE REF TO data.

  SORT gt_old_p0000 BY endda DESCENDING.
  READ TABLE gt_old_p0000 INTO gs_old_p0000 INDEX 1.
  SORT gt_old_p0001 BY endda DESCENDING.
  READ TABLE gt_old_p0001 INTO gs_old_p0001 INDEX 1.
  SORT gt_old_p0002 BY endda DESCENDING.
  READ TABLE gt_old_p0002 INTO gs_old_p0002 INDEX 1.
  SORT gt_old_p0006 BY endda DESCENDING.
  READ TABLE gt_old_p0006 INTO gs_old_p0006 INDEX 1.
  SORT gt_old_p0008 BY endda DESCENDING.
  READ TABLE gt_old_p0008 INTO gs_old_p0008 INDEX 1.
  SORT gt_old_p0009 BY subty endda DESCENDING.
  SORT gt_old_p0019 BY endda DESCENDING.
  READ TABLE gt_old_p0019 INTO gs_old_p0019 INDEX 1.
  SORT gt_old_p0032 BY endda DESCENDING.
  READ TABLE gt_old_p0032 INTO gs_old_p0032 INDEX 1.
  SORT gt_old_p0033 BY endda DESCENDING.
  READ TABLE gt_old_p0033 INTO gs_old_p0033 INDEX 1.
  SORT gt_old_p0041 BY endda DESCENDING.
  READ TABLE gt_old_p0041 INTO gs_old_p0041 INDEX 1.
  SORT gt_old_p0105 BY endda DESCENDING.
  READ TABLE gt_old_p0105 INTO gs_old_p0105 INDEX 1.
  SORT gt_old_p0185 BY endda DESCENDING.
  READ TABLE gt_old_p0185 INTO gs_old_p0185 INDEX 1.
  SORT gt_old_p0461 BY endda DESCENDING.
  READ TABLE gt_old_p0461 INTO gs_old_p0461 INDEX 1.
  SORT gt_old_p0462 BY endda DESCENDING.
  READ TABLE gt_old_p0462 INTO gs_old_p0462 INDEX 1.
  SORT gt_old_p0463 BY endda DESCENDING.
  READ TABLE gt_old_p0463 INTO gs_old_p0463 INDEX 1.
  SORT gt_old_p0464 BY endda DESCENDING.
  READ TABLE gt_old_p0464 INTO gs_old_p0464 INDEX 1.

  CREATE DATA lr_p0000 TYPE ts_p0000.
  CREATE DATA lr_p0001 TYPE ts_p0001.
  CREATE DATA lr_p0002 TYPE ts_p0002.
  CREATE DATA lr_p0006 TYPE ts_p0006.
  CREATE DATA lr_p0008 TYPE ts_p0008.
  CREATE DATA lr_p0009 TYPE ts_p0009.
  CREATE DATA lr_t0009 TYPE tt_p0009.
  CREATE DATA lr_p0019 TYPE ts_p0019.
  CREATE DATA lr_p0032 TYPE ts_p0032.
  CREATE DATA lr_p0033 TYPE ts_p0033.
  CREATE DATA lr_t0033 TYPE tt_p0033.
  CREATE DATA lr_p0041 TYPE ts_p0041.
  CREATE DATA lr_p0105 TYPE ts_p0105.
  CREATE DATA lr_p0185 TYPE ts_p0185.
  CREATE DATA lr_p0461 TYPE ts_p0461.
  CREATE DATA lr_p0462 TYPE ts_p0462.
  CREATE DATA lr_p0463 TYPE ts_p0463.
  CREATE DATA lr_p0464 TYPE ts_p0464.

  ASSIGN lr_p0000->* TO <gs_p0000>.
  ASSIGN lr_p0001->* TO <gs_p0001>.
  ASSIGN lr_p0002->* TO <gs_p0002>.
  ASSIGN lr_p0006->* TO <gs_p0006>.
  ASSIGN lr_p0008->* TO <gs_p0008>.
  ASSIGN lr_p0009->* TO <gs_p0009>.
  ASSIGN lr_t0009->* TO <gt_p0009>.
  ASSIGN lr_p0019->* TO <gs_p0019>.
  ASSIGN lr_p0032->* TO <gs_p0032>.
  ASSIGN lr_p0033->* TO <gs_p0033>.
  ASSIGN lr_t0033->* TO <gt_p0033>.
  ASSIGN lr_p0041->* TO <gs_p0041>.
  ASSIGN lr_p0105->* TO <gs_p0105>.
  ASSIGN lr_p0185->* TO <gs_p0185>.
  ASSIGN lr_p0461->* TO <gs_p0461>.
  ASSIGN lr_p0462->* TO <gs_p0462>.
  ASSIGN lr_p0463->* TO <gs_p0463>.
  ASSIGN lr_p0464->* TO <gs_p0464>.

  <gs_p0000> = gs_old_p0000.
  <gs_p0001> = gs_old_p0001.
  <gs_p0002> = gs_old_p0002.
  <gs_p0006> = gs_old_p0006.
  <gs_p0008> = gs_old_p0008.
  <gs_p0009> = gs_old_p0009.
  <gt_p0009> = gt_old_p0009[].
  <gs_p0019> = gs_old_p0019.
  <gs_p0032> = gs_old_p0032.
  <gs_p0033> = gs_old_p0033.
  <gt_p0033> = gt_old_p0033[].
  <gs_p0041> = gs_old_p0041.
  <gs_p0105> = gs_old_p0105.
  <gs_p0185> = gs_old_p0185.
  <gs_p0461> = gs_old_p0461.
  <gs_p0462> = gs_old_p0462.
  <gs_p0463> = gs_old_p0463.
  <gs_p0464> = gs_old_p0464.

  ASSIGN gs_old_employee_data TO <gs_employee_data>.


ENDFORM.                    " SET_OLD_DATA_RECORDS
*&---------------------------------------------------------------------*
*&      Form  SET_NEW_DATA_RECORDS
*&---------------------------------------------------------------------*
*       Set new data records
*----------------------------------------------------------------------*
FORM set_new_data_records .

  DATA: lr_p0000 TYPE REF TO data,
        lr_p0001 TYPE REF TO data,
        lr_p0002 TYPE REF TO data,
        lr_p0006 TYPE REF TO data,
        lr_p0008 TYPE REF TO data,
        lr_p0009 TYPE REF TO data,
        lr_t0009 TYPE REF TO data,
        lr_p0019 TYPE REF TO data,
        lr_p0032 TYPE REF TO data,
        lr_p0033 TYPE REF TO data,
        lr_t0033 TYPE REF TO data,
        lr_p0041 TYPE REF TO data,
        lr_p0105 TYPE REF TO data,
        lr_p0185 TYPE REF TO data,
        lr_p0461 TYPE REF TO data,
        lr_p0462 TYPE REF TO data,
        lr_p0463 TYPE REF TO data,
        lr_p0464 TYPE REF TO data.

  SORT gt_new_p0000 BY endda DESCENDING.
  READ TABLE gt_new_p0000 INTO gs_new_p0000 INDEX 1.
  SORT gt_new_p0001 BY endda DESCENDING.
  READ TABLE gt_new_p0001 INTO gs_new_p0001 INDEX 1.
  SORT gt_new_p0002 BY endda DESCENDING.
  READ TABLE gt_new_p0002 INTO gs_new_p0002 INDEX 1.
  SORT gt_new_p0006 BY endda DESCENDING.
  READ TABLE gt_new_p0006 INTO gs_new_p0006 INDEX 1.
  SORT gt_new_p0008 BY endda DESCENDING.
  READ TABLE gt_new_p0008 INTO gs_new_p0008 INDEX 1.
  SORT gt_new_p0009 BY subty endda DESCENDING.
  SORT gt_new_p0019 BY endda DESCENDING.
  READ TABLE gt_new_p0019 INTO gs_new_p0019 INDEX 1.
  SORT gt_new_p0032 BY endda DESCENDING.
  READ TABLE gt_new_p0032 INTO gs_new_p0032 INDEX 1.
  SORT gt_new_p0033 BY endda DESCENDING.
  READ TABLE gt_new_p0033 INTO gs_new_p0033 INDEX 1.
  SORT gt_new_p0041 BY endda DESCENDING.
  READ TABLE gt_new_p0041 INTO gs_new_p0041 INDEX 1.
  SORT gt_new_p0105 BY endda DESCENDING.
  READ TABLE gt_new_p0105 INTO gs_new_p0105 INDEX 1.
  SORT gt_new_p0185 BY endda DESCENDING.
  READ TABLE gt_new_p0185 INTO gs_new_p0185 INDEX 1.
  SORT gt_new_p0461 BY endda DESCENDING.
  READ TABLE gt_new_p0461 INTO gs_new_p0461 INDEX 1.
  SORT gt_new_p0462 BY endda DESCENDING.
  READ TABLE gt_new_p0462 INTO gs_new_p0462 INDEX 1.
  SORT gt_new_p0463 BY endda DESCENDING.
  READ TABLE gt_new_p0463 INTO gs_new_p0463 INDEX 1.
  SORT gt_new_p0464 BY endda DESCENDING.
  READ TABLE gt_new_p0464 INTO gs_new_p0464 INDEX 1.

  CREATE DATA lr_p0000 TYPE ts_p0000.
  CREATE DATA lr_p0001 TYPE ts_p0001.
  CREATE DATA lr_p0002 TYPE ts_p0002.
  CREATE DATA lr_p0006 TYPE ts_p0006.
  CREATE DATA lr_p0008 TYPE ts_p0008.
  CREATE DATA lr_p0009 TYPE ts_p0009.
  CREATE DATA lr_t0009 TYPE tt_p0009.
  CREATE DATA lr_p0019 TYPE ts_p0019.
  CREATE DATA lr_p0032 TYPE ts_p0032.
  CREATE DATA lr_p0033 TYPE ts_p0033.
  CREATE DATA lr_t0033 TYPE tt_p0033.
  CREATE DATA lr_p0041 TYPE ts_p0041.
  CREATE DATA lr_p0105 TYPE ts_p0105.
  CREATE DATA lr_p0185 TYPE ts_p0185.
  CREATE DATA lr_p0461 TYPE ts_p0461.
  CREATE DATA lr_p0462 TYPE ts_p0462.
  CREATE DATA lr_p0463 TYPE ts_p0463.
  CREATE DATA lr_p0464 TYPE ts_p0464.

  ASSIGN lr_p0000->* TO <gs_p0000>.
  ASSIGN lr_p0001->* TO <gs_p0001>.
  ASSIGN lr_p0002->* TO <gs_p0002>.
  ASSIGN lr_p0006->* TO <gs_p0006>.
  ASSIGN lr_p0008->* TO <gs_p0008>.
  ASSIGN lr_p0009->* TO <gs_p0009>.
  ASSIGN lr_t0009->* TO <gt_p0009>.
  ASSIGN lr_p0019->* TO <gs_p0019>.
  ASSIGN lr_p0032->* TO <gs_p0032>.
  ASSIGN lr_p0033->* TO <gs_p0033>.
  ASSIGN lr_t0033->* TO <gt_p0033>.
  ASSIGN lr_p0041->* TO <gs_p0041>.
  ASSIGN lr_p0105->* TO <gs_p0105>.
  ASSIGN lr_p0185->* TO <gs_p0185>.
  ASSIGN lr_p0461->* TO <gs_p0461>.
  ASSIGN lr_p0462->* TO <gs_p0462>.
  ASSIGN lr_p0463->* TO <gs_p0463>.
  ASSIGN lr_p0464->* TO <gs_p0464>.

  <gs_p0000> = gs_new_p0000.
  <gs_p0001> = gs_new_p0001.
  <gs_p0002> = gs_new_p0002.
  <gs_p0006> = gs_new_p0006.
  <gs_p0008> = gs_new_p0008.
  <gs_p0009> = gs_new_p0009.
  <gt_p0009> = gt_new_p0009[].
  <gs_p0019> = gs_new_p0019.
  <gs_p0032> = gs_new_p0032.
  <gs_p0033> = gs_new_p0033.
  <gt_p0033> = gt_new_p0033[].
  <gs_p0041> = gs_new_p0041.
  <gs_p0105> = gs_new_p0105.
  <gs_p0185> = gs_new_p0185.
  <gs_p0461> = gs_new_p0461.
  <gs_p0462> = gs_new_p0462.
  <gs_p0463> = gs_new_p0463.
  <gs_p0464> = gs_new_p0464.

  ASSIGN gs_new_employee_data TO <gs_employee_data>.

ENDFORM.                    " SET_NEW_DATA_RECORDS
*&---------------------------------------------------------------------*
*&      Form  GET_DATES
*&---------------------------------------------------------------------*
*       Get dates from Infotype 41
*----------------------------------------------------------------------*
FORM get_dates .

  DATA: lv_darnn TYPE c LENGTH 5 VALUE 'DARNN',
        lv_datnn TYPE c LENGTH 5 VALUE 'DATNN',
        lv_num   TYPE n LENGTH 2.

  FIELD-SYMBOLS: <lv_darnn> TYPE data,
                 <lv_datnn> TYPE data.

  CLEAR: gv_date_01, "Original Hire Date
         gv_date_06, "Ajusted Service Date
         gv_date_07, "Last Day Worked
         gv_date_08, "Last Day Paid
         gv_date_09, "Rehire Date
         gv_date_11, "Tax ID Expiry Date
         gv_date_12, "Seniority Date
         gv_date_98, "Hire Date
         gv_date_99. "Termination Date

  CHECK <gs_p0041> IS NOT INITIAL.

  DO 12 TIMES.
    lv_num = lv_num + 1.
    lv_darnn+3(2) = lv_num.
    lv_datnn+3(2) = lv_num.

    ASSIGN COMPONENT lv_darnn OF STRUCTURE <gs_p0041> TO <lv_darnn>.
    ASSIGN COMPONENT lv_datnn OF STRUCTURE <gs_p0041> TO <lv_datnn>.


    CASE <lv_darnn>.
      WHEN '01'.
        MOVE <lv_datnn> TO gv_date_01.   "Original Hire Date
      WHEN '06'.
        MOVE <lv_datnn> TO gv_date_06.   "Ajusted Service Date
      WHEN '07'.
        MOVE <lv_datnn> TO gv_date_07.   "Last Day Worked
      WHEN '08'.
        MOVE <lv_datnn> TO gv_date_08.   "Last Day Paid
      WHEN '09'.
        MOVE <lv_datnn> TO gv_date_09.   "Rehire Date
      WHEN '11'.
        MOVE <lv_datnn> TO gv_date_11.   "Tax ID Expiry Date
      WHEN '12'.
        MOVE <lv_datnn> TO gv_date_12.   "Seniority Date
      WHEN OTHERS.
    ENDCASE.

  ENDDO.

ENDFORM.                    " GET_DATES
*&---------------------------------------------------------------------*
*&      Form  GET_COMP_DETAILS
*&---------------------------------------------------------------------*
*       Get compensation details
*----------------------------------------------------------------------*
FORM get_comp_details .

  FIELD-SYMBOLS: <lv_persg>,
                 <lv_persk>,
                 <lv_trfgb>,
                 <lv_trfar>.

  CLEAR: gv_abart,
         gv_trfkz,
         gv_zeinh.

  ASSIGN COMPONENT 'PERSG' OF STRUCTURE <gs_p0001> TO <lv_persg>.
  ASSIGN COMPONENT 'PERSK' OF STRUCTURE <gs_p0001> TO <lv_persk>.
  ASSIGN COMPONENT 'TRFGB' OF STRUCTURE <gs_p0008> TO <lv_trfgb>.
  ASSIGN COMPONENT 'TRFAR' OF STRUCTURE <gs_p0008> TO <lv_trfar>.

  SELECT SINGLE abart trfkz FROM t503 INTO (gv_abart, gv_trfkz)
    WHERE persg EQ <lv_persg>
      AND persk EQ <lv_persk>.

  CALL FUNCTION 'RP_ZEINH_GET'
    EXPORTING
      p_molga        = '07'
      p_trfgb        = <lv_trfgb>
      p_trfar        = <lv_trfar>
      p_trfkz        = gv_trfkz
      p_date         = gv_frbeg
    IMPORTING
      p_zeinh        = gv_zeinh
    EXCEPTIONS
      no_entry_t549r = 1
      illegal_zeinh  = 2
      OTHERS         = 3.

ENDFORM.                    " GET_COMP_DETAILS
*&---------------------------------------------------------------------*
*&      Form  GET_BANK_DETAILS
*&---------------------------------------------------------------------*
*       Get bank details
*----------------------------------------------------------------------*
FORM get_bank_details .

  FIELD-SYMBOLS: <lv_subty>, <lv_begda>, <lv_bankl>, <lv_bankn>, <lv_zlsch>, <lv_betrg>.

  CLEAR gs_bank.

  CHECK <gt_p0009> IS NOT INITIAL.

  LOOP AT <gt_p0009> ASSIGNING <gs_p0009>.
    ASSIGN COMPONENT 'SUBTY' OF STRUCTURE <gs_p0009> TO <lv_subty>.
    IF <lv_subty> EQ '0'.
      ASSIGN COMPONENT 'BEGDA' OF STRUCTURE <gs_p0009> TO <lv_begda>.
      ASSIGN COMPONENT 'BANKL' OF STRUCTURE <gs_p0009> TO <lv_bankl>.
      ASSIGN COMPONENT 'BANKN' OF STRUCTURE <gs_p0009> TO <lv_bankn>.
      ASSIGN COMPONENT 'ZLSCH' OF STRUCTURE <gs_p0009> TO <lv_zlsch>.
      MOVE <lv_begda> TO gs_bank-effective_date_p.
      IF <lv_zlsch> EQ 'C'.
        MOVE 'C' TO gs_bank-payment_method.
        EXIT.
      ELSE.
        MOVE 'D' TO gs_bank-payment_method.
      ENDIF.
      MOVE <lv_bankl>+1(3) TO gs_bank-primary_bank.
      MOVE <lv_bankl>+4(5) TO gs_bank-primary_branch.
      MOVE <lv_bankn> TO gs_bank-primary_accnt_no.
      EXIT.
    ENDIF.
  ENDLOOP.

  IF sy-subrc NE 0.
    MOVE 'C' TO gs_bank-payment_method.
  ENDIF.

  LOOP AT <gt_p0009> ASSIGNING <gs_p0009>.
    ASSIGN COMPONENT 'SUBTY' OF STRUCTURE <gs_p0009> TO <lv_subty>.
    IF <lv_subty> EQ '1'.
      ASSIGN COMPONENT 'BEGDA' OF STRUCTURE <gs_p0009> TO <lv_begda>.
      ASSIGN COMPONENT 'BANKL' OF STRUCTURE <gs_p0009> TO <lv_bankl>.
      ASSIGN COMPONENT 'BANKN' OF STRUCTURE <gs_p0009> TO <lv_bankn>.
      ASSIGN COMPONENT 'BETRG' OF STRUCTURE <gs_p0009> TO <lv_betrg>.
      MOVE <lv_begda> TO gs_bank-effective_date_s.
      MOVE <lv_bankl>+1(3) TO gs_bank-secondary_bank.
      MOVE <lv_bankl>+4(5) TO gs_bank-secondary_branch.
      MOVE <lv_bankn> TO gs_bank-second_accnt_no.
      MOVE <lv_betrg> TO gs_bank-second_dep_amnt.
      SHIFT gs_bank-second_dep_amnt LEFT DELETING LEADING space.
      EXIT.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " GET_BANK_DETAILS
*&---------------------------------------------------------------------*
*&      Form  GET_EXEMPTIONS
*&---------------------------------------------------------------------*
*       Get employee exemptions.
*----------------------------------------------------------------------*
FORM get_exemptions .

  DATA: lv_tax TYPE c LENGTH 5 VALUE 'TAX00',
        lv_exi TYPE c LENGTH 5 VALUE 'EXI00',
        lv_num TYPE n LENGTH 2.

  FIELD-SYMBOLS: <lv_tax>, <lv_exi>.

  CLEAR gs_exemptions.

  DO 15 TIMES.
    MOVE sy-index TO lv_num.
    MOVE lv_num TO:  lv_tax+3(2), lv_exi+3(2).
    ASSIGN COMPONENT lv_tax OF STRUCTURE <gs_p0464> TO <lv_tax>.
    ASSIGN COMPONENT lv_exi OF STRUCTURE <gs_p0464> TO <lv_exi>.
    CASE <lv_tax>.
      WHEN 'FIT'.
        MOVE <lv_exi> TO gs_exemptions-fed.
      WHEN 'CPP' OR 'QPP'.
        MOVE <lv_exi> TO gs_exemptions-cpp.
      WHEN 'EI'.
        MOVE <lv_exi> TO gs_exemptions-ei.
      WHEN OTHERS.
    ENDCASE.
  ENDDO.
ENDFORM.                    " GET_EXEMPTIONS
*&---------------------------------------------------------------------*
*&      Form  GET_WFN_DATA
*&---------------------------------------------------------------------*
*       Get WFN data based on field symbols and parameters
*----------------------------------------------------------------------*
*       -->FV_ALL   If '1', then process all fields
*                   Else process only the fields that need to be
*                   compared for changes
*----------------------------------------------------------------------*
FORM get_wfn_data USING fv_all.

  FIELD-SYMBOLS: <lv_return>.

  CLEAR <gs_employee_data>.

  LOOP AT go_structdescr_ed->components INTO gs_component.
    ASSIGN COMPONENT gs_component-name OF STRUCTURE <gs_employee_data> TO <lv_return>.
    PERFORM (gs_component-name) IN PROGRAM zhro_adp_wfn_ca IF FOUND USING <lv_return>.
    IF fv_all EQ gc_all.
      CONCATENATE '_' gs_component-name INTO gs_component-name.
      PERFORM (gs_component-name) IN PROGRAM zhro_adp_wfn_ca IF FOUND USING <lv_return>.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " GET_WFN_DATA
*&---------------------------------------------------------------------*
*&      Form  CHECK_FOR_BANK_DELETION
*&---------------------------------------------------------------------*
*       Check if the secondary bank has been deleted (delimited)
*----------------------------------------------------------------------*
FORM check_for_bank_deletion .

  DATA: lv_old_subty TYPE subty,
        lv_new_subty TYPE subty,
        lv_old_endda TYPE endda,
        lv_new_endda TYPE endda,
        lv_eff_date  TYPE d,
        lv_delete    TYPE c.

  LOOP AT gt_old_p0009 INTO gs_old_p0009 WHERE subty EQ '1'. "Second bank
    MOVE gs_old_p0009-subty TO lv_old_subty.
    MOVE gs_old_p0009-endda TO lv_old_endda.
    EXIT.
  ENDLOOP.

  LOOP AT gt_new_p0009 INTO gs_new_p0009 WHERE subty EQ '1'. "Second bank
    MOVE gs_new_p0009-subty TO lv_new_subty.
    MOVE gs_new_p0009-endda TO lv_new_endda.
    EXIT.
  ENDLOOP.

  IF ( lv_old_subty EQ '1' AND lv_new_subty EQ '1' AND
       lv_new_endda LT lv_old_endda AND lv_new_endda GE gv_frbeg AND lv_new_endda LT gv_frend ).
    lv_delete = 'X'.
    lv_eff_date = lv_new_endda + 1. "Effective date of delimitation
  ELSEIF ( lv_old_subty EQ '1' AND lv_new_subty NE '1' ).
    lv_delete = 'X'.
    lv_eff_date = gv_frbeg. "Effective date of delimitation
  ENDIF.

  IF lv_delete EQ 'X'.
    MOVE lv_eff_date TO gs_bank-effective_date_s.
    MOVE '~' TO : gs_bank-secondary_bank,
                  gs_bank-secondary_branch,
                  gs_bank-second_accnt_no,
                  gs_bank-second_dep_amnt.
  ENDIF.

ENDFORM.                    " CHECK_FOR_BANK_DELETION
*&---------------------------------------------------------------------*
*&      Form  CHECK_FOR_CHANGES
*&---------------------------------------------------------------------*
*       Check for changes
*----------------------------------------------------------------------*
FORM check_for_changes .

  PERFORM check_for_new_action.
  PERFORM check_for_field_changes.

ENDFORM.                    " CHECK_FOR_CHANGES
*&---------------------------------------------------------------------*
*&      Form  CHECK_FOR_NEW_ACTION
*&---------------------------------------------------------------------*
*       Check if there are any new personnel actions
*----------------------------------------------------------------------*
FORM check_for_new_action .

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    MOVE gs_new_p0000-begda TO gv_effective_date. "Store the effective date of the new action
    IF gs_new_p0000-massn EQ '7F'.
      gv_effective_date = gv_effective_date - 1.
    ENDIF.
    CASE gs_new_p0000-massn.
      WHEN '7A' OR                "New Hire
           '7G' OR                "Rehire
           '7F' OR '7H' OR '7R'.  "Termination
        MOVE '1' TO gs_export_flags-ed_export.
        MOVE 'X' TO gs_change_blocks-cb_27.  "Time block
*        IF gs_new_p0000-massn EQ '7A' OR   "Hire
*           gs_new_p0000-massn EQ '7G'.     "Rehire
*          MOVE 'X' TO gs_change_blocks-cb_29. "Time off policy block
*        ENDIF.
      WHEN '7I' OR '7K' OR        "Leave of Absence
           '7J' OR '7N' OR        "Return from Leave of Absence
           '7D'.                  "Pay Rate Change
        MOVE '1' TO gs_export_flags-ed_export.
      WHEN '7C'.
        CASE gs_new_p0000-massg.
          WHEN '03' OR '04' OR '05'.    "Pay Rate Change
            MOVE '1' TO gs_export_flags-ed_export.
          WHEN OTHERS.
        ENDCASE.
      WHEN '7E'.
        MOVE '1' TO gs_export_flags-ed_export.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

ENDFORM.                    " CHECK_FOR_NEW_ACTION
*&---------------------------------------------------------------------*
*&      Form  CHECK_FOR_FIELD_CHANGES
*&---------------------------------------------------------------------*
*       Check if any field value has changed.
*----------------------------------------------------------------------*
FORM check_for_field_changes .

  DATA: lv_sname TYPE c LENGTH 30. "Subroutine name

  FIELD-SYMBOLS: <lv_old>, <lv_new>.

  LOOP AT go_structdescr_ed->components INTO gs_component.
    ASSIGN COMPONENT gs_component-name OF STRUCTURE gs_old_employee_data TO <lv_old>.
    ASSIGN COMPONENT gs_component-name OF STRUCTURE gs_new_employee_data TO <lv_new>.
    IF <lv_new> NE <lv_old>.
      MOVE '1' TO gs_export_flags-ed_export.
      CONCATENATE gs_component-name '_EFF_DATE' INTO lv_sname.
*     Get the effective date, if we don't have one yet
      IF gv_effective_date IS INITIAL.
        PERFORM (lv_sname) IN PROGRAM zhro_adp_wfn_ca IF FOUND CHANGING gv_effective_date.
      ENDIF.
      CONCATENATE gs_component-name '_CB' INTO lv_sname.
*     Set the change block for export
      PERFORM (lv_sname) IN PROGRAM zhro_adp_wfn_ca IF FOUND.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " CHECK_FOR_FIELD_CHANGES
*&---------------------------------------------------------------------*
*&      Form  GET_COMP_CHANGE_DATE
*&---------------------------------------------------------------------*
*       Get Date of Compensation Change
*----------------------------------------------------------------------*
*      <--FV_COMP_CHANGE_DATE  Date of Compensation Change
*----------------------------------------------------------------------*
FORM get_comp_change_date  CHANGING fv_comp_change_date.

  DATA: lv_date TYPE d.

  CLEAR fv_comp_change_date.

  CHECK gs_old_p0008 IS NOT INITIAL OR gs_old_p0001 IS NOT INITIAL.


* Pay Rate Change without SAP action
  IF gs_old_p0008-bet01 NE gs_new_p0008-bet01.
    MOVE gs_new_p0008-begda TO lv_date.
  ENDIF.

* Hours Change without SAP action
  IF gs_old_p0008-divgv NE gs_new_p0008-divgv.
    IF gs_new_p0008-begda GT lv_date.
      MOVE gs_new_p0008-begda TO lv_date.
    ENDIF.
  ENDIF.

* Rate Type Change without SAP action
  IF gs_old_employee_data-rate_type NE gs_new_employee_data-rate_type.
    IF gs_new_p0001-begda GT lv_date.
      MOVE gs_new_p0001-begda TO lv_date.
    ENDIF.
  ENDIF.

  MOVE lv_date TO fv_comp_change_date.

ENDFORM.                    " GET_COMP_CHANGE_DATE
*&---------------------------------------------------------------------*
*&      Form  GET_TRANSFERS
*&---------------------------------------------------------------------*
*       Get transfer relevant data.
*----------------------------------------------------------------------*
*      <--FV_SAME_TAX_FORM  Same Tax Form
*      <--FV_TRANSFER_DATE  Transfer Date
*----------------------------------------------------------------------*
FORM get_transfers  CHANGING fv_same_tax_form
                             fv_transfer_date.

  DATA: lv_date TYPE d.

  CLEAR: fv_same_tax_form,  fv_transfer_date.

* CRA number change within same company - with/without SAP action
  IF gs_old_employee_data-cra_pa_rq_id IS NOT INITIAL.
    IF gs_old_employee_data-cra_pa_rq_id NE gs_new_employee_data-cra_pa_rq_id.
      MOVE gs_new_p0033-begda TO lv_date.
      MOVE 'N' TO fv_same_tax_form.
    ENDIF.
  ENDIF.

* Pay Group change within same company - with/without SAP action
  IF gs_old_employee_data-pay_group IS NOT INITIAL.
    IF gs_old_employee_data-pay_group NE gs_new_employee_data-pay_group.
      IF gs_old_employee_data-rate_amount NE gs_old_employee_data-rate_amount.
        MOVE 'N' TO fv_same_tax_form.
      ELSE.
        MOVE 'Y' TO fv_same_tax_form.
      ENDIF.
      IF gs_new_p0001-begda GT lv_date.
        MOVE gs_new_p0001-begda TO lv_date.
      ENDIF.
    ENDIF.
  ENDIF.

* Province of Employment change without SAP action
  IF gs_old_employee_data-prov_of_emplymnt IS NOT INITIAL.
    IF gs_old_employee_data-prov_of_emplymnt  NE gs_new_employee_data-prov_of_emplymnt. "Change in Province of Employment
      IF gs_new_p0461-begda GT lv_date.
        MOVE gs_new_p0461-begda TO lv_date.
      ENDIF.
      MOVE 'N' TO fv_same_tax_form.
    ENDIF.
  ENDIF.

  MOVE lv_date TO fv_transfer_date.

ENDFORM.                    " GET_TRANSFERS
*&---------------------------------------------------------------------*
*&      Form  FILL_WFN_RECORDS
*&---------------------------------------------------------------------*
*       Fill the WFN records with employee and time data
*----------------------------------------------------------------------*
FORM fill_wfn_records .

*  DATA: lv_num TYPE i.

  ASSIGN gs_employee_data TO <gs_employee_data>.

*  PERFORM get_num_time_off_records CHANGING lv_num.

*  IF lv_num EQ 0.
*    CLEAR gs_change_blocks-cb_29.
*    lv_num = 1.
*  ENDIF.

*  DO lv_num TIMES.  "Looping 3 times to include the time records (by requirements)
  CLEAR: gs_employee_data, gs_line_out.
*    gv_time_iteration = gv_time_iteration + 1.
*    IF ( gv_time_iteration EQ 1 ) OR ( gv_time_iteration GT 1 AND gs_change_blocks-cb_29 EQ 'X' ).
  IF gs_export_flags-ed_export EQ '1'.
    PERFORM get_wfn_data USING gc_all.
    APPEND gs_employee_data TO gt_employee_data.
    PERFORM convert_to_csv CHANGING gs_line_out.
    PERFORM append_to_file_section.
*    APPEND gs_line_out TO gt_file_out.
    gv_number_of_records = gv_number_of_records + 1.
*        IF gv_time_iteration EQ 1.
    gv_num_exported_pernr = gv_num_exported_pernr + 1.
*        ENDIF.
  ENDIF.
*    ENDIF.
*  ENDDO.

ENDFORM.                    " FILL_WFN_RECORDS
*&---------------------------------------------------------------------*
*&      Form  WRITE_TO_FILE
*&---------------------------------------------------------------------*
*       Write records to the file
*----------------------------------------------------------------------*
FORM write_to_file .

  DATA: lv_lines TYPE i.

  APPEND LINES OF : gt_file_1 TO gt_file_out,
                    gt_file_2 TO gt_file_out,
                    gt_file_3 TO gt_file_out,
                    gt_file_4 TO gt_file_out,
                    gt_file_5 TO gt_file_out.

  DESCRIBE TABLE gt_file_out LINES lv_lines.
  CHECK lv_lines GT 1.

  IF p_pc EQ 'X'.
    PERFORM create_file_on_pc USING p_pfile gt_file_out.
  ELSEIF p_srv EQ 'X'.
    PERFORM create_file_on_srv USING p_sfile p_backup gt_file_out.
  ENDIF.

ENDFORM.                    " WRITE_TO_FILE
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_EMPLOYEE
*&---------------------------------------------------------------------*
*       Employee Validation
*----------------------------------------------------------------------*
FORM validate_employee .

  IF gt_new_p0000[] IS INITIAL.
*   skip employees that have new hires in the future.
    SUBTRACT 1 FROM gv_num_selected_pernr.
    REJECT.
  ENDIF.

  PERFORM get_data_to_validate.

  PERFORM check_for_actions_to_skip.
  PERFORM check_error_e013.
  PERFORM check_termination.
  PERFORM check_error_e001.
  PERFORM check_error_e003.
  PERFORM check_error_e004.
  PERFORM check_error_e005_e006.
  PERFORM check_error_e007_e008.
  PERFORM check_error_e009.
  PERFORM check_error_e010_e011.
  PERFORM check_error_e012.
  PERFORM check_error_w001.
*  PERFORM check_error_w002.
  PERFORM check_error_w003.
  PERFORM check_error_w004.
  PERFORM check_error_w005.
  PERFORM check_error_w006.
  PERFORM check_error_w007.
  PERFORM check_error_w008.
*  PERFORM check_error_w009.
*  PERFORM check_error_w010.
*  PERFORM check_error_w011.
  PERFORM check_error_w012.
  PERFORM clear_globals.

ENDFORM.                    " VALIDATE_EMPLOYEE
*&---------------------------------------------------------------------*
*&      Form  GET_NUM_TIME_OFF_RECORDS
*&---------------------------------------------------------------------*
*       Get the number of time off records from infotype 33
*----------------------------------------------------------------------*
FORM get_num_time_off_records  CHANGING fv_num.

  IF gs_new_p0033-aus04 IS NOT INITIAL.
    fv_num = fv_num + 1.
  ENDIF.

  IF gs_new_p0033-aus05 IS NOT INITIAL.
    fv_num = fv_num + 1.
  ENDIF.

  IF gs_new_p0033-aus06 IS NOT INITIAL.
    fv_num = fv_num + 1.
  ENDIF.

ENDFORM.                    " GET_NUM_TIME_OFF_RECORDS
*&---------------------------------------------------------------------*
*&      Form  ACTION_BASED_VALIDATION
*&---------------------------------------------------------------------*
*       This is to add any extra logic that is based on Actions.
*       For example, only send addresses and bank details on Hires
*       and Re-Hires.
*----------------------------------------------------------------------*
FORM action_based_validation .

* Don't send address for all actions except Hire/Rehire
  IF gs_new_p0000-massn NE '7A' AND "New Hire
     gs_new_p0000-massn NE '7G'.    "Rehire

    CLEAR:  gs_change_blocks-cb_14. "Addresses
*            gs_change_blocks-cb_16, "Primary Bank      [[ When ESS is enabled for bank details ]]
*            gs_change_blocks-cb_17. "Secondary Bank    [[ these can be added.                  ]]
  ELSE.
    MOVE 'X' TO : gs_change_blocks-cb_20, gs_change_blocks-cb_21.   "Send Fed/Prov Tax Credit Type on Hire/Re-hire
  ENDIF.

ENDFORM.                    " ACTION_BASED_VALIDATION
*&---------------------------------------------------------------------*
*&      Form  DATA_COLLECTION
*&---------------------------------------------------------------------*
*       Data Collectin Routine
*----------------------------------------------------------------------*
FORM data_collection .

  PERFORM init_globals.
  PERFORM get_old_data.
  IF p_cp EQ 'X'. "Current period for all payroll areas
    PERFORM get_current_period CHANGING gv_frper gv_frbeg gv_frend.
  ENDIF.
  PERFORM get_new_data.

ENDFORM.                    " DATA_COLLECTION
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E001
*&---------------------------------------------------------------------*
FORM check_error_e001 .

  IF gs_new_p0002-perid EQ '000000000'.
    PERFORM error
                USING
                   'E'
                   'E001'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E001
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E003
*&---------------------------------------------------------------------*
FORM check_error_e003 .

  IF gs_new_p0185-icnum IS INITIAL.
    PERFORM error
                USING
                   'E'
                   'E003'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E003
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E004
*&---------------------------------------------------------------------*
FORM check_error_e004 .

  IF gs_new_p0001-pernr IS INITIAL AND gs_new_p0032-pnalt IS INITIAL.
    PERFORM error
                USING
                   'E'
                   'E004'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E004
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E005_E006
*&---------------------------------------------------------------------*
FORM check_error_e005_e006 .

  DATA: lv_pernr TYPE pernr_d,
        lv_begda TYPE begda,
        lv_endda TYPE endda.

  DATA: lt_0185 TYPE STANDARD TABLE OF p0185,
        ls_0185 TYPE p0185.

  IF gs_new_p0001-yysupervisor_id IS INITIAL.
    PERFORM error
                USING
                   'E'
                   'E005'
                   space
                   space
                   space
                   space.
  ENDIF.

  lv_pernr = gs_new_p0001-yysupervisor_id.
  lv_begda = gs_new_p0001-begda.
  lv_endda = gs_new_p0001-endda.

* Get the WFN ID of the Supervisor
  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      pernr           = lv_pernr
      infty           = '0185'
      begda           = lv_begda
      endda           = lv_endda
    TABLES
      infty_tab       = lt_0185
    EXCEPTIONS
      infty_not_found = 1
      OTHERS          = 2.
  IF sy-subrc EQ 0.
    SORT lt_0185 DESCENDING BY endda.
    LOOP AT lt_0185 INTO ls_0185
      WHERE ictyp EQ 'Z3'.
      EXIT.
    ENDLOOP.
    IF sy-subrc NE 0 OR ls_0185-icnum IS INITIAL.
      PERFORM error
                  USING
                     'E'
                     'E006'
                     space
                     space
                     space
                     space.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E005_E006
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E007_E008
*&---------------------------------------------------------------------*
FORM check_error_e007_e008 .

  IF gs_new_p0008-divgv IS INITIAL.
    PERFORM error
                USING
                   'E'
                   'E007'
                   space
                   space
                   space
                   space.
  ENDIF.

  IF gs_new_p0008-bet01 IS INITIAL.
    PERFORM error
                USING
                   'E'
                   'E008'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E007_E008
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E009
*&---------------------------------------------------------------------*
FORM check_error_e009 .

  CHECK gs_new_p0000-begda NE gs_old_p0000-begda. "New action

  CASE gs_new_p0000-massn.
    WHEN  '7D'.                  "Pay Rate Change
      IF gs_old_p0008-bet01 EQ gs_new_p0008-bet01.
        PERFORM error
                    USING
                       'E'
                       'E009'
                       space
                       space
                       space
                       space.
      ENDIF.
    WHEN '7C'.
      CASE gs_new_p0000-massg.
        WHEN '03' OR '04' OR '05'.    "Pay Rate Change
          IF gs_old_p0008-bet01 EQ gs_new_p0008-bet01.
            PERFORM error
                        USING
                           'E'
                           'E009'
                           space
                           space
                           space
                           space.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
  ENDCASE.

ENDFORM.                    " CHECK_ERROR_E009
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E010_E011
*&---------------------------------------------------------------------*
FORM check_error_e010_e011 .

  DATA: lv_darnn    TYPE c LENGTH 5 VALUE 'DARNN',
        lv_datnn    TYPE c LENGTH 5 VALUE 'DATNN',
        lv_num      TYPE n LENGTH 2,
        lv_date_07  TYPE dardt,       "Last Day Worked
        lv_date_08  TYPE dardt.       "Last Day Paid

  FIELD-SYMBOLS: <lv_darnn> TYPE data,
                 <lv_datnn> TYPE data.


  DO 12 TIMES.
    lv_num = lv_num + 1.
    lv_darnn+3(2) = lv_num.
    lv_datnn+3(2) = lv_num.

    ASSIGN COMPONENT lv_darnn OF STRUCTURE gs_new_p0041 TO <lv_darnn>.
    ASSIGN COMPONENT lv_datnn OF STRUCTURE gs_new_p0041 TO <lv_datnn>.

    CASE <lv_darnn>.
      WHEN '07'.
        MOVE <lv_datnn> TO lv_date_07.   "Last Day Worked
      WHEN '08'.
        MOVE <lv_datnn> TO lv_date_08.   "Last Day Paid
      WHEN OTHERS.
    ENDCASE.

  ENDDO.

  CASE gs_new_p0000-massn.
    WHEN  '7F' OR '7H' OR '7R'.  "Termination
      IF lv_date_08 IS INITIAL.
        PERFORM error
                    USING
                       'E'
                       'E010'
                       space
                       space
                       space
                       space.
      ENDIF.
      IF lv_date_07 IS INITIAL.
        PERFORM error
                    USING
                       'E'
                       'E011'
                       space
                       space
                       space
                       space.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " CHECK_ERROR_E010_E011
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E012
*&---------------------------------------------------------------------*
FORM check_error_e012 .

  CASE gs_new_p0001-bukrs.
    WHEN  'CA10' OR 'CA70'.   "T56B
      IF gs_new_p0033-aus01 EQ '0'.
        PERFORM error
                    USING
                       'E'
                       'E012'
                       space
                       space
                       space
                       space.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " CHECK_ERROR_E012
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_E013
*&---------------------------------------------------------------------*
FORM check_error_e013 .

  IF gs_new_p0000-massn(1) NE '7'.
    PERFORM error
                USING
                   'E'
                   'E013'
                   gs_new_p0000-massn
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_E013
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W001
*&---------------------------------------------------------------------*
FORM check_error_w001 .

  DATA: lv_darnn    TYPE c LENGTH 5 VALUE 'DARNN',
        lv_datnn    TYPE c LENGTH 5 VALUE 'DATNN',
        lv_num      TYPE n LENGTH 2,
        lv_date_06  TYPE dardt.       "Adjusted Service Date

  FIELD-SYMBOLS: <lv_darnn> TYPE data,
                 <lv_datnn> TYPE data.

  DO 12 TIMES.

    lv_num = lv_num + 1.
    lv_darnn+3(2) = lv_num.
    lv_datnn+3(2) = lv_num.

    ASSIGN COMPONENT lv_darnn OF STRUCTURE gs_new_p0041 TO <lv_darnn>.
    ASSIGN COMPONENT lv_datnn OF STRUCTURE gs_new_p0041 TO <lv_datnn>.

    CASE <lv_darnn>.
      WHEN '06'.
        MOVE <lv_datnn> TO lv_date_06.   "Adjusted Service Date
      WHEN OTHERS.
    ENDCASE.

  ENDDO.

  IF lv_date_06 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W001'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W001
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W002
*&---------------------------------------------------------------------*
FORM check_error_w002 .

  IF gs_new_p0002-famst IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W002'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W002
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_TO_VALIDATE
*&---------------------------------------------------------------------*
FORM get_data_to_validate .


  SORT gt_new_p0000 BY endda DESCENDING.
  READ TABLE gt_new_p0000 INTO gs_new_p0000 INDEX 1.

  SORT gt_old_p0000 BY endda DESCENDING.
  READ TABLE gt_old_p0000 INTO gs_old_p0000 INDEX 1.

  SORT gt_new_p0001 BY endda DESCENDING.
  READ TABLE gt_new_p0001 INTO gs_new_p0001 INDEX 1.

  SORT gt_new_p0002 BY endda DESCENDING.
  READ TABLE gt_new_p0002 INTO gs_new_p0002 INDEX 1.

  SORT gt_old_p0008 BY endda DESCENDING.
  READ TABLE gt_old_p0008 INTO gs_old_p0008 INDEX 1.

  SORT gt_new_p0008 BY endda DESCENDING.
  READ TABLE gt_new_p0008 INTO gs_new_p0008 INDEX 1.

  SORT gt_new_p0032 BY endda DESCENDING.
  READ TABLE gt_new_p0032 INTO gs_new_p0032 INDEX 1.

  SORT gt_new_p0033 BY endda DESCENDING.
  READ TABLE gt_new_p0033 INTO gs_new_p0033 INDEX 1.

  SORT gt_new_p0041 BY endda DESCENDING.
  READ TABLE gt_new_p0041 INTO gs_new_p0041 INDEX 1.

  SORT gt_new_p0105 BY endda DESCENDING.
  READ TABLE gt_new_p0105 INTO gs_new_p0105 INDEX 1.

  SORT gt_new_p0185 BY endda DESCENDING.
  READ TABLE gt_new_p0185 INTO gs_new_p0185 INDEX 1.

  SORT gt_new_p0461 BY endda DESCENDING.
  READ TABLE gt_new_p0461 INTO gs_new_p0461 INDEX 1.

  SORT gt_new_p0462 BY endda DESCENDING.
  READ TABLE gt_new_p0462 INTO gs_new_p0462 INDEX 1.

  SORT gt_new_p0463 BY endda DESCENDING.
  READ TABLE gt_new_p0463 INTO gs_new_p0463 INDEX 1.

  SORT gt_new_p0464 BY endda DESCENDING.
  READ TABLE gt_new_p0464 INTO gs_new_p0464 INDEX 1.

ENDFORM.                    " GET_DATA_TO_VALIDATE
*&---------------------------------------------------------------------*
*&      Form  CLEAR_GLOBALS
*&---------------------------------------------------------------------*
FORM clear_globals .

  CLEAR: gs_new_p0000,
         gs_old_p0000,
         gs_new_p0001,
         gs_new_p0002,
         gs_old_p0008,
         gs_new_p0008,
         gs_new_p0032,
         gs_new_p0033,
         gs_new_p0041,
         gs_new_p0105,
         gs_new_p0185,
         gs_new_p0461,
         gs_new_p0462,
         gs_new_p0463,
         gs_new_p0464.
ENDFORM.                    " CLEAR_GLOBALS
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W003
*&---------------------------------------------------------------------*
FORM check_error_w003 .

  IF gs_new_p0002-sprsl IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W003'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W003
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W004
*&---------------------------------------------------------------------*
FORM check_error_w004 .

  IF gs_new_p0002-gesch IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W004'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W004
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W005
*&---------------------------------------------------------------------*
FORM check_error_w005 .

  CASE gs_new_p0000-massn.
    WHEN '7A' OR                "New Hire
         '7G'.                  "Rehire
      IF gt_new_p0006[] IS INITIAL.
        PERFORM error
                    USING
                       'W'
                       'W005'
                       space
                       space
                       space
                       space.
      ENDIF.

  ENDCASE.

ENDFORM.                    " CHECK_ERROR_W005
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W006
*&---------------------------------------------------------------------*
FORM check_error_w006 .

  IF gs_new_p0105-usrid_long IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W006'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W006
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W007
*&---------------------------------------------------------------------*
FORM check_error_w007 .

  CASE gs_new_p0000-massn.
    WHEN '7A' OR                "New Hire
         '7G'.                  "Rehire
      IF gt_new_p0009[] IS INITIAL.
        PERFORM error
                    USING
                       'W'
                       'W007'
                       space
                       space
                       space
                       space.
      ENDIF.
  ENDCASE.

ENDFORM.                    " CHECK_ERROR_W007
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W008
*&---------------------------------------------------------------------*
FORM check_error_w008 .

  IF gs_new_p0461 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W008'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W008
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W009
*&---------------------------------------------------------------------*
FORM check_error_w009 .

  IF gs_new_p0462 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W009'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W009
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W010
*&---------------------------------------------------------------------*
FORM check_error_w010 .

  IF gs_new_p0463 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W010'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W010
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W011
*&---------------------------------------------------------------------*
FORM check_error_w011 .

  IF gs_new_p0464 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W011'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W011
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR_W012
*&---------------------------------------------------------------------*
FORM check_error_w012 .

  IF gs_new_p0033 IS INITIAL.
    PERFORM error
                USING
                   'W'
                   'W012'
                   space
                   space
                   space
                   space.
  ENDIF.

ENDFORM.                    " CHECK_ERROR_W012
*&---------------------------------------------------------------------*
*&      Form  CHECK_TERMINATION
*&---------------------------------------------------------------------*
*       Check if termination already sent
*----------------------------------------------------------------------*
FORM check_termination .

  IF ( gs_old_p0000-massn EQ '7F' AND gs_new_p0000-massn EQ '7F' ) OR
     ( gs_old_p0000-massn EQ '7H' AND gs_new_p0000-massn EQ '7H' ) OR
     ( gs_old_p0000-massn EQ '7R' AND gs_new_p0000-massn EQ '7R' ).
    SUBTRACT 1 FROM gv_num_selected_pernr.
    REJECT.
  ENDIF.

* Old employee terminated before Ev5 was implemented.  Do not send.
* Change table will be empty and existing IT0 record will be 7F.
  IF gt_old_p0000[] IS INITIAL AND
    ( gs_new_p0000-massn EQ '7F' OR gs_new_p0000-massn EQ '7H' OR gs_new_p0000-massn EQ '7R' ).
    SUBTRACT 1 FROM gv_num_selected_pernr.
    REJECT.
  ENDIF.
ENDFORM.                    " CHECK_TERMINATION
*&---------------------------------------------------------------------*
*&      Form  CHECK_FOR_ACTIONS_TO_SKIP
*&---------------------------------------------------------------------*
FORM check_for_actions_to_skip .

  IF gs_new_p0000-massn(1) EQ 'X'.
    SUBTRACT 1 FROM gv_num_selected_pernr.
    REJECT.
  ENDIF.

ENDFORM.                    " CHECK_FOR_ACTIONS_TO_SKIP
*&---------------------------------------------------------------------*
*&      Form  APPEND_TO_FILE_SECTION
*&---------------------------------------------------------------------*
*       Append line to the corresponding section of the
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM append_to_file_section .

  IF gs_old_p0001-yymanager_flag IS NOT INITIAL AND gs_new_p0001-yymanager_flag IS NOT INITIAL.
    IF ( gs_old_p0001-yymanager_flag NE gs_new_p0001-yymanager_flag ) AND
         gs_new_p0000-stat2 EQ 3.
      IF gs_new_p0001-yymanager_flag EQ 'Y'.
        APPEND gs_line_out TO gt_file_1.
      ELSEIF gs_old_p0001-yymanager_flag EQ 'Y' AND gs_new_p0001-yymanager_flag EQ 'N'.
        APPEND gs_line_out TO gt_file_3.
      ENDIF.
    ELSEIF ( gs_old_p0000-stat2 NE gs_new_p0000-stat2 ) AND
             gs_new_p0000-stat2 NE 3.
      IF gs_new_p0001-yymanager_flag EQ 'N'.
        APPEND gs_line_out TO gt_file_4.
      ELSEIF gs_new_p0001-yymanager_flag EQ 'Y'.
        APPEND gs_line_out TO gt_file_5.
      ENDIF.
    ELSE.
      APPEND gs_line_out TO gt_file_2.
    ENDIF.
  ELSE.
    IF gs_new_p0001-yymanager_flag EQ 'Y'.  "New manager hire.
      APPEND gs_line_out TO gt_file_1.
    ELSE.
      APPEND gs_line_out TO gt_file_2.
    ENDIF.
  ENDIF.

ENDFORM.                    " APPEND_TO_FILE_SECTION