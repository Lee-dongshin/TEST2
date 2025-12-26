$PBExportHeader$w_32017_d.srw
$PBExportComments$중국생산대비 임가공현황
forward
global type w_32017_d from w_com000
end type
type dw_head from u_dw within w_32017_d
end type
type ln_1 from line within w_32017_d
end type
type ln_2 from line within w_32017_d
end type
type dw_list from u_dw within w_32017_d
end type
type dw_body from u_dw within w_32017_d
end type
type st_1 from u_st within w_32017_d
end type
type dw_print from u_dw within w_32017_d
end type
type rb_sojae from radiobutton within w_32017_d
end type
type rb_item from radiobutton within w_32017_d
end type
type rb_cust_cd from radiobutton within w_32017_d
end type
type dw_1 from datawindow within w_32017_d
end type
type gb_1 from groupbox within w_32017_d
end type
end forward

global type w_32017_d from w_com000
integer width = 3675
integer height = 2272
string menuname = "m_1_0000"
boolean toolbarvisible = false
dw_head dw_head
ln_1 ln_1
ln_2 ln_2
dw_list dw_list
dw_body dw_body
st_1 st_1
dw_print dw_print
rb_sojae rb_sojae
rb_item rb_item
rb_cust_cd rb_cust_cd
dw_1 dw_1
gb_1 gb_1
end type
global w_32017_d w_32017_d

type variables
long         il_HiddenColor
dragobject   idrg_vertical[2]

boolean      ib_debug=False
integer      ii_barthickness = 20
w_com020_d   iw_window



string is_brand, is_year, is_season, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd
string is_brand_key, is_year_key, is_season_key
datawindowchild idw_brand, idw_season, idw_item, idw_make_type, idw_country_cd
end variables

forward prototypes
public function integer wf_refreshbars ()
public function integer wf_resizepanels ()
end prototypes

public function integer wf_refreshbars ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
st_1.setposition(ToTop!)

st_1.width = 20

return 1
end function

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

idrg_Vertical[1].Resize (st_1.X - idrg_Vertical[1].X, idrg_Vertical[1].Height)

idrg_Vertical[2].Move (st_1.X + ii_BarThickness, idrg_Vertical[2].Y)
idrg_Vertical[2].Resize (ll_Width, idrg_Vertical[2].Height)

Return 1


end function

on w_32017_d.create
int iCurrent
call super::create
if this.MenuName = "m_1_0000" then this.MenuID = create m_1_0000
this.dw_head=create dw_head
this.ln_1=create ln_1
this.ln_2=create ln_2
this.dw_list=create dw_list
this.dw_body=create dw_body
this.st_1=create st_1
this.dw_print=create dw_print
this.rb_sojae=create rb_sojae
this.rb_item=create rb_item
this.rb_cust_cd=create rb_cust_cd
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_head
this.Control[iCurrent+2]=this.ln_1
this.Control[iCurrent+3]=this.ln_2
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_body
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.rb_sojae
this.Control[iCurrent+9]=this.rb_item
this.Control[iCurrent+10]=this.rb_cust_cd
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.gb_1
end on

