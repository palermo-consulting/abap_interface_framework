*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_F02
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  POSITION_ID
*&---------------------------------------------------------------------*
*       Position ID
*----------------------------------------------------------------------*
FORM position_id USING fv_return.

  FIELD-SYMBOLS: <lv_icnum>.

  ASSIGN COMPONENT 'ICNUM' OF STRUCTURE <gs_p0185> TO <lv_icnum>.

  fv_return = <lv_icnum>.

ENDFORM.                    "POSITION_ID
*&---------------------------------------------------------------------*
*&      Form  _CHANGE_EFFECTIV
*&---------------------------------------------------------------------*
*       Change Effective On - There must always be a Change Effection
*       On date
*----------------------------------------------------------------------*
FORM _change_effective USING fv_return.

  PERFORM convert_date USING gv_effective_date CHANGING fv_return.

ENDFORM.                    "_CHANGE_EFFECTIVE
*&---------------------------------------------------------------------*
*&      Form  _IS_PAID_BY_WFN
*&---------------------------------------------------------------------*
*       Is Paid By WFN
*         Add
*           Required when adding a new associate and/or position record.
*           When 'Y', the position is to be created as a paid position.
*           When 'N', the position is to be created as a non-paid position.
*         Change
*           Field must be blank when updating an existing associate and/or
*           position record.
*         Delete
*           Not allowed.
*----------------------------------------------------------------------*
FORM _is_paid_by_wfn USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "Only export value when there is a New Hire or Rehire
    IF gs_new_p0000-massn EQ '7A'. "OR gs_new_p0000-massn EQ '7G'.  "New Hire
      MOVE 'Y' TO fv_return.
    ENDIF.
  ENDIF.

  IF gs_new_employee_data-position_id NE gs_old_employee_data-position_id. "OR when there is a position change.
    MOVE 'Y' TO fv_return.
  ENDIF.

ENDFORM.                    "_IS_PAID_BY_WFN
*&---------------------------------------------------------------------*
*&      Form  _POS_USES_TIME
*&---------------------------------------------------------------------*
*       Position Uses Time
*         Add
*           Required when adding a new associate and/or position record.
*           Cannot be 'Y' when a new position record is being inserted with an
*           Employee Status equal to 'T', 'R', 'D' or 'L'.
*         Change
*           Value is optional.
*         Delete
*           Not allowed.
*----------------------------------------------------------------------*
FORM _pos_uses_time USING fv_return.

**  CHECK gv_time_iteration LT 2.

  DATA: lv_employee_status.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "Only export value when there is a New Hire or Rehire
    IF gs_new_p0000-massn EQ '7A' OR gs_new_p0000-massn EQ '7G'.  "New Hire/Rehire
      MOVE 'Y' TO fv_return.
    ENDIF.
  ENDIF.

  IF gs_new_employee_data-position_id NE gs_old_employee_data-position_id. "OR when there is a position change.
    MOVE 'Y' TO fv_return.
  ENDIF.

  PERFORM get_employee_status USING gs_new_p0000-massn gs_new_p0000-massg CHANGING lv_employee_status.

  CASE lv_employee_status.
    WHEN 'T' OR 'R' OR 'D' OR 'L'.  "Cannot be 'Y' when Employee Status equal to 'T', 'R', 'D' or 'L'.
      CLEAR fv_return.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    "_POS_USES_TIME
*&---------------------------------------------------------------------*
*&      Form  CO_CODE
*&---------------------------------------------------------------------*
*       Co Code
*         Supply when the value is changed or
*         for a hire action or
*         for a rehire action or
*         for a transfer
*----------------------------------------------------------------------*
FORM co_code USING fv_return.

  FIELD-SYMBOLS: <lv_bukrs>.

  ASSIGN COMPONENT 'BUKRS' OF STRUCTURE <gs_p0001> TO <lv_bukrs>.

  CASE <lv_bukrs>.
    WHEN 'SP01'.
      MOVE 'T55Z' TO fv_return.
    WHEN 'SP02'.
      MOVE 'T55X' TO fv_return.
    WHEN 'SP03'.
      MOVE 'T55Y' TO fv_return.
    WHEN 'SP04'.
      MOVE 'T56A' TO fv_return.
    WHEN 'CA10' OR 'CA20'.
      MOVE 'T56B' TO fv_return.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    "CO_CODE
*&---------------------------------------------------------------------*
*&      Form  _FILE_NUMBER
*&---------------------------------------------------------------------*
*       File Number
*         Required when Is Paid By WFN is 'Y', Position ID is not provided
*         and Auto Assign Next File Number is 'off'.
*         Value is not permitted when Is Paid By WFN is 'N'.
*----------------------------------------------------------------------*
FORM _file_number USING fv_return.

  FIELD-SYMBOLS: <lv_pnalt>,
                 <lv_pernr>.

  ASSIGN COMPONENT 'PNALT' OF STRUCTURE <gs_p0032> TO <lv_pnalt>.
  ASSIGN COMPONENT 'PERNR' OF STRUCTURE <gs_p0001> TO <lv_pernr>.

  IF <lv_pnalt> IS NOT INITIAL.
    MOVE <lv_pnalt> TO fv_return.
  ELSE.
    MOVE <lv_pernr> TO fv_return.
  ENDIF.

ENDFORM.                    "_FILE_NUMBER
*&---------------------------------------------------------------------*
*&      Form  _HIRE_DATE
*&---------------------------------------------------------------------*
*       Hire Date
*----------------------------------------------------------------------*
FORM _hire_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF gs_new_p0000-massn EQ '7A'. "Hire action
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_HIRE_DATE
*&---------------------------------------------------------------------*
*&      Form  SENIORITY_DATE
*&---------------------------------------------------------------------*
*       Seniority Date
*----------------------------------------------------------------------*
FORM seniority_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_3 EQ 'X'.

    PERFORM convert_date USING gv_date_01 CHANGING fv_return.

  ENDIF.

ENDFORM.                    "SENIORITY_DATE
*&---------------------------------------------------------------------*
*&      Form  CREDITED_SERVICE_DATE
*&---------------------------------------------------------------------*
*       Credited Service Date
*----------------------------------------------------------------------*
FORM credited_service_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_3 EQ 'X'.

    PERFORM convert_date USING gv_date_06 CHANGING fv_return.

  ENDIF.

ENDFORM.                    "CREDITED_SERVICE_DATE
*&---------------------------------------------------------------------*
*&      Form  ADJUSTED_SERVICE_DATE
*&---------------------------------------------------------------------*
*       Adjusted Service Date
*----------------------------------------------------------------------*
FORM adjusted_service_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_3 EQ 'X'.

    PERFORM convert_date USING gv_date_06 CHANGING fv_return.

  ENDIF.

ENDFORM.                    "ADJUSTED_SERVICE_DATE
*&---------------------------------------------------------------------*
*&      Form   EMPLOYEE_STATUS
*&---------------------------------------------------------------------*
*       Employee Status
*----------------------------------------------------------------------*
FORM employee_status USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_4 EQ 'X'.

    FIELD-SYMBOLS: <lv_massn>, <lv_massg>.

    IF <gs_p0000> IS NOT INITIAL.

      ASSIGN COMPONENT 'MASSN' OF STRUCTURE <gs_p0000> TO <lv_massn>.
      ASSIGN COMPONENT 'MASSG' OF STRUCTURE <gs_p0000> TO <lv_massg>.

      PERFORM get_employee_status USING <lv_massn> <lv_massg> CHANGING fv_return.

    ENDIF.

  ENDIF.


