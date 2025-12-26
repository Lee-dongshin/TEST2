$PBExportHeader$w_42049_e.srw
$PBExportComments$DAS데이터 생성
forward
global type w_42049_e from w_com020_e
end type
type dw_1 from datawindow within w_42049_e
end type
type st_2 from statictext within w_42049_e
end type
type rb_style from radiobutton within w_42049_e
end type
type rb_shop from radiobutton within w_42049_e
end type
type rb_style_no from radiobutton within w_42049_e
end type
type rb_yearseason from radiobutton within w_42049_e
end type
end forward

global type w_42049_e from w_com020_e
integer width = 3680
integer height = 2276
dw_1 dw_1
st_2 st_2
rb_style rb_style
rb_shop rb_shop
rb_style_no rb_style_no
rb_yearseason rb_yearseason
end type
global w_42049_e w_42049_e

type variables
DataWindowChild idw_brand, idw_deal_fg
String is_brand, is_yymmdd,  is_deal_fg, is_work_yn, ls_print = '1',is_deal_fg1
integer ii_deal_seq
end variables

on w_42049_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.rb_style=create rb_style
this.rb_shop=create rb_shop
this.rb_style_no=create rb_style_no
this.rb_yearseason=create rb_yearseason
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_style
this.Control[iCurrent+4]=this.rb_shop
this.Control[iCurrent+5]=this.rb_style_no
this.Control[iCurrent+6]=this.rb_yearseason
end on

on w_42049_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.rb_style)
destroy(this.rb_shop)
destroy(this.rb_style_no)
destroy(this.rb_yearseason)
end on

