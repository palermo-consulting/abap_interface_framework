*----------------------------------------------------------------------*
***INCLUDE RPCIFU02_TOP .
*----------------------------------------------------------------------*

REPORT rpcifu02 NO STANDARD PAGE HEADING LINE-SIZE 132.


TYPES: BEGIN OF ts_if_version,
        cdate TYPE d,
        ctime TYPE t,
        cprog LIKE sy-repid,
        uname LIKE sy-uname,
       END OF ts_if_version,

       BEGIN OF ts_if_results,
        seqnr(9) TYPE n,
        frper(6) TYPE n,
        frbeg    TYPE d,
        frend    TYPE d,
        rundt    LIKE pc261-rundt,
        runtm    LIKE pc261-runtm,
        abkrs    LIKE pc261-abkrs,
       END OF ts_if_results,

       BEGIN OF ts_id_key,
        pernr LIKE pernr-pernr,
        fldid LIKE t532a-fldid,
       END OF ts_id_key,

       BEGIN OF ts_if_key,
         pernr LIKE pernr-pernr,
         seqnr(9) TYPE n,
         fldid LIKE t532a-fldid,
       END OF ts_if_key.

TYPES: tt_if_results    TYPE STANDARD TABLE OF ts_if_results.

DATA: g_custom_container2000 TYPE REF TO cl_gui_custom_container,
      alv2000                TYPE REF TO cl_gui_alv_grid,
      ok_code                TYPE sy-ucomm,
      gs_layout              TYPE lvc_s_layo,                   "Layout des ALV_GRID
      gt_fieldcat            TYPE lvc_t_fcat WITH HEADER LINE,  "Ausgabefelder ALV
      gt_sort_grid           TYPE lvc_t_sort WITH HEADER LINE,
      gt_index_rows          TYPE lvc_t_row WITH HEADER LINE,    "markierte Zeilen
      flag_new(1)                 VALUE 'X'.

DATA: BEGIN OF delete_table OCCURS 300.
        INCLUDE STRUCTURE hrrpcifu02_del_tab.
DATA:   marks(1),
        tabindex LIKE sy-tabix,
        dsign(1),
      END OF delete_table.


CONSTANTS: c_container_delete_tab TYPE scrfname VALUE 'DELETE_TABLE'.