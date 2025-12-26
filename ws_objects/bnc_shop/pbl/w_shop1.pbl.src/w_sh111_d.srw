$PBExportHeader$w_sh111_d.srw
$PBExportComments$점간이송승인조회
forward
global type w_sh111_d from w_com010_d
end type
type rb_1 from radiobutton within w_sh111_d
end type
type rb_2 from radiobutton within w_sh111_d
end type
type rb_3 from radiobutton within w_sh111_d
end type
type gb_1 from groupbox within w_sh111_d
end type
end forward

global type w_sh111_d from w_com010_d
integer width = 2985
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_sh111_d w_sh111_d

type variables
String is_fr_ymd, is_to_ymd, is_style_no, is_flag, is_market
end variables

on w_sh111_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
end on

on w_sh111_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event open;call super::open;is_flag = '1'
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
string   ls_title
long ll_day_diff
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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	
	
if gs_brand_1 = 'X' then
	gs_brand = dw_head.GetItemString(1, "brand")
	if IsNull(gs_brand) or Trim(gs_brand) = "" then
		MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("brand")
		return false
	end if
end if


is_fr_ymd   = dw_head.GetItemString(1, "fr_ymd") //String(dw_head.GetItemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd   = dw_head.GetItemString(1, "to_ymd") //String(dw_head.GetItemDate(1, "to_ymd"), "yyyymmdd")

select datediff(day, :is_fr_ymd, :is_to_ymd)
into :ll_day_diff
from dual;

IF ll_day_diff > 60 THEN
   MessageBox(ls_title,"2개월 이상은 조회할수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_style_no = dw_head.GetItemString(1, "style_no")
is_market = dw_head.GetItemString(1, "market")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

il_rows = dw_body.retrieve(gs_shop_cd, is_fr_ymd, is_to_ymd, is_style_no, is_flag, is_market)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_postopen();call super::pfc_postopen;if MidA(gs_shop_cd_1,1,2) = 'XX' then 
	gs_shop_cd = 'N' + gs_shop_div + MidA(gs_shop_cd_1,3,4)
end if

This.Trigger Event ue_retrieve()
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
String     ls_style, ls_chno, ls_color, ls_size  
Boolean    lb_check 
DataStore  lds_Source 

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	gs_brand = MidA(as_data,1,1)
end if

CHOOSE CASE as_column
	CASE "style_no"		
		
		//IF isnull(as_data) or trim(as_data) = ""  then RETURN 0
			
			IF ai_div = 1 THEN 	
				RETURN 0 
			END IF

			ls_style = LeftA(as_data, 8)  
			ls_chno  = MidA(as_data,  9, 1)  
			ls_color = MidA(as_data, 10, 2)  
			ls_size  = MidA(as_data, 12, 2)  
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색" 
			gst_cd.datawindow_nm   = "d_com012" 
//			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "' "
			gst_cd.default_where   =  "WHERE   '" + gs_brand_grp + "' like '%' + brand + '%'"			
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style  LIKE '" + ls_style + "%'" + &
				                " and chno  LIKE '" + ls_chno  + "%'"  + &
				                " and color LIKE '" + ls_color + "%'"  + &
				                " and size  LIKE '" + ls_size  + "%'"  
			ELSE
				gst_cd.Item_where = ""
			END IF

			lb_check = FALSE 
			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
			   /* 다음컬럼으로 이동 */
			   cb_retrieve.SetFocus()
		      lb_check = TRUE 
				ib_itemchanged = FALSE
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"t_shop_cd.Text = '" + gs_shop_cd + "'" + &
             "t_shop_nm.Text = '" + gs_shop_nm + "'" + &
             "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
             "t_to_ymd.Text = '" + is_to_ymd + "'" 

IF is_flag = "1" THEN
	ls_modify =	ls_modify + "t_show_title.Text = '점간이동 승인조회 (받은거)'"
ELSE
	ls_modify =	ls_modify + "t_show_title.Text = '점간이동 승인조회 (보낸거)'"	
END IF
		
dw_print.Modify(ls_modify)
end event

type cb_close from w_com010_d`cb_close within w_sh111_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh111_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_sh111_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh111_d
integer taborder = 30
end type

type cb_update from w_com010_d`cb_update within w_sh111_d
end type

type cb_print from w_com010_d`cb_print within w_sh111_d
integer taborder = 70
end type

type cb_preview from w_com010_d`cb_preview within w_sh111_d
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_sh111_d
end type

type dw_head from w_com010_d`dw_head within w_sh111_d
integer x = 997
integer y = 160
integer width = 1888
integer height = 172
integer taborder = 20
string dataobject = "d_sh111_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.02                                                  */	
/* 수정일      : 2002.05.02                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "style_no"	 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
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
			Trigger Event ue_retrieve()
			
END CHOOSE

end event

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

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


end event

type ln_1 from w_com010_d`ln_1 within w_sh111_d
integer beginy = 348
integer endy = 348
end type

type ln_2 from w_com010_d`ln_2 within w_sh111_d
integer beginy = 352
integer endy = 352
end type

type dw_body from w_com010_d`dw_body within w_sh111_d
integer y = 372
integer width = 2898
integer height = 1412
integer taborder = 40
string dataobject = "d_sh111_d01"
end type

event dw_body::constructor;call super::constructor;DataWindowchild ldw_child 

This.GetChild("fr_shop_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('009')
end event

type dw_print from w_com010_d`dw_print within w_sh111_d
string dataobject = "d_sh111_r01"
end type

type rb_1 from radiobutton within w_sh111_d
event ue_keydown pbm_keydown
integer x = 50
integer y = 196
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "받은거"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_2.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
is_flag = '1'

Parent.Post Event ue_retrieve()
end event

type rb_2 from radiobutton within w_sh111_d
event ue_keydown pbm_keydown
integer x = 343
integer y = 192
integer width = 576
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
string text = "보낸거(승인일기준)"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_3.TextColor = Rgb(0, 0, 0)
is_flag = '2'

Parent.Post Event ue_retrieve()



end event

type rb_3 from radiobutton within w_sh111_d
event ue_keydown pbm_keydown
integer x = 343
integer y = 256
integer width = 576
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
string text = "보낸거(등록일기준)"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0)) 
	RETURN 1
END IF

end event

event clicked;This.TextColor = Rgb(0, 0, 255)
rb_1.TextColor = Rgb(0, 0, 0)
rb_2.TextColor = Rgb(0, 0, 0)
is_flag = '3'

Parent.Post Event ue_retrieve()


end event

type gb_1 from groupbox within w_sh111_d
integer x = 18
integer y = 140
integer width = 983
integer height = 200
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