on w_32017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_head)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.dw_list)
destroy(this.dw_body)
destroy(this.st_1)
destroy(this.dw_print)
destroy(this.rb_sojae)
destroy(this.rb_item)
destroy(this.rb_cust_cd)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
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

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item = dw_head.GetItemString(1, "item")
is_make_type = dw_head.GetItemString(1, "make_type")
is_country_cd = dw_head.GetItemString(1, "country_cd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_mat_cd = dw_head.GetItemString(1, "mat_cd")


return true

end event

event ue_msg;call super::ue_msg;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
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
   CASE 2      /* 추가 */
      IF al_rows > 0 THEN
         ls_msg = "자료를 입력하십시요."
      ELSE
         ls_msg = "자료 입력이 실패했습니다."
      END IF
   CASE 3      /* 저장 */
      IF al_rows = 1 THEN
         ls_msg = "자료가 저장되었습니다."
      ELSE
         ls_msg = "자료 저장이 실패하였습니다."
      END IF
   CASE 4      /* 삭제 */
      IF al_rows > 0 THEN
         ls_msg = "자료가 삭제되었습니다."
      ELSE
         ls_msg = "자료 삭제가 실패하였습니다."
      END IF
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.07                                                  */	
/* 수정일      : 2001.12.07                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_part_nm)
							RETURN 0
						END IF
				End Choose
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
			Choose Case is_brand
				Case 'J'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'Y'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_type")
				ib_itemchanged = False
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	case "mat_cd"
		IF ai_div = 1 THEN 				
			if isnull(as_data) or as_data = "" then
				return 0					
			END IF 
		END IF

		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "원자재코드 검색" 
		gst_cd.datawindow_nm   = "d_com020" 
		gst_cd.default_where   = " where brand = '" + is_brand + "'"
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " mat_cd like '" + as_data + "%'"
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
			dw_head.SetItem(1, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
			dw_head.SetItem(1, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))

			/* 다음컬럼으로 이동 */
//				dw_head.post event ue_addnew(as_data,al_row)
//				dw_head.SetColumn("color")					
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

event ue_preview();call super::ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//dw_body.ShareData(dw_print)
dw_print.retrieve(is_brand_key, is_year_key, is_season_key, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)

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

event ue_button;call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
END CHOOSE

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.12.27																  */	
/* 수정일      : 2001.12.27																  */
/* 설  명      : head 기본값 처리                                            */
/*===========================================================================*/
u_head_set lu_head_set

lu_head_set = create u_head_set

lu_head_set.uf_set(dw_head)

if IsValid (lu_head_set) then
   DESTROY lu_head_set
end if

dw_head.setitem(1,"season","%")

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
             "t_datetime.Text = '" + ls_datetime + "'"
				 
dw_print.object.t_brand.text = idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")				 

dw_print.object.t_year.text = dw_head.getitemstring(1,"year")				 
dw_print.object.t_season.text = is_season_key				 

dw_print.object.t_item.text = idw_item.getitemstring(idw_item.getrow(),"item_nm")
dw_print.object.t_make_type.text = idw_make_type.getitemstring(idw_make_type.getrow(),"inter_nm")				 
dw_print.object.t_country_cd.text = idw_country_cd.getitemstring(idw_country_cd.getrow(),"inter_nm")			 
dw_print.object.t_cust_cd.text = dw_head.getitemstring(1,"cust_cd")			 
dw_print.object.t_mat_cd.text = is_mat_cd




dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32017_d","0")
end event

type cb_close from w_com000`cb_close within w_32017_d
integer taborder = 110
end type

type cb_delete from w_com000`cb_delete within w_32017_d
boolean visible = false
integer x = 1079
integer taborder = 60
end type

type cb_insert from w_com000`cb_insert within w_32017_d
boolean visible = false
integer x = 736
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com000`cb_retrieve within w_32017_d
integer taborder = 20
end type

event cb_retrieve::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type cb_update from w_com000`cb_update within w_32017_d
boolean visible = false
integer taborder = 100
end type

type cb_print from w_com000`cb_print within w_32017_d
integer x = 1422
integer taborder = 70
end type

type cb_preview from w_com000`cb_preview within w_32017_d
integer x = 1765
integer taborder = 80
boolean enabled = true
end type

type gb_button from w_com000`gb_button within w_32017_d
integer taborder = 0
end type

type cb_excel from w_com000`cb_excel within w_32017_d
integer x = 2107
integer taborder = 90
end type

type dw_head from u_dw within w_32017_d
event ue_keydown pbm_dwnkey
integer x = 27
integer y = 168
integer width = 3552
integer height = 224
integer taborder = 10
string dataobject = "d_32013_h01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "cust_cd", "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")

			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		

		
END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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

event rbuttonup;//
end event

event constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from line within w_32017_d
integer linethickness = 4
integer beginy = 400
integer endx = 3639
integer endy = 400
end type

type ln_2 from line within w_32017_d
long linecolor = 16777215
integer linethickness = 4
integer beginy = 404
integer endx = 3639
integer endy = 404
end type

type dw_list from u_dw within w_32017_d
integer x = 27
integer y = 416
integer width = 3561
integer height = 672
integer taborder = 30
string dataobject = "d_32017_l01"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_brand_key  = is_brand
is_year_key	  = this.getitemstring(row,"year")
is_season_key = this.getitemstring(row,"season")

IF IsNull(is_brand_key) or IsNull(is_year_key) or IsNull(is_season_key) THEN return
il_rows = dw_body.retrieve(is_brand_key, is_year_key, is_season_key, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

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

event rbuttonup;//
end event

event itemerror;call super::itemerror;return 1
end event

type dw_body from u_dw within w_32017_d
integer x = 434
integer y = 1100
integer width = 3154
integer height = 932
integer taborder = 40
string dataobject = "d_32017_d01"
end type

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

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
/* 작성자      : 지우정보                                                    */	
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

event itemerror;call super::itemerror;return 1
end event

event rbuttonup;//
end event

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_sojae, ls_item, ls_cust_cd, ls_country_cd
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_sojae   = LeftA(this.getitemstring(row,"sojae"),1)
if rb_item.checked then
	ls_item	  = LeftA(this.getitemstring(row,"sojae"),1)
else
	ls_item	  = LeftA(this.getitemstring(row,"item"),1)	
end if
ls_cust_cd = LeftA(this.getitemstring(row,"cust_nm"),6)
ls_country_cd  = LeftA(this.getitemstring(row,"country_cd"),2)

IF IsNull(is_brand_key) or IsNull(is_year_key) or IsNull(is_season_key) THEN return
il_rows = dw_1.retrieve(is_brand_key, is_year_key, is_season_key, ls_sojae, ls_item, ls_cust_cd, is_make_type, ls_country_cd, is_mat_cd)
if il_rows > 0 then dw_1.visible = true

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type st_1 from u_st within w_32017_d
event ue_mousemove pbm_mousemove
event ue_mousedown pbm_lbuttondown
event ue_mouseup pbm_lbuttonup
boolean visible = false
integer x = 1957
integer y = 1084
integer width = 18
integer height = 960
string dragicon = "Exclamation!"
string pointer = "SizeWE!"
long backcolor = 8388608
boolean enabled = true
string text = ""
long bordercolor = 79741120
end type

event ue_mousemove;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/

IF KeyDown(keyLeftButton!) Then
   wf_refreshbars()
   This.x = Parent.PointerX()
End If

end event

event ue_mousedown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// mouse click시 text bar의 색상을 black 처리
If Not ib_debug Then this.BackColor = 0
end event

event ue_mouseup;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/

If Not ib_debug Then This.BackColor = il_hiddencolor

// 화면에 벗어 났을 경우 처리 
IF This.x < idrg_vertical[1].x + 50 THEN
   This.x = idrg_vertical[1].x + 50		
ELSEIF This.x > idrg_vertical[2].width + idrg_vertical[2].x - 50 THEN
	This.x = idrg_vertical[2].width + idrg_vertical[2].x - 50
END IF

// Data Window 크기 변경
wf_ResizePanels()

end event

type dw_print from u_dw within w_32017_d
boolean visible = false
integer x = 27
integer y = 348
integer width = 1074
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_32017_r00"
boolean hscrollbar = true
end type

event constructor;call super::constructor;This.of_SetPrintPreview(TRUE)
end event

type rb_sojae from radiobutton within w_32017_d
integer x = 41
integer y = 1216
integer width = 334
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
string text = "소재별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if dw_body.dataobject <> "d_32017_d01" then
	dw_body.dataobject = "d_32017_d01"
	dw_body.SetTransObject(SQLCA)
	dw_body.retrieve(is_brand_key, is_year_key, is_season_key, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)

	dw_print.object.dw_2.dataobject = "d_32017_r01"
	dw_print.SetTransObject(SQLCA)
	
end if

end event

type rb_item from radiobutton within w_32017_d
integer x = 41
integer y = 1340
integer width = 334
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

event clicked;if dw_body.dataobject <> "d_32017_d02" then
	dw_body.dataobject = "d_32017_d02"
	dw_body.SetTransObject(SQLCA)
	dw_body.retrieve(is_brand_key, is_year_key, is_season_key, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)
	
	dw_print.object.dw_2.dataobject = "d_32017_r02"
	dw_print.SetTransObject(SQLCA)
	
end if

end event

type rb_cust_cd from radiobutton within w_32017_d
integer x = 41
integer y = 1468
integer width = 334
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
string text = "시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;if dw_body.dataobject <> "d_32017_d03" then
	dw_body.dataobject = "d_32017_d03"
	dw_body.SetTransObject(SQLCA)
	dw_body.retrieve(is_brand_key, is_year_key, is_season_key, is_item, is_make_type, is_country_cd, is_cust_cd, is_mat_cd)
	
	dw_print.object.dw_2.dataobject = "d_32017_r03"
	dw_print.SetTransObject(SQLCA)	
end if

end event

type dw_1 from datawindow within w_32017_d
boolean visible = false
integer x = 402
integer y = 1232
integer width = 2706
integer height = 1272
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "스타일별 리스트"
string dataobject = "d_32013_d04"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/

String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')			
	end choose	
end if
end event

event constructor;

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

type gb_1 from groupbox within w_32017_d
integer x = 9
integer y = 1100
integer width = 407
integer height = 508
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "구분"
borderstyle borderstyle = stylelowered!
end type

