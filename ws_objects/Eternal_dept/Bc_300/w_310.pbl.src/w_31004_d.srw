$PBExportHeader$w_31004_d.srw
$PBExportComments$생산 공정 진행 현황
forward
global type w_31004_d from w_com010_d
end type
type rb_cust from radiobutton within w_31004_d
end type
type rb_item from radiobutton within w_31004_d
end type
type rb_out_seq from radiobutton within w_31004_d
end type
type cbx_dt from checkbox within w_31004_d
end type
end forward

global type w_31004_d from w_com010_d
integer width = 3675
integer height = 2276
rb_cust rb_cust
rb_item rb_item
rb_out_seq rb_out_seq
cbx_dt cbx_dt
end type
global w_31004_d w_31004_d

type variables
string is_work_dt, is_cust_cd, is_brand, is_sojae, is_make_type, is_country_cd, is_style_no
string is_object_body, is_object_print

datawindowchild idw_brand, idw_sojae, idw_make_type
end variables

on w_31004_d.create
int iCurrent
call super::create
this.rb_cust=create rb_cust
this.rb_item=create rb_item
this.rb_out_seq=create rb_out_seq
this.cbx_dt=create cbx_dt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_cust
this.Control[iCurrent+2]=this.rb_item
this.Control[iCurrent+3]=this.rb_out_seq
this.Control[iCurrent+4]=this.cbx_dt
end on

on w_31004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_cust)
destroy(this.rb_item)
destroy(this.rb_out_seq)
destroy(this.cbx_dt)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
is_work_dt = dw_head.GetItemString(1, "work_dt")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

is_sojae     = dw_head.GetItemString(1, "sojae")
is_make_type = dw_head.GetItemString(1, "make_type")
is_country_cd = dw_head.GetItemString(1, "country_cd")
is_style_no     = dw_head.GetItemString(1, "style_no")

if cbx_dt.checked then
	is_object_body  = 'd_31004_d04'
	is_object_print = 'd_31004_r04'	
elseif rb_cust.checked then
	is_object_body  = 'd_31004_d01'
	is_object_print = 'd_31004_r01'
elseif rb_item.checked then 
	is_object_body  = 'd_31004_d02'
	is_object_print = 'd_31004_r02'
elseif rb_out_seq.checked then
	is_object_body  = 'd_31004_d03'
	is_object_print = 'd_31004_r03'	
end if
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
if dw_body.dataobject <> is_object_body then
	dw_body.dataobject = is_object_body
	dw_print.dataobject = is_object_print
	
	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
end if


il_rows = dw_body.retrieve(is_brand,is_work_dt, is_cust_cd, is_sojae, is_make_type, is_country_cd, is_style_no)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				if isnull(as_data) or LenA(as_data) = 0 then 
					return 0
				ElseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF
				
			END IF   
			
			gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
			gst_cd.window_title    = "거래처 코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (CustCode LIKE ~'%" + as_data + "%~' or Cust_name like ~'%" + as_data + "%~')"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("work_dt")
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

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime
string 	ls_date


IF gf_cdate(ld_datetime,0)  THEN  
	ls_date = string(ld_datetime,"yyyymmdd")
	dw_head.setitem(1,"work_dt",ls_date)
	
end if

inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_cust_nm, ls_brand, ls_sojae, ls_make_type


IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_cust_nm  = dw_head.getitemstring(1,"cust_nm")

ls_brand  = idw_brand.getitemstring(idw_brand.getrow(),"inter_display")
ls_sojae  = idw_sojae.getitemstring(idw_sojae.getrow(),"inter_display")
ls_make_type  = idw_make_type.getitemstring(idw_make_type.getrow(),"inter_display")

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
             "t_brand.Text = '" + ls_brand + "'" + &
             "t_work_dt.Text = '" + is_work_dt + "'" + &
             "t_cust_cd.Text = '" + ls_cust_nm + "'" + &
             "t_sojae.Text = '" + ls_sojae + "'" + &
             "t_make_type.Text = '" + ls_make_type + "'"				 
dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_31004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_31004_d
end type

type cb_delete from w_com010_d`cb_delete within w_31004_d
end type

type cb_insert from w_com010_d`cb_insert within w_31004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_31004_d
end type

type cb_update from w_com010_d`cb_update within w_31004_d
end type

type cb_print from w_com010_d`cb_print within w_31004_d
end type

type cb_preview from w_com010_d`cb_preview within w_31004_d
end type

type gb_button from w_com010_d`gb_button within w_31004_d
end type

type cb_excel from w_com010_d`cb_excel within w_31004_d
end type

type dw_head from w_com010_d`dw_head within w_31004_d
integer y = 168
integer width = 3566
integer height = 200
string dataobject = "d_31004_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"cust_nm","")
		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "work_dt"
		IF  not  gf_datechk(data)  then
			messagebox('확인', "일자 형식이 틀립니다 !!")
			return 1
		end if
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('111')
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"inter_cd","%")
idw_sojae.setitem(1,"inter_nm","전체")

This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.insertrow(1)
idw_make_type.setitem(1,"inter_cd","%")
idw_make_type.setitem(1,"inter_nm","전체")


end event

type ln_1 from w_com010_d`ln_1 within w_31004_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_31004_d
integer beginy = 388
integer endy = 388
end type

type dw_body from w_com010_d`dw_body within w_31004_d
integer y = 404
integer height = 1636
string dataobject = "d_31004_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;//string ls_Work_Dt, ls_Country_cd, ls_Cust_Cd, ls_Style, ls_Chno, ls_end_yn
//choose case dwo.name
//	case "end_yn"
//		ls_Work_Dt   =this.getitemstring(row,"work_dt")
//		ls_Country_cd=this.getitemstring(row,"country_cd")
//		ls_Cust_Cd   =this.getitemstring(row,"cust_cd")
//		ls_Style     =this.getitemstring(row,"style")
//		ls_Chno      =this.getitemstring(row,"chno")
//
//		ls_end_yn = string(data)
//		
//		update a set end_yn = :ls_end_yn
//		from tb_31021_h a(nolock) 
//		where Work_Dt   = :ls_work_dt
//		and   Country_cd= :ls_country_cd
//		and   Cust_Cd   = :ls_cust_cd
//		and   Style     = :ls_style
//		and   Chno      = :ls_chno;
//		commit  USING SQLCA;
//end choose
//
end event

type dw_print from w_com010_d`dw_print within w_31004_d
integer x = 206
integer y = 516
string dataobject = "d_31004_r01"
end type

type rb_cust from radiobutton within w_31004_d
integer x = 2121
integer y = 300
integer width = 288
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "업체별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_item from radiobutton within w_31004_d
integer x = 2409
integer y = 300
integer width = 288
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "복종별"
borderstyle borderstyle = stylelowered!
end type

type rb_out_seq from radiobutton within w_31004_d
integer x = 2715
integer y = 300
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고차순별"
borderstyle borderstyle = stylelowered!
end type

type cbx_dt from checkbox within w_31004_d
integer x = 2903
integer y = 188
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "일자보기"
borderstyle borderstyle = stylelowered!
end type

