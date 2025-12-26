$PBExportHeader$w_55012_d.srw
$PBExportComments$매장 월별 판매누계
forward
global type w_55012_d from w_com010_d
end type
type st_1 from statictext within w_55012_d
end type
end forward

global type w_55012_d from w_com010_d
integer width = 3689
integer height = 2280
st_1 st_1
end type
global w_55012_d w_55012_d

type variables
DataWindowChild idw_brand

String is_brand, is_yyyy, is_gubn, is_person_id, is_dotcom

end variables

on w_55012_d.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_55012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_brand, is_gubn, is_person_id, is_dotcom)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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





is_yyyy = Trim(String(dw_head.GetItemDateTime(1, "yyyy"), 'yyyy'))
IF IsNull(is_yyyy) OR is_yyyy = "" THEN
   MessageBox(ls_title,"기준 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   RETURN FALSE
END IF

is_gubn = Trim(dw_head.GetItemString(1, "gubn"))

is_person_id = dw_head.getitemstring(1, "person_id")
IF IsNull(is_person_id) OR is_person_id = "" THEN
	is_person_id = "%"
END IF

is_dotcom = dw_head.getitemstring(1, "dotcom")




RETURN TRUE

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.02.18                                                  */
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
				"t_user_id.Text   = '" + gs_user_id   + "'" + &
				"t_datetime.Text  = '" + ls_datetime  + "'" + &
				"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_yyyy.Text      = '" + is_yyyy      + "'"
				
dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55012_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55012_d
end type

type cb_delete from w_com010_d`cb_delete within w_55012_d
end type

type cb_insert from w_com010_d`cb_insert within w_55012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55012_d
end type

type cb_update from w_com010_d`cb_update within w_55012_d
end type

type cb_print from w_com010_d`cb_print within w_55012_d
end type

type cb_preview from w_com010_d`cb_preview within w_55012_d
end type

type gb_button from w_com010_d`gb_button within w_55012_d
end type

type cb_excel from w_com010_d`cb_excel within w_55012_d
end type

type dw_head from w_com010_d`dw_head within w_55012_d
integer width = 3328
integer height = 168
string dataobject = "d_55012_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("person_id", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_brand)
ldw_child.InsertRow(0)

end event

event dw_head::itemchanged;call super::itemchanged;DataWindowChild ldw_child 

CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"person_id","")
		This.GetChild("person_id", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.InsertRow(0)
	CASE "emp_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55012_d
integer beginx = 5
integer beginy = 352
integer endx = 3625
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_55012_d
integer beginx = 5
integer beginy = 356
integer endx = 3625
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_55012_d
integer x = 9
integer y = 372
integer width = 3593
integer height = 1672
string dataobject = "d_55012_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55012_d
string dataobject = "d_55012_r01"
end type

type st_1 from statictext within w_55012_d
integer x = 32
integer y = 64
integer width = 480
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "(금액단위 : 천원)"
boolean focusrectangle = false
end type