ENDFORM.                    " EMPLOYEE_STATUS
*&---------------------------------------------------------------------*
*&      Form  _TERMINATION_DATE
*&---------------------------------------------------------------------*
*       Termination Date
*----------------------------------------------------------------------*
FORM _termination_date USING fv_return.

  DATA: lv_date TYPE d.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF gs_new_p0000-massn EQ '7H' OR
       gs_new_p0000-massn EQ '7R'.
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ENDIF.
    IF gs_new_p0000-massn EQ '7F'.
      lv_date = gs_new_p0000-begda - 1.
      PERFORM convert_date USING lv_date CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_TERMINATION_DATE
*&---------------------------------------------------------------------*
*&      Form  _TERM_REASON
*&---------------------------------------------------------------------*
*       Termination Reason
*----------------------------------------------------------------------*
FORM _term_reason USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    CASE gs_new_p0000-massn.
      WHEN '7F'.
        CASE gs_new_p0000-massg.
          WHEN '01'.
            MOVE        'N' TO fv_return.
          WHEN '02'.
            MOVE        'N' TO fv_return.
          WHEN '03'.
            MOVE        'C' TO fv_return.
          WHEN '04'.
            MOVE        'F' TO fv_return.
          WHEN '05'.
            MOVE        'N' TO fv_return.
          WHEN '06'.
            MOVE        'N' TO fv_return.
          WHEN '07'.
            MOVE        'N' TO fv_return.
          WHEN '08'.
            MOVE        'K' TO fv_return.
          WHEN '09'.
            MOVE        'V' TO fv_return.
          WHEN '10'.
            MOVE        'P' TO fv_return.
          WHEN '11'.
            MOVE        'U' TO fv_return.
          WHEN '12'.
            MOVE        'T' TO fv_return.
          WHEN '13'.
            MOVE        'U' TO fv_return.
          WHEN '14'.
            MOVE        'U' TO fv_return.
          WHEN '15'.
            MOVE        'P' TO fv_return.
          WHEN '16'.
            MOVE        'N' TO fv_return.
          WHEN '17'.
            MOVE        'N' TO fv_return.
          WHEN '18'.
            MOVE        'W' TO fv_return.
          WHEN '19'.
            MOVE        'M' TO fv_return.
          WHEN '20'.
            MOVE        'N' TO fv_return.
          WHEN '21'.
            MOVE        'T' TO fv_return.
          WHEN '22'.
            MOVE        'V' TO fv_return.
          WHEN '23'.
            MOVE        'B' TO fv_return.
          WHEN '24'.
            MOVE        'B' TO fv_return.
          WHEN OTHERS.
        ENDCASE.
*      WHEN '7H'.
*        CASE gs_new_p0000-massg.
*          WHEN '01'.
*            MOVE        'E05' TO fv_return.
*          WHEN '02'.
*            MOVE        'G07' TO fv_return.
*          WHEN '03'.
*            MOVE        'G07' TO fv_return.
*          WHEN OTHERS.
*        ENDCASE.
*      WHEN '7R'.
*        CASE gs_new_p0000-massg.
*          WHEN '01'.
*            MOVE        'K00' TO fv_return.
*          WHEN '02'.
*            MOVE        'K00' TO fv_return.
*          WHEN '03'.
*            MOVE        'K00' TO fv_return.
*          WHEN OTHERS.
*        ENDCASE.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

ENDFORM.                    "_TERM_REASON
*&---------------------------------------------------------------------*
*&      Form  _REHIRE_DATE
*&---------------------------------------------------------------------*
*       Rehire Date
*----------------------------------------------------------------------*
FORM _rehire_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF gs_new_p0000-massn EQ '7G'.
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_REHIRE_DATE
*&---------------------------------------------------------------------*
*&      Form  _REHIRE_REASON
*&---------------------------------------------------------------------*
*       Rehire Reason
*----------------------------------------------------------------------*
FORM _rehire_reason USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF gs_new_p0000-massn EQ '7G'. "Rehire
      MOVE 'NEW' TO fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_REHIRE_REASON
*&---------------------------------------------------------------------*
*&      Form  _LOA_START_DATE
*&---------------------------------------------------------------------*
*       Leave of Absence Start Date
*----------------------------------------------------------------------*
FORM _loa_start_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF  gs_new_p0000-massn EQ '7I' OR "UnPaid LOA
        gs_new_p0000-massn EQ '7K' OR "Hire Unpaid LOA
        gs_new_p0000-massn EQ '7L' OR "Hire Paid LOA
        gs_new_p0000-massn EQ '7M'.   "Paid LOA – Active Status
      PERFORM convert_date USING gs_new_p0000-begda  CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_LOA_START_DATE
*&---------------------------------------------------------------------*
*&      Form  _LOA_EXP_RET_DATE
*&---------------------------------------------------------------------*
*       Leave of Absence Expected Return Date
*----------------------------------------------------------------------*
FORM _loa_exp_ret_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF  gs_new_p0000-massn EQ '7I' OR "UnPaid LOA
        gs_new_p0000-massn EQ '7K' OR "Hire Unpaid LOA
        gs_new_p0000-massn EQ '7L' OR "Hire Paid LOA
        gs_new_p0000-massn EQ '7M'.   "Paid LOA – Active Status
      IF gs_new_p0019-termn IS NOT INITIAL.
        PERFORM convert_date USING gs_new_p0019-termn  CHANGING fv_return.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    "_LOA_EXP_RET_DATE
*&---------------------------------------------------------------------*
*&      Form  _LOA_RETURN_DATE
*&---------------------------------------------------------------------*
*       Leave of Absence Return Date
*----------------------------------------------------------------------*
FORM _loa_return_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF  gs_new_p0000-massn EQ '7J' OR
        gs_new_p0000-massn EQ '7N'.
      PERFORM convert_date USING gs_new_p0000-begda  CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_LOA_RETURN_DATE
*&---------------------------------------------------------------------*
*&      Form  _LOA_REASON
*&---------------------------------------------------------------------*
*       Leave of Absence Reason
*----------------------------------------------------------------------*
FORM _loa_reason USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    CASE gs_new_p0000-massn.
      WHEN '7I'. "UnPaid LOA.
        CASE gs_new_p0000-massg.
          WHEN   '01'.
            MOVE 'DIS'       TO fv_return.
          WHEN   '02'.
            MOVE 'DIS'       TO fv_return.
*          WHEN   '03'.
*            MOVE 'N00'       TO fv_return.
          WHEN   '04'.
            MOVE 'PER'       TO fv_return.
          WHEN   '05'.
            MOVE 'FAM'       TO fv_return.
          WHEN   '06'.
            MOVE 'FAM'       TO fv_return.
          WHEN   '07'.
            MOVE 'PER'       TO fv_return.
          WHEN   '08'.
            MOVE 'EDU'       TO fv_return.
          WHEN   '09'.
            MOVE 'MIL'       TO fv_return.
          WHEN   '10'.
            MOVE 'DIS'       TO fv_return.
*          WHEN   '11'.
*            MOVE 'A00'       TO fv_return.
          WHEN OTHERS.
        ENDCASE.
      WHEN '7K'. "Hire Unpaid LOA.
        CASE gs_new_p0000-massg.
          WHEN   '01'.
            MOVE 'DIS'       TO fv_return.
          WHEN   '02'.
            MOVE 'DIS'       TO fv_return.
          WHEN   '03'.
            MOVE 'PER'       TO fv_return.
          WHEN   '04'.
            MOVE 'PER'       TO fv_return.
          WHEN   '05'.
            MOVE 'FAM'       TO fv_return.
          WHEN   '06'.
            MOVE 'FAM'       TO fv_return.
          WHEN   '07'.
            MOVE 'PER'       TO fv_return.
          WHEN   '08'.
            MOVE 'EDU'       TO fv_return.
          WHEN   '09'.
            MOVE 'MIL'       TO fv_return.
          WHEN   '10'.
            MOVE 'DIS'       TO fv_return.
          WHEN OTHERS.
        ENDCASE.
      WHEN '7M'. "Paid LOA.
        CASE gs_new_p0000-massg.
          WHEN   '01'.
            MOVE 'DIS'       TO fv_return.
          WHEN   '03'.
            MOVE 'PER'       TO fv_return.
          WHEN   '04'.
            MOVE 'PER'       TO fv_return.
          WHEN OTHERS.
        ENDCASE.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

