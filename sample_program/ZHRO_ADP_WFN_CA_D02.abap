*&---------------------------------------------------------------------*
*&  Include           ZHRO_ADP_WFN_CA_D02
*&---------------------------------------------------------------------*

DATA:     gv_sfile          TYPE c LENGTH 255,
          gv_path           TYPE string,
          gv_fullpath       TYPE string,
          gv_filename       TYPE string,
          gt_dynpfields     TYPE STANDARD TABLE OF dynpread,
          gs_dynpfields     TYPE dynpread.