$PBExportHeader$w_61007_d.srw
$PBExportComments$판매율추이분석
forward
global type w_61007_d from w_com000
end type
type dw_head from u_dw within w_61007_d
end type
type ln_1 from line within w_61007_d
end type
type ln_2 from line within w_61007_d
end type
type dw_print from u_dw within w_61007_d
end type
type dw_body from u_dw within w_61007_d
end type
type dw_back1 from datawindow within w_61007_d
end type
type dw_back2 from datawindow within w_61007_d
end type
type dw_back5 from datawindow within w_61007_d
end type
type dw_back4 from datawindow within w_61007_d
end type
type dw_back3 from datawindow within w_61007_d
end type
end forward

global type w_61007_d from w_com000
boolean visible = false
integer width = 3680
integer height = 2272
string menuname = "m_1_0000"
boolean toolbarvisible = false
dw_head dw_head
ln_1 ln_1
ln_2 ln_2
dw_print dw_print
dw_body dw_body
dw_back1 dw_back1
dw_back2 dw_back2
dw_back5 dw_back5
dw_back4 dw_back4
dw_back3 dw_back3
end type
global w_61007_d w_61007_d

type prototypes

end prototypes

type variables
string is_brand, is_year, is_season, is_sojae, is_item, is_shop_cd, is_shop_div, is_pos_yn, is_shop_type
string is_style, is_chno, is_color, is_size, is_fr_yymmdd, is_to_yymmdd, is_opt_grp, is_opt_shop_style, is_opt_qty_amt, is_opt_detail
string is_obj_nm, is_obj_back, is_opt_chn
decimal is_back_no 


datawindowchild idw_shop_div, idw_shop_type, idw_brand, idw_sojae, idw_item, idw_season, idw_back

end variables

on w_61007_d.create
int iCurrent
call super::create
if this.MenuName = "m_1_0000" then this.MenuID = create m_1_0000
this.dw_head=create dw_head
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_print=create dw_print
this.dw_body=create dw_body
this.dw_back1=create dw_back1
this.dw_back2=create dw_back2
this.dw_back5=create dw_back5
this.dw_back4=create dw_back4
this.dw_back3=create dw_back3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.ln_1
this.Control[iCurrent+3]=this.ln_2
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_body
this.Control[iCurrent+6]=this.dw_back1
this.Control[iCurrent+7]=this.dw_back2
this.Control[iCurrent+8]=this.dw_back5
this.Control[iCurrent+9]=this.dw_back4
this.Control[iCurrent+10]=this.dw_back3
end on

on w_61007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_print)
destroy(this.dw_body)
destroy(this.dw_back1)
destroy(this.dw_back2)
destroy(this.dw_back5)
destroy(this.dw_back4)
destroy(this.dw_back3)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back2, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back3, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back4, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_back5, "ScaleToRight&Bottom")

inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_excel;call super::ue_excel;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_body.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_back_nm, ls_before
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


dw_body.dataobject = is_obj_nm
dw_body.SetTransObject(SQLCA)

			
il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, is_shop_cd, is_shop_div, is_pos_yn, is_shop_type, is_style, is_chno, is_color, is_size, is_fr_yymmdd, is_to_yymmdd, is_opt_grp, is_opt_chn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

dw_head.setitem(1,"grp","")
///////////////////////////////////////////////////

