$PBExportHeader$w_75001_e.srw
$PBExportComments$VIP 고객등록
forward
global type w_75001_e from w_com010_e
end type
type dw_member from datawindow within w_75001_e
end type
end forward

global type w_75001_e from w_com010_e
integer height = 2232
dw_member dw_member
end type
global w_75001_e w_75001_e

type variables
datawindowchild idw_brand, idw_area_cd, idw_shop_grp, idw_area, idw_sale_type

string is_yyyy, is_yymmdd, is_brand, is_area_cd, is_shop_cd, is_shop_grp

end variables

on w_75001_e.create
int iCurrent
call super::create
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
end on

on w_75001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if


is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_brand  = dw_head.GetItemString(1, "brand")

is_area_cd  = dw_head.GetItemString(1, "area_cd")
is_shop_cd  = dw_head.GetItemString(1, "shop_cd")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i
string ls_flag

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_yymmdd, gs_user_id, is_brand, is_area_cd, is_shop_cd, is_shop_grp)
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = "N" then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next
	
	
   dw_body.SetFocus()
else
	messagebox("확인","먼저 VIP 고객을 생성하세요..")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
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
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

update a set vip_grd = NULL
from tb_71010_m a (nolock) where vip_grd is not null;
	
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_yyyy.text = '" + is_yyyy + "'" 
dw_print.Modify(ls_modify)

dw_print.object.t_area_cd.text = idw_area_cd.getitemstring(idw_area_cd.getrow(), "inter_nm")
dw_print.object.t_shop_cd.text = dw_head.getitemstring(1, "shop_nm")
dw_print.object.t_shop_grp.text = idw_shop_grp.getitemstring(idw_shop_grp.getrow(), "inter_nm")


end event

event pfc_preopen();call super::pfc_preopen;
dw_member.SetTransObject(SQLCA)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75001_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE SHOP_STAT = '00' "	+ &
											 "  AND SHOP_DIV  IN ('G','K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or SHOP_SNM LIKE '%" + as_data + "%')"
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

type cb_close from w_com010_e`cb_close within w_75001_e
end type

type cb_delete from w_com010_e`cb_delete within w_75001_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_75001_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_75001_e
end type

type cb_update from w_com010_e`cb_update within w_75001_e
end type

type cb_print from w_com010_e`cb_print within w_75001_e
end type

type cb_preview from w_com010_e`cb_preview within w_75001_e
end type

type gb_button from w_com010_e`gb_button within w_75001_e
end type

type cb_excel from w_com010_e`cb_excel within w_75001_e
end type

type dw_head from w_com010_e`dw_head within w_75001_e
integer height = 208
string dataobject = "d_75001_h01"
end type

event dw_head::buttonclicked;call super::buttonclicked;integer Net

choose case dwo.name
	case "cb_vip"
		net = messagebox("확인", "VIP 고객을 생성하시겠습니까?",Exclamation!, OKCancel!, 2)
		if net = 1 then	
			IF parent.Trigger Event ue_keycheck('1') = FALSE THEN RETURN
			
			DECLARE sp_make_vip PROCEDURE FOR sp_make_vip  
						@yyyy     = :is_yyyy,   
						@yymmdd   = :is_yymmdd,   
						@empno    = :gs_user_id; 
			execute sp_make_vip;	

			if sqlca.sqlcode > 0 then
				commit    USING SQLCA;
				messagebox("확인", "VIP 고객생성 완료")
			else
				rollback  USING SQLCA;
				messagebox("확인", "VIP 고객생성중 에러가 발생했습니다..")
			end if
		end if
end choose


end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")


this.getchild("area_cd",idw_area_cd)
idw_area_cd.settransobject(sqlca)
idw_area_cd.retrieve('090')
idw_area_cd.insertrow(1)
idw_area_cd.setitem(1,"inter_cd","%")
idw_area_cd.setitem(1,"inter_nm","전체")

this.getchild("shop_grp",idw_shop_grp)
idw_shop_grp.settransobject(sqlca)
idw_shop_grp.retrieve('912')
idw_shop_grp.insertrow(1)
idw_shop_grp.setitem(1,"inter_cd","%")
idw_shop_grp.setitem(1,"inter_nm","전체")

end event

event dw_head::editchanged;call super::editchanged;this.setitem(1,"shop_nm","")
end event

type ln_1 from w_com010_e`ln_1 within w_75001_e
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_e`ln_2 within w_75001_e
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_e`dw_body within w_75001_e
integer y = 416
integer height = 1624
string dataobject = "d_75001_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

event dw_body::doubleclicked;call super::doubleclicked;string  ls_jumin
long    ll_rows


dw_member.Reset()
ls_jumin = this.getitemstring(row,"jumin")
ll_rows = dw_member.Retrieve(ls_jumin) 

if  ll_rows > 0 then
	dw_member.visible = true
end if



end event

type dw_print from w_com010_e`dw_print within w_75001_e
integer x = 23
integer y = 560
string dataobject = "d_75001_r01"
end type

type dw_member from datawindow within w_75001_e
boolean visible = false
integer x = 5
integer y = 300
integer width = 4500
integer height = 2000
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
end event

event doubleclicked;This.Visible = false 
end event

