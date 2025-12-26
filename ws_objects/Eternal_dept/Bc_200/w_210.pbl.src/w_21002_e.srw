$PBExportHeader$w_21002_e.srw
$PBExportComments$자재코드복사
forward
global type w_21002_e from w_com020_e
end type
type dw_detail from datawindow within w_21002_e
end type
type st_2 from statictext within w_21002_e
end type
end forward

global type w_21002_e from w_com020_e
integer width = 3657
event type long ue_detail ( )
event ue_detail_set ( )
event ue_magam_chk ( )
event type boolean ue_magam_check ( )
dw_detail dw_detail
st_2 st_2
end type
global w_21002_e w_21002_e

type variables
string is_fr_year, is_fr_season, is_to_year, is_to_season, is_brand

datawindowchild idw_season, idw_brand



end variables

forward prototypes
public function integer wf_resizepanels ()
end prototypes

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)




//ll_Width = idrg_Vertical2[1].X + idrg_Vertical2[1].Width - st_1.X - ii_BarThickness
//
//idrg_Vertical2[1].Move (st_1.X + ii_BarThickness, idrg_Vertical2[1].Y)
//idrg_Vertical2[1].Resize (ll_Width, idrg_Vertical2[1].Height)
//

Return 1

end function

on w_21002_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_2
end on

on w_21002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.st_2)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF



IF dw_head.AcceptText() <> 1 THEN RETURN FALSE


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_fr_year   = dw_head.GetItemString(1, "fr_year")
is_fr_season = dw_head.GetItemString(1, "fr_season")
is_to_year   = dw_head.GetItemString(1, "to_year")
is_to_season = dw_head.GetItemString(1, "to_season")


return true

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */

inv_resize.of_Register(cb_close, "FixedToRight")


idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_detail

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_head.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
//this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */

dw_head.insertrow(0)

datetime ld_datetime



//idrg_Vertical2[1] = dw_detail



end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23013_d","0")
end event

type cb_close from w_com020_e`cb_close within w_21002_e
integer taborder = 120
end type

type cb_delete from w_com020_e`cb_delete within w_21002_e
boolean visible = false
integer taborder = 70
boolean enabled = true
end type

type cb_insert from w_com020_e`cb_insert within w_21002_e
boolean visible = false
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_21002_e
boolean visible = false
end type

type cb_update from w_com020_e`cb_update within w_21002_e
integer x = 1248
integer y = 1168
integer width = 736
integer taborder = 110
integer weight = 700
boolean enabled = true
string text = "부자재 복사"
end type

event cb_update::clicked;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//messagebox("fr_year"  ,is_fr_year)
//messagebox("fr_season",is_fr_season)
//messagebox("to_year"  ,is_to_year)
//messagebox("to_season",is_to_season)

if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return
	
 DECLARE sp_smat_SeasonCopy_brand PROCEDURE FOR sp_smat_SeasonCopy_brand  
			@fr_year   = :is_fr_year,   
			@fr_season = :is_fr_season,   
			@to_year   = :is_to_year,   
			@to_season = :is_to_season,
			@brand     = :is_brand	;
			
execute sp_smat_SeasonCopy_brand;	

if SQLCA.sqlcode = -1 then
	messagebox("확인", "복사에 실패하였습니다..")
	rollback  USING SQLCA;
else
	messagebox("확인","정상처리되었슴니다...")
	commit  USING SQLCA;
end if




	
	
end event

type cb_print from w_com020_e`cb_print within w_21002_e
boolean visible = false
integer x = 384
integer taborder = 80
end type

type cb_preview from w_com020_e`cb_preview within w_21002_e
boolean visible = false
integer x = 1422
integer taborder = 90
end type

type gb_button from w_com020_e`gb_button within w_21002_e
boolean visible = false
end type

type cb_excel from w_com020_e`cb_excel within w_21002_e
boolean visible = false
integer x = 1765
integer taborder = 100
end type

type dw_head from w_com020_e`dw_head within w_21002_e
event type long ue_detail ( )
integer y = 160
integer height = 1848
string dataobject = "d_21002_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')




this.getchild("fr_season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003')



this.getchild("to_season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003')

end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_21002_e
boolean visible = false
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_21002_e
boolean visible = false
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_21002_e
boolean visible = false
integer x = 5
integer y = 888
integer width = 754
integer height = 1148
end type

type dw_body from w_com020_e`dw_body within w_21002_e
event type long ue_detail ( )
boolean visible = false
integer x = 5
integer y = 348
integer width = 3593
integer height = 524
boolean vscrollbar = false
end type

type st_1 from w_com020_e`st_1 within w_21002_e
boolean visible = false
integer x = 763
integer y = 896
integer height = 1140
end type

type dw_print from w_com020_e`dw_print within w_21002_e
integer x = 5
integer y = 724
end type

type dw_detail from datawindow within w_21002_e
event ue_refresh ( long row,  string iwol_yn )
boolean visible = false
integer x = 782
integer y = 888
integer width = 2811
integer height = 1148
integer taborder = 60
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_21002_e
integer x = 581
integer y = 1376
integer width = 2098
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 81324524
string text = ">>(((⊙>...다음 시즌에 존재하지 않는 부자재코드만을 복사합니다.....<⊙)))<<"
boolean focusrectangle = false
end type

