*&---------------------------------------------------------------------*
*& Report  ZHRO_ADP_WFN_CA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zhro_adp_wfn_ca.

INCLUDE zhro_adp_wfn_ca_d01.
INCLUDE zhro_adp_wfn_ca_d02.  "Data structures for file handling
INCLUDE zhro_adp_wfn_ca_s01.
INCLUDE zhro_adp_wfn_ca_f01.  "Interface Logic
INCLUDE zhro_adp_wfn_ca_f02.  "Field Logic
INCLUDE zhro_adp_wfn_ca_f03.  "Effective Dates and Change Blocks
INCLUDE zhro_adp_wfn_ca_f04.  "Field Mapping
INCLUDE zhro_adp_wfn_ca_f05.  "Auxiliary Routines

INITIALIZATION.

  PERFORM begin.

GET pernr.
  ADD 1 TO gv_num_selected_pernr.
  PERFORM enqueue_pernr.
  PERFORM data_collection.
  PERFORM validate_employee.
  PERFORM export_new_data.
  PERFORM change_validation.
  PERFORM action_based_validation.
  PERFORM fill_wfn_records.
  PERFORM dequeue_pernr.

END-OF-SELECTION.

  PERFORM write_to_file.
  PERFORM export_summary.