///////////////////////////////////////////////////
if dw_body.rowcount() > 0 then
		 
	if isnull(is_back_no) then is_back_no = 0
	is_back_no = is_back_no + 1
	if is_back_no > 5 then is_back_no = 0

	
	if idw_back.rowcount() = 6 then	idw_back.deleterow(6)
	idw_back.insertrow(1)
	idw_back.setitem(1,"inter_cd",string(is_back_no,"#")+ upper(is_obj_nm))
	idw_back.setrow(1)
	
	
	if is_back_no = 1 then
		dw_back1.dataobject = dw_body.dataobject
		dw_back1.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back1,1,Primary!)

	elseif is_back_no = 2 then
		dw_back2.dataobject = dw_body.dataobject
		dw_back2.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back2,1,Primary!)

	elseif is_back_no = 3 then
		dw_back3.dataobject = dw_body.dataobject
		dw_back3.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back3,1,Primary!)

	elseif is_back_no = 4  then
		dw_back4.dataobject = dw_body.dataobject
		dw_back4.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back4,1,Primary!)

	elseif is_back_no = 5 then
		dw_back5.dataobject = dw_body.dataobject
		dw_back5.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back5,1,Primary!)

	elseif is_back_no = 0 then
		dw_back1.dataobject = dw_body.dataobject
		dw_back1.SetTransObject(SQLCA)	
		dw_body.rowscopy(1,dw_body.rowcount(),Primary!,dw_back1,1,Primary!)
	end if
end if

end event

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

is_brand 			= dw_head.GetItemString(1, "brand")
is_year 				= dw_head.GetItemString(1, "year")
is_season 			= dw_head.GetItemString(1, "season")
is_sojae 			= dw_head.GetItemString(1, "sojae")
is_item 				= dw_head.GetItemString(1, "item")

is_shop_cd 			= dw_head.GetItemString(1, "shop_cd")
is_shop_div 		= dw_head.GetItemString(1, "shop_div")
is_pos_yn 			= dw_head.GetItemString(1, "pos_yn")
is_shop_type 		= dw_head.GetItemString(1, "shop_type")

is_style 			= dw_head.GetItemString(1, "style")
is_chno 				= dw_head.GetItemString(1, "chno")
is_color 			= dw_head.GetItemString(1, "color")
is_size 				= dw_head.GetItemString(1, "size")

is_fr_yymmdd      = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd      = dw_head.GetItemString(1, "to_yymmdd")
is_opt_shop_style = dw_head.GetItemString(1, "opt_shop_style")
is_opt_qty_amt    = dw_head.GetItemString(1, "opt_qty_amt")

is_opt_detail 		= dw_head.GetItemString(1, "opt_detail")
is_opt_grp    		= dw_head.GetItemString(1, "grp")
is_opt_chn    		= dw_head.GetItemString(1, "opt_chn")

if isnull(is_opt_grp) or LenA(is_opt_grp) = 0 then
	if is_opt_shop_style = "0" then
		if isnull(is_shop_cd) or is_shop_cd = "%" or  LenA(is_shop_cd) <> 6 then		
	
			if isnull(is_style) or is_style = "%" or LenA(is_style) <> 8 then 
				is_opt_grp = "it"
			
			elseif isnull(is_size) or is_size = "%" or LenA(is_size) <> 2 then
				is_opt_grp = "st"
						
			else
				is_opt_grp = "sz"
							
			end if	
							
		else
			if isnull(is_item) or is_item = "%" or LenA(is_item) <> 1 then
				is_opt_grp = "it"
			else
				is_opt_grp = "st"
				if isnull(is_style) or is_style = "%" or LenA(is_style) <> 8 then	is_opt_grp = "sz"
			end if		
		end if
	else 
		if LenA(is_style) = 8 then
			is_opt_grp = "sz"
		elseif isnull(is_item) or is_item  = "%" or LenA(is_item) <> 1 then
			is_opt_grp = "it"
		else
			is_opt_grp = "st"
		end if		
	
	end if
end if


is_obj_back = is_obj_nm
is_obj_nm = "d_61007_"

if is_opt_shop_style = "0" then

	is_obj_nm = is_obj_nm + "shop_"
else
	is_obj_nm = is_obj_nm + "style_"
	
end if

is_obj_nm = is_obj_nm + is_opt_grp

if is_opt_shop_style = "0" then
	if is_opt_qty_amt = "0" then
		is_obj_nm = is_obj_nm + "_qty" 
	else
		is_obj_nm = is_obj_nm + "_amt" 
	end if
	
	if is_opt_detail = "0" then	is_obj_nm = is_obj_nm + "_press"
else
	if is_opt_detail = "0" then
		is_obj_nm = is_obj_nm + "_press" 
	else
		is_obj_nm = is_obj_nm + "_qty" 
	end if	

