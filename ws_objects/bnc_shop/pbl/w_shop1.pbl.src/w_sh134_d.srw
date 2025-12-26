$PBExportHeader$w_sh134_d.srw
$PBExportComments$판매순위
forward
global type w_sh134_d from w_com010_d
end type
type st_1 from statictext within w_sh134_d
end type
type st_2 from statictext within w_sh134_d
end type
end forward

global type w_sh134_d from w_com010_d
integer width = 2953
integer height = 2072
st_1 st_1
st_2 st_2
end type
global w_sh134_d w_sh134_d

type variables
string is_fr_ymd, is_to_ymd
end variables

on w_sh134_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_sh134_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title
integer li_datediff


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


if gs_brand = "N" then
	st_1.text = "＊매장순위 기준 : 당일 조회, 매장매출 정상 행사 닷컴 전체."
	st_2.text = " "// "＊품번TPO15기준 : 당일 조회, 정상+기획(기회행사제외) 판매분."	
else	
	st_1.text = "＊기준 : 전일 조회, 정상+세일 판매분."
	st_2.text = "＊기간별 조회 가능합니다.(최대 일주일)"	
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


//if gs_brand = 'N' then
//	if gs_shop_cd <> "NG0008" then
//		MessageBox(ls_title,"올리브 매장만 사용이 가능합니다!")
//		return false
//	end if	
//end if


select datediff(day, :is_fr_ymd, :is_to_ymd)
into :li_datediff
from dual;

if gs_brand <> "N" then
	IF li_datediff > 7 THEN
		MessageBox(ls_title,"일주일 이상은 조회할수 없습니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("to_ymd")
		return false
	end if
else	
	IF li_datediff >= 1 THEN
		MessageBox(ls_title,"온앤온의 경우 기간으로 조회할 수 없습니다!")
		dw_head.SetFocus()
		dw_head.SetColumn("to_ymd")
		dw_head.SetItem(1, "to_ymd", is_fr_ymd)
		return false
	end if
end if


return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_brand, is_fr_ymd, is_to_ymd)
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

event open;call super::open;string ls_today, ls_yesterday
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_today = string(ld_datetime,"yyyymmdd")

if gs_brand = "N" then

  select convert(char(08), dateadd(day, 0, :ls_today),112)
	into :ls_yesterday
   from dual;  
	
	dw_head.setitem(1, "fr_ymd", ls_yesterday)	  
	dw_head.setitem(1, "to_ymd", ls_yesterday)	
	
	dw_head.object.fr_ymd.protect = 1
	dw_head.object.to_ymd.protect = 1	

	
else 

 select convert(char(08), dateadd(day, -1, :ls_today),112)
 into :ls_yesterday
 from dual;  
 
 dw_head.setitem(1, "fr_ymd", ls_yesterday)	  
 dw_head.setitem(1, "to_ymd", ls_yesterday)
 
end if 

	  


end event

event pfc_postopen();call super::pfc_postopen;This.Trigger Event ue_Retrieve()
end event

type cb_close from w_com010_d`cb_close within w_sh134_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh134_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh134_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh134_d
end type

type cb_update from w_com010_d`cb_update within w_sh134_d
end type

type cb_print from w_com010_d`cb_print within w_sh134_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh134_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh134_d
end type

type dw_head from w_com010_d`dw_head within w_sh134_d
integer height = 132
string dataobject = "d_sh134_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_sh134_d
integer beginx = 9
integer beginy = 328
integer endx = 2889
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_sh134_d
integer beginx = 9
integer beginy = 332
integer endx = 2889
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_sh134_d
integer y = 344
integer width = 2857
integer height = 1492
string dataobject = "d_sh134_d03"
end type

type dw_print from w_com010_d`dw_print within w_sh134_d
end type

type st_1 from statictext within w_sh134_d
integer x = 1211
integer y = 176
integer width = 1943
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "＊기준 : 전일 조회, 정상+세일 판매분."
boolean focusrectangle = false
end type

type st_2 from statictext within w_sh134_d
integer x = 1211
integer y = 244
integer width = 2021
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "＊기간별 조회 가능합니다.(최대 일주일)"
boolean focusrectangle = false
end type

