$PBExportHeader$w_51009_chk.srw
$PBExportComments$행사계획서 일괄 등록
forward
global type w_51009_chk from window
end type
type em_2 from editmask within w_51009_chk
end type
type em_1 from editmask within w_51009_chk
end type
type st_2 from statictext within w_51009_chk
end type
type st_1 from statictext within w_51009_chk
end type
type dw_head_1 from datawindow within w_51009_chk
end type
type dw_1 from datawindow within w_51009_chk
end type
type cb_4 from commandbutton within w_51009_chk
end type
type dw_body from datawindow within w_51009_chk
end type
type dw_list from datawindow within w_51009_chk
end type
type cb_3 from commandbutton within w_51009_chk
end type
type cb_1 from commandbutton within w_51009_chk
end type
type cb_2 from commandbutton within w_51009_chk
end type
type dw_head_2 from datawindow within w_51009_chk
end type
end forward

global type w_51009_chk from window
integer x = 402
integer y = 400
integer width = 3360
integer height = 1776
boolean titlebar = true
string title = "행사계획 일괄등록"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
em_2 em_2
em_1 em_1
st_2 st_2
st_1 st_1
dw_head_1 dw_head_1
dw_1 dw_1
cb_4 cb_4
dw_body dw_body
dw_list dw_list
cb_3 cb_3
cb_1 cb_1
cb_2 cb_2
dw_head_2 dw_head_2
end type
global w_51009_chk w_51009_chk

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_dep_seq
String is_brand, is_frm_ymd, is_to_ymd, is_shop_cd, is_yymmdd, IS_CANCEL_YN, is_shop_div
long           il_rows               /* retrieve, update, insertrow, deleterow.... Return Value */
dwitemstatus	idw_status            /* DataWindow item status */
end variables

on w_51009_chk.create
this.em_2=create em_2
this.em_1=create em_1
this.st_2=create st_2
this.st_1=create st_1
this.dw_head_1=create dw_head_1
this.dw_1=create dw_1
this.cb_4=create cb_4
this.dw_body=create dw_body
this.dw_list=create dw_list
this.cb_3=create cb_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_head_2=create dw_head_2
this.Control[]={this.em_2,&
this.em_1,&
this.st_2,&
this.st_1,&
this.dw_head_1,&
this.dw_1,&
this.cb_4,&
this.dw_body,&
this.dw_list,&
this.cb_3,&
this.cb_1,&
this.cb_2,&
this.dw_head_2}
end on

on w_51009_chk.destroy
destroy(this.em_2)
destroy(this.em_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_head_1)
destroy(this.dw_1)
destroy(this.cb_4)
destroy(this.dw_body)
destroy(this.dw_list)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_head_2)
end on

event open;long ll_acnt


dw_list.SetTransObject(SQLCA)
dw_head_1.SetTransObject(SQLCA)
dw_head_2.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_head_2.InsertRow(0)

dw_list.retrieve('%','%')
ll_acnt = dw_list.rowcount()
em_1.text = string(ll_acnt,'#,##0')

dw_head_1.setfocus()

dw_body.insertrow(0)
end event

type em_2 from editmask within w_51009_chk
integer x = 1934
integer y = 36
integer width = 261
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_1 from editmask within w_51009_chk
integer x = 1321
integer y = 36
integer width = 261
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_51009_chk
integer x = 1600
integer y = 44
integer width = 343
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "선택 매장수:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_51009_chk
integer x = 1042
integer y = 44
integer width = 288
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "총 매장수:"
boolean focusrectangle = false
end type

type dw_head_1 from datawindow within w_51009_chk
integer y = 16
integer width = 910
integer height = 104
integer taborder = 10
string title = "none"
string dataobject = "d_51009_h01_chk"
boolean border = false
boolean livescroll = true
end type

event constructor;DataWindowChild ldw_brand

dw_head_1.GetChild("inter_cd", ldw_brand)
dw_head_1.SetTransObject(SQLCA)
dw_head_1.Retrieve('001')

