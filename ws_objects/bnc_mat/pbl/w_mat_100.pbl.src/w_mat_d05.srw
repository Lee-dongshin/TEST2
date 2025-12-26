$PBExportHeader$w_mat_d05.srw
$PBExportComments$원자재 검단조회
forward
global type w_mat_d05 from w_com010_e
end type
type dw_1 from datawindow within w_mat_d05
end type
end forward

global type w_mat_d05 from w_com010_e
integer height = 2256
dw_1 dw_1
end type
global w_mat_d05 w_mat_d05

type variables
string is_yymmdd, is_mat_cd, is_color
datawindowchild idw_color

end variables

on w_mat_d05.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_mat_d05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm, ls_spec
Boolean    lb_check 
long  i
DataStore  lds_Source 

CHOOSE CASE as_column
	case "color"

			dw_body.setitem(al_row,"tmp_qty",0)
			dw_body.setitem(al_row,"qc_qty",0)
			dw_body.setitem(al_row,"dft_1",0)
			dw_body.setitem(al_row,"dft_2",0)
			dw_body.setitem(al_row,"dft_3",0)
			dw_body.setitem(al_row,"dft_4",0)
			dw_body.setitem(al_row,"dft_5",0)
			dw_body.setitem(al_row,"dft_6",0)
			dw_body.setitem(al_row,"dft_7",0)
			dw_body.setitem(al_row,"dft_8",0)
			dw_body.setitem(al_row,"dft_9",0)
			dw_body.setitem(al_row,"dft_qty",0)
			i = dw_body.Find("color = '" + string(as_data) + "'" ,1,al_row - 1)
		
			ls_spec = dw_body.getitemstring(i,"spec")
			dw_body.setitem(al_row,"spec",string(ls_spec))	
			RETURN 0
	CASE "mat_cd"
			if isnull(as_data) or LenA(as_data) < 4 then return 0
//			IF ai_div = 1 THEN 	
//				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
//					RETURN 0
//				END IF 
//				IF w_21003_e.wf_mat_chk(as_data) THEN
//					RETURN 0 
//				ELSEIF Len(as_data) = 10 THEN 
//					MessageBox("오류", "원자재 코드가 형식에 맞지안습니다 !")
//					Return 1
//				END IF
//			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				
				dw_head.GetChild("color", idw_color)
				idw_color.SetTransObject(SQLCA)
				idw_color.Retrieve(lds_Source.GetItemString(1,"mat_cd"))
				idw_color.InsertRow(1)
				idw_color.SetItem(1, "color", '%')
				idw_color.SetItem(1, "color_nm", '전체')


				dw_body.GetChild("color", idw_color)
				idw_color.SetTransObject(SQLCA)
				idw_color.Retrieve(lds_Source.GetItemString(1,"mat_cd"))

				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
is_color = dw_head.GetItemString(1, "color")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

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

il_rows = dw_1.retrieve(is_mat_cd)
il_rows = dw_body.retrieve(is_mat_cd, is_color)
IF il_rows > 0 THEN	
	for i = 0 to il_rows 
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = 'New' then 
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if
	next 
//   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_in_no = 0, j = 0
decimal ll_defect
string ls_in_no,  ls_mat_year, ls_mat_season, ls_mat_sojae, ls_mat_chno, ls_out_seq
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

select cast(max(in_no) as int) into :ll_in_no from tb_22011_d a(nolock)
	where in_ymd = :is_yymmdd;


if isnull(ll_in_no) then ll_in_no = 0
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
		j = j + 1 

 		ls_in_no = RightA('0000'+string(ll_in_no + j),4)
	
 		dw_body.Setitem(i, "in_no", ls_in_no)

      dw_body.Setitem(i, "brand", LeftA(is_mat_cd,1))
      dw_body.Setitem(i, "in_ymd", is_yymmdd)
      dw_body.Setitem(i, "in_gubn", '01')
      dw_body.Setitem(i, "mat_cd", is_mat_cd)		
		
		select 
			mat_Year,
			mat_Season,
			mat_sojae,
			mat_chno,
			out_seq	into :ls_mat_year, :ls_mat_season, :ls_mat_sojae, :ls_mat_chno, :ls_out_seq	
		 from tb_21011_d a(nolock)
		where mat_cd = :is_mat_cd;

      dw_body.Setitem(i, "mat_year", ls_mat_year)	
      dw_body.Setitem(i, "mat_season", ls_mat_season)	
      dw_body.Setitem(i, "mat_sojae", ls_mat_sojae)	
      dw_body.Setitem(i, "mat_chno", ls_mat_chno)	
      dw_body.Setitem(i, "out_seq", ls_out_seq)			

		ll_defect = dw_body.getitemdecimal(i,"defect")
		dw_body.Setitem(i, "dft_qty", ll_defect)
		
	
 		dw_body.Setitem(i, "in_ymd", string(ld_datetime,"yyyymmdd"))
 
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)

		ll_defect = dw_body.getitemdecimal(i,"defect")
		dw_body.Setitem(i, "dft_qty", ll_defect)
		
   END IF
