$PBExportHeader$w_12027_d.srw
$PBExportComments$디자인진행 그래프
forward
global type w_12027_d from w_com010_d
end type
type rb_1 from radiobutton within w_12027_d
end type
type rb_2 from radiobutton within w_12027_d
end type
type rb_3 from radiobutton within w_12027_d
end type
type cbx_1 from checkbox within w_12027_d
end type
type cbx_2 from checkbox within w_12027_d
end type
type cbx_3 from checkbox within w_12027_d
end type
type cbx_4 from checkbox within w_12027_d
end type
type cbx_5 from checkbox within w_12027_d
end type
type cbx_6 from checkbox within w_12027_d
end type
type cbx_7 from checkbox within w_12027_d
end type
type cbx_8 from checkbox within w_12027_d
end type
type cbx_9 from checkbox within w_12027_d
end type
type cbx_10 from checkbox within w_12027_d
end type
type cbx_11 from checkbox within w_12027_d
end type
type cbx_12 from checkbox within w_12027_d
end type
type cbx_13 from checkbox within w_12027_d
end type
type cbx_14 from checkbox within w_12027_d
end type
end forward

global type w_12027_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
cbx_7 cbx_7
cbx_8 cbx_8
cbx_9 cbx_9
cbx_10 cbx_10
cbx_11 cbx_11
cbx_12 cbx_12
cbx_13 cbx_13
cbx_14 cbx_14
end type
global w_12027_d w_12027_d

type variables
string is_brand, is_yymmdd, is_yymm, is_team_cd, is_team_cd_grp

datawindowchild idw_brand, idw_team_cd
end variables

forward prototypes
public subroutine wf_team_cd_chk ()
end prototypes

public subroutine wf_team_cd_chk ();

is_team_cd_grp = ''    // 초기화 작업	

if  cbx_1.checked = enabled then 
	 is_team_cd_grp = 'A'   // 샘플작지
end if
if  cbx_2.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'B'  // 패턴제작
end if
if  cbx_3.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'C'  // 가봉제작
end if
if  cbx_4.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'D'  // 디자인수정
end if
if  cbx_5.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'E'  // 패턴수정
end if
if  cbx_6.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'F'  // 샘플완성
end if
if  cbx_7.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'G'  // 품평
end if
if  cbx_8.checked = enabled then  
	 is_team_cd_grp = is_team_cd_grp + 'H'  // 디자인완봉
end if
if  cbx_9.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'I'  // 패턴완봉 
end if
if  cbx_10.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'J'  // 패턴제작
end if
if  cbx_11.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'K'  // 가봉제작
end if
if  cbx_12.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'L'  // 패턴수정
end if
if  cbx_13.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'M'  // 샘플완성
end if
if  cbx_14.checked = enabled then 
	 is_team_cd_grp = is_team_cd_grp + 'N'  // 품평
end if




end subroutine

on w_12027_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.cbx_7=create cbx_7
this.cbx_8=create cbx_8
this.cbx_9=create cbx_9
this.cbx_10=create cbx_10
this.cbx_11=create cbx_11
this.cbx_12=create cbx_12
this.cbx_13=create cbx_13
this.cbx_14=create cbx_14
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.cbx_3
this.Control[iCurrent+7]=this.cbx_4
this.Control[iCurrent+8]=this.cbx_5
this.Control[iCurrent+9]=this.cbx_6
this.Control[iCurrent+10]=this.cbx_7
this.Control[iCurrent+11]=this.cbx_8
this.Control[iCurrent+12]=this.cbx_9
this.Control[iCurrent+13]=this.cbx_10
this.Control[iCurrent+14]=this.cbx_11
this.Control[iCurrent+15]=this.cbx_12
this.Control[iCurrent+16]=this.cbx_13
this.Control[iCurrent+17]=this.cbx_14
end on

