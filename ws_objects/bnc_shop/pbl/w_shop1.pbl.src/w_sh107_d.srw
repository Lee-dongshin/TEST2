$PBExportHeader$w_sh107_d.srw
$PBExportComments$RT 지시 확인
forward
global type w_sh107_d from w_com010_e
end type
end forward

global type w_sh107_d from w_com010_e
integer width = 2985
integer height = 2072
end type
global w_sh107_d w_sh107_d

type variables
String  is_fr_ymd, is_to_ymd 
end variables

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd, is_fr_ymd, is_to_ymd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_msg(1, il_rows)
This.Trigger Event ue_BUTTON(1, il_rows)

end event

on w_sh107_d.create
call super::create
end on

on w_sh107_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.04.23                                                  */	
/* 수정일      : 2002.05.07                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

IF MidA(GS_SHOP_CD,3,4) = '2000' THEN 
	messagebox("참고!", "정상 매장에서 사용이 가능합니다!")
   RETURN FALSE
end if	

IF DaysAfter(dw_head.GetItemDate(1, "fr_ymd"), dw_head.GetItemDate(1, "to_ymd")) > 62 THEN
   MessageBox(ls_title,"2개월 이상은 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

//is_fr_ymd = String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
//is_to_ymd = String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if

return true
end event

event open;call super::open;Date ld_fr_ymd, ld_to_ymd  

//ld_to_ymd  = dw_head.GetitemDate(1, "to_ymd")
//ld_fr_ymd  = RelativeDate(ld_to_ymd, -7)
//dw_head.Setitem(1, "fr_ymd", ld_fr_ymd)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_shop_cd.Text = '" + gs_shop_cd + "'" + &
             "t_shop_nm.Text = '" + gs_shop_nm + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

dw_print.Modify(ls_modify)
end event

event ue_print();

dw_print.dataobject = "d_sh107_r02"
dw_print.SetTransObject(SQLCA)

dw_print.retrieve(gs_shop_cd, is_fr_ymd, is_to_ymd)
dw_print.inv_printpreview.of_SetZoom()
end event

event ue_preview();call super::ue_preview;dw_print.dataobject = "d_sh107_r01"
dw_print.SetTransObject(SQLCA)

end event

type cb_close from w_com010_e`cb_close within w_sh107_d
end type

type cb_delete from w_com010_e`cb_delete within w_sh107_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh107_d
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh107_d
end type

type cb_update from w_com010_e`cb_update within w_sh107_d
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_sh107_d
integer width = 343
string text = "전표출력(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_sh107_d
integer width = 370
string text = "리스트출력(&V)"
end type

type gb_button from w_com010_e`gb_button within w_sh107_d
end type

type dw_head from w_com010_e`dw_head within w_sh107_d
integer height = 160
string dataobject = "d_sh107_h01"
end type

event dw_head::itemchanged;call super::itemchanged;long ll_b_cnt
CHOOSE CASE dwo.name

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			Trigger Event ue_retrieve()
	
END CHOOSE
		
end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


end event

type ln_1 from w_com010_e`ln_1 within w_sh107_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_sh107_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_sh107_d
integer y = 376
integer height = 1456
string dataobject = "d_sh107_d01"
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)                                           */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemchanged;String ls_brand, ls_yymmdd, ls_rt_no, ls_no, ls_fg

//ls_brand  = GS_BRAND //This.GetitemString(row, "brand")
ls_brand  = This.GetitemString(row, "brand")
ls_yymmdd = This.GetitemString(row, "yymmdd")
ls_rt_no  = This.GetitemString(row, "rt_no")
ls_no     = This.GetitemString(row, "no")
ls_fg     = This.GetitemString(row, "rt_fg")


 DECLARE SP_SH107_UPDATE PROCEDURE FOR SP_SH107_UPDATE  
         @brand  = :ls_brand,   
         @yymmdd = :ls_yymmdd,   
         @rt_no  = :ls_rt_no,   
         @no     = :ls_no,   
         @rt_fg  = :ls_fg  ;

 EXECUTE SP_SH107_UPDATE ;
 
 COMMIT; 
 
end event

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn

If dwo.Name = 'cb_prt' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "prt_yn", ls_yn)		
	Next	
End If

end event

type dw_print from w_com010_e`dw_print within w_sh107_d
integer x = 128
integer y = 660
string dataobject = "d_sh107_r01"
end type