end if

//messagebox("is_obj_nm",is_obj_nm)
return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm ,ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			ls_brand = dw_head.getitemstring(1,"brand")
			
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0  then
					return 0
				elseIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + ls_brand + "' and Shop_Stat = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '%" + as_data + "%' or shop_nm like '%" + as_data + "%')"
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

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.01.01                                                  */	
///* 수정일      : 2001.01.01                                                  */
///*===========================================================================*/
///* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
///*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
///*===========================================================================*/
//
//CHOOSE CASE ai_cb_div
//   CASE 1		/* 조회 */
//      if al_rows > 0 then
//         cb_print.enabled = true
//         cb_preview.enabled = true
//         cb_excel.enabled = true
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
//         dw_body.Enabled = true
//         dw_body.SetFocus()
//      else
//         cb_print.enabled = false
//         cb_preview.enabled = false
//         cb_excel.enabled = false
//      end if
//
//      if al_rows >= 0 then
//         ib_changed = false
//         cb_update.enabled = false
//      end if
//		
//   CASE 5    /* 조건 */
//      cb_retrieve.Text = "조회(&Q)"
//      cb_print.enabled = false
//      cb_preview.enabled = false
//      cb_excel.enabled = false
//      ib_changed = false
//      dw_body.Enabled = false
//      dw_head.Enabled = true
//      dw_head.SetFocus()
//      dw_head.SetColumn(1)
//	
//END CHOOSE
//
end event

event ue_msg;call super::ue_msg;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/* ai_cb_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 삭제  */
/* al_rows     : 리턴값                                                      */
/*===========================================================================*/

String ls_msg

CHOOSE CASE ai_cb_div
   CASE 1      /* 조회 */
      CHOOSE CASE al_rows
         CASE IS > 0
            ls_msg = "조회가 완료되었습니다."
         CASE 0
            ls_msg = "조회 할 자료가 없습니다."
         CASE IS < 0
            ls_msg = "조회가 실패하였습니다."
      END CHOOSE
   CASE 5      /* 조건 */
      ls_msg = "조회할 자료를 입력하세요."
   CASE 6      /* 인쇄 */
		IF al_rows = 1 THEN
         ls_msg = "인쇄가 되었습니다."
      ELSE
         ls_msg = "인쇄가 실패하였습니다."
      END IF
END CHOOSE

This.ParentWindow().SetMicroHelp(ls_msg)

end event

event ue_preview();call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
dw_print.dataobject = dw_body.dataobject
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event closequery;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   IF This.Windowstate = Minimized! THEN
	   This.Windowstate = Normal!
   END IF
   This.SetFocus()

   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   Message.ReturnValue = 1
			   return
		   END IF		
	   CASE 3
		   Message.ReturnValue = 1
		   return
   END CHOOSE
END IF

end event

event ue_head;call super::ue_head;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
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
This.Trigger Event ue_msg(5, 2)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.12.27																  */	
/* 수정일      : 2001.12.27																  */
/* 설  명      : head 기본값 처리                                            */
/*===========================================================================*/
datetime id_datetime
u_head_set lu_head_set

lu_head_set = create u_head_set

lu_head_set.uf_set(dw_head)

if IsValid (lu_head_set) then
   DESTROY lu_head_set
end if


IF gf_cdate(id_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(id_datetime,"yyyymmdd"))

end if
end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

//datetime ld_datetime
//string ls_modify, ls_datetime
//
//IF gf_sysdate(ld_datetime) = FALSE THEN
//   ld_datetime = DateTime(Today(), Now())
//END IF
//
//ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
//
//ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
//             "t_user_id.Text = '" + gs_user_id + "'" + &
//             "t_datetime.Text = '" + ls_datetime + "'"
//
//dw_print.Modify(ls_modify)
//

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_61007_d","0")
end event

type cb_close from w_com000`cb_close within w_61007_d
integer taborder = 100
end type

type cb_delete from w_com000`cb_delete within w_61007_d
boolean visible = false
integer x = 1083
integer taborder = 50
end type