ENDFORM.                    "_LOA_REASON
*&---------------------------------------------------------------------*
*&      Form  _POS_START_DATE
*&---------------------------------------------------------------------*
*       Position Start Date
*----------------------------------------------------------------------*
FORM _pos_start_date USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    IF gs_new_p0000-massn EQ '7A' OR gs_new_p0000-massn EQ '7G'.  "Hire or Rehire
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_POS_START_DATE
*&---------------------------------------------------------------------*
*&      Form  GET_REPORTS_TO_ID
*&---------------------------------------------------------------------*
*       Reports To Position ID
*----------------------------------------------------------------------*
FORM get_reports_to_id USING fv_return.

  DATA: lv_pernr TYPE pernr_d,
        lv_begda TYPE begda,
        lv_endda TYPE endda.

  DATA: lt_0185 TYPE STANDARD TABLE OF p0185,
        ls_0185 TYPE p0185.

  FIELD-SYMBOLS: <lv_yysupervisor_id>, <lv_begda>, <lv_endda>.

  ASSIGN COMPONENT 'YYSUPERVISOR_ID' OF STRUCTURE <gs_p0001> TO <lv_yysupervisor_id>.
  ASSIGN COMPONENT 'BEGDA'           OF STRUCTURE <gs_p0001> TO <lv_begda>.
  ASSIGN COMPONENT 'ENDDA'           OF STRUCTURE <gs_p0001> TO <lv_endda>.

  lv_pernr = <lv_yysupervisor_id>.
  lv_begda = <lv_begda>.
  lv_endda = <lv_endda>.

*   Get the WFN ID of the Supervisor
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
    IF sy-subrc EQ 0 AND ls_0185-icnum IS NOT INITIAL.
      MOVE ls_0185-icnum TO fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "GET_REPORTS_TO_ID
*&---------------------------------------------------------------------*
*&      Form  REPORTS_TO_ID
*&---------------------------------------------------------------------*
*       Reports To Position ID
*----------------------------------------------------------------------*
FORM reports_to_id USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.
    PERFORM get_reports_to_id USING fv_return.
  ENDIF.

ENDFORM.                    "REPORTS_TO_ID
*&---------------------------------------------------------------------*
*&      Form  HOME_COST_NUMBER
*&---------------------------------------------------------------------*
*       Home Cost Number
*         Supply only when changed
*----------------------------------------------------------------------*
FORM home_cost_number USING fv_return.

*  CHECK gv_time_iteration LT 2.

  DATA: lv_kostl LIKE p0001-kostl.

  IF gs_change_blocks-cb_5 EQ 'X'.

    FIELD-SYMBOLS: <lv_bukrs>, <lv_kostl>.

    ASSIGN COMPONENT 'BUKRS' OF STRUCTURE <gs_p0001> TO <lv_bukrs>.
    ASSIGN COMPONENT 'KOSTL' OF STRUCTURE <gs_p0001> TO <lv_kostl>.

    CASE <lv_bukrs>.
      WHEN 'SP01' OR 'SP02' OR 'SP03' OR  'SP04'.
        MOVE <lv_kostl> TO lv_kostl.
        SHIFT lv_kostl LEFT DELETING LEADING '0'.
        MOVE lv_kostl(6) TO fv_return.
      WHEN 'CA10' OR 'CA20'.
        MOVE <lv_kostl> TO fv_return.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.

ENDFORM.                    "HOME_COST_NUMBER
*&---------------------------------------------------------------------*
*&      Form  HOME_DEPARTMENT
*&---------------------------------------------------------------------*
*       Home Department
*----------------------------------------------------------------------*
FORM home_department USING fv_return.

*  CHECK gv_time_iteration LT 2.

  DATA: lv_kostl LIKE p0001-kostl.

  IF gs_change_blocks-cb_6 EQ 'X'.

    FIELD-SYMBOLS: <lv_bukrs>,
                   <lv_kostl>.

    ASSIGN COMPONENT 'BUKRS' OF STRUCTURE <gs_p0001> TO <lv_bukrs>.
    ASSIGN COMPONENT 'KOSTL' OF STRUCTURE <gs_p0001> TO <lv_kostl>.

    CASE <lv_bukrs>.
      WHEN 'SP01' OR 'SP02' OR 'SP03' OR  'SP04'.
        MOVE <lv_kostl> TO lv_kostl.
        SHIFT lv_kostl LEFT DELETING LEADING '0'.
        MOVE lv_kostl(6) TO fv_return.
      WHEN 'CA10' OR 'CA20'.
        MOVE <lv_kostl>(6) TO fv_return.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.

ENDFORM.                    "HOME_DEPARTMENT
*&---------------------------------------------------------------------*
*&      Form  LOCATION_CODE
*&---------------------------------------------------------------------*
*       Location Code
*----------------------------------------------------------------------*
FORM location_code USING fv_return.

  IF gs_change_blocks-cb_30 EQ 'X'.

    FIELD-SYMBOLS: <lv_yywork_location>.

    ASSIGN COMPONENT 'YYWORK_LOCATION' OF STRUCTURE <gs_p0001> TO <lv_yywork_location>.
    MOVE <lv_yywork_location> TO fv_return.

  ENDIF.

ENDFORM.                    "LOCATION_CODE
*&---------------------------------------------------------------------*
*&      Form  PAY_GROUP
*&---------------------------------------------------------------------*
*       Pay Group
*----------------------------------------------------------------------*
FORM pay_group USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_7 EQ 'X'.

    DATA: lv_rate_type LIKE gs_employee_data-rate_type.

    FIELD-SYMBOLS: <lv_bukrs>.

    IF <gs_p0001> IS NOT INITIAL.

      ASSIGN COMPONENT 'BUKRS' OF STRUCTURE <gs_p0001> TO <lv_bukrs>.

      PERFORM rate_type_mapping USING gv_abart CHANGING lv_rate_type.
      PERFORM pay_group_mapping USING <lv_bukrs> lv_rate_type CHANGING fv_return.

    ENDIF.

  ENDIF.

ENDFORM.                    "PAY_GROUP
*&---------------------------------------------------------------------*
*&      Form  LAST_NAME
*&---------------------------------------------------------------------*
*       Last Name
*         Supply only if the value has changed
*----------------------------------------------------------------------*
FORM last_name USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_8 EQ 'X'.

    FIELD-SYMBOLS: <lv_nachn>.

    ASSIGN COMPONENT 'NACHN' OF STRUCTURE <gs_p0002> TO <lv_nachn>.

    MOVE <lv_nachn> TO fv_return.

  ENDIF.

ENDFORM.                    "LAST_NAME
*&---------------------------------------------------------------------*
*&      Form  FIRST_NAME
*&---------------------------------------------------------------------*
*       First Name
*         Supply only if the value has changed
*----------------------------------------------------------------------*
FORM first_name USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_8 EQ 'X'.

    FIELD-SYMBOLS: <lv_vorna>.

    ASSIGN COMPONENT 'VORNA' OF STRUCTURE <gs_p0002> TO <lv_vorna>.

    MOVE <lv_vorna> TO fv_return.

  ENDIF.

ENDFORM.                    "FIRST_NAME
*&---------------------------------------------------------------------*
*&      Form  ACTUAL_MAR_STA
*&---------------------------------------------------------------------*
*       Actual Marital Status
*----------------------------------------------------------------------*
FORM actual_mar_sta USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_9 EQ 'X'.

    FIELD-SYMBOLS: <lv_famst>.

    IF <gs_p0002> IS NOT INITIAL.

      ASSIGN COMPONENT 'FAMST' OF STRUCTURE <gs_p0002> TO <lv_famst>.
      CASE <lv_famst>.
        WHEN '0'.
          MOVE 'S' TO fv_return.
        WHEN '1'.
          MOVE 'M' TO fv_return.
        WHEN OTHERS.
      ENDCASE.

    ENDIF.

  ENDIF.

