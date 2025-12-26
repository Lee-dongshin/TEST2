$PBExportHeader$w_32016_d.srw
$PBExportComments$사전 원가계산서 조회
forward
global type w_32016_d from w_com010_e
end type
type dw_mast2 from u_dw within w_32016_d
end type
type dw_1 from datawindow within w_32016_d
end type
type dw_price from datawindow within w_32016_d
end type
type cbx_1 from checkbox within w_32016_d
end type
type cb_wonga from commandbutton within w_32016_d
end type
type dw_2 from datawindow within w_32016_d
end type
end forward

global type w_32016_d from w_com010_e
integer width = 3671
integer height = 2284
event ue_retrieve2 ( )
dw_mast2 dw_mast2
dw_1 dw_1
dw_price dw_price
cbx_1 cbx_1
cb_wonga cb_wonga
dw_2 dw_2
end type
global w_32016_d w_32016_d

type variables
String is_style_no, is_yymmdd , is_season_bae_su
Decimal idc_ord_qty, idc_in_qty
datetime id_datetime

datawindowchild idw_bae_su

end variables

forward prototypes
public function integer wf_style_info (string as_style_no, long al_row, string as_div)
public function integer wf_12020_set ()
public function integer wf_12022_set ()
end prototypes

event ue_retrieve2;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
Long ll_rows2, ll_find2
Decimal ldc_mmat_price1, ldc_smat_price1, ldc_mmat_price2, ldc_smat_price2

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ll_rows2 = dw_mast2.retrieve(is_style_no,'N','H')  //원가 임시계산
il_rows  = dw_body.retrieve(is_style_no)

IF il_rows > 0 THEN
	il_rows = dw_1.retrieve(is_style_no)
	
	idw_bae_su.settransobject(sqlca)
	idw_bae_su.retrieve(MidA(is_style_no,1,1))
	dw_body.setitem(1,"season_bae_su",MidA(is_style_no,3,2))

			
	ll_find2 = dw_mast2.Find("price = 0", 1, dw_mast2.RowCount())
	If ll_find2 > 0 Then 
		dw_mast2.Object.t_error.Text = "아직 발주하지 않은 자재가 있습니다!"
		dw_body.Object.busi_price.Protect = 1
		dw_body.Object.busi_price.BackGround.Color = RGB(192, 192, 192)
		dw_body.Object.md_price.Protect   = 1
		dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
		dw_body.Object.tag_price.Protect  = 1
		dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
	End IF

	If idc_in_qty <> 0 Then
		dw_body.Object.busi_price.Protect = 1
		dw_body.Object.busi_price.BackGround.Color = RGB(192, 192, 192)
		dw_body.Object.md_price.Protect   = 1
		dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
		dw_body.Object.tag_price.Protect  = 1
		dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
	End IF
	
	If ll_find2 = 0 Then
		ldc_mmat_price1 = dw_body.GetItemDecimal(1, "mmat_price")
		ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
		ldc_smat_price1 = dw_body.GetItemDecimal(1, "smat_price")
		ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")
		If ldc_mmat_price1 <> ldc_mmat_price2 or ldc_smat_price1 <> ldc_smat_price2 Then
//			dw_body.SetItem(1, "mmat_price", ldc_mmat_price2 )
//			dw_body.SetItem(1, "smat_price", ldc_smat_price2 )
		
			IF ldc_mmat_price1 = 0 or idc_in_qty  = 0  then
				dw_body.SetItem(1, "mmat_price", ldc_mmat_price2 )	
			END IF
			
			IF ldc_smat_price1 = 0  or idc_in_qty  = 0 then
				dw_body.SetItem(1, "smat_price", ldc_smat_price2 )	
			END IF
		
//			ib_changed = TRUE
//			cb_update.enabled = TRUE
			cb_excel.enabled = FALSE
		
		Else
			cb_print.enabled = TRUE
			cb_preview.enabled = TRUE
			cb_excel.enabled = TRUE
		End If
	Else
		cb_print.enabled = TRUE
		cb_preview.enabled = TRUE
		cb_excel.enabled = TRUE
	End IF
	
	
	
	
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

public function integer wf_style_info (string as_style_no, long al_row, string as_div);String  ls_cust_cd, ls_cust_nm, ls_out_seq,ls_out_seq_nm, ls_ord_ymd, ls_dlvy_ymd