type cb_insert from w_com000`cb_insert within w_61007_d
boolean visible = false
integer x = 741
integer taborder = 40
end type

type cb_retrieve from w_com000`cb_retrieve within w_61007_d
integer taborder = 20
end type

event cb_retrieve::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

//This.Enabled = False
oldpointer = SetPointer(HourGlass!)

//IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
//ELSE
//	Parent.Trigger Event ue_head()	//조건
//END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com000`cb_update within w_61007_d
boolean visible = false
integer taborder = 90
end type

type cb_print from w_com000`cb_print within w_61007_d
integer x = 1426
integer taborder = 60
boolean enabled = true
end type

type cb_preview from w_com000`cb_preview within w_61007_d
integer x = 1769
integer taborder = 70
boolean enabled = true
end type

type gb_button from w_com000`gb_button within w_61007_d
integer taborder = 0
end type

type cb_excel from w_com000`cb_excel within w_61007_d
integer x = 2112
boolean enabled = true
end type

type dw_head from u_dw within w_61007_d
event ue_keydown pbm_dwnkey
integer x = 37
integer y = 172
integer width = 3520
integer height = 360
integer taborder = 10
string dataobject = "d_61007_h01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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
		return 1
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
		IF ls_report = "1" THEN RETURN  0
	   ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
	   IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
			   					String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report ,ls_back_nm
long i

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)







end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_back_nm
DECIMAL I
is_opt_shop_style = this.getitemstring(1,"opt_shop_style")
is_shop_cd  = this.getitemstring(1,"shop_cd")
is_chno  = this.getitemstring(1,"chno")

CHOOSE CASE dwo.name
	CASE "style"
		this.setitem(1,"brand",MidA(data,1,1))
		this.setitem(1,"sojae",MidA(data,2,1))
		this.setitem(1,"season",MidA(data,4,1))
		this.setitem(1,"item",MidA(data,5,1))


	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	

	case "dw_back"

			ls_back_nm = MidA(data,2)
			dw_body.dataobject = ls_back_nm
			dw_body.SetTransObject(SQLCA)

			
			if LeftA(data,1) = "1" then	
				dw_back1.rowscopy(1,dw_back1.rowcount(),Primary!,dw_body,1,Primary!)
		
			elseif LeftA(data,1) = "2" then	
				dw_back2.rowscopy(1,dw_back2.rowcount(),Primary!,dw_body,1,Primary!)
		
			elseif LeftA(data,1) = "3" then	
				dw_back3.rowscopy(1,dw_back3.rowcount(),Primary!,dw_body,1,Primary!)
		
			elseif LeftA(data,1) = "4"  then
				dw_back4.rowscopy(1,dw_back4.rowcount(),Primary!,dw_body,1,Primary!)
		
			elseif LeftA(data,1) = "5" then	
				dw_back5.rowscopy(1,dw_back5.rowcount(),Primary!,dw_body,1,Primary!)
		
			elseif LeftA(data,1) = "0" then
				dw_back1.rowscopy(1,dw_back1.rowcount(),Primary!,dw_body,1,Primary!)
			end if
			
	case "opt_shop_style"
			if data = '1' then
				this.setitem(1,"opt_qty_amt", "0")
			end if
END CHOOSE

end event

event rbuttonup;//
end event

event constructor;call super::constructor;This.GetChild("dw_back", idw_back)
idw_back.SetTransObject(SQLCA) 
idw_back.Retrieve('xxx')
//idw_back.insertrow(1)
//idw_back.setitem(1,"inter_cd","0")
//idw_back.setitem(1,"inter_nm","MAIN BODY")
//idw_back.scrolltorow(1)