ENDFORM.                    "ACTUAL_MAR_STA
*&---------------------------------------------------------------------*
*&      Form  TAX_ID_NUMBER
*&---------------------------------------------------------------------*
*       Tax ID number
*         Supply on when the value has changed
*----------------------------------------------------------------------*
FORM tax_id_number USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_10 EQ 'X'.

    FIELD-SYMBOLS: <lv_perid>.

    ASSIGN COMPONENT 'PERID' OF STRUCTURE <gs_p0002> TO <lv_perid>.

    fv_return = <lv_perid>.

  ENDIF.

ENDFORM.                    "TAX_ID_NUMBER
*&---------------------------------------------------------------------*
*&      Form  TAX_ID_EXPY_DATE
*&---------------------------------------------------------------------*
*       Tax ID Expiry Date
*         Supply only when the value has changed
*----------------------------------------------------------------------*
FORM tax_id_expy_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_10 EQ 'X'.

    FIELD-SYMBOLS: <lv_perid>.

    ASSIGN COMPONENT 'PERID' OF STRUCTURE <gs_p0002> TO <lv_perid>.

    IF <lv_perid>(1) EQ '9'.
      PERFORM convert_date USING gv_date_11 CHANGING fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "TAX_ID_EXPY_DATE
*&---------------------------------------------------------------------*
*&      Form  BIRTH_DATE
*&---------------------------------------------------------------------*
*       Birth Date
*         Supply only if the value has changed
*----------------------------------------------------------------------*
FORM birth_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_11 EQ 'X'.

    FIELD-SYMBOLS: <lv_gbdat>.

    ASSIGN COMPONENT 'GBDAT' OF STRUCTURE <gs_p0002> TO <lv_gbdat>.

    IF <lv_gbdat> IS NOT INITIAL.
      PERFORM convert_date USING <lv_gbdat> CHANGING fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "BIRTH_DATE
*&---------------------------------------------------------------------*
*&      Form  CORRESP_LANG
*&---------------------------------------------------------------------*
*       Correspondence Language
*         Supply when the value has changed or
*         for a hire or
*         for a rehire
*----------------------------------------------------------------------*
FORM corresp_lang USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_12 EQ 'X'.

    FIELD-SYMBOLS: <lv_sprsl>.

    IF <gs_p0002> IS NOT INITIAL.
      ASSIGN COMPONENT 'SPRSL' OF STRUCTURE <gs_p0002> TO <lv_sprsl>.
      CASE <lv_sprsl>.
        WHEN 'E'.
          MOVE 'E' TO fv_return.
        WHEN 'F'.
          MOVE 'F' TO fv_return.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDIF.

ENDFORM.                    "CORRESP_LANG
*&---------------------------------------------------------------------*
*&      Form  GENDER
*&---------------------------------------------------------------------*
*       Gender
*----------------------------------------------------------------------*
FORM gender USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_13 EQ 'X'.

    FIELD-SYMBOLS: <lv_gesch>.

    IF <gs_p0002> IS NOT INITIAL.

      ASSIGN COMPONENT 'GESCH' OF STRUCTURE <gs_p0002> TO <lv_gesch>.
      CASE <lv_gesch>.
        WHEN '1'.
          MOVE 'M' TO fv_return.
        WHEN '2'.
          MOVE 'F' TO fv_return.
        WHEN OTHERS.
          MOVE 'N' TO fv_return.
      ENDCASE.

    ENDIF.

  ENDIF.

ENDFORM.                    "GENDER
*&---------------------------------------------------------------------*
*&      Form  _ADDR1_USE_AS_LEG
*&---------------------------------------------------------------------*
*       Address 1 Use as Legal
*         Supply only for a new hire
*----------------------------------------------------------------------*
FORM _addr1_use_as_leg USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    MOVE 'Y' TO fv_return.

  ENDIF.

ENDFORM.                    "_ADDR1_USE_AS_LEG
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_LINE_1
*&---------------------------------------------------------------------*
*       Address Line 1
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_line_1 USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_stras>.

    ASSIGN COMPONENT 'STRAS' OF STRUCTURE <gs_p0006> TO <lv_stras>.

    MOVE <lv_stras> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_LINE_1
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_LINE_2
*&---------------------------------------------------------------------*
*       Address Line 2
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_line_2 USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_locat>.

    ASSIGN COMPONENT 'LOCAT' OF STRUCTURE <gs_p0006> TO <lv_locat>.

    MOVE <lv_locat> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_LINE_2
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_1_PROV
*&---------------------------------------------------------------------*
*       Address 1 Province
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_1_prov USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_state>.

    ASSIGN COMPONENT 'STATE' OF STRUCTURE <gs_p0006> TO <lv_state> .

    MOVE <lv_state> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_1_PROV
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_1_CITY
*&---------------------------------------------------------------------*
*       Address 1 City
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_1_city USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_ort01>.

    ASSIGN COMPONENT 'ORT01' OF STRUCTURE <gs_p0006> TO <lv_ort01> .

    MOVE <lv_ort01> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_1_CITY
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_1_PSTLCD
*&---------------------------------------------------------------------*
*       Address 1 Postal Code
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_1_pstlcd USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_pstlz>.

    ASSIGN COMPONENT 'PSTLZ' OF STRUCTURE <gs_p0006> TO <lv_pstlz> .

    MOVE <lv_pstlz> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_1_PSTLCD
*&---------------------------------------------------------------------*
*&      Form  ADDRESS_1_CNTRY
*&---------------------------------------------------------------------*
*       Address 1 Country
*         Supply only the entire address block when one item changes
*----------------------------------------------------------------------*
FORM address_1_cntry USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_14 EQ 'X'.

    FIELD-SYMBOLS: <lv_land1>.

    ASSIGN COMPONENT 'LAND1' OF STRUCTURE <gs_p0006> TO <lv_land1> .

    MOVE <lv_land1> TO fv_return.

  ENDIF.

ENDFORM.                    "ADDRESS_1_CNTRY
*&---------------------------------------------------------------------*
*&      Form  WORK_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM work_email USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_28 EQ 'X'.

    FIELD-SYMBOLS: <lv_usrid_long>.

    ASSIGN COMPONENT 'USRID_LONG' OF STRUCTURE <gs_p0105> TO <lv_usrid_long>.
    MOVE <lv_usrid_long> TO fv_return.

  ENDIF.

ENDFORM.                    "WORK_EMAIL
*&---------------------------------------------------------------------*
*&      Form  _RECEIVE_SCHD_PAY
*&---------------------------------------------------------------------*
*       Receive Scheduled Payment
*
*         Add
*
*           Required when adding a new position with an Employee Status set
*           to 'R', 'T', 'D' or 'L'.
*           Not allowed when adding a new position with an Employee Status
*           set to 'A'.
*
*         Change
*
*           Required when changing an Employee Status (already sent to
*           PayTech) from 'A' to 'R', 'T', 'D' or 'L'.
*
*           Required when changing an Employee Status (already sent to
*           PayTech) from 'R', 'T', 'D' or 'L', to 'A'.
*
*           Optional when the WFN Employee Status has previously been
*           changed during the same current open pay cycle (pay cycle is open
*           when in 'Entering Payroll Information' or 'Preview Submitted'
*           mode) and that status change will revise PayTech's current status
*           from 'A' to 'R', 'T', 'D' or 'L' or from 'R', 'T', 'D' or 'L', to 'A' (once
*           payroll is submitted).
*
*         Add/Change
*
*           Not allowed when the pay cycle is not open (i.e. not in 'Entering
*           Payroll Information' and not in 'Preview Submitted' modes).
*
*           Not allowed when the Change Effective On date is greater than the
*           current open pay cycle's Pay Period End Date (pay cycle is open
*           when in 'Entering Payroll Information' or 'Preview Submitted'
*           mode).
*           ~ (tilde) is interpreted as 'N' or 'No'.
*----------------------------------------------------------------------*
FORM _receive_schd_pay USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda. "New action
    CASE gs_new_p0000-massn.
      WHEN '7F' OR '7H' OR '7R'. "Termination/Retired/Deceased
        MOVE 'N' TO fv_return.
      WHEN '7L' OR '7M'. "Paid Leave
        MOVE 'Y' TO fv_return.
      WHEN '7I' OR '7K'. "Unpaid Leave
        MOVE 'N' TO fv_return.
      WHEN '7J' OR '7N'. "Return from leave
        MOVE 'Y' TO fv_return.
      WHEN '7G'.         "Rehire
        MOVE 'Y' TO fv_return.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

