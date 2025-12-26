$PBExportHeader$w_42055_d.srw
$PBExportComments$PDA반품 일일현황
forward
global type w_42055_d from w_com010_d
end type
type cbx_laser from checkbox within w_42055_d
end type
type dw_1 from datawindow within w_42055_d
end type
type rb_rtn from radiobutton within w_42055_d
end type
type rb_out from radiobutton within w_42055_d
end type
type cbx_laser_a4 from checkbox within w_42055_d
end type
type cbx_laser_a4_full from checkbox within w_42055_d
end type
end forward

global type w_42055_d from w_com010_d
integer width = 3680
integer height = 2256
cbx_laser cbx_laser
dw_1 dw_1
rb_rtn rb_rtn
rb_out rb_out
cbx_laser_a4 cbx_laser_a4
cbx_laser_a4_full cbx_laser_a4_full
end type
global w_42055_d w_42055_d

type variables
DataWindowChild idw_brand, idw_tran_cust, idw_empno
String is_brand, is_yymmdd, is_tran_cust, is_shop_cd, is_view_opt, is_work_ymd, is_empno
end variables

on w_42055_d.create
int iCurrent
call super::create
this.cbx_laser=create cbx_laser
this.dw_1=create dw_1
this.rb_rtn=create rb_rtn
this.rb_out=create rb_out
this.cbx_laser_a4=create cbx_laser_a4
this.cbx_laser_a4_full=create cbx_laser_a4_full
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_laser
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_rtn
this.Control[iCurrent+4]=this.rb_out
this.Control[iCurrent+5]=this.cbx_laser_a4
this.Control[iCurrent+6]=this.cbx_laser_a4_full
end on

on w_42055_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_laser)
destroy(this.dw_1)
destroy(this.rb_rtn)
destroy(this.rb_out)
destroy(this.cbx_laser_a4)
destroy(this.cbx_laser_a4_full)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_tran_cust = dw_head.GetItemString(1, "tran_cust")
if IsNull(is_tran_cust) or Trim(is_tran_cust) = "" then
   MessageBox(ls_title,"운송업체를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("tran_cust")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_tran_cust) or Trim(is_tran_cust) = "" then
  is_shop_cd = "%"
end if

is_view_opt = dw_head.GetItemString(1, "view_opt")
if IsNull(is_view_opt) or Trim(is_view_opt) = "" then
  is_view_opt = "N"
end if

is_work_ymd = dw_head.GetItemString(1, "work_ymd")
if IsNull(is_work_ymd) or Trim(is_work_ymd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_ymd")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"작업자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

//MESSAGEBOX("", is_empno)

return true

end event

event ue_retrieve();call super::ue_retrieve;
string ls_opt_view

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_view_opt = "B" then
	if rb_rtn.checked then
		dw_body.DataObject = "d_42055_d02"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r02"
		dw_print.SetTransObject(SQLCA)
		
	else
		dw_body.DataObject = "d_42055_d12"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r12"
		dw_print.SetTransObject(SQLCA)		
	end if	
	
elseif is_view_opt = "C" then
	if rb_rtn.checked then
		dw_body.DataObject = "d_42055_d04"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r04"
		dw_print.SetTransObject(SQLCA)
		
	else
		dw_body.DataObject = "d_42055_d14"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r14"
		dw_print.SetTransObject(SQLCA)		
	end if		
elseif is_view_opt = "D" then
		dw_body.DataObject = "d_42055_d31"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r31"
		dw_print.SetTransObject(SQLCA)		
ELSE
	if rb_rtn.checked then
		dw_body.DataObject = "d_42055_d01"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r01"
		dw_print.SetTransObject(SQLCA)		
	else
		dw_body.DataObject = "d_42055_d11"
		dw_body.SetTransObject(SQLCA)
		
		dw_print.DataObject = "d_42055_r11"
		dw_print.SetTransObject(SQLCA)			
	end if	
END IF	

if rb_rtn.checked then 
	ls_opt_view = 'R'
elseif rb_out.checked	then
	ls_opt_view = 'O'
end if	

if is_view_opt <> "D" then
	il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_tran_cust, is_work_ymd, is_empno )
else	
	il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_tran_cust, is_work_ymd, is_empno,ls_opt_view)
end if	
	
	
	
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

event ue_print();Long   i 
String ls_shop_type, ls_out_no, ls_shop_cd, ls_yymmdd, ls_print 
String ls_inout_gubn, ls_out_gubn,ls_print1, ls_out_ymd

if cbx_laser.checked then
	dw_print.DataObject = "d_com420_A"
	dw_print.SetTransObject(SQLCA)
elseif cbx_laser_a4.checked then
	dw_print.DataObject = "d_com420_new"
	dw_print.SetTransObject(SQLCA)	
elseif cbx_laser_a4_full.checked then
	dw_print.DataObject = "d_com420_a4"
	dw_print.SetTransObject(SQLCA)	
	