This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.Retrieve('001')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA) 
idw_shop_div.Retrieve('910')
idw_shop_div.insertrow(1)
idw_shop_div.setitem(1,"inter_cd","%")
idw_shop_div.setitem(1,"inter_nm","전체")

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA) 
idw_shop_type.Retrieve('911')
idw_shop_type.insertrow(1)
idw_shop_type.setitem(1,"inter_cd","%")
idw_shop_type.setitem(1,"inter_nm","전체")


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA) 
idw_season.Retrieve('003')
//idw_season.insertrow(1)
//idw_season.setitem(1,"inter_cd","%")
//idw_season.setitem(1,"inter_nm","전체")

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA) 
idw_item.Retrieve('%')
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA) 
idw_sojae.Retrieve('111')
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"inter_cd","%")
idw_sojae.setitem(1,"inter_nm","전체")

end event

event editchanged;call super::editchanged;choose case dwo.name
	case "cust_cd"
		if LenA(data) = 1 then this.setitem(1,"brand",data)
	case "style"
		if LenA(data) = 1 then this.setitem(1,"brand",data)
		if LenA(data) = 2 then this.setitem(1,"sojae",MidA(data,2,1))
		if LenA(data) = 4 then this.setitem(1,"season",MidA(data,4,1))
		if LenA(data) = 5 then this.setitem(1,"item",MidA(data,5,1))
end choose
end event

type ln_1 from line within w_61007_d
integer linethickness = 4
integer beginy = 540
integer endx = 3621
integer endy = 540
end type

type ln_2 from line within w_61007_d
long linecolor = 16777215
integer linethickness = 4
integer beginy = 544
integer endx = 3621
integer endy = 544
end type

type dw_print from u_dw within w_61007_d
boolean visible = false
integer x = 55
integer y = 676
integer width = 1006
integer taborder = 0
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

type dw_body from u_dw within w_61007_d
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 30
string dataobject = "d_61007_style_it_press"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

event constructor;call super::constructor;/*===========================================================================*/
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

/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event itemerror;return 1
end event

event rbuttonup;//
end event

event doubleclicked;call super::doubleclicked;string ls_shop_div
if row = 0 then return 0

//This.SelectRow(0, FALSE)
//This.SelectRow(row, TRUE)

is_brand 			= this.GetItemString(row, "brand")
is_year 				= this.GetItemString(row, "year")
is_season 			= this.GetItemString(row, "season")
is_sojae 			= this.GetItemString(row, "sojae")
is_item 				= this.GetItemString(row, "item")

ls_shop_div		   = this.GetItemString(row, "shop_div")
is_shop_cd		   = is_brand + ls_shop_div + this.GetItemString(row, "shop_cd")
is_style 			= this.GetItemString(row, "style")
is_chno 				= this.GetItemString(row, "chno")
is_color 			= this.GetItemString(row, "color")
is_size 				= this.GetItemString(row, "size")

if not isnull(is_size) and LenA(is_size) <> 0 then  
	if is_opt_shop_style = "0" then
		dw_head.setitem(1,"opt_shop_style","1")
	else 
		dw_head.setitem(1,"opt_shop_style","0")		
	end if
end if	

dw_head.setitem(1,"brand",is_brand)
dw_head.setitem(1,"year",is_year)
dw_head.setitem(1,"season",is_season)
dw_head.setitem(1,"sojae",is_sojae)
dw_head.setitem(1,"item",is_item)
dw_head.setitem(1,"style",is_style)
dw_head.setitem(1,"chno",is_chno)
dw_head.setitem(1,"color",is_color)
dw_head.setitem(1,"size",is_size)

dw_head.setitem(1,"shop_cd",is_shop_cd)



/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

oldpointer = SetPointer(HourGlass!)
Parent.post Event ue_retrieve()	//조회
SetPointer(oldpointer)


end event

event clicked;call super::clicked;if row > 0 then
	This.SelectRow(0, false)
	This.SelectRow(row, TRUE)
end if
end event

type dw_back1 from datawindow within w_61007_d
boolean visible = false
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 40
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_back2 from datawindow within w_61007_d
boolean visible = false
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 50
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_back5 from datawindow within w_61007_d
boolean visible = false
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 50
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_back4 from datawindow within w_61007_d
boolean visible = false
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 40
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_back3 from datawindow within w_61007_d
boolean visible = false
integer x = 9
integer y = 556
integer width = 3589
integer height = 1480
integer taborder = 40
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

