$PBExportHeader$w_51007_e.srw
$PBExportComments$일일업무 등록
forward
global type w_51007_e from w_com010_e
end type
type dw_d02 from datawindow within w_51007_e
end type
type dw_d03 from datawindow within w_51007_e
end type
type dw_1 from datawindow within w_51007_e
end type
end forward

global type w_51007_e from w_com010_e
integer width = 3680
integer height = 2252
dw_d02 dw_d02
dw_d03 dw_d03
dw_1 dw_1
end type
global w_51007_e w_51007_e

type variables
datawindowchild idw_brand, idw_person_id

boolean	ib_changed_d02, ib_changed_d03

string is_brand, is_yymmdd, is_person_id, is_shop_cd
end variables

on w_51007_e.create
int iCurrent
call super::create
this.dw_d02=create dw_d02
this.dw_d03=create dw_d03
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_d02
this.Control[iCurrent+2]=this.dw_d03
this.Control[iCurrent+3]=this.dw_1
end on

on w_51007_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_d02)
destroy(this.dw_d03)
destroy(this.dw_1)
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
IF gf_datechk(is_yymmdd) = FALSE THEN
	MessageBox(ls_title,"기준일자를 확인하십시요!")
	Return false
END IF



is_person_id = dw_head.GetItemString(1, "person_id")
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
is_shop_cd = is_person_id
il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_person_id)
IF il_rows > 0 THEN
	is_shop_cd = dw_body.getitemstring(1, "shop_cd")
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = 'New' then
			dw_body.SetItemStatus(i, 0, Primary!,New!)
		end if
	next
	
   dw_body.SetFocus()
END IF

//업무일지
il_rows = dw_d02.retrieve(is_brand, is_yymmdd, is_person_id)
if il_rows > 0 then
	for i = 1 to il_rows
		ls_flag = dw_d02.getitemstring(i,"flag")
		if ls_flag = 'New' then
			dw_d02.SetItemStatus(i, 0, Primary!, New!)
		end if
	next
end if

//브랜드 인기스타일
il_rows = dw_d03.retrieve(is_brand, is_yymmdd, is_shop_cd)
if il_rows > 0 then
	for i = 1 to il_rows
		ls_flag = dw_d03.getitemstring(i,"flag")
		if ls_flag = 'New' then
			dw_d03.SetItemStatus(i, 0, Primary!, New!)
		end if
	next
end if


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 		   									  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_d02, "ScaledToRight")
inv_resize.of_Register(dw_d02, "FixedToBottom")

inv_resize.of_Register(dw_d03, "FixedToBottom")

inv_resize.of_Register(dw_1, "FixedToRight&Bottom")
//inv_resize.of_Register(dw_1, "ScaledToBottom")

dw_body.height = dw_body.height - dw_d03.height - 20
/* DataWindow의 Transction 정의 */
dw_d02.SetTransObject(SQLCA)
dw_d03.SetTransObject(SQLCA)

dw_1.SetTransObject(SQLCA)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
string ls_shop_cd, ls_flag, ls_yymm
decimal  ldc_magam_sale_amt


IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_d02.AcceptText() <> 1 THEN RETURN -1
IF dw_d03.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

//업무일지
ll_row_count = dw_d02.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_d02.GetItemStatus(i, 0, Primary!)	
   IF idw_status = NewModified! THEN				/* New Record */
      dw_d02.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_d02.Setitem(i, "mod_id", gs_user_id)
      dw_d02.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

//브랜드 인기스타일
ll_row_count = dw_d03.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_d03.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_d03.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_d03.Setitem(i, "mod_id", gs_user_id)
      dw_d03.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

//타브랜드 동향

il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then	il_rows = dw_d02.Update(TRUE, FALSE)
if il_rows = 1 then	il_rows = dw_d03.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   dw_d02.ResetUpdate()
   dw_d03.ResetUpdate()	
   commit  USING SQLCA;
	
	ls_yymm = LeftA(is_yymmdd,6)
	for i = 1 to dw_body.rowcount()
		ls_shop_cd = dw_body.getitemstring(i,"shop_cd")
		ldc_magam_sale_amt = dw_body.getitemnumber(i,"magam_sale_amt")
		if ldc_magam_sale_amt = 0 then setnull(ldc_magam_sale_amt)
		
		update a set magam_sale_amt = 1000 * :ldc_magam_sale_amt
		from tb_51010_h a
		where yymm = :ls_yymm
		and   shop_cd = :ls_shop_cd
		and   sale_type = '11'
		and   isnull(magam_sale_amt,0) <> 1000 * isnull(:ldc_magam_sale_amt,0);

	next 
	
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
string ls_modify, ls_datetime, ls_person_nm

ls_person_nm = idw_person_id.getitemstring(idw_person_id.getrow(),"person_nm")

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"				

dw_print.Modify(ls_modify)


dw_print.object.t_yymmdd.text = is_yymmdd
dw_print.object.t_person_nm.text = is_person_id + "-" + ls_person_nm

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_yymmdd, is_person_id)

dw_print.inv_printpreview.of_SetZoom()


end event

