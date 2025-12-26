$PBExportHeader$w_51016_e.srw
$PBExportComments$판매사원휴무계획서
forward
global type w_51016_e from w_com020_e
end type
type dw_1 from datawindow within w_51016_e
end type
end forward

global type w_51016_e from w_com020_e
dw_1 dw_1
end type
global w_51016_e w_51016_e

type variables
String is_yymm, is_shop_cd ,is_sm_gbn,  is_sale_empnm
end variables

on w_51016_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_51016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"조회년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_shop_cd, is_yymm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
String     ls_shop_nm 
Long       ll_row_cnt 
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
                                  " and brand = '" + gs_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event type long ue_update();call super::ue_update;long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_1.RowCount()
IF dw_1.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_1.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_1.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_1.Setitem(i, "mod_id", gs_user_id)
      dw_1.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_1.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"W_51016_E","0")
end event

type cb_close from w_com020_e`cb_close within w_51016_e
end type

type cb_delete from w_com020_e`cb_delete within w_51016_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_51016_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_51016_e
end type

type cb_update from w_com020_e`cb_update within w_51016_e
end type

type cb_print from w_com020_e`cb_print within w_51016_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_51016_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_51016_e
end type

type cb_excel from w_com020_e`cb_excel within w_51016_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_51016_e
integer height = 136
string dataobject = "d_51016_h01"
end type

event dw_head::itemchanged;call super::itemchanged;String ls_yymmdd

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_51016_e
integer beginy = 304
integer endy = 304
end type

type ln_2 from w_com020_e`ln_2 within w_51016_e
integer beginy = 308
integer endy = 308
end type

type dw_list from w_com020_e`dw_list within w_51016_e
integer y = 316
integer width = 818
integer height = 1732
string dataobject = "d_51016_d01"
end type

event dw_list::clicked;call super::clicked;string ls_flag
long i

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_sm_gbn = This.GetItemString(row, 'sm_gbn') 
is_sale_empnm = This.GetItemString(row, 'sale_empnm') 


if IsNull(is_sale_empnm) or Trim(is_sale_empnm) = "" then
   dw_1.reset()
   dw_body.reset()
   return 
end if

il_rows = dw_body.retrieve(is_yymm)
il_rows = dw_1.retrieve(MidA(is_shop_cd,1,1), is_yymm, is_shop_cd, is_sm_gbn, '000000', is_sale_empnm)
IF il_rows > 0 THEN
	ls_Flag = dw_1.getitemstring(1,"Flag")
	if ls_Flag = "New" then	dw_1.SetItemStatus(1, 0, Primary!, New!)
	dw_body.setredraw(false)
	for i = 1 to 31
		choose case dw_1.getitemstring(1,"dd_" + string(i))
			case "M"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_m.background.color))
			case "J"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_j.background.color))
			case "P"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_p.background.color))
			case "O"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_o.background.color))
			case "X"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_x.background.color))
			case "Q"
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(dw_body.object.b_gbn_q.background.color))				
			case else
				dw_body.modify("dd_" + string(i) + ".background.color = " + string(81324524))
		end choose
	next	
	
	dw_body.setredraw(true)
   dw_1.SetFocus()
END IF


Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)



end event

type dw_body from w_com020_e`dw_body within w_51016_e
integer x = 859
integer y = 316
integer width = 2734
integer height = 1732
string dataobject = "d_51016_d03"
end type

event dw_body::clicked;call super::clicked;if not dw_head.Enabled and LeftA(string(dwo.name),2) = "dd" then
		this.modify(dwo.name + ".background.color = " + this.object.t_gbn.background.color)
		dw_1.setitem(1,dwo.name,string(this.object.t_gbn_cd.text))
		
		ib_changed = true
		cb_update.enabled = true

	
end if


end event

event dw_body::buttonclicked;call super::buttonclicked;choose case dwo.name
	case "b_gbn_m"
		this.object.t_gbn.background.color = this.object.b_gbn_m.background.color
		this.object.t_gbn_cd.text = "M"
case "b_gbn_j"
		this.object.t_gbn.background.color = this.object.b_gbn_j.background.color
		this.object.t_gbn_cd.text = "J"
	case "b_gbn_p"
		this.object.t_gbn.background.color = this.object.b_gbn_p.background.color
		this.object.t_gbn_cd.text = "P"
	case "b_gbn_o"
		this.object.t_gbn.background.color = this.object.b_gbn_o.background.color
		this.object.t_gbn_cd.text = "O"
	case "b_gbn_x"
		this.object.t_gbn.background.color = this.object.b_gbn_x.background.color
		this.object.t_gbn_cd.text = "X"
	case "b_gbn_q"
		this.object.t_gbn.background.color = this.object.b_gbn_q.background.color
		this.object.t_gbn_cd.text = "Q"
		

end choose

end event

type st_1 from w_com020_e`st_1 within w_51016_e
integer x = 850
integer y = 316
integer height = 1732
end type

type dw_print from w_com020_e`dw_print within w_51016_e
end type

type dw_1 from datawindow within w_51016_e
boolean visible = false
integer x = 1787
integer y = 592
integer width = 411
integer height = 432
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_51016_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