NEXT

il_rows = dw_1.Update(TRUE, FALSE)
if il_rows = 1 then
   dw_1.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


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

event ue_insert();call super::ue_insert;string ls_spec

dw_body.setitem(il_rows,"color",is_color)


			dw_body.setitem(il_rows,"tmp_qty",0)
			dw_body.setitem(il_rows,"qc_qty",0)
			dw_body.setitem(il_rows,"dft_1",0)
			dw_body.setitem(il_rows,"dft_2",0)
			dw_body.setitem(il_rows,"dft_3",0)
			dw_body.setitem(il_rows,"dft_4",0)
			dw_body.setitem(il_rows,"dft_5",0)
			dw_body.setitem(il_rows,"dft_6",0)
			dw_body.setitem(il_rows,"dft_7",0)
			dw_body.setitem(il_rows,"dft_8",0)
			dw_body.setitem(il_rows,"dft_9",0)
			dw_body.setitem(il_rows,"dft_qty",0)
		
		
			ls_spec = dw_body.getitemstring(1,"spec")
			dw_body.setitem(il_rows,"spec",string(ls_spec))	

end event

event pfc_preopen();call super::pfc_preopen;
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if


		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_e`cb_close within w_mat_d05
end type

type cb_delete from w_com010_e`cb_delete within w_mat_d05
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_mat_d05
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_mat_d05
end type

type cb_update from w_com010_e`cb_update within w_mat_d05
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_mat_d05
end type

type cb_preview from w_com010_e`cb_preview within w_mat_d05
end type

type gb_button from w_com010_e`gb_button within w_mat_d05
end type

type cb_excel from w_com010_e`cb_excel within w_mat_d05
end type

type dw_head from w_com010_e`dw_head within w_mat_d05
integer height = 204
string dataobject = "d_mat05_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('')
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_nm", '전체')


//This.GetChild("season", idw_season)
//idw_season.SetTransObject(SQLCA)
//idw_season.Retrieve('003')
//
//This.GetChild("sojae", idw_sojae)
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')
//
//This.GetChild("item", idw_item)
//idw_item.SetTransObject(SQLCA)
//idw_item.Retrieve()
//idw_item.InsertRow(1)
//idw_item.SetItem(1, "item", '%')
//idw_item.SetItem(1, "item_nm", '전체')
//
//This.GetChild("color", idw_color)
//idw_color.SetTransObject(SQLCA)
//idw_color.retrieve('%')
//idw_color.InsertRow(1)
//idw_color.SetItem(1, "color", '%')
//idw_color.SetItem(1, "color_enm", '전체')
//
//This.GetChild("size", idw_size)
//idw_size.SetTransObject(SQLCA)
//idw_size.retrieve('%')
//idw_size.InsertRow(1)
//idw_size.SetItem(1, "size", '%')
//idw_size.SetItem(1, "size_nm", '전체')
//
end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//

CHOOSE CASE dwo.name
	case "mat_cd"

		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_mat_d05
integer beginy = 404
integer endy = 404
end type

type ln_2 from w_com010_e`ln_2 within w_mat_d05
integer beginy = 408
integer endy = 408
end type

type dw_body from w_com010_e`dw_body within w_mat_d05
integer y = 560
integer height = 1480
boolean enabled = false
string dataobject = "d_mat05_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;//
end event

type dw_print from w_com010_e`dw_print within w_mat_d05
integer x = 699
integer y = 324
string dataobject = "d_mat05_r01"
end type

event dw_print::constructor;call super::constructor;				dw_body.GetChild("color", idw_color)
				idw_color.SetTransObject(SQLCA)
				idw_color.Retrieve('')
end event

type dw_1 from datawindow within w_mat_d05
integer x = 5
integer y = 420
integer width = 3579
integer height = 140
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_mat05_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;//
end event

