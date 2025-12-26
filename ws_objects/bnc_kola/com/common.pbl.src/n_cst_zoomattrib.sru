$PBExportHeader$n_cst_zoomattrib.sru
$PBExportComments$Extension Attributes for the DataWindow Zoom service
forward
global type n_cst_zoomattrib from pfc_n_cst_zoomattrib
end type
end forward

global type n_cst_zoomattrib from pfc_n_cst_zoomattrib
end type

type variables
String		is_modify       // modify string
Long        il_dddw_cnt  //child datawindow count                
String      is_column_nm
String      is_cd_div       // 구분코드
end variables

on n_cst_zoomattrib.create
call super::create
end on

on n_cst_zoomattrib.destroy
call super::destroy
end on

