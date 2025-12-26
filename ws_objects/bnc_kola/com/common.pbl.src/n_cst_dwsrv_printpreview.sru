$PBExportHeader$n_cst_dwsrv_printpreview.sru
$PBExportComments$Extension DataWindow  PrintPreview service
forward
global type n_cst_dwsrv_printpreview from pfc_n_cst_dwsrv_printpreview
end type
end forward

global type n_cst_dwsrv_printpreview from pfc_n_cst_dwsrv_printpreview
end type
global n_cst_dwsrv_printpreview n_cst_dwsrv_printpreview

forward prototypes
public function integer of_setzoom ()
public function integer of_setzoom (string as_modify)
end prototypes

public function integer of_setzoom ();integer	li_zoom
n_cst_zoomattrib	lnv_zoomattrib

if IsNull(idw_requestor) Or not IsValid (idw_requestor) then
	return -1
end if

lnv_zoomattrib.idw_obj = idw_requestor
lnv_zoomattrib.ii_zoom = of_GetZoom()
if lnv_zoomattrib.ii_zoom = -1 then
	return -1
end if

OpenWithParm (W_COM900, lnv_zoomattrib)
li_zoom = message.DoubleParm
return li_zoom
end function

public function integer of_setzoom (string as_modify);integer	li_zoom
n_cst_zoomattrib	lnv_zoomattrib

if IsNull(idw_requestor) Or not IsValid (idw_requestor) then
	return -1
end if

lnv_zoomattrib.idw_obj = idw_requestor
lnv_zoomattrib.ii_zoom = of_GetZoom()
lnv_zoomattrib.is_modify = as_modify

if lnv_zoomattrib.ii_zoom = -1 then
	return -1
end if

OpenWithParm (W_COM900, lnv_zoomattrib)
li_zoom = message.DoubleParm
return li_zoom

end function

on n_cst_dwsrv_printpreview.create
call super::create
end on

on n_cst_dwsrv_printpreview.destroy
call super::destroy
end on

