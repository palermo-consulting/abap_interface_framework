*&---------------------------------------------------------------------*
*& Report  ZHRU_ADP_WFN_CA_PCL2
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zhru_adp_wfn_ca_pcl2 NO STANDARD PAGE HEADING LINE-SIZE 1023.

INCLUDE zhru_adp_wfn_ca_pcl2_d01.
INCLUDE zhru_adp_wfn_ca_pcl2_s01.
INCLUDE zhru_adp_wfn_ca_pcl2_f01.


START-OF-SELECTION.

  PERFORM start_of_selection.

AT LINE-SELECTION.

  PERFORM at_line_selection.