dw_head_1.InsertRow(1)
dw_head_1.setitem(1,'inter_cd','브랜드전체')

//This.GetChild("brand", idw_brand)
//dw_head_1.SetTransObject(SQLCA)
//dw_head_1.Retrieve('001')
end event

event itemchanged;dw_head_1.accepttext()

is_brand = dw_head_1.getitemstring(1,'inter_cd')


end event

type dw_1 from datawindow within w_51009_chk
event ue_keydown pbm_dwnkey
integer x = 1056
integer y = 952
integer width = 2286
integer height = 720
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_51009_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 1999.11.08                                                  */	
///* 수정일      : 1999.11.08                                                  */
///*===========================================================================*/
//
//String ls_column_name, ls_tag, ls_report
//
//ls_column_name = This.GetColumnName()
//
//IF KeyDown(21) THEN
//	ls_tag = This.Describe(ls_column_name + ".Tag")
//	gf_kor_eng(Handle(Parent), ls_tag, 2)
//END IF
//
//CHOOSE CASE key
//	CASE KeyEnter!
//		IF ls_column_name = "dep_seq" THEN 
//			IF This.GetRow() = This.RowCount() THEN
//			il_rows = This.InsertRow(0)				
//			This.SetColumn(il_rows)
//		   END IF
//		END IF
//		Send(Handle(This), 256, 9, long(0,0))
//		Return 1
//	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
//		Return 1
//   CASE KeyF12!
//      char lc_kb[256]
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (128)
//      SetKeyboardState (lc_kb)
//      Send (Handle (this), 256, 9, 0)
//      GetKeyboardState (lc_kb)
//      lc_kb[17] = Char (0)
//      SetKeyboardState (lc_kb)
//	CASE KeyF1!
//		// Column.Protect = True Then Return
//		ls_report = This.Describe(ls_column_name + ".Protect")
//		IF ls_report = "1" THEN RETURN 0 
//		ls_report = Mid(ls_report, 4, Len(ls_report) - 4)
//		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
//								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
//		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
//END CHOOSE
//
//Return 0
//
end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg
Long ll_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "add"
			il_rows = This.InsertRow(0)				
			This.SetColumn(il_rows)
	Case "delete"
		ll_row = This.GetRow()
		if ll_row <= 0 then return

		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
//		Parent.Trigger Event ue_button (4, il_rows)
End Choose

end event

event clicked;//
//CHOOSE CASE dwo.name
//
//	CASE "year"  	     //  Popup 검색창이 존재하는 항목 
//		ib_changed = true
//		cb_update.enabled = true
//		cb_print.enabled = false
//		cb_preview.enabled = false
//		cb_excel.enabled = false
//
//   case  "season" 
//		ib_changed = true
//		cb_update.enabled = true
//		cb_print.enabled = false
//		cb_preview.enabled = false
//		cb_excel.enabled = false
//		
//	case 	"dep_seq"
//		ib_changed = true
//		cb_update.enabled = true
//		cb_print.enabled = false
//		cb_preview.enabled = false
//		cb_excel.enabled = false
//
//
//END CHOOSE
//
//
//
end event

event constructor;string ls_year
datetime ld_datetime

is_brand = dw_head_1.getitemstring(1,'inter_cd')

SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', is_brand, ls_year)

//This.GetChild("dep_seq", idw_dep_seq)
//idw_dep_seq.SetTRansObject(SQLCA)
//idw_dep_seq.Retrieve('%','%','%')




end event

event editchanged;//ib_changed = true
//cb_update.enabled = true
//cb_print.enabled = false
//cb_preview.enabled = false
//cb_excel.enabled = false
//
end event

event itemfocuschanged;String ls_year, ls_season

CHOOSE CASE dwo.name
	CASE "dep_seq"
		ls_year = This.GetitemString(row, "year")
		ls_season  = This.GetitemString(row, "season")
		This.GetChild("dep_seq", idw_dep_seq)
		idw_dep_seq.SetTRansObject(SQLCA)		
		idw_dep_seq.Retrieve(is_brand, ls_year, ls_season)

