$PBExportHeader$w_sh112_d.srw
$PBExportComments$매장수불현황조회
forward
global type w_sh112_d from w_com010_d
end type
type st_1 from statictext within w_sh112_d
end type
type st_2 from statictext within w_sh112_d
end type
type st_qty from statictext within w_sh112_d
end type
type st_amt from statictext within w_sh112_d
end type
type dw_2 from datawindow within w_sh112_d
end type
type cb_excel from cb_retrieve within w_sh112_d
end type
type gb_1 from groupbox within w_sh112_d
end type
type dw_1 from datawindow within w_sh112_d
end type
end forward

global type w_sh112_d from w_com010_d
st_1 st_1
st_2 st_2
st_qty st_qty
st_amt st_amt
dw_2 dw_2
cb_excel cb_excel
gb_1 gb_1
dw_1 dw_1
end type
global w_sh112_d w_sh112_d

type variables
string	is_style,is_chno,is_color,is_size, is_shop_type, is_year, is_season, is_opt
datawindowchild idw_shop_type, idw_year, idw_season
end variables

on w_sh112_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_qty=create st_qty
this.st_amt=create st_amt
this.dw_2=create dw_2
this.cb_excel=create cb_excel
this.gb_1=create gb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_qty
this.Control[iCurrent+4]=this.st_amt
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.cb_excel
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.dw_1
end on

on w_sh112_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_qty)
destroy(this.st_amt)
destroy(this.dw_2)
destroy(this.cb_excel)
destroy(this.gb_1)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 동은아빠                                       */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
String   ls_title,ls_style_no

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

is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_opt = dw_head.GetItemString(1, "opt")

is_shop_type = dw_head.GetItemString(1, "shop_type")



ls_style_no = dw_head.GetItemString(1, "style_no")

is_style	= LeftA(ls_style_no,8)
is_chno	= MidA(ls_style_no,9,1)
is_color	= MidA(ls_style_no,10,2)
is_size	= MidA(ls_style_no,12,2)

IF isnull(is_style) then is_style = '%' 
IF isnull(is_chno)  then is_chno  = '%' 
IF isnull(is_color) then is_color = '%' 
IF isnull(is_size)  then is_size  = '%' 

if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if
return true


end event

event ue_retrieve();call super::ue_retrieve;int li_cnt

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


select count(*)
into :li_cnt 
from tb_12020_m (nolock)
where style = :is_style ; 

if MidA(gs_brand_1,1,1) = 'X' then
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if
//messagebox("1", gs_brand_1)
//messagebox("", gs_shop_cd)
//
if li_cnt = 1 then
	dw_2.retrieve(is_style, gs_shop_cd)
else
	dw_2.reset()
end if

il_rows = dw_body.retrieve(gs_shop_cd, is_style, is_chno, is_color, is_size,is_shop_type, is_opt, is_year, is_season)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
String     ls_style_no
Boolean    lb_check 
DataStore  lds_Source

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4)
end if

CHOOSE CASE as_column
	CASE "style_no"				
			IF ai_div = 1 THEN 	
				IF gf_style_no_chk(LeftA(as_data, 8), MidA(as_data, 9, 1),MidA(as_data, 10, 2),MidA(as_data, 12, 2)) = True THEN
					RETURN 0
				END IF 
			END IF
			
//			IF ai_div = 1 THEN 	
//				RETURN 0 
//			END IF
			
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com012" 
			//	gst_cd.default_where   = ""		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 
				gst_cd.default_where   = "WHERE   '" + gs_brand_grp + "' like '%' + brand + '%' "								
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
					gst_cd.Item_where = gst_cd.Item_where + " AND CHNO LIKE '" + MidA(as_data, 9,1) + "%' "
					gst_cd.Item_where = gst_cd.Item_where + " AND COLOR LIKE '" + MidA(as_data, 10,2) + "%' "
					gst_cd.Item_where = gst_cd.Item_where + " AND SIZE LIKE '" + MidA(as_data, 12,2) + "%' "
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
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("flag")
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

event pfc_postopen();call super::pfc_postopen;datetime ld_datetime 
String   ls_yymm
Long     ll_qty, ll_amt

/* 시스템 날짜를 가져온다 */
gf_sysdate(ld_datetime) 
ls_yymm  = String(ld_datetime, "yyyymm")

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
	gs_brand = 'N'
end if

if MidA(gs_shop_cd ,3,4) = '2000' then
	select isnull(sum(limit_qty), 0), isnull(sum(limit_amt), 0) 
	  into :ll_qty,        :ll_amt 
	  from tb_51010_h with (nolock)
	 where yymm    = :ls_yymm 
		and shop_cd like '__2000' ;