on w_12027_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.cbx_7)
destroy(this.cbx_8)
destroy(this.cbx_9)
destroy(this.cbx_10)
destroy(this.cbx_11)
destroy(this.cbx_12)
destroy(this.cbx_13)
destroy(this.cbx_14)
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif  ( gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U') and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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

is_team_cd = dw_head.GetItemString(1, "team_cd")
if IsNull(is_team_cd) or Trim(is_team_cd) = "" then
  is_team_cd = "A"
end if



is_yymmdd = dw_head.GetItemString(1, "yymmdd")
is_yymm = LeftA(is_yymmdd,6)

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if rb_3.checked = true then
	wf_team_cd_chk()
	il_rows = dw_body.retrieve(is_brand, is_yymm, is_team_cd_grp)
else
	il_rows = dw_body.retrieve(is_brand, is_yymmdd)
end if


IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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
//         cb_retrieve.Text = "조건(&Q)"
//         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
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
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12027_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12027_d
end type

type cb_delete from w_com010_d`cb_delete within w_12027_d
end type

type cb_insert from w_com010_d`cb_insert within w_12027_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12027_d
end type

type cb_update from w_com010_d`cb_update within w_12027_d
end type

type cb_print from w_com010_d`cb_print within w_12027_d
end type

type cb_preview from w_com010_d`cb_preview within w_12027_d
end type

type gb_button from w_com010_d`gb_button within w_12027_d
end type

type cb_excel from w_com010_d`cb_excel within w_12027_d
end type

type dw_head from w_com010_d`dw_head within w_12027_d
integer x = 23
integer y = 176
integer width = 2775
integer height = 116
string dataobject = "d_12027_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("team_cd", idw_team_cd)
idw_team_cd.SetTransObject(SQLCA)
idw_team_cd.Retrieve('993')
end event

type ln_1 from w_com010_d`ln_1 within w_12027_d
integer beginy = 464
integer endy = 464
end type

type ln_2 from w_com010_d`ln_2 within w_12027_d
integer beginy = 468
integer endy = 468
end type

type dw_body from w_com010_d`dw_body within w_12027_d
integer y = 480
integer height = 1564
string dataobject = "d_12027_d01"
end type

type dw_print from w_com010_d`dw_print within w_12027_d
integer x = 151
integer y = 728
string dataobject = "d_12027_d01"
end type

type rb_1 from radiobutton within w_12027_d
integer x = 2880
integer y = 184
integer width = 603
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
string text = "전체단계(선그래프)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor      = RGB(0, 0, 255)
rb_2.TextColor  = RGB(0, 0, 0)
rb_3.TextColor  = RGB(0, 0, 0)


dw_body.DataObject = 'd_12027_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_12027_d01'
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()

end event

type rb_2 from radiobutton within w_12027_d
integer x = 2880
integer y = 256
integer width = 663
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
string text = "전체단계(막대그래프)"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor      = RGB(0, 0, 255)
rb_1.TextColor  = RGB(0, 0, 0)
rb_3.TextColor  = RGB(0, 0, 0)

dw_body.DataObject = 'd_12027_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_12027_d02'
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()
end event

type rb_3 from radiobutton within w_12027_d
integer x = 2880
integer y = 336
integer width = 645
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
string text = "특정단계일자별보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor      = RGB(0, 0, 255)
rb_1.TextColor  = RGB(0, 0, 0)
rb_2.TextColor  = RGB(0, 0, 0)

dw_body.DataObject = 'd_12027_d03'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_12027_d03'
dw_print.SetTransObject(SQLCA)

trigger event ue_retrieve()

end event

type cbx_1 from checkbox within w_12027_d
integer x = 41
integer y = 300
integer width = 379
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
string text = "샘플작지"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_12027_d
integer x = 430
integer y = 300
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
string text = "패턴제작"
borderstyle borderstyle = stylelowered!
end type

type cbx_3 from checkbox within w_12027_d
integer x = 800
integer y = 304
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
string text = "가봉제작"
borderstyle borderstyle = stylelowered!
end type

type cbx_4 from checkbox within w_12027_d
integer x = 1189
integer y = 300
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
string text = "디자인수정"
borderstyle borderstyle = stylelowered!
end type

type cbx_5 from checkbox within w_12027_d
integer x = 1618
integer y = 300
integer width = 329
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
string text = "패턴수정"
borderstyle borderstyle = stylelowered!
end type

type cbx_6 from checkbox within w_12027_d
integer x = 2043
integer y = 308
integer width = 329
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
string text = "샘플완성"
borderstyle borderstyle = stylelowered!
end type

type cbx_7 from checkbox within w_12027_d
integer x = 2450
integer y = 300
integer width = 325
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
string text = "품평"
borderstyle borderstyle = stylelowered!
end type

type cbx_8 from checkbox within w_12027_d
integer x = 41
integer y = 384
integer width = 379
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
string text = "디자인완봉"
borderstyle borderstyle = stylelowered!
end type

type cbx_9 from checkbox within w_12027_d
integer x = 430
integer y = 384
integer width = 320
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
string text = "패턴완봉"
borderstyle borderstyle = stylelowered!
end type

type cbx_10 from checkbox within w_12027_d
integer x = 800
integer y = 388
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
string text = "QC투입"
borderstyle borderstyle = stylelowered!
end type

type cbx_11 from checkbox within w_12027_d
integer x = 1189
integer y = 384
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
string text = "QC입고"
borderstyle borderstyle = stylelowered!
end type

type cbx_12 from checkbox within w_12027_d
integer x = 1618
integer y = 384
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
string text = "QC수정"
borderstyle borderstyle = stylelowered!
end type

type cbx_13 from checkbox within w_12027_d
integer x = 2043
integer y = 392
integer width = 329
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
string text = "CAD접수"
borderstyle borderstyle = stylelowered!
end type

type cbx_14 from checkbox within w_12027_d
integer x = 2450
integer y = 384
integer width = 325
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
string text = "CAD완료"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