If as_div = '1' Then
	  SELECT ISNULL(CUST_CD, ' '), ISNULL(dbo.sf_cust_nm(CUST_CD, 'S'), ' '),
				ISNULL(OUT_SEQ,' '), ISNULL(dbo.sf_inter_nm('010',OUT_SEQ),' '), 
				ORD_YMD, DLVY_YMD
	    INTO :ls_cust_cd, :ls_cust_nm, :ls_out_seq, :ls_out_seq_nm, 
		      :ls_ord_ymd, :ls_dlvy_ymd
   	 FROM VI_12020_1
		WHERE STYLE = LEFT(:as_style_no, 8)
		  AND CHNO  = SUBSTRING(:as_style_no, 9, 1) ;

	If SQLCA.SQLCODE <> 0 Then Return SQLCA.SQLCODE

	
	dw_head.SetItem(al_row, "cust_cd", ls_cust_cd)
	dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
	dw_head.SetItem(al_row, "out_seq", ls_out_seq)
	dw_head.SetItem(al_row, "out_seq_nm", ls_out_seq_nm)
	dw_head.SetItem(al_row, "ord_ymd", ls_ord_ymd)
	dw_head.SetItem(al_row, "dlvy_ymd", ls_dlvy_ymd)
End If

  SELECT ISNULL(SUM(ORD_QTY), 0), ISNULL(SUM(IN_QTY), 0)
	 INTO :idc_ord_qty, :idc_in_qty
	 FROM TB_12030_S
	WHERE STYLE = LEFT(:as_style_no, 8)
	  AND CHNO  = SUBSTRING(:as_style_no, 9, 1) ;

If SQLCA.SQLCODE <> 0 Then Return SQLCA.SQLCODE

dw_head.SetItem(al_row, "ord_qty", idc_ord_qty)
dw_head.SetItem(al_row, "in_qty",  idc_in_qty)

Return 0

end function

public function integer wf_12020_set ();Decimal ldc_busi_price, ldc_md_price, ldc_tag_price

ldc_busi_price = dw_body.GetItemDecimal(1, "busi_price")
ldc_md_price   = dw_body.GetItemDecimal(1, "md_price")
ldc_tag_price  = dw_body.GetItemDecimal(1, "tag_price")

  UPDATE TB_12020_M
     SET BUSI_PRICE = :ldc_busi_price,
	      MD_PRICE   = :ldc_md_price,
			TAG_PRICE  = :ldc_tag_price,
			MOD_ID     = :gs_user_id,
			MOD_DT     = :id_datetime
	WHERE STYLE = LEFT(:is_style_no, 8) ;
	
Return SQLCA.SQLCODE

end function

public function integer wf_12022_set ();Decimal ldc_tag_price
String  ls_datetime

ldc_tag_price  = dw_body.GetItemDecimal(1, "tag_price")
ls_datetime = String(id_datetime, 'yyyymmdd')

INSERT 
  INTO TB_12022_H 
       ( STYLE, END_YMD, START_YMD, PRICE, REG_ID, REG_DT )
VALUES ( LEFT(:is_style_no, 8), '99999999', :ls_datetime,
       :ldc_tag_price, :gs_user_id, :id_datetime ) ;
			
IF SQLCA.SQLCODE = -1 Then 
	UPDATE TB_12022_H
		SET PRICE = :ldc_tag_price,
			 MOD_ID    = :gs_user_id,
			 MOD_DT    = :id_datetime
	 WHERE STYLE = LEFT(:is_style_no, 8) 
		AND END_YMD = '99999999' ;
End If
	
Return SQLCA.SQLCODE

end function

on w_32016_d.create
int iCurrent
call super::create
this.dw_mast2=create dw_mast2
this.dw_1=create dw_1
this.dw_price=create dw_price
this.cbx_1=create cbx_1
this.cb_wonga=create cb_wonga
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_price
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cb_wonga
this.Control[iCurrent+6]=this.dw_2
end on

on w_32016_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast2)
destroy(this.dw_1)
destroy(this.dw_price)
destroy(this.cbx_1)
destroy(this.cb_wonga)
destroy(this.dw_2)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
Long ll_rows2, ll_find2, jj,ii, ll_row
Decimal ldc_mmat_price1, ldc_smat_price1, ldc_mmat_price2, ldc_smat_price2
string ls_style, ls_color, ls_file_name

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ll_rows2 = dw_mast2.retrieve(is_style_no,'1','H')  //현재원가 조회