else		
	select isnull(sum(limit_qty), 0), isnull(sum(limit_amt), 0) 
	  into :ll_qty,        :ll_amt 
	  from tb_51010_h with (nolock)
	 where yymm    = :ls_yymm 
		and shop_cd = :gs_shop_cd ;
end if
	
st_qty.Text = String(ll_qty, "#,###,##0")
st_amt.Text = String(ll_amt, "##,###,###,##0")

dw_1.Retrieve(gs_shop_cd, gs_brand) 

end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(dw_1, "FixedToRight")
inv_resize.of_Register(dw_2, "FixedToRight")

end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd")


ls_modify =	"t_pg_id.Text =   '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_yymmdd.Text =  '" + ls_datetime + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_shop_cd.Text = '" + gs_shop_cd + " " + gs_shop_nm + "'" 


dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_sh112_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh112_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh112_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh112_d
end type

type cb_update from w_com010_d`cb_update within w_sh112_d
end type

type cb_print from w_com010_d`cb_print within w_sh112_d
integer x = 37
integer y = 40
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_sh112_d
integer x = 379
integer y = 40
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_sh112_d
end type

type dw_head from w_com010_d`dw_head within w_sh112_d
integer x = 0
integer y = 164
integer width = 987
integer height = 392
string dataobject = "d_sh112_h01"
end type

event dw_head::itemchanged;call super::itemchanged;datetime ld_datetime 
String   ls_yymm
Long     ll_qty, ll_amt, ll_b_cnt

CHOOSE CASE dwo.name

//	CASE "style_no"	 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')

			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
		
			/* 시스템 날짜를 가져온다 */
			gf_sysdate(ld_datetime) 
			ls_yymm  = String(ld_datetime, "yyyymm")
			
			if MidA(gs_shop_cd_1,1,2) = 'XX' then 
				gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			end if
			
			if MidA(gs_shop_cd ,3,4) = '2000' then
				select isnull(sum(limit_qty), 0), isnull(sum(limit_amt), 0) 
				  into :ll_qty,        :ll_amt 
				  from tb_51010_h with (nolock)
				 where yymm    = :ls_yymm 
					and shop_cd like '__2000' ;
			else		
				select isnull(sum(limit_qty), 0), isnull(sum(limit_amt), 0) 
				  into :ll_qty,        :ll_amt 
				  from tb_51010_h with (nolock)
				 where yymm    = :ls_yymm 
					and shop_cd = :gs_shop_cd ;
			end if
				
			st_qty.Text = String(ll_qty, "#,###,##0")
			st_amt.Text = String(ll_amt, "##,###,###,##0")
			
			dw_1.Retrieve(gs_shop_cd, gs_brand) 
			
			Trigger Event ue_retrieve()
	
	
	
END CHOOSE
		
end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002','%')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')



This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.object.brand_t.visible = true
	dw_head.object.brand.visible = true
else
	dw_head.object.brand_t.visible = false
	dw_head.object.brand.visible = false
end if


String   ls_filter_str = ''	

ls_filter_str = "inter_cd <> '9' " 
idw_shop_type.SetFilter(ls_filter_str)
idw_shop_type.Filter( )
end event

type ln_1 from w_com010_d`ln_1 within w_sh112_d
integer beginy = 580
integer endy = 580
end type

type ln_2 from w_com010_d`ln_2 within w_sh112_d
integer beginy = 584
integer endy = 584
end type

type dw_body from w_com010_d`dw_body within w_sh112_d
integer y = 612
integer height = 1220
string dataobject = "d_sh112_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_sh112_d
string dataobject = "d_sh112_r01"
end type

type st_1 from statictext within w_sh112_d
boolean visible = false
integer x = 2203
integer y = 232
integer width = 169
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "수량"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh112_d
boolean visible = false
integer x = 2203
integer y = 300
integer width = 169
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "금액"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_qty from statictext within w_sh112_d
boolean visible = false
integer x = 2409
integer y = 216
integer width = 325
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_amt from statictext within w_sh112_d
boolean visible = false
integer x = 2409
integer y = 288
integer width = 325
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_sh112_d
integer x = 1801
integer y = 156
integer width = 1088
integer height = 408
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh112_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_excel from cb_retrieve within w_sh112_d
integer x = 1806
integer taborder = 60
boolean bringtotop = true
string text = "Excel"
end type

event clicked;call super::clicked;string ls_doc_nm, ls_nm
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

type gb_1 from groupbox within w_sh112_d
boolean visible = false
integer x = 2144
integer y = 172
integer width = 649
integer height = 204
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "적정재고"
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_sh112_d
integer x = 818
integer y = 20
integer width = 978
integer height = 544
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "정상제품재고조회"
string dataobject = "d_sh112_d02"
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

