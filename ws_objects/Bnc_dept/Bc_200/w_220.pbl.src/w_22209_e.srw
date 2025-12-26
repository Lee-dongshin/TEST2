$PBExportHeader$w_22209_e.srw
$PBExportComments$원자재 출고요청 등록
forward
global type w_22209_e from w_com010_e
end type
type dw_list from u_dw within w_22209_e
end type
type dw_out_sheet from u_dw within w_22209_e
end type
end forward

global type w_22209_e from w_com010_e
event type long up_update_list ( )
dw_list dw_list
dw_out_sheet dw_out_sheet
end type
global w_22209_e w_22209_e

type variables
string is_brand, is_req_ymd, is_cust_cd, is_req_dept, is_person_id

datawindowchild idw_brand, idw_color

end variables

on w_22209_e.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_out_sheet=create dw_out_sheet
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_out_sheet
end on

on w_22209_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_out_sheet)
end on

event close;call super::close;gf_user_connect_pgm(gs_user_id,"w_22209_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_saup_gubn
Boolean    lb_check 
DataStore  lds_Source

ls_saup_gubn = dw_head.getitemstring(1,"brand")
if ls_saup_gubn = "N" then
	ls_saup_gubn = "01"
elseif ls_saup_gubn = "O" then
	ls_saup_gubn = "02"
end if

CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "업체 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw1" 
			gst_cd.default_where   = "WHERE cust_code between '4999' and '8999' " + &
												"and   brand in ('n','o') " + &
												"and   change_gubn = '00' " + &
												"and   custcode like '_0%' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
//				gst_cd.Item_where = "custcode LIKE '" + as_data + "%'" // or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "req_dept"				
			IF ai_div = 1 THEN 	
				IF gf_dept_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "req_dept_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부서 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw2" 
			gst_cd.default_where   = "WHERE saup_gubn like '" + ls_saup_gubn + "%'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(dept_code LIKE '" + as_data + "%' or dbo.sf_dept_nm(dept_code) like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "req_dept", lds_Source.GetItemString(1,"dept_code"))
				dw_head.SetItem(al_row, "req_dept_nm", lds_Source.GetItemString(1,"dept_nm"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source	
			
	CASE "person_id"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "person_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com931" 
			gst_cd.default_where   = "WHERE 	where status_yn = 'y' " + &
											"and   (dept_nm like '%디자인%' " + &
											"or    dept_nm like '%개발%' " + &
											"or    dept_nm like '%생산%') "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(person_id LIKE '" + as_data + "%' or person_nm like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "person_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("end_ymd")
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

event open;call super::open;datetime ld_datetime
string ls_person_id, ls_person_nm, ls_req_detp, ls_req_dept_nm

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"req_ymd",string(ld_datetime,"yyyymmdd"))

end if

SELECT dbo.SF_DEPT_NM(:gs_dept_cd)
	into :ls_req_dept_nm
  FROM DUAL;
  
  
dw_head.setitem(1,'person_id',gs_user_id)
dw_head.setitem(1,'person_nm',gs_user_nm)
dw_head.setitem(1,'req_dept',gs_dept_cd)
dw_head.setitem(1,'req_dept_nm',ls_req_dept_nm)

dw_head.setitem(1,'brand','%')
il_rows = dw_list.retrieve('%', string(ld_datetime,"yyyymmdd"), '%', '%', '%', '2')
end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

inv_resize.of_Register(dw_out_sheet, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_out_sheet.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)




end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.retrieve(is_brand, is_req_ymd, 0, is_cust_cd, is_req_dept, is_person_id, 'N')
	
/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */


This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

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



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_req_ymd = dw_head.GetItemString(1, "req_ymd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
is_req_dept = dw_head.GetItemString(1, "req_dept")
is_person_id = dw_head.GetItemString(1, "person_id")

return true

end event

event ue_retrieve();call super::ue_retrieve;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_req_ymd, is_cust_cd, is_req_dept, is_person_id, '2')
IF il_rows > 0 THEN
   dw_body.SetFocus()
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
				
string ls_brand, ls_mat_cd, ls_color, ls_cust_cd, ls_out_ymd, ls_out_no, ls_flag, ls_req_ymd, ls_fin_yn, ls_person_id
decimal ldc_qty
int		li_req_no

ll_row_count = dw_list.RowCount()
IF dw_list.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF



FOR i=1 TO ll_row_count
	idw_status = dw_list.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
			idw_status = dw_body.GetItemStatus(i, 0, Primary!)
			ls_brand   = dw_list.getitemstring(i,"brand")
			ls_req_ymd = dw_list.getitemstring(i,"req_ymd")
			li_req_no  = dw_list.getitemnumber(i,"req_no")			
			ls_mat_cd  = dw_list.getitemstring(i,"mat_cd")
			ls_color   = dw_list.getitemstring(i,"color")
			ldc_qty    = dw_list.getitemnumber(i,"qty")
			ls_cust_cd = dw_list.getitemstring(i,"cust_cd")
			ls_out_ymd = dw_list.getitemstring(i,"out_ymd")
			ls_out_no  = dw_list.getitemstring(i,"out_no")
			ls_fin_yn  = dw_list.getitemstring(i,"fin_yn")

			ls_person_id  = dw_list.getitemstring(i,"person_id")
			

			if ls_fin_yn = 'Y' and isnull(ls_out_ymd) then
				ls_flag = "New"
				select right('0000' + convert(varchar(3),isnull(max(out_no),'0000') + 1),4) 
					into :ls_out_no
					from tb_22020_h (nolock)
					where brand = :ls_brand
					and   out_ymd = convert(char(8),getdate(),112);
					
			elseif ls_fin_yn = 'N' and not isnull(ls_out_ymd) then 
			
				ls_flag = "Del"			
			end if
	
			declare sp_mat_sample_out procedure for sp_mat_sample_out
				@brand		= :ls_brand,
				@req_ymd		= :ls_req_ymd,
				@req_no		= :li_req_no,
				@mat_cd		= :ls_mat_cd,
				@color		= :ls_color,
				@qty			= :ldc_qty,
				@cust_cd		= :ls_cust_cd,	
				@out_ymd		= :ls_out_ymd,
				@out_no		= :ls_out_no,			
				@person_id	= :ls_person_id,
				@flag			= :ls_flag;
				
			execute 	sp_mat_sample_out;


   END IF
NEXT

	
if sqlca.sqlcode <> 0 then
   dw_body.ResetUpdate()
	commit  USING SQLCA;
	Trigger Event ue_retrieve()	//조회
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = false 
         dw_list.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_excel();/*===========================================================================*/
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
li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event ue_title();/*===========================================================================*/
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
				 
dw_print.object.t_brand.text = dw_head.getitemstring(1,"brand")
dw_print.object.t_req_ymd.text = dw_head.getitemstring(1,"req_ymd")

dw_print.Modify(ls_modify)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

//This.Trigger Event ue_title ()

/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result
string ls_brand, ls_out_ymd, ls_style, ls_mat_cd, ls_out_gubn



ls_brand   = dw_body.getitemstring(1,"brand")
ls_out_ymd = dw_body.GetItemstring(1,"out_ymd")
ls_style   = dw_body.getitemstring(1,"style")
ls_mat_cd  = dw_body.getitemstring(1,"mat_cd")
ls_out_gubn= '04'

//messagebox("ls_brand",ls_brand)
//messagebox("ls_out_ymd",ls_out_ymd)
//messagebox("ls_style",ls_style)
//messagebox("ls_mat_cd",ls_mat_cd)
//messagebox("ls_out_gubn",ls_out_gubn)

il_rows = dw_print.Retrieve(ls_brand, ls_out_ymd, ls_style, ls_mat_cd, ls_out_gubn) 
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Integer li_result
string ls_brand, ls_out_ymd, ls_style, ls_mat_cd, ls_out_gubn



ls_brand   = dw_body.getitemstring(1,"brand")
ls_out_ymd = dw_body.GetItemstring(1,"out_ymd")
ls_style   = dw_body.getitemstring(1,"style")
ls_mat_cd  = dw_body.getitemstring(1,"mat_cd")
ls_out_gubn= '04'

//messagebox("ls_brand",ls_brand)
//messagebox("ls_out_ymd",ls_out_ymd)
//messagebox("ls_style",ls_style)
//messagebox("ls_mat_cd",ls_mat_cd)
//messagebox("ls_out_gubn",ls_out_gubn)

il_rows = dw_out_sheet.Retrieve(ls_brand, ls_out_ymd, ls_style, ls_mat_cd, ls_out_gubn) 
if il_rows > 0 then
	dw_out_sheet.visible = true
end if 
dw_out_sheet.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_e`cb_close within w_22209_e
end type

type cb_delete from w_com010_e`cb_delete within w_22209_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22209_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22209_e
end type

type cb_update from w_com010_e`cb_update within w_22209_e
boolean enabled = true
end type

type cb_print from w_com010_e`cb_print within w_22209_e
boolean visible = false
string text = "출고증"
end type

type cb_preview from w_com010_e`cb_preview within w_22209_e
string text = "출고증"
end type

type gb_button from w_com010_e`gb_button within w_22209_e
end type

type cb_excel from w_com010_e`cb_excel within w_22209_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_22209_e
integer x = 23
integer width = 3538
integer height = 140
string dataobject = "d_22209_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd", "%")
idw_brand.setitem(1,"inter_nm", "전체")


end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_req_detp, ls_req_dept_nm, ls_empno
CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "req_dept"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		


	CASE "person_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE



end event

type ln_1 from w_com010_e`ln_1 within w_22209_e
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_e`ln_2 within w_22209_e
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_e`dw_body within w_22209_e
event type long ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
integer x = 0
integer y = 332
integer height = 692
boolean enabled = false
string dataobject = "d_22209_d01"
boolean vscrollbar = false
end type

event type long dw_body::ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_saup_gubn, ls_brand
Boolean    lb_check 
DataStore  lds_Source

ls_saup_gubn = dw_body.getitemstring(1,"brand")
if ls_saup_gubn = "N" then
	ls_saup_gubn = "01"
elseif ls_saup_gubn = "O" then
	ls_saup_gubn = "02"
end if

CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0 then return 0

				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "업체 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw1" 
			gst_cd.default_where   = "WHERE cust_code between '4999' and '8999' " + &
												"and   brand in ('n','o') " + &
												"and   change_gubn = '00' " + &
												"and   custcode like '_0%' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
//				gst_cd.Item_where = "custcode LIKE '" + as_data + "%'" // or cust_sname like '%" + as_data + "%')"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "req_dept"				
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0 then return 0
				
				IF gf_dept_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "req_dept_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부서 코드 검색" 
			gst_cd.datawindow_nm   = "d_22100_dw2" 
			gst_cd.default_where   = "WHERE saup_gubn like '" + ls_saup_gubn + "%'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(dept_code LIKE '" + as_data + "%' or dbo.sf_dept_nm(dept_code) like '%" + as_data + "%')"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "req_dept", lds_Source.GetItemString(1,"dept_code"))
				dw_body.SetItem(al_row, "dept_nm", lds_Source.GetItemString(1,"dept_nm"))
				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source	
			
	CASE "person_id"				
			IF ai_div = 1 THEN 	
				if isnull(as_data) or LenA(as_data) = 0 then return 0
				
				IF gf_emp_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "person_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com931" 
			gst_cd.default_where   = "WHERE brand = '" + is_brand + "'" + &
											" and   status_yn = 'Y' "  + &
											" and   (dept_nm like '%디자인%' " + &
											" or     dept_nm like '%개발%' "   + &
											" or     dept_nm like '%생산%') "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(person_id LIKE '" + as_data + "%' or person_nm like '%" + as_data + "%')"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "person_id", lds_Source.GetItemString(1,"person_id"))
				dw_body.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"person_nm"))
				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source	

	CASE "mat_cd"				
			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then 

					RETURN 0
				END IF 
			END IF
			ls_brand = this.getitemstring(al_row,"brand")
		   gst_cd.ai_div          = ai_div

			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = "where brand = '" + ls_brand + "'"
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm

				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				dw_body.SetItem(al_row, "spec", lds_Source.GetItemString(1,"spec"))


				This.GetChild("color", idw_color)
				idw_color.SetTransObject(SQLCA)
				idw_color.Retrieve(lds_Source.GetItemString(1,"mat_cd"))


				
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("color")
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

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_req_detp, ls_req_dept_nm, ls_empno

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return dw_body.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "req_dept"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return dw_body.Trigger Event ue_Popup(dwo.name, row, data, 1)		


	CASE "person_id"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return dw_body.Trigger Event ue_Popup(dwo.name, row, data, 1)		
		
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return dw_body.Trigger Event ue_Popup(dwo.name, row, data, 1)			
END CHOOSE



