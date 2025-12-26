$PBExportHeader$w_sh104_e.srw
$PBExportComments$점간 이동 승인
forward
global type w_sh104_e from w_com010_e
end type
type st_1 from statictext within w_sh104_e
end type
end forward

global type w_sh104_e from w_com010_e
integer width = 2985
long backcolor = 16777215
st_1 st_1
end type
global w_sh104_e w_sh104_e

type variables
string is_proc_opt
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

if is_proc_opt = "C" then
	dw_body.DataObject = "d_sh104_d02"
	dw_body.SetTransObject(SQLCA)
else
	dw_body.DataObject = "d_sh104_d01"
	dw_body.SetTransObject(SQLCA)
end if

IF MidA(GS_SHOP_CD,3,4) = '2000' THEN 
	messagebox("참고!", "정상 매장에서 사용이 가능합니다!")
else

	il_rows = dw_body.retrieve(gs_shop_cd, is_proc_opt)
	IF il_rows > 0 THEN
		dw_body.SetFocus()
	END IF
end if

This.Trigger Event ue_msg(1, il_rows)

end event

on w_sh104_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sh104_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String  ls_yymmdd, ls_out_no,     ls_no,   ls_proc_yn,  ls_to_shop_type   
String  ls_fr_ymd, ls_fr_shop_cd, ls_fr_shop_type,      ls_rtrn_no,    ls_fr_no 
String  ls_style,  ls_chno,       ls_color, ls_size,    ls_err_msg 
Long    ll_qty 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = String(ld_datetime, "yyyymmdd")

il_rows = 1

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
		ls_proc_yn = dw_body.GetitemString(i, "proc_yn") 
		IF ls_proc_yn = 'Y' THEN 
		   /* 전표 번호 채번 */
   	   gf_style_outno (ls_yymmdd, gs_brand, ls_out_no)
			ls_no           = '0001' 
         ls_fr_ymd       = dw_body.GetitemString(i, "fr_ymd") 
         ls_fr_shop_cd   = dw_body.GetitemString(i, "fr_shop_cd") 
         ls_fr_shop_type = dw_body.GetitemString(i, "fr_shop_type")  
         ls_rtrn_no      = dw_body.GetitemString(i, "fr_rtn_no")  
         ls_fr_no        = dw_body.GetitemString(i, "fr_no")  
         ls_to_shop_type = dw_body.GetitemString(i, "to_shop_type")  
         ls_style        = dw_body.GetitemString(i, "style")  
         ls_chno         = dw_body.GetitemString(i, "chno")  
         ls_color        = dw_body.GetitemString(i, "color")  
         ls_size         = dw_body.GetitemString(i, "size")  
         ll_qty          = dw_body.GetitemNumber(i, "move_qty")  
			
			if is_proc_opt = "A" then
			
				DECLARE SP_SH104_UPDATE_new PROCEDURE FOR SP_SH104_UPDATE_new  
						  @fr_ymd       = :ls_fr_ymd, 
						  @fr_shop_cd   = :ls_fr_shop_cd, 
						  @fr_shop_type = :ls_fr_shop_type, 
						  @fr_rtrn_no   = :ls_rtrn_no, 
						  @fr_no        = :ls_fr_no, 
						  @to_shop_cd   = :gs_shop_cd , 
						  @to_shop_type = :ls_to_shop_type, 
						  @to_ymd       = :ls_yymmdd, 
						  @out_no       = :ls_out_no, 
						  @no           = :ls_no,
						  @style        = :ls_style , 
						  @chno         = :ls_chno, 
						  @color        = :ls_color, 
						  @size         = :ls_size , 
						  @qty          = :ll_qty, 
						  @mod_id       = :gs_user_id   ,        
						  @mod_dt       = :ld_datetime  ;
				EXECUTE SP_SH104_UPDATE_new ;
			
			else
				
				DECLARE SP_SH104_UPDATE_m_new PROCEDURE FOR SP_SH104_UPDATE_m_new  
						  @fr_ymd       = :ls_fr_ymd, 
						  @fr_shop_cd   = :ls_fr_shop_cd, 
						  @fr_shop_type = :ls_fr_shop_type, 
						  @fr_rtrn_no   = :ls_rtrn_no, 
						  @fr_no        = :ls_fr_no, 
						  @to_shop_cd   = :gs_shop_cd , 
						  @to_shop_type = :ls_to_shop_type, 
						  @to_ymd       = :ls_yymmdd, 
						  @out_no       = :ls_out_no, 
						  @no           = :ls_no,
						  @style        = :ls_style , 
						  @chno         = :ls_chno, 
						  @color        = :ls_color, 
						  @size         = :ls_size , 
						  @qty          = :ll_qty, 
						  @mod_id       = :gs_user_id   ,        
						  @mod_dt       = :ld_datetime  ;
						  
				EXECUTE SP_SH104_UPDATE_m_new   ;				
			end if	
				
			IF SQLCA.SQLCODE < 0 THEN 
				il_rows = - 1
				ls_Err_msg = SQLCA.SQLERRTEXT
				EXIT
			END IF
		END IF
   END IF
NEXT

if il_rows = 1 then
   commit  USING SQLCA;
   st_1.Text = ""
   dw_body.ResetUpdate()
	This.Post Event ue_retrieve()
else
   rollback  USING SQLCA;
	MessageBox("SQL오류", ls_Err_msg)
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_proc_opt = dw_head.GetItemString(1, "proc_opt")
if IsNull(is_proc_opt) or Trim(is_proc_opt) = "" then
   MessageBox(ls_title," 구분코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_opt")
   return false
end if

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

type cb_close from w_com010_e`cb_close within w_sh104_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh104_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh104_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh104_e
end type

type cb_update from w_com010_e`cb_update within w_sh104_e
end type

type cb_print from w_com010_e`cb_print within w_sh104_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh104_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh104_e
integer height = 160
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh104_e
integer x = 9
integer y = 152
integer width = 2875
integer height = 104
string dataobject = "d_sh104_h01"
end type

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

type ln_1 from w_com010_e`ln_1 within w_sh104_e
boolean visible = false
end type

type ln_2 from w_com010_e`ln_2 within w_sh104_e
boolean visible = false
end type

type dw_body from w_com010_e`dw_body within w_sh104_e
integer y = 264
integer height = 1576
string dataobject = "d_sh104_d01"
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

event dw_body::itemchanged;call super::itemchanged;st_1.Text = "☜ 승인 처리후 반드시 저장 버튼을 누르세요 "

end event

event dw_body::constructor;call super::constructor;//DataWindowchild ldw_child 
//
//This.GetChild("fr_shop_type", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.retrieve('009')
end event

type dw_print from w_com010_e`dw_print within w_sh104_e
end type

type st_1 from statictext within w_sh104_e
integer x = 402
integer y = 60
integer width = 1637
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
boolean focusrectangle = false
end type