ENDFORM.                    "_RECEIVE_SCHD_PAY
*&---------------------------------------------------------------------*
*&      Form  STANDARD_HOURS
*&---------------------------------------------------------------------*
*       Standard hours
*       Supply only when changed
*----------------------------------------------------------------------*
FORM standard_hours USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_15 EQ 'X'.

    FIELD-SYMBOLS: <lv_divgv>.

    DATA: lv_divgv TYPE p0008-divgv.

    ASSIGN COMPONENT 'DIVGV' OF STRUCTURE <gs_p0008> TO <lv_divgv>.
    MOVE <lv_divgv> TO lv_divgv.

    IF gv_zeinh EQ '03'. "Weekly
      lv_divgv = lv_divgv * 2.
      "ELSE.  "Bi-Weekly
    ENDIF.

    MOVE lv_divgv TO fv_return.

    SHIFT fv_return LEFT DELETING LEADING space.

  ENDIF.

ENDFORM.                    "STANDARD_HOURS
*&---------------------------------------------------------------------*
*&      Form  RATE_TYPE
*&---------------------------------------------------------------------*
*       Rate Type
*         Supply when changed, when there is a transfer action, and when
*         there is a pay rate amount change.
*----------------------------------------------------------------------*
FORM rate_type USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_15 EQ 'X'.

    PERFORM rate_type_mapping USING gv_abart CHANGING fv_return.

  ENDIF.

ENDFORM.                    "RATE_TYPE
*&---------------------------------------------------------------------*
*&      Form  RATE_AMOUNT
*&---------------------------------------------------------------------*
*       Rate Amount
*         Supply when changed, when there is a pay change action, or
*         when there is a trasnfer action
*----------------------------------------------------------------------*
FORM rate_amount USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_15 EQ 'X'.

    FIELD-SYMBOLS: <lv_bet01>.

    DATA: lv_bet01 TYPE p0008-bet01.

    ASSIGN COMPONENT 'BET01' OF STRUCTURE <gs_p0008> TO <lv_bet01>.
    MOVE <lv_bet01> TO lv_bet01.

    IF gv_zeinh EQ '03'. "Weekly
      lv_bet01 = lv_bet01 * 2.
      "ELSE.  "Bi-Weekly
    ENDIF.

    MOVE lv_bet01 TO fv_return.

    SHIFT fv_return LEFT DELETING LEADING space.

  ENDIF.

ENDFORM.                    "RATE_AMOUNT
*&---------------------------------------------------------------------*
*&      Form  _COMP_CHNGE_REASN
*&---------------------------------------------------------------------*
*       Compensation Change Reason
*----------------------------------------------------------------------*
FORM _comp_chnge_reasn USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda.  "New action
    CASE gs_new_p0000-massn.
      WHEN '7C'.
        CASE gs_new_p0000-massg.
          WHEN '03'.
            MOVE 'OTH' TO fv_return.
          WHEN '04'.
            MOVE 'PRO' TO fv_return.
          WHEN '05'.
            MOVE 'ADJ' TO fv_return.
          WHEN OTHERS.
        ENDCASE.
      WHEN '7D'.
        CASE gs_new_p0000-massg.
          WHEN '01'.
            MOVE 'MER' TO fv_return.
          WHEN '02'.
            MOVE 'REC' TO fv_return.
          WHEN '03'.
            MOVE 'MER' TO fv_return.
          WHEN '04'.
            MOVE 'PERF' TO fv_return.
          WHEN '11'.
            MOVE 'INIT' TO fv_return.
          WHEN '12'.
            MOVE 'OTH' TO fv_return.
          WHEN OTHERS.
        ENDCASE.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

  IF fv_return IS INITIAL.
    IF gv_comp_change_date IS NOT INITIAL.
      MOVE 'CHANGE' TO fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_COMP_CHNGE_REASN
*&---------------------------------------------------------------------*
*&      Form  _SAME_TAX_FORM
*&---------------------------------------------------------------------*
*       Same Tax Form
*----------------------------------------------------------------------*
FORM _same_tax_form USING fv_return.

*  CHECK gv_time_iteration LT 2.

  MOVE gv_same_tax_form TO fv_return.

ENDFORM.                    "_SAME_TAX_FORM
*&---------------------------------------------------------------------*
*&      Form  _TRANSFER_DATE
*&---------------------------------------------------------------------*
*       Transfer Date
*----------------------------------------------------------------------*
FORM _transfer_date USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gv_transfer_date IS NOT INITIAL.
    PERFORM convert_date USING gv_transfer_date CHANGING fv_return.
  ENDIF.

ENDFORM.                    "_TRANSFER_DATE
*&---------------------------------------------------------------------*
*&      Form  PAYMENT_METHOD
*&---------------------------------------------------------------------*
*       Payment Method
*----------------------------------------------------------------------*
FORM payment_method USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_16 EQ 'X'.

    MOVE gs_bank-payment_method TO fv_return.

  ENDIF.

ENDFORM.                    "PAYMENT_METHOD
*&---------------------------------------------------------------------*
*&      Form  PRIMARY_BANK
*&---------------------------------------------------------------------*
*       Primary Bank
*----------------------------------------------------------------------*
FORM primary_bank USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_16 EQ 'X'.

    MOVE gs_bank-primary_bank TO fv_return.

  ENDIF.

ENDFORM.                    "PRIMARY_BANK
*&---------------------------------------------------------------------*
*&      Form  PRIMARY_BRANCH
*&---------------------------------------------------------------------*
*       Primary Branch
*----------------------------------------------------------------------*
FORM primary_branch USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_16 EQ 'X'.

    MOVE gs_bank-primary_branch TO fv_return.

  ENDIF.

ENDFORM.                    "PRIMARY_BRANCH
*&---------------------------------------------------------------------*
*&      Form  PRIMARY_ACCNT_NO
*&---------------------------------------------------------------------*
*       Primary Account Number
*----------------------------------------------------------------------*
FORM primary_accnt_no USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_16 EQ 'X'.

    MOVE gs_bank-primary_accnt_no TO fv_return.

  ENDIF.

ENDFORM.                    "PRIMARY_ACCNT_NO
*&---------------------------------------------------------------------*
*&      Form  SECONDARY_BANK
*&---------------------------------------------------------------------*
*       Secondary Bank
*----------------------------------------------------------------------*
FORM secondary_bank USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_17 EQ 'X'.

    MOVE gs_bank-secondary_bank TO fv_return.

  ENDIF.

ENDFORM.                    "SECONDARY_BANK
*&---------------------------------------------------------------------*
*&      Form  SECONDARY_BRANCH
*&---------------------------------------------------------------------*
*       Secondary Branch
*----------------------------------------------------------------------*
FORM secondary_branch USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_17 EQ 'X'.

    MOVE gs_bank-secondary_branch TO fv_return.

  ENDIF.