for jj = 1 to 	ll_rows2
	// 사진이 없는 경우 있는 칼라를 찾아 사진 보이도록 작업
//	ls_file_name = dw_body.getitemstring(jj,"style_pic")
	ls_style     = MidA(is_style_no,1,8)
	
		
		dw_2.retrieve(ls_style)
		ll_row = dw_2.RowCount()
		
		for ii = 1 to ll_row
			 ls_color = dw_2.getitemstring(ii, "color")
			 
			 select dbo.SF_PIC_COLOR_DIR(:ls_style +'%',:ls_color)
			 into :ls_file_name
			 from dual ;
			 
			 if FileExists(ls_file_name) then
				goto NextStep
			 end if
	
		next
		
		NextStep:
		dw_mast2.setitem(jj,"style_pic", ls_file_name)
		

//end if	
next	


IF ll_rows2 > 0  OR MidA(is_style_no, 1,1) = "D" THEN
			
		il_rows  = dw_body.retrieve(is_style_no)
		
		IF il_rows > 0 THEN
			il_rows = dw_1.retrieve(is_style_no)
			
			idw_bae_su.settransobject(sqlca)
			idw_bae_su.retrieve(MidA(is_style_no,1,1))
			dw_body.setitem(1,"season_bae_su",MidA(is_style_no,3,2))
		
					
			ll_find2 = dw_mast2.Find("price = 0", 1, dw_mast2.RowCount())
			If ll_find2 > 0 Then 
				dw_mast2.Object.t_error.Text = "아직 발주하지 않은 자재가 있습니다!"
				dw_body.Object.busi_price.Protect = 1
				dw_body.Object.busi_price.BackGround.Color = RGB(192, 192, 192)
				dw_body.Object.md_price.Protect   = 1
				dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
				dw_body.Object.tag_price.Protect  = 1
				dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
			End IF
		
			If idc_in_qty <> 0 Then
				dw_body.Object.busi_price.Protect = 1
				dw_body.Object.busi_price.BackGround.Color = RGB(192, 192, 192)
				dw_body.Object.md_price.Protect   = 1
				dw_body.Object.md_price.BackGround.Color   = RGB(192, 192, 192)
				dw_body.Object.tag_price.Protect  = 1
				dw_body.Object.tag_price.BackGround.Color  = RGB(192, 192, 192)
			End IF
			
			If ll_find2 = 0 Then
				ldc_mmat_price1 = dw_body.GetItemDecimal(1, "mmat_price")
				ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
				ldc_smat_price1 = dw_body.GetItemDecimal(1, "smat_price")
				ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")
				If ldc_mmat_price1 <> ldc_mmat_price2 or ldc_smat_price1 <> ldc_smat_price2 Then
		//			dw_body.SetItem(1, "mmat_price", ldc_mmat_price2 )
		//			dw_body.SetItem(1, "smat_price", ldc_smat_price2 )
				
					IF ldc_mmat_price1 = 0 or idc_in_qty  = 0  then
						dw_body.SetItem(1, "mmat_price", ldc_mmat_price2 )	
					END IF
					
					IF ldc_smat_price1 = 0  or idc_in_qty  = 0 then
						dw_body.SetItem(1, "smat_price", ldc_smat_price2 )	
					END IF
				
		//			ib_changed = TRUE
		//			cb_update.enabled = TRUE
					cb_excel.enabled = FALSE
				
				Else
					cb_print.enabled = TRUE
					cb_preview.enabled = TRUE
					cb_excel.enabled = TRUE
				End If
			Else
				cb_print.enabled = TRUE
				cb_preview.enabled = TRUE
				cb_excel.enabled = TRUE
			End IF
			
			
			
			
			dw_body.SetFocus()
		END IF
else
	messagebox("확인","아직 계산된 원가가 없습니다..")		