END CHOOSE

end event

event itemchanged;string ls_year
datetime ld_datetime

CHOOSE CASE dwo.name
	CASE "brand", "year"		
			//라빠레트 시즌적용
			dw_head_1.accepttext()
			is_brand = dw_head_1.getitemstring(1,'inter_cd')

			SELECT GetDate()
			  INTO :ld_datetime
			  FROM DUAL ;
			
			GF_CURR_YEAR(ld_datetime, ls_year)
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, ls_year)
END CHOOSE
end event

type cb_4 from commandbutton within w_51009_chk
integer x = 27
integer y = 228
integer width = 238
integer height = 68
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전체선택"
end type

event clicked;long ll_cnt, ll_acnt

if cb_4.text = '전체선택' then
	dw_list.scrolltorow(0)
	for ll_cnt =1 to dw_list.rowcount()
		 dw_list.setitem(ll_cnt,'cbit','0')
		 dw_list.ScrollNextRow()
		 SetPointer(HourGlass!)
	next	
	ll_acnt = dw_list.rowcount()
	em_1.text = string(ll_acnt,'#,##0')
	dw_list.accepttext()
	em_2.text = string(dw_list.GetItemNumber(1, 'sum_check'),'#,##0')
	cb_4.text = '전체해지'
else
	dw_list.scrolltorow(0)
	for ll_cnt =1 to dw_list.rowcount()
		 dw_list.setitem(ll_cnt,'cbit','1')
		 dw_list.ScrollNextRow()
		 SetPointer(HourGlass!)
	em_2.text = string('0')
	next
	cb_4.text = '전체선택'
end if

end event

type dw_body from datawindow within w_51009_chk
integer x = 1056
integer y = 212
integer width = 2286
integer height = 728
integer taborder = 20
string dataobject = "d_51009_d02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_season, ldw_year
string ls_year
datetime ld_datetime

This.GetChild("fr_year", ldw_year)
ldw_year.SetTransObject(SQLCA)
ldw_year.Retrieve('002')
ldw_year.InsertRow(1)
ldw_year.SetItem(1, "inter_cd", '%')
ldw_year.SetItem(1, "inter_cd1", '%')
ldw_year.SetItem(1, "inter_nm", '전체')

is_brand = dw_head_1.getitemstring(1,'inter_cd')

SELECT GetDate()
  INTO :ld_datetime
  FROM DUAL ;

GF_CURR_YEAR(ld_datetime, ls_year)

This.GetChild("fr_season", ldw_season)
ldw_season.SetTransObject(SQLCA)
ldw_season.Retrieve('003', is_brand, ls_year)
ldw_season.InsertRow(1)
ldw_season.SetItem(1, "inter_cd", '%')
ldw_season.SetItem(1, "inter_nm", '전체')



end event

event itemchanged;string ls_year
datetime ld_datetime

