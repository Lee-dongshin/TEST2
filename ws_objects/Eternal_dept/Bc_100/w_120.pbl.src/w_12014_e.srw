$PBExportHeader$w_12014_e.srw
$PBExportComments$출고차순확정
forward
global type w_12014_e from w_com020_e
end type
type pb_next from picturebutton within w_12014_e
end type
type pb_previous from picturebutton within w_12014_e
end type
end forward

global type w_12014_e from w_com020_e
integer width = 3680
integer height = 2276
pb_next pb_next
pb_previous pb_previous
end type
global w_12014_e w_12014_e

type variables
String is_brand, is_year, is_season, is_out_seq, is_check1 = 'N', is_check2 = 'N'
datawindowchild  idw_brand, idw_season, idw_out_seq

end variables

forward prototypes
public function integer wf_user_info (string as_person_id)
end prototypes

public function integer wf_user_info (string as_person_id);/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)                                             */	
/* 작성일      : 2000.09.18                                                  */	
/* 수정일      : 2000.09.18                                                  */
/* Description : 사용자정보를 조회한다.                                      */
/*===========================================================================*/
string	ls_person_nm, ls_brand_cd, ls_part_cd, ls_part_nm, ls_branch_cd, ls_user_grp 
integer	li_user_level

  SELECT PERSON_NM, BRAND,	DEPT_CD, dbo.sf_dept_nm(DEPT_CD),
			USER_GRP,  USER_LEVEL
	 INTO :ls_person_nm, :ls_brand_cd, :ls_part_cd,  :ls_part_nm,
			:ls_user_grp, :li_user_level
	 FROM VI_93010_1
	WHERE PERSON_ID = :as_person_id ;

if SQLCA.SQLCODE <> 0 then
	return 1
end if 

dw_head.SetItem(1, "person_nm", ls_person_nm)
dw_head.SetItem(1, "brand_cd", ls_brand_cd)
dw_head.SetItem(1, "part_cd",   ls_part_cd)
dw_head.SetItem(1, "part_nm",   ls_part_nm)
dw_head.SetItem(1, "user_grp",  ls_user_grp)
dw_head.SetItem(1, "user_level", li_user_level)

return 0

end function

on w_12014_e.create
int iCurrent
call super::create
this.pb_next=create pb_next
this.pb_previous=create pb_previous
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_next
this.Control[iCurrent+2]=this.pb_previous
end on

on w_12014_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_next)
destroy(this.pb_previous)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */ 
/* 작성일      : 2001.11.16                                                  */
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/
Long ll_rows

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand,is_year,is_season,is_out_seq)
//dw_body.Reset()
ll_rows = dw_body.retrieve(is_brand,is_year,is_season,is_out_seq)
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF ll_rows > 0 THEN
   dw_body.SetFocus()
	il_rows = ll_rows
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_out_seq = Trim(dw_head.GetItemString(1, "out_seq"))
if IsNull(is_out_seq) or is_out_seq = "" then
   MessageBox(ls_title,"출고차순을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("out_seq")
   return false
end if




return true

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12014_e","0")
end event

type cb_close from w_com020_e`cb_close within w_12014_e
end type

type cb_delete from w_com020_e`cb_delete within w_12014_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_12014_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12014_e
end type

type cb_update from w_com020_e`cb_update within w_12014_e
end type

type cb_print from w_com020_e`cb_print within w_12014_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_12014_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_12014_e
end type

type cb_excel from w_com020_e`cb_excel within w_12014_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_12014_e
integer width = 3557
integer height = 132
string dataobject = "d_12014_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
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
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")


This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('032')

end event

event dw_head::itemchanged;call super::itemchanged;//라빠레트 시즌적용
dw_head.accepttext()

CHOOSE CASE dwo.name
	CASE "brand", "year"
		dw_head.accepttext()
		is_brand = dw_head.getitemstring(1,'brand')
		is_year = dw_head.getitemstring(1,'year')
	
		this.getchild("season",idw_season)
		idw_season.settransobject(sqlca)
		idw_season.retrieve('003', is_brand, is_year)
		idw_season.insertrow(1)
		idw_season.setitem(1,"inter_cd","%")
		idw_season.setitem(1,"inter_nm","전체")
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_12014_e
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com020_e`ln_2 within w_12014_e
integer beginy = 312
integer endy = 312
end type

type dw_list from w_com020_e`dw_list within w_12014_e
integer x = 37
integer y = 324
integer width = 1609
integer height = 1708
string dataobject = "d_12014_d01"
end type

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 2000.09.18                                                  */
/*===========================================================================*/
This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('032')

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

event dw_list::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_choice1"
		If is_check1 = 'N' then
			is_check1 = 'Y'
			This.Object.cb_choice1.Text = '제외'
		Else
			is_check1 = 'N'
			This.Object.cb_choice1.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "flag", is_check1)
		Next
		
END CHOOSE

end event

type dw_body from w_com020_e`dw_body within w_12014_e
integer x = 1915
integer y = 324
integer width = 1678
integer height = 1708
string dataobject = "d_12014_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_choice2"
		If is_check2 = 'N' then
			is_check2 = 'Y'
			This.Object.cb_choice2.Text = '제외'
		Else
			is_check2 = 'N'
			This.Object.cb_choice2.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "flag", is_check2)
		Next
		
