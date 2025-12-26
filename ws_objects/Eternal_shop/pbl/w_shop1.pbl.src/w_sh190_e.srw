$PBExportHeader$w_sh190_e.srw
$PBExportComments$고객인도일 입력
forward
global type w_sh190_e from w_com010_e
end type
end forward

global type w_sh190_e from w_com010_e
integer height = 2008
string title = "고객인도일 등록"
long backcolor = 16777215
end type
global w_sh190_e w_sh190_e

type variables
DataWindowChild ldw_child
String is_fr_yymmdd, is_to_yymmdd, is_shop_cd
end variables

on w_sh190_e.create
call super::create
end on

on w_sh190_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Integer li_rc
string ls_fr_yymmdd


u_head_set lu_head_set

lu_head_set = create u_head_set

lu_head_set.uf_set(dw_head)

if IsValid (lu_head_set) then
   DESTROY lu_head_set
end if


// Allow for pre and post open events to occur
This.Event pfc_preopen()
This.Post Event pfc_postopen()


// Default window title is application title
If LenA (This.title) = 0 Then
	If IsValid (gnv_app.iapp_object) Then
		This.title = gnv_app.iapp_object.DisplayName
	End If
End If

// Allow preference service to restore settings if necessary
If IsValid(inv_preference) Then
	If gnv_app.of_IsRegistryAvailable() Then
		If LenA(gnv_app.of_GetUserKey())> 0 Then 
			li_rc = inv_preference.of_Restore( &
				gnv_app.of_GetUserKey()+'\'+this.ClassName()+'\Preferences')
		ElseIf IsValid(gnv_app.inv_debug) Then				
			of_MessageBox ("pfc_master_open_preferenceregistrydebug", &
				"PowerBuilder Foundation Class Library", "The PFC User Preferences service" +&
				" has been requested but The UserRegistrykey property has not" +&
				" been Set on The application manager Object.~r~n~r~n" + &
  				"Call of_SetRegistryUserKey on The Application Manager" +&
				" to Set The property.", &
				Exclamation!, OK!, 1)
		End If
	Else
		If LenA(gnv_app.of_GetUserIniFile()) > 0 Then
			li_rc = inv_preference.of_Restore (gnv_app.of_GetUserIniFile(), This.ClassName()+' Preferences')
		ElseIf IsValid(gnv_app.inv_debug) Then		
			of_MessageBox ("pfc_master_open_preferenceinidebug", &
				"PowerBuilder Class Library", "The PFC User Preferences service" +&
				" has been requested but The UserINIFile property has not" +&
				" been Set on The application manager Object.~r~n~r~n" + &
  				"Call of_SetUserIniFile on The Application Manager" +&
				" to Set The property.", &
				Exclamation!, OK!, 1)		
		End If
	End If
End If

// Allow MRU service to restore settings if necessary
If IsValid(gnv_app.inv_mru) Then
	this.event pfc_mrurestore()
End if





dw_head.setitem(1,"to_yymmdd",gsv_cd.gs_cd2)


select convert(varchar,dateadd(day,-15,:gsv_cd.gs_cd2),112)
into :ls_fr_yymmdd
from dual;



dw_head.setitem(1,"fr_yymmdd", ls_fr_yymmdd)


end event

event type boolean ue_keycheck(string as_cb_div);String   ls_title

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



is_shop_cd = gs_user_id



is_fr_yymmdd = Trim(dw_head.GetItemString(1, "fr_yymmdd"))
if IsNull(is_fr_yymmdd) or is_fr_yymmdd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if


is_to_yymmdd = Trim(dw_head.GetItemString(1, "to_yymmdd"))
if IsNull(is_to_yymmdd) or is_to_yymmdd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if




return true


end event

event ue_retrieve();IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN




il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd)



IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();Datetime ld_datetime
long i, ll_row_count

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
		if Trim(dw_body.GetItemString(i, "flag")) = 'Y' then
			if LenA(Trim(dw_body.GetItemString(i, "empty_4")))<> 8 then
				messagebox('확인','고객 인도일을 올바르게 입력하세요.')
				return 0
			else
				dw_body.Setitem(i, "mod_id", gs_user_id)
				dw_body.Setitem(i, "mod_dt", ld_datetime)
			end if
		end if
   END IF
NEXT



il_rows     = dw_body.Update(TRUE, FALSE)



if il_rows = 1  then
   dw_body.ResetUpdate()
   commit USING SQLCA;
	dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_shop_cd)
else
   rollback USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
//This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_head();IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

This.Trigger Event ue_button(5, 2)
//This.Trigger Event ue_msg(5, 2)

end event

type cb_close from w_com010_e`cb_close within w_sh190_e
end type

type cb_delete from w_com010_e`cb_delete within w_sh190_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_sh190_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh190_e
end type

type cb_update from w_com010_e`cb_update within w_sh190_e
end type

type cb_print from w_com010_e`cb_print within w_sh190_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_sh190_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_sh190_e
long backcolor = 16777215
end type

type dw_head from w_com010_e`dw_head within w_sh190_e
integer width = 2811
integer height = 112
string dataobject = "d_sh190_h01"
end type

type ln_1 from w_com010_e`ln_1 within w_sh190_e
integer beginy = 288
integer endy = 288
end type

type ln_2 from w_com010_e`ln_2 within w_sh190_e
integer beginy = 292
integer endy = 292
end type

type dw_body from w_com010_e`dw_body within w_sh190_e
integer y = 312
integer width = 2857
integer height = 1460
string dataobject = "d_sh190_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.GetChild("color", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("sale_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('011')

end event

event dw_body::clicked;call super::clicked;String ls_flag
int dd


this.AcceptText() 


CHOOSE CASE dwo.name
	CASE "flag"
		
		ls_flag = Trim(this.GetItemString(row, "flag"))
		
		if ls_flag = 'Y'then
			this.Setitem(row,"empty_4",'')
		else
			this.SetFocus()
			this.SetColumn(row)
			this.setitem(row,"empty_4",gsv_cd.gs_cd2)
		end if
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_sh190_e
integer x = 2382
integer y = 836
integer width = 1417
end type