end if
	
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
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

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
   MessageBox(ls_title,"품번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

if LeftA(is_style_no,1)  = "J"    OR  LeftA(is_style_no,1) = 'Y' then
   MessageBox(ls_title,"상설용 원가계산서를 이용하세요 !")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

is_yymmdd = String(dw_head.GetItemDateTime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"작업일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

idc_ord_qty = dw_head.GetItemDecimal(1, "ord_qty")
if IsNull(idc_ord_qty) then
	idc_ord_qty = 1
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/
String     ls_style_no
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"				
			IF ai_div = 1 THEN 	
				IF wf_style_info(as_data, al_row, '1') = 0 THEN
					RETURN 0
				END IF
			END IF
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " where brand not in ('T','J','Y') "		//WHERE TB_11010_M.PART_FG IN ('1', '2', '3') 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
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
				ls_style_no = lds_Source.GetItemString(1,"style_no")

				dw_head.SetItem(al_row, "style_no", ls_style_no)
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"cust_cd"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_nm"))
				dw_head.SetItem(al_row, "out_seq", lds_Source.GetItemString(1,"out_seq"))
				dw_head.SetItem(al_row, "out_seq_nm", lds_Source.GetItemString(1,"out_seq_nm"))
				dw_head.SetItem(al_row, "ord_ymd", lds_Source.GetItemString(1,"ord_ymd"))
				dw_head.SetItem(al_row, "dlvy_ymd", lds_Source.GetItemString(1,"dlvy_ymd"))

				IF wf_style_info(ls_style_no, al_row, '2') <> 0 THEN
					MessageBox("입력오류", "발주수량을 조회에 실패하였습니다!")
					RETURN 1
				END IF
				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("style_no")
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

event pfc_preopen();call super::pfc_preopen;/* Data window Resize */
inv_resize.of_Register(dw_mast2, "ScaleToRight")
inv_resize.of_Register(dw_1, "FixedToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_mast2.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_price.SetTransObject(SQLCA)

dw_body.InsertRow(0)

if gs_user_id = '970104' then 
	cb_wonga.visible = true
end if


end event

event ue_button;/*===========================================================================*/
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
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_mast2.Enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
      else
         cb_print.enabled = false
         cb_preview.enabled = false
      end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"

      cb_print.enabled = false
      cb_preview.enabled = false

      ib_changed = false
      dw_mast2.Enabled = false

      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.15                                                  */	
/* 수정일      : 2002.01.15                                                  */
/*===========================================================================*/

dw_body.setitem(1, "mmat_price", dw_mast2.getitemnumber(1,"mmat_price"))
dw_body.setitem(1, "smat_price", dw_mast2.getitemnumber(1,"smat_price"))

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(id_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = DataModified! THEN		/* Modify Record */
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", id_datetime)
	If MidA(is_style_no, 9, 1) = '0' or MidA(is_style_no, 9, 1) = 'S' Then
		If wf_12022_set() <> 0 Then
			MessageBox("저장오류", "품번 단가를 저장하는데 실패하였습니다.")
			rollback  USING SQLCA;
			Return -1
		end if
		If wf_12020_set() <> 0 Then
			MessageBox("저장오류", "제품을 저장하는데 실패하였습니다.")
			rollback  USING SQLCA;
			Return -1
		end if
	End IF

END IF

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
	il_rows = dw_1.Update(TRUE, FALSE)
	if il_rows = 1 then
		dw_1.ResetUpdate()
	end if
	
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title
decimal ll_bae_su_tag, ll_wonga

ll_bae_su_tag = dw_body.getitemdecimal(1, 'tag_price')
ll_wonga = dw_body.getitemdecimal(1, 'wonga_price')

ll_bae_su_tag = ll_bae_su_tag / (ll_wonga*1.1)

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_body.setcolumn('season_bae_su')

//messagebox("is_style_no",is_style_no)
//messagebox("make_price", String(dw_body.getitemdecimal(1, 'make_price'), "#,##0"))

//ls_modify =  
				 dw_print.object.t_style.Text =  is_style_no
             dw_print.object.t_yymmdd.Text = String(is_yymmdd,"@@@@/@@/@@")
				 dw_print.object.t_ord_qty.Text = String(dw_head.getitemdecimal(1, 'ord_qty'), "#,##0")
				 dw_print.object.t_out_seq.Text = dw_head.getitemstring(1, 'out_seq')
				 dw_print.object.t_out_seq_nm.Text = dw_head.getitemstring(1, 'out_seq_nm')
				 dw_print.object.t_cust_cd.Text = dw_head.getitemstring(1, 'cust_cd')
				 dw_print.object.t_cust_nm.Text = dw_head.getitemstring(1, 'cust_nm')
				 dw_print.object.t_ord_ymd.Text = string(dw_head.getitemstring(1, 'ord_ymd'),"@@@@/@@/@@") 
				 dw_print.object.t_dlvy_ymd.Text = string(dw_head.getitemstring(1, 'dlvy_ymd'),"@@@@/@@/@@")  
   	   	 dw_print.object.t_mat_price.Text = String(dw_body.getitemdecimal(1, 'mat_price'), "#,##0") 
				 dw_print.object.t_make_price.Text = String(dw_body.getitemdecimal(1, 'make_price'), "#,##0")
				 dw_print.object.t_etc_price.Text = String(dw_body.getitemdecimal(1, 'etc_price'), "#,##0") 
				 dw_print.object.t_im_price.Text = String(dw_body.getitemdecimal(1, 'im_price'), "#,##0")
				 dw_print.object.t_won_price.Text = String(dw_body.getitemdecimal(1, 'won_price'), "#,##0") 
				 dw_print.object.t_chu_price.Text = String(dw_body.getitemdecimal(1, 'chu_price'), "#,##0") 
				 dw_print.object.t_bae_su.Text = dw_body.getitemstring(1, 'bae_su') 
				 dw_print.object.t_bae_su_tag.Text =  String(ll_bae_su_tag, "0.0")  
				 dw_print.object.t_tag_price.Text = String(dw_body.getitemdecimal(1, 'tag_price'), "#,##0") 
				 dw_print.object.t_busi_price.Text = String(dw_body.getitemdecimal(1, 'busi_price'), "#,##0")
				 dw_print.object.t_md_price.Text = String(dw_body.getitemdecimal(1, 'md_price'), "#,##0") 
				 dw_print.object.t_design_price.Text = String(dw_body.getitemdecimal(1, 'tag_price'), "#,##0") 	 
				 dw_print.object.season_bae_su.Text = idw_bae_su.getitemstring( idw_bae_su.getrow(),'ord_baesu') 
//dw_print.Modify(ls_modify)

//dw_print.object.t_style.text = 

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_rows2, ll_find2
Decimal ldc_mmat_price1, ldc_smat_price1, ldc_mmat_price2, ldc_smat_price2
string ls_brand

ls_brand = MidA(dw_head.getitemstring(1,'style_no'),1,1)
if ls_brand = 'C' then
	dw_print.dataobject = 'd_32001_r01_c'
	dw_print.SetTransObject(SQLCA)
else
	dw_print.dataobject = 'd_32001_r01' //S부터
	dw_print.SetTransObject(SQLCA)
end if

This.Trigger Event ue_title ()
//dw_print.retrieve(is_style_no)

dw_mast2.ShareData(dw_print)
		ldc_mmat_price1 = dw_print.GetItemDecimal(1, "mmat_price")
		ldc_mmat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "mmat_price")
		ldc_smat_price1 = dw_print.GetItemDecimal(1, "smat_price")
		ldc_smat_price2 = dw_mast2.GetItemDecimal(dw_mast2.RowCount(), "smat_price")
		If ldc_mmat_price1 <> ldc_mmat_price2 or ldc_smat_price1 <> ldc_smat_price2 Then
			dw_print.SetItem(1, "mmat_price", ldc_mmat_price2 )
			dw_print.SetItem(1, "smat_price", ldc_smat_price2 )
	   end if
		

dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_32001_e","0")
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
string ls_brand

ls_brand = MidA(dw_head.getitemstring(1,'style_no'),1,1)
if ls_brand = 'C' then
	dw_print.dataobject = 'd_32001_r01_c'
	dw_print.SetTransObject(SQLCA)
else
	dw_print.dataobject = 'd_32001_r01'
	dw_print.SetTransObject(SQLCA)
end if

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_mast2.ShareData(dw_print)


IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_32016_d
integer taborder = 130
end type

type cb_delete from w_com010_e`cb_delete within w_32016_d
boolean visible = false
integer taborder = 80
end type

type cb_insert from w_com010_e`cb_insert within w_32016_d
boolean visible = false
integer taborder = 70
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_32016_d
end type

type cb_update from w_com010_e`cb_update within w_32016_d
boolean visible = false
integer taborder = 120
end type

type cb_print from w_com010_e`cb_print within w_32016_d
integer taborder = 90
end type

type cb_preview from w_com010_e`cb_preview within w_32016_d
integer taborder = 100
end type

type gb_button from w_com010_e`gb_button within w_32016_d
end type

type cb_excel from w_com010_e`cb_excel within w_32016_d
boolean visible = false
integer x = 2368
integer width = 384
integer taborder = 110
boolean enabled = true
string text = "임시계산조회"
end type

event cb_excel::clicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

IF dw_head.Enabled THEN
	Parent.Trigger Event ue_retrieve2()	//조회
ELSE
	Parent.Trigger Event ue_head()	//조건
END IF

SetPointer(oldpointer)
This.Enabled = True

end event

type dw_head from w_com010_e`dw_head within w_32016_d
integer width = 3547
integer height = 220
string dataobject = "d_32001_h01"
boolean livescroll = false
end type

event dw_head::constructor;//DataWindowChild ldw_child
//
//This.GetChild("item", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve()
//
end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_32016_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_32016_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_32016_d
integer y = 1584
integer height = 456
integer taborder = 40
boolean enabled = false
string dataobject = "d_32001_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::constructor;call super::constructor;this.getchild("season_bae_su",idw_bae_su)
idw_bae_su.settransobject(sqlca)
idw_bae_su.retrieve(gs_brand)






end event

event dw_body::itemchanged;call super::itemchanged;choose case dwo.name
	case "busi_price"
		if dec(data) <= 0 or isnull(data) then
			dw_1.setitem(1,"busi_agree","N")
		else
			dw_1.setitem(1,"busi_agree","Y")
		end if
	case "md_price"
		if dec(data) <= 0 or isnull(data) then
			dw_1.setitem(1,"md_agree","N")
		else
			dw_1.setitem(1,"md_agree","Y")
		end if		
	case "tag_price"
		if dec(data) <= 0 or isnull(data) then
			dw_1.setitem(1,"design_agree","N")
		else
			dw_1.setitem(1,"design_agree","Y")
		end if		
		
end choose
end event

type dw_print from w_com010_e`dw_print within w_32016_d
integer x = 0
integer y = 100
string dataobject = "d_32001_r01"
end type

type dw_mast2 from u_dw within w_32016_d
integer x = 5
integer y = 444
integer width = 3589
integer height = 1132
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_32001_d01"
end type

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_1 from datawindow within w_32016_d
integer x = 2953
integer y = 1496
integer width = 626
integer height = 528
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_32001_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;/*===========================================================================*/
ib_changed = true
cb_update.enabled = true

end event

type dw_price from datawindow within w_32016_d
integer x = 2478
integer y = 448
integer width = 987
integer height = 1040
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_32001_d03"
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_32016_d
integer x = 3058
integer y = 256
integer width = 480
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "단가상세정보"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then 
	dw_price.retrieve(is_style_no)
	dw_price.visible = true
else
	dw_price.reset()
end if

end event

type cb_wonga from commandbutton within w_32016_d
boolean visible = false
integer x = 3493
integer y = 220
integer width = 402
integer height = 148
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "원가새로계산"
end type

event clicked;string ls_style_no, ls_flag

ls_flag='E'
ls_style_no = dw_head.GetItemString(1, "style_no")
if LenA(ls_style_no)=9 then 
	if messagebox("확인",ls_style_no +" 원가을 다시 계산합니다...",Exclamation!,YesNoCancel!,1 ) <> 1 then return
	DECLARE ww PROCEDURE FOR ww  
			@style_no  = :ls_style_no,
			@flag	     = :ls_flag;
			
	execute ww;	

	if SQLCA.sqlcode = -1 then
		messagebox("확인", "원가계산에 실패하였습니다..")
		rollback  USING SQLCA;
	else
		messagebox("확인","투입일이 3개월 이상 지난 작지는 전산실 문의..")
		messagebox("확인","정상처리되었슴니다...")
		commit  USING SQLCA;
	Parent.Trigger Event ue_retrieve()	
	end if	
else
	MessageBox("확인","스타일 번호을 올바로 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("style_no")
end if
		


end event

type dw_2 from datawindow within w_32016_d
boolean visible = false
integer x = 2779
integer y = 812
integer width = 480
integer height = 840
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_32001_color"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