end event

event dw_body::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('N13MW00060')


end event

event dw_body::buttonclicked;/*===========================================================================*/
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

this.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type dw_print from w_com010_e`dw_print within w_22209_e
integer x = 471
integer y = 420
string dataobject = "d_22101_r01"
end type

type dw_list from u_dw within w_22209_e
integer y = 1032
integer width = 3561
integer height = 968
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_22209_l01"
boolean hscrollbar = true
end type

event clicked;call super::clicked;string ls_brand, ls_req_ymd, ls_mat_cd
integer li_req_no

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


choose case dwo.name
	case "fin_yn"
	case else
		ls_mat_cd  = dw_list.getitemstring(row,"mat_cd")
		ls_req_ymd = dw_list.getitemstring(row,"req_ymd")
		li_req_no  = dw_list.getitemnumber(row,"req_no")

		This.GetChild("color", idw_color)
		idw_color.SetTransObject(SQLCA)
		idw_color.Retrieve(ls_mat_cd)
				
		
		il_rows = dw_body.retrieve(is_brand, ls_req_ymd, li_req_no, is_cust_cd, is_req_dept, is_person_id, 'D')			
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			
			dw_body.ScrollToRow(il_rows)
			dw_body.SetColumn(ii_min_column_id)
			dw_body.SetFocus()
			cb_preview.enabled = true
		end if		
end choose

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_out_sheet from u_dw within w_22209_e
boolean visible = false
integer x = 82
integer y = 384
integer width = 933
integer height = 384
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_22100_r01"
boolean hscrollbar = true
boolean resizable = true
end type