type cb_close from w_com010_e`cb_close within w_51007_e
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_51007_e
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_51007_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_51007_e
end type

type cb_update from w_com010_e`cb_update within w_51007_e
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_51007_e
boolean visible = false
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_51007_e
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_51007_e
end type

type cb_excel from w_com010_e`cb_excel within w_51007_e
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_51007_e
integer y = 164
integer height = 128
string dataobject = "d_51007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("person_id", idw_person_id)
idw_person_id.SetTransObject(SQLCA)
idw_person_id.Retrieve(gs_brand)
idw_person_id.InsertRow(0)

//idw_person_id.SetItem(1, "inter_cd", '%')
//idw_person_id.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_work_type, ls_person_id
CHOOSE CASE dwo.name
	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		this.setitem(1,"person_id","")
		This.GetChild("person_id", idw_person_id)
		idw_person_id.SetTransObject(SQLCA)
		idw_person_id.Retrieve(data)
		idw_person_id.InsertRow(0)

	CASE "person_id"		
		select left(work_type,1) into :ls_work_type 
			from tb_93010_m (nolock) where person_id = :data;
		
		dw_head.setitem(1,"work_type",ls_work_type)	
		
	CASE "work_type"		
		ls_person_id = dw_head.getitemstring(1,"person_id")

		update a set work_type = :data 
		from tb_93010_m a(nolock) where person_id = :ls_person_id;
		commit  USING SQLCA;
			
END CHOOSE


end event

type ln_1 from w_com010_e`ln_1 within w_51007_e
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_e`ln_2 within w_51007_e
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_e`dw_body within w_51007_e
integer y = 336
integer width = 3593
integer height = 1684
string dataobject = "d_51007_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;

/*===========================================================================*/
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
This.inv_sort.of_SetColumnHeader(false)

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

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_color


if row > 0 then
	choose case dwo.name
		case "style_no1", "style_no2", "style_no3"
			ls_style = this.getitemstring(row,string(dwo.name))

			ls_color = RightA(ls_style,2)
			ls_style = LeftA(ls_style,8)

			il_rows = dw_1.retrieve(is_yymmdd, ls_style, ls_color)
			if il_rows > 0 then	
				dw_1.visible = true	
				dw_1.title = ls_style + '-' + ls_color + '    ' + '매장별 판매현황'
			end if

			
	end choose
end if
end event

event dw_body::clicked;call super::clicked;string ls_style, ls_color, ls_flag
long i


IF ib_changed then
	Parent.Trigger Event ue_head()	//조건
END IF




if row > 0 then
	choose case dwo.name
		case "style_no1", "style_no2", "style_no3"
			ls_style = this.getitemstring(row,string(dwo.name))

			ls_color = RightA(ls_style,2)
			ls_style = LeftA(ls_style,8)
			

			if isnull(ls_style) or LenA(ls_style) <> 8 then
			else	
				gf_style_color_pic(ls_style,'','%')
			end if
//		case "shop_nm"
//			is_shop_cd = this.getitemstring(row,"shop_cd")
//			il_rows = dw_d02.retrieve(is_brand, is_yymmdd, is_shop_cd)
//			if il_rows > 0 then
//				for i = 1 to il_rows
//					ls_flag = dw_d02.getitemstring(i,"flag")
//					if ls_flag = 'New' then
//						dw_d02.SetItemStatus(i, 0, Primary!, New!)
//					end if
//				next
//			end if

		
	end choose
end if
end event

type dw_print from w_com010_e`dw_print within w_51007_e
string dataobject = "d_51007_r00"
end type

type dw_d02 from datawindow within w_51007_e
integer x = 2395
integer y = 1104
integer width = 2359
integer height = 916
integer taborder = 50
boolean bringtotop = true
string title = "업무일지"
string dataobject = "d_51007_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true


end event

type dw_d03 from datawindow within w_51007_e
integer x = 9
integer y = 1104
integer width = 2377
integer height = 916
integer taborder = 60
boolean bringtotop = true
string title = "브랜드 인기스타일"
string dataobject = "d_51007_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
end event

event doubleclicked;string ls_style, ls_color
if row > 0 then
	choose case dwo.name
		case "style"
			ls_style = this.getitemstring(row,"style")
			ls_color = this.getitemstring(row,"color")
			
			il_rows = dw_1.retrieve(is_yymmdd, ls_style, ls_color)
			if il_rows > 0 then	
				dw_1.visible = true	
				dw_1.title = ls_style + '-' + ls_color + '    ' + '매장별 판매현황'
			end if
	end choose 
end if
end event

event clicked;string ls_style, ls_color
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row,"style")
		ls_color = this.getitemstring(row,"color")		
		if isnull(ls_style) or LenA(ls_style) <> 8 then
		else	
			gf_style_color_pic(ls_style,'', ls_color)
		end if
end choose

end event

type dw_1 from datawindow within w_51007_e
boolean visible = false
integer x = 1842
integer width = 1760
integer height = 2020
integer taborder = 40
boolean titlebar = true
string title = "매장별 판매현황"
string dataobject = "d_51007_d04"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;this.visible = false
end event