ELSE
	dw_print.DataObject = "d_com420"
	dw_print.SetTransObject(SQLCA)
END IF	
	
	if is_view_opt <> 'D' then
	
	FOR i = 1 TO dw_body.RowCount() 
		ls_print = dw_body.getitemstring(i, "prt_chk_r")
		ls_print1 = dw_body.getitemstring(i, "prt_chk_o")	
		IF ls_print = "Y"  THEN 
		
			if rb_out.checked then
			ls_yymmdd     = dw_body.GetitemString(i, "yymmdd")			 
			ls_out_no     = dw_body.GetitemString(i, "out_no")
			ls_shop_cd    = dw_body.GetitemString(i, "shop_cd") 
			ls_shop_type  = dw_body.GetitemString(i, "shop_type")			
			ls_out_gubn = "1"
			else	
			ls_yymmdd     = dw_body.GetitemString(i, "rtn_ymd")			 
			ls_out_no     = dw_body.GetitemString(i, "rtn_no")
			ls_shop_cd    = dw_body.GetitemString(i, "shop_cd") 
			ls_shop_type  = dw_body.GetitemString(i, "shop_type")
			ls_out_gubn = "2"
			end if	
	
			il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
			IF dw_print.RowCount() > 0 Then
				il_rows = dw_print.Print()
			END IF
		END IF 	
		
		IF ls_print1 = "Y"  THEN 
			ls_out_ymd    = dw_body.GetitemString(i, "out_ymd")			 
			ls_out_no     = dw_body.GetitemString(i, "out_no")
			ls_shop_cd    = dw_body.GetitemString(i, "out_shop_cd") 
			ls_shop_type  = dw_body.GetitemString(i, "out_shop_type")
			ls_out_gubn = "1"
	
	
			il_rows = dw_print.Retrieve(is_brand, ls_out_ymd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
			IF dw_print.RowCount() > 0 Then
				il_rows = dw_print.Print()
			END IF
		END IF 		
	NEXT 
else	
	FOR i = 1 TO dw_body.RowCount() 
			ls_print1 = dw_body.getitemstring(i, "prt_chk_o")	
			IF ls_print1 = "Y"  THEN 			

				ls_yymmdd     = dw_body.GetitemString(i, "out_ymd")			 
				ls_out_no     = dw_body.GetitemString(i, "out_no")
				ls_shop_cd    = dw_body.GetitemString(i, "shop_cd") 
				ls_shop_type  = dw_body.GetitemString(i, "shop_type")			
				if rb_out.checked then				
					ls_out_gubn = "1"
				else	
					ls_out_gubn = "2"
				end if	
		
				il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
				IF dw_print.RowCount() > 0 Then
					il_rows = dw_print.Print()
//					dw_print.inv_printpreview.of_SetZoom()

				END IF
			END IF 	
			
		
		NEXT 	
end if		
This.Trigger Event ue_msg(6, il_rows)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42055_d","0")
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


dw_print.SetTransObject(SQLCA)

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text  = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_work_ymd.Text  = '" + String(is_work_ymd, '@@@@/@@/@@') + "'" + &				
            "t_tran_cust.Text  = '" + idw_tran_cust.GetItemString(idw_tran_cust.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)
end event

event ue_preview();if is_view_opt = "Y" then
	if rb_rtn.checked then		
		dw_print.DataObject = "d_42055_r02"
		dw_print.SetTransObject(SQLCA)		
	else		
		dw_print.DataObject = "d_42055_r12"
		dw_print.SetTransObject(SQLCA)		
	end if	
elseif is_view_opt = "D" then
		dw_print.DataObject = "d_42055_r31"
		dw_print.SetTransObject(SQLCA)			
ELSE
	if rb_rtn.checked then
		
		dw_print.DataObject = "d_42055_r01"
		dw_print.SetTransObject(SQLCA)		
	else
		
		dw_print.DataObject = "d_42055_r11"
		dw_print.SetTransObject(SQLCA)			
	end if	
END IF	

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event open;call super::open;datetime ld_datetime
string ls_work_ymd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_work_ymd = String(ld_datetime, "yyyymmdd")


dw_head.setitem(1, "work_ymd", ls_work_ymd)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
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

type cb_close from w_com010_d`cb_close within w_42055_d
end type

type cb_delete from w_com010_d`cb_delete within w_42055_d
end type

type cb_insert from w_com010_d`cb_insert within w_42055_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42055_d
end type

type cb_update from w_com010_d`cb_update within w_42055_d
end type

type cb_print from w_com010_d`cb_print within w_42055_d
integer width = 343
string text = "전표출력(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_42055_d
string text = "조회인쇄(&V)"
end type

type gb_button from w_com010_d`gb_button within w_42055_d
end type

type cb_excel from w_com010_d`cb_excel within w_42055_d
end type

type dw_head from w_com010_d`dw_head within w_42055_d
integer y = 160
integer width = 3525
integer height = 212
string dataobject = "d_42055_h01"
end type

event dw_head::constructor;call super::constructor;DatawindowChild ldw_empno

This.GetChild("empno", idw_empno)
idw_empno.SetTransObject(SQLCA)
idw_empno.Retrieve("%")

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
//idw_brand.InsertRow(1)
//idw_brand.SetItem(1, "inter_cd", '%')
//idw_brand.SetItem(1, "inter_nm", '전체')
//
This.GetChild("tran_cust", idw_tran_cust)
idw_tran_cust.SetTransObject(SQLCA)
idw_tran_cust.Retrieve('404')
idw_tran_cust.InsertRow(1)
idw_tran_cust.SetItem(1, "inter_cd", '%')
idw_tran_cust.SetItem(1, "inter_nm", '전체')
end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		if LenA(data) <> 0 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_42055_d
integer beginy = 372
integer endy = 372
end type

type ln_2 from w_com010_d`ln_2 within w_42055_d
integer beginy = 376
integer endy = 376
end type

type dw_body from w_com010_d`dw_body within w_42055_d
integer y = 388
integer height = 1628
string dataobject = "d_42055_d01"
end type

event dw_body::buttonclicked;call super::buttonclicked;Long i
String ls_yn

If dwo.Name = 'cb_prt_chk_r' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "prt_chk_r", ls_yn)
	Next