ENDFORM.                    "SECONDARY_BRANCH
*&---------------------------------------------------------------------*
*&      Form  SECOND_ACCNT_NO
*&---------------------------------------------------------------------*
*       Secondary Account Number
*----------------------------------------------------------------------*
FORM second_accnt_no USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_17 EQ 'X'.

    MOVE gs_bank-second_accnt_no TO fv_return.

  ENDIF.

ENDFORM.                    "SECOND_ACCNT_NO
*&---------------------------------------------------------------------*
*&      Form  SECOND_DEP_AMNT
*&---------------------------------------------------------------------*
*       Secondary Deposit Amount
*----------------------------------------------------------------------*
FORM second_dep_amnt USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_17 EQ 'X'.

    MOVE gs_bank-second_dep_amnt TO fv_return.

  ENDIF.

ENDFORM.                    "SECOND_DEP_AMNT
*&---------------------------------------------------------------------*
*&      Form  PROV_OF_EMPLYMNT
*&---------------------------------------------------------------------*
*       Province of Employment
*----------------------------------------------------------------------*
FORM prov_of_emplymnt USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_18 EQ 'X'.

    FIELD-SYMBOLS: <lv_wrkar>.

    ASSIGN COMPONENT 'WRKAR' OF STRUCTURE <gs_p0461> TO <lv_wrkar>.

    CASE <lv_wrkar>.
      WHEN 'NF'.
        MOVE 'NL' TO fv_return.
      WHEN 'NN'.
        MOVE 'NU' TO fv_return.
      WHEN OTHERS.
        MOVE <lv_wrkar> TO fv_return.
    ENDCASE.

  ENDIF.

ENDFORM.                    "PROV_OF_EMPLYMNT
*&---------------------------------------------------------------------*
*&      Form  CRA_PA_RQ_ID
*&---------------------------------------------------------------------*
*       CRA PA / RQ ID
*----------------------------------------------------------------------*
FORM cra_pa_rq_id USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_19 EQ 'X'.

    FIELD-SYMBOLS: <lv_aus01>.

    ASSIGN COMPONENT 'AUS01' OF STRUCTURE <gs_p0033> TO <lv_aus01>.
    CASE <lv_aus01>.
      WHEN '0'. "Full Rate
        MOVE '2' TO fv_return.
      WHEN '1'. "Reduced Rate
        MOVE '1' TO fv_return.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.

ENDFORM.                    "CRA_PA_RQ_ID
*&---------------------------------------------------------------------*
*&      Form  FEDTAX_CRDT_TYPE
*&---------------------------------------------------------------------*
*       Fed Tax Credit Type
*----------------------------------------------------------------------*
FORM fedtax_crdt_type USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_20 EQ 'X'.

*    FIELD-SYMBOLS: <lv_tnind>.
*
*    IF <gs_p0463> IS NOT INITIAL.
*      ASSIGN COMPONENT 'TNIND' OF STRUCTURE <gs_p0463> TO <lv_tnind>.
*      IF <lv_tnind> EQ 0.
*        MOVE 'S' TO fv_return.
*      ELSEIF <lv_tnind> EQ 1.
*        MOVE 'O' TO fv_return.
*      ENDIF.
*    ENDIF.

    MOVE 'S' TO fv_return.

  ENDIF.

ENDFORM.                    "FEDTAX_CRDT_TYPE
*&---------------------------------------------------------------------*
*&      Form  FEDTAX_CRDT_OAMT
*&---------------------------------------------------------------------*
*       Fed Tax Credit Other Amount
*----------------------------------------------------------------------*
FORM fedtax_crdt_oamt USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_20 EQ 'X'.

    FIELD-SYMBOLS: <lv_tnind>, <lv_totcr>.

    ASSIGN COMPONENT 'TNIND' OF STRUCTURE <gs_p0463> TO <lv_tnind>.

    IF <lv_tnind> EQ 1.  "Other amount
      ASSIGN COMPONENT 'TOTCR' OF STRUCTURE <gs_p0463> TO <lv_totcr>.
      MOVE <lv_totcr> TO fv_return.
      SHIFT fv_return LEFT DELETING LEADING space.
    ENDIF.

  ENDIF.

ENDFORM.                    "FEDTAX_CRDT_OAMT
*&---------------------------------------------------------------------*
*&      Form  PRVTAX_CRDT_TYPE
*&---------------------------------------------------------------------*
*       Prov Tax Credit Type
*----------------------------------------------------------------------*
FORM prvtax_crdt_type USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_21 EQ 'X'.

*    FIELD-SYMBOLS: <lv_tninp>.
*
*    IF <gs_p0462> IS NOT INITIAL.
*      ASSIGN COMPONENT 'TNINP' OF STRUCTURE <gs_p0462> TO <lv_tninp>.
*      IF <lv_tninp> EQ 0.
*        MOVE 'S' TO fv_return.
*      ELSEIF <lv_tninp> EQ 1.
*        MOVE 'O' TO fv_return.
*      ENDIF.
*    ENDIF.

    MOVE 'S' TO fv_return.

  ENDIF.

ENDFORM.                    "PRVTAX_CRDT_TYPE
*&---------------------------------------------------------------------*
*&      Form  PRVTAX_CRDT_OAMT
*&---------------------------------------------------------------------*
*       Prov Tax Credit Other Amount
*----------------------------------------------------------------------*
FORM prvtax_crdt_oamt USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_21 EQ 'X'.

    FIELD-SYMBOLS: <lv_tninp>, <lv_wrkar>, <lv_totcq>, <lv_totcp>.

    ASSIGN COMPONENT 'TNINP' OF STRUCTURE <gs_p0462> TO <lv_tninp>.

    IF <lv_tninp> EQ 1. "Other amount
      ASSIGN COMPONENT 'WRKAR' OF STRUCTURE <gs_p0462> TO <lv_wrkar>.
      IF <lv_wrkar> EQ 'QC'.
        ASSIGN COMPONENT 'TOTCQ' OF STRUCTURE <gs_p0462> TO <lv_totcq>.
        MOVE <lv_totcq> TO fv_return.
      ELSE.
        ASSIGN COMPONENT 'TOTCP' OF STRUCTURE <gs_p0462> TO <lv_totcp>.
        MOVE <lv_totcp> TO fv_return.
      ENDIF.

      SHIFT fv_return LEFT DELETING LEADING space.
    ENDIF.

  ENDIF.

ENDFORM.                    "PRVTAX_CRDT_OAMT
*&---------------------------------------------------------------------*
*&      Form  DONT_CALC_FEDTAX
*&---------------------------------------------------------------------*
*       Do Not Calc Federal Tax
*----------------------------------------------------------------------*
FORM dont_calc_fedtax USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_22 EQ 'X'.

    IF gs_exemptions-fed EQ 'E'.
      MOVE 'Y' TO fv_return.
    ELSE.
      MOVE 'N' TO fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "DONT_CALC_FEDTAX
*&---------------------------------------------------------------------*
*&      Form  DONT_CALC_C_QPP
*&---------------------------------------------------------------------*
*       Do Not Calc C/QPP
*----------------------------------------------------------------------*
FORM dont_calc_c_qpp USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_23 EQ 'X'.

    IF gs_exemptions-cpp EQ 'E'.
      MOVE 'Y' TO fv_return.
    ELSE.
      MOVE 'N' TO fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "DONT_CALC_C_QPP
*&---------------------------------------------------------------------*
*&      Form  DO_NOT_CALC_EI
*&---------------------------------------------------------------------*
*       Do Not Calc EI
*----------------------------------------------------------------------*
FORM do_not_calc_ei USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_24 EQ 'X'.

    IF gs_exemptions-ei EQ 'E'.
      MOVE 'Y' TO fv_return.
    ELSE.
      MOVE 'N' TO fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "DO_NOT_CALC_EI
