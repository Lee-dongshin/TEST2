$PBExportHeader$w_12032_d.srw
$PBExportComments$품평회 투표등록
forward
global type w_12032_d from w_com010_e
end type
end forward

global type w_12032_d from w_com010_e
integer width = 3680
integer height = 2352
end type
global w_12032_d w_12032_d

type variables
string is_brand, is_yymmdd, is_shop_cd, is_voter
datawindowchild idw_brand, idw_yymmdd

end variables

on w_12032_d.create
call super::create
end on

on w_12032_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_voter = dw_head.GetItemString(1, "voter")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_flag
decimal i
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_shop_cd, is_voter)
for i=0 to il_rows 
	ls_flag = dw_body.getitemstring(i,"flag")
	if ls_flag = "New" then
		 dw_body.SetItemStatus(i, 0, Primary!, New!)
	end if
next
dw_body.SetFocus()

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

type cb_close from w_com010_e`cb_close within w_12032_d
end type

type cb_delete from w_com010_e`cb_delete within w_12032_d
end type

type cb_insert from w_com010_e`cb_insert within w_12032_d
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_12032_d
end type

type cb_update from w_com010_e`cb_update within w_12032_d
end type

type cb_print from w_com010_e`cb_print within w_12032_d
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_12032_d
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_12032_d
end type

type cb_excel from w_com010_e`cb_excel within w_12032_d
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_12032_d
integer x = 32
integer y = 164
integer height = 260
string dataobject = "d_12032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("yymmdd", idw_yymmdd)
idw_yymmdd.SetTransObject(SQLCA)
idw_yymmdd.Retrieve(gs_brand)
	
end event

event dw_head::itemchanged;call super::itemchanged;string ls_shop

choose case dwo.name
	case "brand"
		This.GetChild("yymmdd", idw_yymmdd)
		idw_yymmdd.SetTransObject(SQLCA)
		idw_yymmdd.Retrieve(string(data))
		
	case "shop_cd"
		ls_shop=string(data)
		select person_nm 
			into :ls_shop
		from tb_93010_m (nolock)
		where person_id = :ls_shop
		and   user_grp  = '3'
		and   status_yn = 'Y';
		
		this.setitem(1,"shop_nm",ls_shop)
		
	case "voter"
		ls_shop=string(data)
		select person_nm 
			into :ls_shop
		from tb_93010_m (nolock)
		where person_id = :ls_shop
		and   user_grp  = '1'
		and   status_yn = 'Y';
		
		this.setitem(1,"voter_nm",ls_shop)			
	case "gubn"
		if string(data) = "1" then 
			this.setitem(1,"shop_cd","직원")
		end if
end choose 
end event

type ln_1 from w_com010_e`ln_1 within w_12032_d
integer beginy = 428
integer endy = 428
end type

type ln_2 from w_com010_e`ln_2 within w_12032_d
integer beginy = 432
integer endy = 432
end type

type dw_body from w_com010_e`dw_body within w_12032_d
integer y = 452
integer height = 1656
string dataobject = "d_12032_d01"
end type

type dw_print from w_com010_e`dw_print within w_12032_d
string dataobject = "d_12032_d01"
end type

