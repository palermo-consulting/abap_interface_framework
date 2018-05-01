*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_F03
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------------------------------------
* This block of subroutines maps the SAP effective date to the WFN field.  These are called by the
* change validation logic.
*--------------------------------------------------------------------------------------------------

FORM position_id_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0185-begda. ENDFORM.
FORM co_code_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM seniority_date_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0041-begda. ENDFORM.
FORM credited_service_date_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0041-begda. ENDFORM.
FORM adjusted_service_date_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0041-begda. ENDFORM.
FORM employee_status_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0000-begda. ENDFORM.
FORM home_cost_number_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM home_department_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM location_code_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM pay_group_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM last_name_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM first_name_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM actual_mar_sta_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM tax_id_number_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM tax_id_expy_date_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0041-begda. ENDFORM.
FORM birth_date_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM corresp_lang_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM gender_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0002-begda. ENDFORM.
FORM address_line_1_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM address_line_2_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM address_1_prov_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM address_1_city_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM address_1_pstlcd_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM address_1_cntry_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0006-begda. ENDFORM.
FORM standard_hours_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0008-begda. ENDFORM.
FORM rate_type_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM rate_amount_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0008-begda. ENDFORM.
FORM payment_method_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_p. ENDFORM.
FORM primary_bank_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_p. ENDFORM.
FORM primary_branch_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_p. ENDFORM.
FORM primary_accnt_no_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_p. ENDFORM.
FORM secondary_bank_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_s. ENDFORM.
FORM secondary_branch_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_s. ENDFORM.
FORM second_accnt_no_eff_date CHANGING fv_effective_date.fv_effective_date = gs_bank-effective_date_s. ENDFORM.
FORM second_dep_amnt_eff_date CHANGING fv_effective_date. fv_effective_date = gs_bank-effective_date_s. ENDFORM.
FORM prov_of_emplymnt_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0461-begda. ENDFORM.
FORM cra_pa_rq_id_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0033-begda. ENDFORM.
FORM fedtax_crdt_type_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0463-begda. ENDFORM.
FORM fedtax_crdt_oamt_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0463-begda. ENDFORM.
FORM prvtax_crdt_type_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0462-begda. ENDFORM.
FORM prvtax_crdt_oamt_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0462-begda. ENDFORM.
FORM dont_calc_fedtax_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0464-begda. ENDFORM.
FORM dont_calc_c_qpp_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0464-begda. ENDFORM.
FORM do_not_calc_ei_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0464-begda. ENDFORM.
FORM employee_occup_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM last_day_paid_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0041-begda. ENDFORM.
FORM payclass_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0033-begda. ENDFORM.
FORM supervisorflag_eff_date CHANGING fv_effective_date. fv_effective_date = sy-datum. ENDFORM.
FORM reports_to_id_eff_date CHANGING fv_effective_date. fv_effective_date = sy-datum. ENDFORM.
FORM timezone_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0462-begda. ENDFORM.
FORM xfertopayroll_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.
FORM to_policy_name_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0033-begda. ENDFORM.
*FORM to_plcyass_begda_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0033-begda. ENDFORM.
FORM work_email_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0105-begda. ENDFORM.
FORM union_code_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0008-begda. ENDFORM.
FORM worker_category_eff_date CHANGING fv_effective_date. fv_effective_date = gs_new_p0001-begda. ENDFORM.


*--------------------------------------------------------------------------------------------------
* This block of subroutines maps a WFN field to a change block that tells the interface if the
* field should be exported.  These are called by the change validation logic.  They are left
* purposely unformatted for ease of search.
*--------------------------------------------------------------------------------------------------

