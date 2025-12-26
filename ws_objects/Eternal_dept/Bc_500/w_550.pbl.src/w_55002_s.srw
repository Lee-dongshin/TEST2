$PBExportHeader$w_55002_s.srw
$PBExportComments$인기 STYLE 판매 현황
forward
global type w_55002_s from w_com010_d
end type
end forward

global type w_55002_s from w_com010_d
integer width = 2816
integer height = 2140
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_55002_s w_55002_s

on w_55002_s.create
call super::create
end on

on w_55002_s.destroy
call super::destroy
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 2001.12.20                                                  */
/*===========================================================================*/
This.Trigger Event ue_retrieve()

end event

event pfc_preopen;call super::pfc_preopen;dw_head.SetTransObject(SQLCA)

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

			 dw_head.Retrieve(gsv_cd.gs_cd4, gsv_cd.gs_cd5, gsv_cd.gs_cd6)
il_rows = dw_body.Retrieve(gsv_cd.gs_cd1, gsv_cd.gs_cd2, gsv_cd.gs_cd3, gsv_cd.gs_cd4, gsv_cd.gs_cd5, &
									gsv_cd.gs_cd6, gsv_cd.gs_cd7, gsv_cd.gs_cd8, gsv_cd.gs_cd9, gsv_cd.gs_cd10)

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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55002_s","0")
end event

type cb_close from w_com010_d`cb_close within w_55002_s
integer x = 2400
end type

type cb_delete from w_com010_d`cb_delete within w_55002_s
end type

type cb_insert from w_com010_d`cb_insert within w_55002_s
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55002_s
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_55002_s
end type

type cb_print from w_com010_d`cb_print within w_55002_s
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_55002_s
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_55002_s
integer width = 2802
end type

type cb_excel from w_com010_d`cb_excel within w_55002_s
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_55002_s
integer width = 2747
integer height = 128
string title = "매장별 판매 현황"
string dataobject = "d_55002_sh01"
end type

type ln_1 from w_com010_d`ln_1 within w_55002_s
integer beginy = 328
integer endx = 2821
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_55002_s
integer beginy = 332
integer endx = 2821
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_55002_s
integer y = 348
integer width = 2798
integer height = 1692
string dataobject = "d_55002_sd01"
end type

type dw_print from w_com010_d`dw_print within w_55002_s
end type