event pfc_preopen();call super::pfc_preopen;//inv_resize.of_Register(dw_1, "ScaleToRight")
dw_1.InsertRow(0)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_work_yn	= dw_head.GetItemString(1, "work_yn")
if IsNull(is_work_yn) or Trim(is_work_yn) = "" then
   MessageBox(ls_title,"작업여부를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("work_yn")
   return false
end if


is_deal_fg = dw_head.GetItemString(1, "deal_fg")
if IsNull(is_deal_fg) or Trim(is_deal_fg) = "" then
	MessageBox(ls_title,"배분구분을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("deal_fg")
	return false
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_yymmdd, II_DEAL_SEQ, is_deal_fg, is_work_yn)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_print();
This.Trigger Event ue_title()


//ii_deal_seq = dw_head.GetItemNumber(1, 'deal_seq')


dw_print.retrieve(is_brand, is_yymmdd, is_deal_fg, is_yymmdd, ii_deal_seq)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();

This.Trigger Event ue_title ()

ii_deal_seq = dw_head.GetItemNumber(1, 'deal_seq')

il_rows = dw_print.retrieve(is_brand, is_yymmdd, is_deal_fg , is_yymmdd, ii_deal_seq)

IF il_rows = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
ELSE
	dw_print.inv_printpreview.of_SetZoom()
END IF

This.Trigger Event ue_msg(6, il_rows)


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

Choose Case ls_print
	Case '1'
		dw_print.DataObject = 'd_42049_r01'
	Case '2'
		dw_print.DataObject = 'd_42049_r02'
	Case '3'
		dw_print.DataObject = 'd_42049_r03'		
	Case '4'
		dw_print.DataObject = 'd_42049_r04'		
		
End Choose

dw_print.SetTransObject(SQLCA)

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_out_ymd.Text  = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_yymmdd.Text   = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_deal_fg.Text  = '" + idw_deal_fg.GetItemString(idw_deal_fg.GetRow(), "inter_display") + "'" + &
            "t_work_no.Text  = '" + String(ii_deal_seq) + "'"

dw_print.Modify(ls_modify)

end event

type cb_close from w_com020_e`cb_close within w_42049_e
end type

type cb_delete from w_com020_e`cb_delete within w_42049_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_42049_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_42049_e
end type

type cb_update from w_com020_e`cb_update within w_42049_e
boolean visible = false
end type

type cb_print from w_com020_e`cb_print within w_42049_e
integer x = 1760
end type

type cb_preview from w_com020_e`cb_preview within w_42049_e
integer x = 2103
end type

type gb_button from w_com020_e`gb_button within w_42049_e
end type

type cb_excel from w_com020_e`cb_excel within w_42049_e
integer x = 2446
end type

type dw_head from w_com020_e`dw_head within w_42049_e
integer y = 172
integer width = 2267
string dataobject = "D_42049_H01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg )
idw_deal_fg.SetTransObject(SQLCA)
idw_deal_fg.Retrieve('521')
idw_deal_fg.insertrow(1)
idw_deal_fg.Setitem(1, "inter_cd", "%")
idw_deal_fg.Setitem(1, "inter_nm", "전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com020_e`ln_1 within w_42049_e
end type

type ln_2 from w_com020_e`ln_2 within w_42049_e
end type

type dw_list from w_com020_e`dw_list within w_42049_e
integer width = 955
string dataobject = "D_42049_D01"
end type

event dw_list::clicked;call super::clicked;
IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ii_deal_seq = This.GetItemNumber(row, 'deal_seq') /* DataWindow에 Key 항목을 가져온다 */
is_deal_fg  = This.GetItemString(row, 'deal_fg') /* DataWindow에 Key 항목을 가져온다 */
is_deal_fg1  = This.GetItemString(row, 'deal_fg') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ii_deal_seq) or ii_deal_seq < 0 tHEN 
	return
else	
   dw_head.setitem(1, "deal_seq", ii_deal_seq)
end if

il_rows = dw_body.retrieve(is_brand ,is_yymmdd, ii_deal_seq, is_deal_fg, is_work_yn)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_42049_e
integer x = 997
integer width = 2597
string dataobject = "D_42049_D02"
end type

type st_1 from w_com020_e`st_1 within w_42049_e
integer x = 978
end type

type dw_print from w_com020_e`dw_print within w_42049_e
string dataobject = "d_42049_r01"
end type

type dw_1 from datawindow within w_42049_e
integer x = 27
integer y = 28
integer width = 599
integer height = 120
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "D_42049_D04"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;string ls_yymmdd, ls_out_no, ls_shop_cd, ls_dps_yn,ls_ErrMsg, ls_trx_chk
Integer li_deal_seq, li_work_no, li_rtrn, li_int, li_rtrn1
long    ll_row, II, JJ, KK, ll_ok

CHOOSE CASE dwo.name
//exec sp_42006_d01  'n', '20020204', '1', 1, 'a'		

	CASE "cb_das"	
	parent.Trigger Event ue_keycheck('1') 
	
	
	if IsNull(is_deal_fg) or is_deal_fg = "%"  then
		is_deal_fg = is_deal_fg1
	end if
	
	select  count(*)
	into :ll_ok
	from tb_42020_work with (nolock)
	WHERE rqst_date  = :is_yymmdd
	and   BRAND      = :is_brand
	and   rqst_gubn  = :is_deal_fg
	and   rqst_chno  = :ii_deal_seq
	and   WORK_NO    = :ii_deal_seq;
	
	if ll_ok > 0  then 
		messagebox("경고!" , "이미 생성된 임시전표가 있습니다. 전표취소후 작업하세요!")
		return -1
	else	
	
			select count(*), max(trx_chk)
			into :li_int, :ls_trx_chk
			from beaucre.dbo.tb_52031_WORK with (nolock)
			WHERE YYMMDD   = :is_yymmdd
			and   deal_fg  = :is_deal_fg
			and   WORK_NO  = :ii_deal_seq
			and   BRAND    = :is_brand ;

		 
			if li_int <= 0  then				
				
				  DECLARE SP_42049_PROC1 PROCEDURE FOR SP_42049_PROC  
					  @yymmdd  = :is_yymmdd,		  
					  @brand   = :is_brand,   
					  @deal_fg = :is_deal_fg,   
					  @work_no = :ii_deal_seq;
					  
				  EXECUTE SP_42049_PROC1;
				  
				IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
					commit  USING SQLCA;
					ll_row = 1
				ELSE
					ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
					rollback  USING SQLCA;
					ll_row = -1
					MessageBox("저장 실패[SP]", ls_ErrMsg)
				END IF
						
				IF ll_row > 0 THEN
					dw_body.SetFocus()		
					messagebox("알림!", "데이터가 생성되었습니다!")
				else
					messagebox("알림!", "데이터 생성이 실패했습니다!")
				end if	
				dw_list.retrieve(is_brand, is_yymmdd, 0, is_deal_fg, is_work_yn)
				//dw_head.setitem(1, "deal_seq", -1)
			
			else	
				li_rtrn = messagebox("경고!", "생성된 데이터가 있습니다! 작업을 진행 하시겠습니까?",Question!,OKCancel! )	
				
				if li_rtrn = 1 then
						
					if ls_trx_chk <> '0' then
						li_rtrn1 = messagebox("경고!", "이미 진행 중이거나 완료된 작업입니다. 다시 작업 하시겠습니까?",Question!,OKCancel! )	
					else	
						li_rtrn1 = 0
					end if 
					
						if li_rtrn1 = 1 then
							delete
							from tb_52031_WORK
							WHERE YYMMDD  = :is_yymmdd
							and   deal_fg = :is_deal_fg
							and   work_no = :ii_deal_seq
							and   BRAND   = :is_brand;
							
						else								
 						 messagebox("알림!", "작업이 취소되었습니다!")
						 return -1 
						end if
					 
					  DECLARE SP_42049_PROC2 PROCEDURE FOR SP_42049_PROC  
						  @yymmdd  = :is_yymmdd,		  
						  @brand   = :is_brand,   
						  @deal_fg = :is_deal_fg,   
						  @work_no = :ii_deal_seq;
						  
					  EXECUTE SP_42049_proc2;
					  
					IF SQLCA.SQLCODE = 0 OR SQLCA.SQLCODE = 100 THEN
						commit  USING SQLCA;
						ll_row = 1
					ELSE
						ls_ErrMsg = "[" + String(SQLCA.SQLCODE) + "]" +SQLCA.SQLERRTEXT
						rollback  USING SQLCA;
						ll_row = -1
						MessageBox("저장 실패[SP]", ls_ErrMsg)
					END IF
							
					IF ll_row > 0 THEN
						dw_body.SetFocus()		
						messagebox("알림!", "데이터가 생성되었습니다!")
					else
						messagebox("알림!", "데이터 생성이 실패했습니다!")
					end if	
				else		
				  messagebox("경고!", "작업이 취소되었습니다!")
				end if
				dw_list.retrieve(is_brand, is_yymmdd, 0, is_deal_fg, is_work_yn)
			//			dw_head.setitem(1, "deal_seq", -1)
			end if	
end if


		
END CHOOSE
end event

type st_2 from statictext within w_42049_e
integer x = 535
integer y = 64
integer width = 1198
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
string text = "( 인쇄:                                 )"
boolean focusrectangle = false
end type

type rb_style from radiobutton within w_42049_e
integer x = 791
integer y = 32
integer width = 256
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
string text = "품번별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_shop.TextColor = 0
rb_style_no.TextColor = 0
rb_yearseason.TextColor = 0
ls_print = '1'

end event

type rb_shop from radiobutton within w_42049_e
integer x = 791
integer y = 88
integer width = 256
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
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = 0
rb_style_no.TextColor = 0
This.TextColor = RGB(0, 0, 255)
rb_yearseason.TextColor = 0

ls_print = '2'

end event

type rb_style_no from radiobutton within w_42049_e
integer x = 1093
integer y = 32
integer width = 357
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
string text = "품번차수별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_style.TextColor = 0
rb_shop.TextColor = 0
rb_yearseason.TextColor = 0

ls_print = '3'

end event

type rb_yearseason from radiobutton within w_42049_e
integer x = 1093
integer y = 88
integer width = 357
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
string text = "년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = 0
rb_style_no.TextColor = 0
rb_yearseason.TextColor = 0
This.TextColor = RGB(0, 0, 255)

ls_print = '4'

end event