FORM position_id_cb. gs_change_blocks-cb_1  = 'X'. ENDFORM.
FORM co_code_cb. gs_change_blocks-cb_2  = 'X'. ENDFORM.
FORM seniority_date_cb. gs_change_blocks-cb_3  = 'X'. ENDFORM.
FORM credited_service_date_cb. gs_change_blocks-cb_3  = 'X'. ENDFORM.
FORM adjusted_service_date_cb. gs_change_blocks-cb_3  = 'X'. ENDFORM.
FORM employee_status_cb. gs_change_blocks-cb_4  = 'X'. ENDFORM.
FORM home_cost_number_cb. gs_change_blocks-cb_5  = 'X'. ENDFORM.
FORM home_department_cb. gs_change_blocks-cb_6  = 'X'. ENDFORM.
FORM location_code_cb. gs_change_blocks-cb_30  = 'X'. ENDFORM.
FORM pay_group_cb. gs_change_blocks-cb_7  = 'X'. ENDFORM.
FORM last_name_cb. gs_change_blocks-cb_8  = 'X'. ENDFORM.
FORM first_name_cb. gs_change_blocks-cb_8  = 'X'. ENDFORM.
FORM actual_mar_sta_cb. gs_change_blocks-cb_9  = 'X'. ENDFORM.
FORM tax_id_number_cb. gs_change_blocks-cb_10  = 'X'. ENDFORM.
FORM tax_id_expy_date_cb. gs_change_blocks-cb_10  = 'X'. ENDFORM.
FORM birth_date_cb. gs_change_blocks-cb_11  = 'X'. ENDFORM.
FORM corresp_lang_cb. gs_change_blocks-cb_12  = 'X'. ENDFORM.
FORM gender_cb. gs_change_blocks-cb_13  = 'X'. ENDFORM.
FORM address_line_1_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM address_line_2_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM address_1_prov_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM address_1_city_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM address_1_pstlcd_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM address_1_cntry_cb. gs_change_blocks-cb_14  = 'X'. ENDFORM.
FORM standard_hours_cb. gs_change_blocks-cb_15  = 'X'. ENDFORM.
FORM rate_type_cb. gs_change_blocks-cb_15  = 'X'. ENDFORM.
FORM rate_amount_cb. gs_change_blocks-cb_15  = 'X'. ENDFORM.
FORM payment_method_cb. gs_change_blocks-cb_16  = 'X'. ENDFORM.
FORM primary_bank_cb. gs_change_blocks-cb_16  = 'X'. ENDFORM.
FORM primary_branch_cb. gs_change_blocks-cb_16  = 'X'. ENDFORM.
FORM primary_accnt_no_cb. gs_change_blocks-cb_16  = 'X'. ENDFORM.
FORM secondary_bank_cb. gs_change_blocks-cb_17  = 'X'. ENDFORM.
FORM secondary_branch_cb. gs_change_blocks-cb_17  = 'X'. ENDFORM.
FORM second_accnt_no_cb. gs_change_blocks-cb_17  = 'X'. ENDFORM.
FORM second_dep_amnt_cb. gs_change_blocks-cb_17  = 'X'. ENDFORM.
FORM prov_of_emplymnt_cb. gs_change_blocks-cb_18  = 'X'. ENDFORM.
FORM cra_pa_rq_id_cb. gs_change_blocks-cb_19  = 'X'. ENDFORM.
FORM fedtax_crdt_type_cb. gs_change_blocks-cb_20  = 'X'. ENDFORM.
FORM fedtax_crdt_oamt_cb. gs_change_blocks-cb_20  = 'X'. ENDFORM.
FORM prvtax_crdt_type_cb. gs_change_blocks-cb_21  = 'X'. ENDFORM.
FORM prvtax_crdt_oamt_cb. gs_change_blocks-cb_21  = 'X'. ENDFORM.
FORM dont_calc_fedtax_cb. gs_change_blocks-cb_22  = 'X'. ENDFORM.
FORM dont_calc_c_qpp_cb. gs_change_blocks-cb_23  = 'X'. ENDFORM.
FORM do_not_calc_ei_cb. gs_change_blocks-cb_24  = 'X'. ENDFORM.
FORM employee_occup_cb. gs_change_blocks-cb_25  = 'X'. ENDFORM.
FORM last_day_paid_cb. gs_change_blocks-cb_26  = 'X'. ENDFORM.
FORM payclass_cb. gs_change_blocks-cb_27  = 'X'. ENDFORM.
FORM supervisorflag_cb. gs_change_blocks-cb_27  = 'X'. ENDFORM.
FORM reports_to_id_cb. gs_change_blocks-cb_27  = 'X'. ENDFORM.
FORM timezone_cb. gs_change_blocks-cb_27  = 'X'. ENDFORM.
FORM xfertopayroll_cb. gs_change_blocks-cb_27  = 'X'. ENDFORM.
*FORM to_policy_name_cb. gs_change_blocks-cb_29  = 'X'. ENDFORM.
*FORM to_plcyass_begda_cb. gs_change_blocks-cb_32  = 'X'. ENDFORM.
FORM work_email_cb. gs_change_blocks-cb_28  = 'X'. ENDFORM.
FORM union_code_cb. gs_change_blocks-cb_31  = 'X'. ENDFORM.
FORM worker_category_cb. gs_change_blocks-cb_32  = 'X'. ENDFORM.