*&---------------------------------------------------------------------*
*&      Form  _REASON_FOR_ISSUE
*&---------------------------------------------------------------------*
*       Reason for Issue
*----------------------------------------------------------------------*
FORM _reason_for_issue USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda.   "New action
    IF gs_employee_data-loa_reason IS NOT INITIAL.
      MOVE gs_employee_data-loa_reason TO fv_return.
    ELSEIF gs_employee_data-term_reason IS NOT INITIAL.
      MOVE gs_employee_data-term_reason TO fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_REASON_FOR_ISSUE
*&---------------------------------------------------------------------*
*&      Form  _COMMENTS_ON_ROE
*&---------------------------------------------------------------------*
*       Comments on ROE
*----------------------------------------------------------------------*
FORM _comments_on_roe USING fv_return.
ENDFORM.                    "_COMMENTS_ON_ROE
*&---------------------------------------------------------------------*
*&      Form  EMPLOYEE_OCCUP
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
FORM employee_occup USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_25 EQ 'X'.

  ENDIF.

ENDFORM.                    "EMPLOYEE_OCCUP
*&---------------------------------------------------------------------*
*&      Form  _FIRST_DAY_WORKED
*&---------------------------------------------------------------------*
*       First Day Worked
*----------------------------------------------------------------------*
FORM _first_day_worked USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda.   "New action
    IF gs_new_p0000-massn EQ '7A' OR    "Hire
       gs_new_p0000-massn EQ '7G'.      "Re-hire
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ENDIF.
  ENDIF.

ENDFORM.                    "_FIRST_DAY_WORKED
*&---------------------------------------------------------------------*
*&      Form  LAST_DAY_PAID
*&---------------------------------------------------------------------*
*       Last Day Paid
*----------------------------------------------------------------------*
FORM last_day_paid USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_change_blocks-cb_26 EQ 'X'.

    IF gv_date_08 IS NOT INITIAL.
      PERFORM convert_date USING gv_date_08 CHANGING fv_return.
    ENDIF.

  ENDIF.

ENDFORM.                    "LAST_DAY_PAID
*&---------------------------------------------------------------------*
*&      Form  _EXPECTED_RECALL
*&---------------------------------------------------------------------*
*       Expected Recall
*----------------------------------------------------------------------*
FORM _expected_recall USING fv_return.

*  CHECK gv_time_iteration LT 2.

  IF gs_old_p0000-begda NE gs_new_p0000-begda.   "New action

    CASE gs_new_p0000-massn.
      WHEN '7I' OR '7K' OR        "Leave of Absence
           '7F' OR '7H' OR '7R'.  "Termination
        MOVE 'U' TO fv_return.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.

ENDFORM.                    "_EXPECTED_RECALL
*&---------------------------------------------------------------------*
*&      Form  _EXPD_RECALL_DATE
*&---------------------------------------------------------------------*
*       Expected Recall Date
*----------------------------------------------------------------------*
FORM _expd_recall_date USING fv_return.
ENDFORM.                    "_EXPD_RECALL_DATE
*&---------------------------------------------------------------------*
*&      Form  _READY_TO_ISSUE
*&---------------------------------------------------------------------*
*       Ready to Issue
*----------------------------------------------------------------------*
FORM _ready_to_issue USING fv_return.

**  CHECK gv_time_iteration LT 2.

  IF gs_new_p0000-begda NE gs_old_p0000-begda.  "New action record
    CASE gs_new_p0000-massn.
      WHEN '7A' OR                  "New Hire
           '7G' OR                  "Rehire
           '7I' OR '7K' OR '7M' OR  "Leave of Absence
           '7F' OR '7H' OR '7R'.    "Termination
        MOVE 'N' TO fv_return.
      WHEN OTHERS.
    ENDCASE.
  ENDIF.

ENDFORM.                    "_READY_TO_ISSUE
*&---------------------------------------------------------------------*
*&      Form  _BADGE
*&---------------------------------------------------------------------*
*       Badge number
*----------------------------------------------------------------------*
FORM _badge USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

    CONCATENATE '0' gs_employee_data-file_number INTO fv_return.

  ENDIF.

ENDFORM.                    "_BADGE
*&---------------------------------------------------------------------*
*&      Form  PAYCLASS
*&---------------------------------------------------------------------*
*       Pay class
*----------------------------------------------------------------------*
FORM payclass USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

    FIELD-SYMBOLS: <lv_aus03>.

    ASSIGN COMPONENT 'AUS03' OF STRUCTURE <gs_p0033> TO <lv_aus03>.
    SELECT SINGLE austx FROM t543d
      INTO fv_return
      WHERE sprsl EQ sy-langu
        AND molga EQ '07'
        AND subty EQ '9011'
        AND stagb EQ '03'
        AND staus EQ <lv_aus03>.

  ENDIF.

ENDFORM.                    "PAYCLASS
*&---------------------------------------------------------------------*
*&      Form  _BEGDA_TRACK_TIME
*&---------------------------------------------------------------------*
*       Start Date for Tracking Time
*----------------------------------------------------------------------*
FORM _begda_track_time USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
*  IF gs_change_blocks-cb_27 EQ 'X'.

  IF gs_new_p0000-begda NE gs_old_p0000-begda AND "New action record
     ( gs_new_p0000-massn EQ '7A' OR gs_new_p0000-massn EQ '7G' ).  "New Hire/Rehire
    IF gs_new_p0000-begda GE gv_frbeg AND
       gs_new_p0000-begda LE gv_frend.
      PERFORM convert_date USING gs_new_p0000-begda CHANGING fv_return.
    ELSE.
      PERFORM convert_date USING gv_frbeg CHANGING fv_return.
    ENDIF.
  ENDIF.

*  ENDIF.

ENDFORM.                    "_BEGDA_TRACK_TIME
*&---------------------------------------------------------------------*
*&      Form  _ENDDA_TRACK_TIME
*&---------------------------------------------------------------------*
*       Stop Date for Tracking Time
*----------------------------------------------------------------------*
FORM _endda_track_time USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

    IF gv_date_07 IS NOT INITIAL.   "Last day worked

      PERFORM convert_date USING gv_date_07 CHANGING fv_return.

    ENDIF.

  ENDIF.

ENDFORM.                    "_ENDDA_TRACK_TIME
*&---------------------------------------------------------------------*
*&      Form  SUPERVISORFLAG
*&---------------------------------------------------------------------*
*       SUPERVISORFLAG
*----------------------------------------------------------------------*
FORM supervisorflag USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

    FIELD-SYMBOLS: <lv_yymanager_flag>.

    ASSIGN COMPONENT 'YYMANAGER_FLAG' OF STRUCTURE <gs_p0001> TO <lv_yymanager_flag>.
    CASE <lv_yymanager_flag>.
      WHEN 'Y'.
        MOVE 'T' TO fv_return.
      WHEN 'N'.
        MOVE 'F' TO fv_return.
    ENDCASE.

  ENDIF.

ENDFORM.                    "SUPERVISORFLAG
*&---------------------------------------------------------------------*
*&      Form  SUPERVISORID
*&---------------------------------------------------------------------*
*       Reports To Position ID
*----------------------------------------------------------------------*
FORM supervisorid USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.
    PERFORM get_reports_to_id USING fv_return.
  ENDIF.

ENDFORM.                    "SUPERVISORID
*&---------------------------------------------------------------------*
*&      Form  TIMEZONE
*&---------------------------------------------------------------------*
*       Time Zone
*----------------------------------------------------------------------*
FORM timezone USING fv_return.