END CHOOSE

end event

event dw_body::itemchanged;//////////////////////////////////////////////////////////////////////////////
//	Event:			itemchanged
//	Description:	Send itemchanged notification to services
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						6.0   Initial version
// 					7.0	Linkage service should not fire events when querymode is enabled
//////////////////////////////////////////////////////////////////////////////
//	Copyright ?1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean lb_disablelinkage
integer li_rc

// Is Querymode enabled?
If IsValid(inv_QueryMode) then lb_disablelinkage = inv_QueryMode.of_GetEnabled()

if not lb_disablelinkage then
	if IsValid (inv_Linkage) then
		//	*Note: If the changed value needs to be validated.  Validation needs to 
		//		occur prior to this linkage.pfc_itemchanged event.  If key syncronization is 
		//		performed, then the changed value cannot be undone. (i.e. return codes)	
		li_rc = inv_Linkage.event pfc_itemchanged (row, dwo, data)
	end if
end if


end event

event dw_body::constructor;call super::constructor;This.GetChild("out_seq", idw_out_seq)
idw_out_seq.SetTransObject(SQLCA)
idw_out_seq.Retrieve('032')

end event

type st_1 from w_com020_e`st_1 within w_12014_e
boolean visible = false
integer y = 380
integer height = 1652
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_12014_e
end type

type pb_next from picturebutton within w_12014_e
integer x = 1664
integer y = 528
integer width = 160
integer height = 252
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "next.bmp"
alignment htextalign = left!
end type

event clicked;/* 사용불가 프로그램을 사용가능 프로그램으로 이동 */
Long i, row_cnt

row_cnt = dw_list.RowCount()
For i = row_cnt To 1 Step -1
	If dw_list.GetItemString(i, 'flag') = 'Y' Then
		dw_list.RowsMove(i, i, Primary!, dw_body, 1, Primary!)
		dw_body.SetItem(1,"out_seq",is_out_seq)
		dw_body.SetItem(1, 'flag', 'N')
		ib_changed = true
		cb_update.enabled = true
		is_check1 = 'N'
		dw_list.Object.cb_choice1.Text = '선택'
	End If
Next

end event

type pb_previous from picturebutton within w_12014_e
integer x = 1664
integer y = 872
integer width = 160
integer height = 252
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "previous.bmp"
alignment htextalign = left!
end type

event clicked;/* 사용불가 프로그램을 사용가능 프로그램으로 이동 */
Long i, row_cnt

row_cnt = dw_body.RowCount()

For i = row_cnt To 1 Step -1
	If dw_body.GetItemString(i, 'flag') = 'Y' Then
		dw_body.RowsCopy(i, i, Primary!, dw_list, 1, Primary!)
		dw_body.RowsMove(i, i, Primary!, dw_body, 1, Delete!)
		dw_list.SetItem(1, 'flag', 'N')
		ib_changed = true
		cb_update.enabled = true
		is_check2 = 'N'
		dw_body.Object.cb_choice2.Text = '선택'
	End If
Next

end event