CHOOSE CASE dwo.name
	CASE "brand", "fr_year"		
			//라빠레트 시즌적용
			dw_head_1.accepttext()
			is_brand = dw_head_1.getitemstring(1,'inter_cd')

			SELECT GetDate()
			  INTO :ld_datetime
			  FROM DUAL ;
			
			GF_CURR_YEAR(ld_datetime, ls_year)
			
			this.getchild("fr_season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, ls_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
END CHOOSE
end event

type dw_list from datawindow within w_51009_chk
integer x = 9
integer y = 212
integer width = 1042
integer height = 1460
integer taborder = 30
string title = "none"
string dataobject = "D_51009_D01_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow < 1 then return
this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

event clicked;string ls_cbit
if row < 1 then return
ls_cbit = dw_list.getitemstring(row,'cbit')
if ls_cbit = '0' then 
	 dw_list.setitem(row,'cbit','1')
else
	 dw_list.setitem(row,'cbit','0')
end if

dw_list.accepttext()
em_2.text = string(dw_list.GetItemNumber(1, 'sum_check'),'#,##0')

end event

type cb_3 from commandbutton within w_51009_chk
integer x = 2254
integer y = 24
integer width = 366
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회"
end type

event clicked;string ls_brand, ls_shop_div
long ll_acnt, ll_ccnt

dw_list.accepttext()
em_2.text = '0'

ls_brand = dw_head_1.GetItemString(1, 'inter_cd')
ls_shop_div = dw_head_2.GetItemString(1, 'shop_div')



if ls_brand = '브랜드전체' then
	dw_list.retrieve('%', ls_shop_div)
else
	dw_list.retrieve(ls_brand, ls_shop_div)
end if
ll_acnt = dw_list.rowcount()

em_1.text = string(ll_acnt,'#,##0')

if cb_4.text = '전체해지' then
	cb_4.text = '전체선택'
end if

dw_body.Reset()
dw_body.insertrow(0)
dw_body.setitem(1,'frm_ymd', MidA(string(today(),'YYYYMM'),1,6)+'01')
dw_body.setitem(1,'to_ymd','')
dw_body.setitem(1,'plan_amt',0)
dw_body.setitem(1,'sale_scale','')
dw_body.setitem(1,'note','')
dw_body.setitem(1,'dep_parti','')
dw_body.setitem(1,'plan_parti','')
dw_body.setitem(1,'cancle','N')

dw_1.Reset()


end event

type cb_1 from commandbutton within w_51009_chk
integer x = 2615
integer y = 24
integer width = 366
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장"
end type

event clicked;long ll_cnt, ll_cnt2, ll_cnt3
decimal ld_plan_amt
integer Net
string ls_brand, ls_shop_cd, ls_frm_ymd, ls_to_ymd, ls_sale_scale, ls_note, ls_dep_parti, ls_plan_parti
string ls_fr_year, ls_fr_season, ls_cancle, ls_year, ls_season, ls_no, ls_brand_chk, ls_frm_ymd_chk, ls_shop_cd_chk
int li_no
datetime ld_datetime

dw_list.accepttext()
dw_body.accepttext()
dw_1.accepttext()

ls_brand			= dw_head_1.getitemstring(1, 'inter_cd')
ls_frm_ymd		= dw_body.getitemstring(1, 'frm_ymd')
ls_to_ymd		= dw_body.getitemstring(1, 'to_ymd')
ld_plan_amt		= dw_body.getitemnumber(1, 'plan_amt')
ls_sale_scale 	= dw_body.getitemstring(1, 'sale_scale')
ls_note			= dw_body.getitemstring(1, 'note')
ls_dep_parti	= dw_body.getitemstring(1, 'dep_parti')
ls_plan_parti	= dw_body.getitemstring(1, 'plan_parti')
ls_fr_year		= dw_body.getitemstring(1, 'fr_year')
ls_fr_season	= dw_body.getitemstring(1, 'fr_season')


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

if gf_datechk(ls_frm_ymd) = false then
	messagebox("경고!", "시작일자가 형식에 맞지 않습니다!")
	Return 0
end if	

if gf_datechk(ls_to_ymd) = false then
	messagebox("경고!", "마지막일자가 형식에 맞지 않습니다!")
	Return 0
end if	

if ls_brand = '브랜드전체' then 
	messagebox('확인','브랜드 전체에 행사내용을 동일 적용이 안됩니다!!!')
	return 0
elseif isnull(ls_brand) or ls_brand = '' then
	messagebox('확인','선택된 브랜드가 없습니다!')
	return 0
elseif dw_1.rowcount() = 0 or isnull(dw_1.rowcount()) then
	messagebox('확인','진행시즌을 추가해 주세요!')	
	return 0
else
	Net = MessageBox('확인', '총 매장수:' + em_1.text + '건 중 선택 매장수:' + em_2.text + '건이 맞습니까?', Exclamation!, OKCancel!, 2)
	IF Net = 1 THEN 	
	 // OK 처리	
 		for ll_cnt = 1 to dw_list.rowcount()
			if dw_list.getitemstring(ll_cnt, 'cbit') = '0' then
				ls_shop_cd = dw_list.getitemstring(ll_cnt, 'shop_cd')
				if ls_brand <> MidA(ls_shop_cd,1,1) then
					messagebox('확인','브랜드를 확인해 주세요!')
					return 0					
				end if				
				select count(*)
				into   :ll_cnt3
				from TB_51035_H
				where brand = :ls_brand and
						shop_cd = :ls_shop_cd and
						frm_ymd = :ls_frm_ymd;
						
				//같은 날에 행사 못들어감을 체크
				if ll_cnt3 < 1 then
					//인서트 구문
					insert into TB_51035_H	(SHOP_CD,			FRM_YMD,			TO_YMD,			 BRAND,		  SALE_TYPE, PLAN_AMT,
													 SALE_SCALE,		DEP_PARTI,		PLAN_PARTI,		 NOTE,		  CANCEL,	  REG_ID,
													 REG_DT,				mod_id,			mod_dt,			 FR_YEAR,	  FR_SEASON)
										values	(:ls_shop_cd,		:ls_frm_ymd,	:ls_to_ymd,		 :ls_brand,	  '',		  :ld_plan_amt,
													 :ls_sale_scale,	:ls_dep_parti,	:ls_plan_parti, :ls_note,	  'N',		  :gs_user_id,
													 :ld_datetime,		'',				'',				 :ls_fr_year, :ls_fr_season);
													 
					for ll_cnt2 = 1 to dw_1.rowcount()
						if dw_1.rowcount() > 0 then
							//매장별 순번가져오기
							select convert(int,	isnull(max(no), '0')) + 1
							into :li_no 
							from tb_51036_d (nolock)
							where shop_cd = :ls_shop_cd	and
									frm_ymd = :ls_frm_ymd	and
									to_ymd  = :ls_to_ymd;
							ls_no			= string(li_no, '0000')
							ls_year		= dw_1.getitemstring(ll_cnt2, 'year')
							ls_season	= dw_1.getitemstring(ll_cnt2, 'season')
							
							insert into TB_51036_d (shop_cd, 	 frm_ymd, 	  to_ymd, 	  no, 	 year, 	  season, 		
															brand, 	    reg_id,		  reg_dt)
												values  (:ls_shop_cd, :ls_frm_ymd, :ls_to_ymd, :ls_no, :ls_year, :ls_season,	
															:ls_brand,   :gs_user_id, :ld_datetime);
						end if
					next
				elseif ll_cnt3 >= 1 then
					messagebox('error','행사기간 시작일자가 중복되었습니다. 확인후 다시 실행해 주세요!')			
					return
				end if				
			end if		
		next	
		
		if (SQLCA.SQLCODE<> 0) then
			messagebox('error','일괄 등록중 에러가 발생하였습니다. 관리자에게 문의 하십시오!')			
			rollback  USING SQLCA;
		else
			commit  USING SQLCA;
		end if
	ELSE
		messagebox('error','일괄 등록중 에러가 발생하였습니다. 관리자에게 문의 하십시오!')
		return
	END IF	
end if

messagebox('확인','일괄 등록이 완료 되었습니다.')
end event

type cb_2 from commandbutton within w_51009_chk
integer x = 2976
integer y = 24
integer width = 366
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기"
end type

event clicked;close(parent)
end event

type dw_head_2 from datawindow within w_51009_chk
integer y = 108
integer width = 910
integer height = 104
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_51009_h02_chk"
boolean border = false
boolean livescroll = true
end type

event constructor;DataWindowChild ldw_shop_div

dw_head_2.GetChild("shop_div", ldw_shop_div)
ldw_shop_div.SetTransObject(SQLCA)
ldw_shop_div.Retrieve('910')
ldw_shop_div.InsertRow(1)
ldw_shop_div.SetItem(1, "inter_cd", '%')
ldw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event itemchanged;dw_head_2.accepttext()

is_shop_div = dw_head_2.getitemstring(1,'shop_div')


end event

