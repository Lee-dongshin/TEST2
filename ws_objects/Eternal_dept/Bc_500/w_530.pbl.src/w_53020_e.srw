$PBExportHeader$w_53020_e.srw
$PBExportComments$타브랜드인기상품등록
forward
global type w_53020_e from w_com010_e
end type
type p_1 from picture within w_53020_e
end type
type cb_input from commandbutton within w_53020_e
end type
end forward

global type w_53020_e from w_com010_e
integer width = 3675
integer height = 2248
event ue_input ( )
p_1 p_1
cb_input cb_input
end type
global w_53020_e w_53020_e

type variables
DataWindowChild	idw_year, idw_season, idw_sojae, idw_item, idw_brand
String is_style_No, is_yymm, is_week_no, is_no, is_brand
end variables

event ue_input();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
dw_body.Visible   = True

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.Reset()
il_rows = dw_body.insertRow(0)

IF il_rows > 0 THEN
	dw_body.Setitem(il_rows, "yymm", is_yymm)
	dw_body.Setitem(il_rows, "week_no", is_week_no)
	dw_body.Setitem(il_rows, "no", is_no)	
	dw_body.Setitem(il_rows, "brand", is_brand)
	dw_body.Setitem(il_rows, "style_no", is_style_no)	
   dw_body.SetFocus()
END IF


This.Trigger Event ue_button(1, il_rows)

//This.Trigger Event ue_button(6, il_rows)



end event

event pfc_preopen();call super::pfc_preopen;
of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_input, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(p_1, "FixedToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)

end event

on w_53020_e.create
int iCurrent
call super::create
this.p_1=create p_1
this.cb_input=create cb_input
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.cb_input
end on

on w_53020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.cb_input)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_style, ls_chno, LS_PIC_NM 
Boolean    lb_check 
DataStore  lds_Source
integer    ls_cnt

CHOOSE CASE as_column
	CASE "style_no"			
		 ls_style = as_data
		 	gf_pic_dir('2', ls_style, ls_pic_nm)
			 
			select count(*)
			into :ls_cnt
			from tb_54050_h (nolock)
			where style_no = :ls_style;
						 
		 
 		 IF ai_div = 1 THEN 	
			IF LenA(ls_pic_nm) <> 44 or FileExists(ls_pic_nm) = false THEN
				   p_1.PictureName = ls_pic_nm
					dw_body.reset()
					MessageBox("오류", "사진이 등록되어 있지 않습니다.!")
					Return 1
				else
				   p_1.PictureName = ls_pic_nm
				   dw_head.SetRow(1)
					if ls_cnt >0 then 
						This.Trigger Event ue_retrieve()						
						return 0
					end if
					dw_body.reset()					
					return 0
				END IF						
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = '품번 코드 검색'	
			gst_cd.datawindow_nm   = "d_com014" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style_no LIKE  '" + ls_style + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.12                                                  */	
/* 수정일      : 2001.12.12                                                  */
/*===========================================================================*/
String ls_pic_nm
long ll_result, ll_row_cnt
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_style_NO)
IF il_rows > 0 THEN
	gf_pic_dir('2', is_style_NO,ls_pic_nm)
	p_1.PictureName = ls_pic_nm
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53020_d","0")
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or LenA(is_style_no) <> 8 then
   MessageBox(ls_title,"제품번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if


is_yymm = '20' + MidA(is_style_no,3,4)
is_week_no = MidA(is_style_no,7,1)
is_no = MidA(is_style_no,8,1)
is_brand = MidA(is_style_no,1,2)


return true

end event

event type long ue_update();call super::ue_update;
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		dw_body.setitem(i, "style_no", is_style_no)
		dw_body.setitem(i, "brand",    is_brand)		
      dw_body.Setitem(i, "reg_id",   gs_user_id)
   ELSEIF idw_status = DataModified! THEN		   /* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_dberror();//
end event

type cb_close from w_com010_e`cb_close within w_53020_e
end type

type cb_delete from w_com010_e`cb_delete within w_53020_e
end type

type cb_insert from w_com010_e`cb_insert within w_53020_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53020_e
end type

type cb_update from w_com010_e`cb_update within w_53020_e
end type

type cb_print from w_com010_e`cb_print within w_53020_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53020_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53020_e
end type

type cb_excel from w_com010_e`cb_excel within w_53020_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53020_e
integer y = 156
integer width = 2149
integer height = 152
string dataobject = "d_53020_h01"
boolean livescroll = false
end type

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53020_e
integer beginy = 320
integer endx = 2373
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_53020_e
integer beginy = 324
integer endx = 2373
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_53020_e
integer y = 344
integer width = 2377
integer height = 1668
string dataobject = "d_53020_d01"
end type

event dw_body::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('040')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')


end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_53020_e
end type

type p_1 from picture within w_53020_e
integer x = 2405
integer y = 168
integer width = 1189
integer height = 1352
boolean bringtotop = true
boolean focusrectangle = false
end type

type cb_input from commandbutton within w_53020_e
integer x = 2528
integer y = 44
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "등록"
end type

event clicked;///* 작성자      : 김태범        															  */	
///* 작성일      : 2002.03.04																  */	
///* 수정일      : 2002.03.04																  */
///*===========================================================================*/
IF dw_head.Enabled THEN
   Parent.Trigger Event ue_input()	//등록 
ELSE 
	Parent.Trigger Event ue_head()	//조건 
END IF

end event