**  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

    DATA: lv_province TYPE t005s-bland,
          lv_timezone TYPE ttzdata-tzone.

    FIELD-SYMBOLS: <lv_wrkar>.

    ASSIGN COMPONENT 'WRKAR' OF STRUCTURE <gs_p0462> TO <lv_wrkar>.
    MOVE <lv_wrkar> TO lv_province.
    CALL FUNCTION 'TZ_LOCATION_TIMEZONE'
      EXPORTING
        country           = 'CA'
        region            = lv_province
      IMPORTING
        timezone          = lv_timezone
      EXCEPTIONS
        no_timezone_found = 1
        OTHERS            = 2.
    IF sy-subrc EQ 0.
      IF lv_timezone EQ 'AST'.
        MOVE 'Atlantic' TO fv_return.
      ELSE.
        MOVE lv_timezone TO fv_return.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.                    "TIMEZONE
*&---------------------------------------------------------------------*
*&      Form  _XFERTOPAYROLL
*&---------------------------------------------------------------------*
*       TRANSFERTOPAYROLL
*----------------------------------------------------------------------*
FORM _xfertopayroll USING fv_return.

*  CHECK gv_time_iteration LT 2.

* Export when there is a change
  IF gs_change_blocks-cb_27 EQ 'X'.

*    IF gv_abart EQ '1'. "Hourly
*      MOVE 'T' TO fv_return.
*    ELSE. "Salaried
*      MOVE 'F' TO fv_return.
*    ENDIF.

    IF gs_new_p0000-begda NE gs_old_p0000-begda.  "New action record
      CASE gs_new_p0000-massn.
        WHEN '7A' OR                  "New Hire
             '7G'.                    "Rehire
          MOVE 'T' TO fv_return.
        WHEN OTHERS.
      ENDCASE.
    ENDIF.

  ENDIF.

ENDFORM.                    "_XFERTOPAYROLL
*&---------------------------------------------------------------------*
*&      Form  _TO_POLICY_NAME
*&---------------------------------------------------------------------*
*       Time Off Policy Name
*----------------------------------------------------------------------*
FORM _to_policy_name USING fv_return.

** Export when there is a change
*  IF gs_change_blocks-cb_29 EQ 'X'.
*
*    DATA: lv_stagb TYPE c LENGTH 2.
*    FIELD-SYMBOLS: <lv_aus>.
*
*    CASE gv_time_iteration.
*      WHEN 1.
*        ASSIGN COMPONENT 'AUS04' OF STRUCTURE <gs_p0033> TO <lv_aus>.
*        lv_stagb = '04'.
*      WHEN 2.
*        ASSIGN COMPONENT 'AUS05' OF STRUCTURE <gs_p0033> TO <lv_aus>.
*        lv_stagb = '05'.
*      WHEN 3.
*        ASSIGN COMPONENT 'AUS06' OF STRUCTURE <gs_p0033> TO <lv_aus>.
*        lv_stagb = '06'.
*      WHEN OTHERS.
*    ENDCASE.
*
**    SELECT SINGLE austx FROM t543d
**      INTO fv_return
**      WHERE sprsl EQ sy-langu
**        AND molga EQ '07'
**        AND subty EQ '9011'
**        AND stagb EQ lv_stagb
**        AND staus EQ <lv_aus>.
*
*    CASE <lv_aus>.
*      WHEN 'SI1A'.
*        MOVE 'VACATION PLAN 1-A' TO fv_return.
*      WHEN 'SI2B'.
*        MOVE 'VACATION PLAN 2-B' TO fv_return.
*      WHEN 'SIA'.
*        MOVE 'VACATION PLAN A' TO fv_return.
*      WHEN 'SIB'.
*        MOVE 'VACATION PLAN B' TO fv_return.
*      WHEN 'SIP1'.
*        MOVE 'PERSONAL DAY 8' TO fv_return.
*      WHEN 'SIP2'.
*        MOVE 'PERSONAL DAY 10' TO fv_return.
*      WHEN 'SIP3'.
*        MOVE 'PERSONAL DAY 11' TO fv_return.
*      WHEN 'SIP4'.
*        MOVE 'PERSONAL DAY 9' TO fv_return.
*      WHEN 'SIS1'.
*        MOVE 'SICK 8 HOURS' TO fv_return.
*      WHEN 'SIS2'.
*        MOVE 'SICK 10 HOURS' TO fv_return.
*      WHEN 'SIS3'.
*        MOVE 'SICK 11 HOURS' TO fv_return.
*      WHEN 'SIS4'.
*        MOVE 'SICK 9 HOURS' TO fv_return.
*      WHEN 'SIU'.
*        MOVE 'VACATION CURRENT PLAN U 8' TO fv_return.
*      WHEN 'SIU1'.
*        MOVE 'VACATION CURRENT PLAN U 10' TO fv_return.
*      WHEN 'SRFS'.
*        MOVE 'VACATION PLAN A' TO fv_return.
*      WHEN OTHERS.
*    ENDCASE.
*
*  ENDIF.

ENDFORM.                    "_TO_POLICY_NAME
*&---------------------------------------------------------------------*
*&      Form  TO_POLICY_NAME
*&---------------------------------------------------------------------*
*       Time Off Policy Name
*       This subroutine is just to compare old/new for a change.
*       Therefore AUS04, AUS05, AUS06 are simply concatenated for old
*       and new, and then compared for a change.
*----------------------------------------------------------------------*
FORM to_policy_name USING fv_return.

  FIELD-SYMBOLS: <lv_aus04>, <lv_aus05>, <lv_aus06>.

  ASSIGN COMPONENT 'AUS04' OF STRUCTURE <gs_p0033> TO <lv_aus04>.
  ASSIGN COMPONENT 'AUS05' OF STRUCTURE <gs_p0033> TO <lv_aus05>.
  ASSIGN COMPONENT 'AUS06' OF STRUCTURE <gs_p0033> TO <lv_aus06>.

  CONCATENATE <lv_aus04> <lv_aus05> <lv_aus06> INTO fv_return. "Concatenate to compare old/new

ENDFORM.                    "TO_POLICY_NAME
*&---------------------------------------------------------------------*
*&      Form  _TO_PLCYASS_BEGDA
*&---------------------------------------------------------------------*
*       Time Off Policy Assignment Start Date
*----------------------------------------------------------------------*
FORM _to_plcyass_begda USING fv_return.

** Export when there is a change
*  IF gs_change_blocks-cb_29 EQ 'X'.
*
*    FIELD-SYMBOLS: <lv_begda>.
*
*    ASSIGN COMPONENT 'BEGDA' OF STRUCTURE <gs_p0033> TO <lv_begda>.
*
*    IF <lv_begda> IS NOT INITIAL.
*      PERFORM convert_date USING <lv_begda>  CHANGING fv_return.
*    ENDIF.
*
*  ENDIF.

ENDFORM.                    "_TO_PLCYASS_BEGDA
*&---------------------------------------------------------------------*
*&      Form  UNION_CODE
*&---------------------------------------------------------------------*
*       Union Code
*----------------------------------------------------------------------*
FORM union_code USING fv_return.

* Export when there is a change
  IF gs_change_blocks-cb_31 EQ 'X'.

    FIELD-SYMBOLS: <lv_trfar>.

    ASSIGN COMPONENT 'TRFAR' OF STRUCTURE <gs_p0008> TO <lv_trfar>.
    PERFORM union_code_mapping USING <lv_trfar> CHANGING fv_return.

  ENDIF.

ENDFORM.                    "UNION_CODE
*&---------------------------------------------------------------------*
*&      Form  WORKER_CATEGORY
*&---------------------------------------------------------------------*
*       Worker Category
*----------------------------------------------------------------------*
FORM worker_category USING fv_return.

* Export when there is a change
  IF gs_change_blocks-cb_32 EQ 'X'.

    FIELD-SYMBOLS: <lv_persg>.

    ASSIGN COMPONENT 'PERSG' OF STRUCTURE <gs_p0001> TO <lv_persg>.

    PERFORM worker_category_mapping USING <lv_persg> CHANGING fv_return.

  ENDIF.

ENDFORM.                    "WORKER_CATEGORY