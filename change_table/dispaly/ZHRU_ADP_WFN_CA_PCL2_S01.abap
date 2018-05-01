*&---------------------------------------------------------------------*
*&  Include           ZHRU_ADP_WFN_CA_PCL2_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.
PARAMETERS:     p_fldid   LIKE t532a-fldid OBLIGATORY.
SELECT-OPTIONS: p_pernr   FOR pernr-pernr.
SELECTION-SCREEN END OF BLOCK b01.