end if	
	
If dwo.Name = 'cb_prt_chk_o' Then
	If dwo.Text = '선택' Then
		ls_yn = 'Y'
		dwo.Text = '제외'
	Else
		ls_yn = 'N'
		dwo.Text = '선택'
	End If
	
	For i = 1 To This.RowCount()
		This.SetItem(i, "prt_chk_o", ls_yn)
	Next	
End If

end event

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search, ls_shop_cd, ls_shop_type, ls_yymmdd, ls_out_no

if row > 0 then 
	choose case dwo.name
		case 'rtn_no','rtn_qty', 'out_no', 'out_qty'
			ls_shop_cd 	= this.GetItemString(row,'shop_cd')
			ls_shop_type= this.GetItemString(row,'shop_type')
			if rb_rtn.checked then
				ls_yymmdd  	= this.GetItemString(row,'rtn_ymd')			
				ls_out_no	= this.GetItemString(row,'rtn_no')			
			else
				ls_yymmdd  	= this.GetItemString(row,'YYMMDD')			
				ls_out_no	= this.GetItemString(row,'OUT_no')			
			end if
			
			if rb_rtn.checked then
				il_rows = dw_1.retrieve(ls_yymmdd, ls_shop_cd, ls_shop_type,ls_out_no, '1')		
			else
				il_rows = dw_1.retrieve(ls_yymmdd, ls_shop_cd, ls_shop_type,ls_out_no, '2')		
			end if			

					
			
			if il_rows > 0 then 
				dw_1.visible = true
			else	
				dw_1.visible = false
			end if	


	end choose	
end if
end event

type dw_print from w_com010_d`dw_print within w_42055_d
integer width = 3282
integer height = 1336
boolean titlebar = true
end type

type cbx_laser from checkbox within w_42055_d
integer x = 27
integer y = 32
integer width = 622
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "명세서(Laser)"
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_laser_a4.checked then
	 cbx_laser_a4.checked = false
END IF	

 cbx_laser_a4.checked = false
 cbx_laser_a4_full.checked = false
end event

type dw_1 from datawindow within w_42055_d
boolean visible = false
integer x = 9
integer y = 388
integer width = 2985
integer height = 1328
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세조회"
string dataobject = "d_42055_d03"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_1.visible = false
end event

type rb_rtn from radiobutton within w_42055_d
integer x = 3136
integer y = 188
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "반품전표"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.TextColor        = RGB(0, 0, 255)
rb_out.TextColor = 0

dw_body.DataObject  = 'd_42055_d01'
dw_print.DataObject = 'd_42055_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_out from radiobutton within w_42055_d
integer x = 3136
integer y = 276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 67108864
string text = "출고전표"
borderstyle borderstyle = stylelowered!
end type

event clicked;
This.TextColor        = RGB(0, 0, 255)
rb_rtn.TextColor = 0

dw_body.DataObject  = 'd_42055_d11'
dw_print.DataObject = 'd_42055_R11'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type cbx_laser_a4 from checkbox within w_42055_d
integer x = 27
integer y = 96
integer width = 622
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "A4양식지(Laser)"
borderstyle borderstyle = stylelowered!
end type

event clicked;if cbx_laser.checked then
	cbx_laser.checked = false
END IF	

	cbx_laser.checked = false
	cbx_laser_a4_full.checked = false
end event

type cbx_laser_a4_full from checkbox within w_42055_d
integer x = 622
integer y = 44
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "A4자체인쇄"
borderstyle borderstyle = stylelowered!
end type

event clicked; cbx_laser.checked = false
 cbx_laser_a4.checked = false
end event

