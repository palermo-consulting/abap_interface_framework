*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_F04
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_EMPLOYEE_STATUS
*&---------------------------------------------------------------------*
*       Get employee status
*----------------------------------------------------------------------*
*      -->FV_MASSN      Personnel Action
*      -->FV_MASSG      Personnel Action Reason
*      <--FV_RETURN     Employee Status
*----------------------------------------------------------------------*
FORM get_employee_status  USING    fv_massn fv_massg
                          CHANGING fv_return.

  CASE fv_massn.
    WHEN '7A'.  "Hire
      MOVE 'A' TO fv_return.  "Active
    WHEN '7B'.  "Expat Assignment
      MOVE 'A' TO fv_return.  "Active
    WHEN '7C'.  "Organizational Change
      MOVE 'A' TO fv_return.  "Active
    WHEN '7D'.  "Change of Pay
      MOVE 'A' TO fv_return.  "Active
    WHEN '7E'.  "Transfer/Relocation
      MOVE 'A' TO fv_return.  "Active
    WHEN '7F'.  "Termination/Retirement/Deceased
      CASE fv_massg.
        WHEN '12'.
          MOVE 'D' TO fv_return. "Deceased
        WHEN '18'.
          MOVE 'R' TO fv_return. "Retirement
        WHEN OTHERS.
          MOVE 'T' TO fv_return. "Termination
      ENDCASE.
    WHEN '7G'.  "Rehire
      MOVE 'A' TO fv_return.  "Active
    WHEN '7H'.  "Retirement
      MOVE 'R' TO fv_return. "Retirement
    WHEN '7I'.  "UnPaid LOA
      MOVE 'L' TO fv_return. "LOA
    WHEN '7J'.  "Return to Work from UnPaid LOA
      MOVE 'A' TO fv_return.  "Active
    WHEN '7K'.  "Hire Unpaid LOA
      MOVE 'L' TO fv_return. "LOA
    WHEN '7L'.  "Hire Paid LOA
      MOVE 'L' TO fv_return. "LOA
    WHEN '7M'.  "Paid LOA – Active Status
      MOVE 'L' TO fv_return. "LOA
    WHEN '7N'.  "Return to Work from Paid LOA
      MOVE 'A' TO fv_return.  "Active
    WHEN '7O'.  "Country ReAssignment
      MOVE 'A' TO fv_return.  "Active
    WHEN '7P'.  "Severance - Active
      MOVE 'A' TO fv_return.  "Active
    WHEN '7Q'.  "Return from Expat Assignment
      MOVE 'A' TO fv_return.  "Active
    WHEN '7R'.  "Severance - Withdrawn
      MOVE 'T' TO fv_return.  "Terminated
    WHEN '7T'.  "Change of Bank Details
      MOVE 'A' TO fv_return.  "Active
    WHEN '7U'.  "Intercompany Transfer
      MOVE 'A' TO fv_return.  "Active
    WHEN '7Y'.  "Conversion LOA - Canada
      MOVE 'A' TO fv_return.  "Active
    WHEN '7Z'.  "Conversion Hire - Canada
      MOVE 'A' TO fv_return.  "Active
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " GET_EMPLOYEE_STATUS
*&---------------------------------------------------------------------*
*&      Form  RATE_TYPE_MAPPING
*&---------------------------------------------------------------------*
*       Rate Type Mapping
*----------------------------------------------------------------------*
*      -->FV_ABART   Employee Type: 1 = Hourly, 3 = Salaried
*      <--FV_RETURN  Rate Type
*----------------------------------------------------------------------*
FORM rate_type_mapping  USING    fv_abart
                        CHANGING fv_return.

* 1 = Hourly, 3 = Salaried
  IF fv_abart EQ '1'.
    MOVE 'H' TO fv_return.
  ELSEIF gv_abart EQ '3'.
    MOVE 'S' TO fv_return.
  ENDIF.

ENDFORM.                    " RATE_TYPE_MAPPING
*&---------------------------------------------------------------------*
*&      Form  PAY_GROUP_MAPPING
*&---------------------------------------------------------------------*
*       Pay Group Mapping
*----------------------------------------------------------------------*
*      -->FV_BUKRS      Company code
*      -->FV_RATE_TYPE  H = Hourly, S = Salary
*      <--FV_RETURN     WFN Pay Group
*----------------------------------------------------------------------*
FORM pay_group_mapping  USING    fv_bukrs
                                 fv_rate_type
                        CHANGING fv_return.

  CASE fv_bukrs.
    WHEN 'SP04'.  "T56A
      IF fv_rate_type EQ 'S'. "Salary
        MOVE '2' TO fv_return.
      ELSE.
        MOVE '1' TO fv_return.
      ENDIF.
    WHEN OTHERS.
      MOVE '1' TO fv_return.
  ENDCASE.

ENDFORM.                    " PAY_GROUP_MAPPING
*&---------------------------------------------------------------------*
*&      Form  UNION_CODE_MAPPING
*&---------------------------------------------------------------------*
*       Union Code Mapping
*----------------------------------------------------------------------*
*      -->fv_trfar      Pay scale type
*      <--FV_RETURN     Union code
*----------------------------------------------------------------------*
FORM union_code_mapping  USING    fv_trfar
                         CHANGING fv_return.
  CASE fv_trfar.
    WHEN 'NU'.
      MOVE ''    TO fv_return.
    WHEN 'UA'.
      MOVE 'U30' TO fv_return.
    WHEN 'UB'.
      MOVE 'UN'  TO fv_return.
    WHEN 'UC'.
      MOVE ''    TO fv_return.
    WHEN 'UD'.
      MOVE 'U20' TO fv_return.
    WHEN 'UE'.
      MOVE '847' TO fv_return.
    WHEN 'UF'.
      MOVE '847' TO fv_return.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " UNION_CODE_MAPPING
*&---------------------------------------------------------------------*
*&      Form  WORKER_CATEGORY_MAPPING
*&---------------------------------------------------------------------*
*       Worker Category Mapping
*----------------------------------------------------------------------*
*      -->FV_PERSG     Employee Group
*      <--FV_RETURN    Worker Category
*----------------------------------------------------------------------*
FORM worker_category_mapping  USING    fv_persg
                              CHANGING fv_return.

  CASE fv_persg.
    WHEN '1'.
      MOVE 'F' TO fv_return.
    WHEN '2'.
      MOVE 'P' TO fv_return.
    WHEN '3'.
      MOVE 'P' TO fv_return.
    WHEN '4'.
      MOVE '' TO fv_return.
    WHEN '5'.
      MOVE '' TO fv_return.
    WHEN '6'.
      MOVE '' TO fv_return.
    WHEN '7'.
      MOVE 'CAS' TO fv_return.
    WHEN '8'.
      MOVE 'CAS' TO fv_return.
    WHEN '9'.
      MOVE 'CON' TO fv_return.
    WHEN 'A'.
      MOVE 'OTH' TO fv_return.
    WHEN 'B'.
      MOVE 'OTH' TO fv_return.
    WHEN 'C'.
      MOVE '' TO fv_return.
    WHEN 'D'.
      MOVE 'OTH' TO fv_return.
    WHEN 'E'.
      MOVE 'F' TO fv_return.
    WHEN 'F'.
      MOVE 'F' TO fv_return.
    WHEN 'G'.
      MOVE 'F' TO fv_return.
    WHEN 'H'.
      MOVE '' TO fv_return.
    WHEN 'I'.
      MOVE '' TO fv_return.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                    " WORKER_CATEGORY_MAPPING