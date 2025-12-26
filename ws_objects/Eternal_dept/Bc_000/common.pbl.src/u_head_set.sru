$PBExportHeader$u_head_set.sru
$PBExportComments$Head 기본값 Set
forward
global type u_head_set from nonvisualobject
end type
end forward

global type u_head_set from nonvisualobject
end type
global u_head_set u_head_set

forward prototypes
public subroutine uf_set (datawindow adw_head)
end prototypes

public subroutine uf_set (datawindow adw_head);/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 2001.12.27                                                  */	
/* 수정일      : 2001.12.27                                                  */
/*===========================================================================*/
Integer  i, li_column_count, li_min_column_id
String   ls_column_nm, ls_nm, ls_ColType, ls_year, ls_season
String   ls_tab_order, ls_min_tab_order = '9000'
String   ls_pgm_grp
datetime ld_datetime

li_column_count = Integer(adw_head.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN
IF adw_head.RowCount() <> 1 THEN RETURN 

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_pgm_grp = MidA(adw_head.DataObject, 3, 1)

FOR i=1 TO li_column_count
	ls_column_nm = adw_head.Describe('#' + String(i) + '.Name') 
	ls_ColType   = adw_head.Describe('#' + String(i) + '.ColType') 
	ls_tab_order = adw_head.Describe('#' + String(i) + '.tabsequence')
	IF ls_tab_order <> '?' AND ls_tab_order <> '0' AND Integer(ls_min_tab_order) > Integer(ls_tab_order) THEN
	   ls_min_tab_order = ls_tab_order
	   li_min_column_id = i
   END IF 
   CHOOSE CASE ls_column_nm
      CASE "brand" 
			if gs_brand = "K"  then
			   adw_head.Setitem(1, ls_column_nm, 'K') 
				adw_head.object.brand.protect = 1
				adw_head.object.brand.BackGround.color = '67108864'
			else	
				IF gf_inter_nm('001', gs_brand, ls_nm) = 0 THEN 
					adw_head.Setitem(1, ls_column_nm, gs_brand) 
				ELSE
					adw_head.Setitem(1, ls_column_nm, 'N') 
				END IF
				adw_head.SetColumn(ls_column_nm)
			end if	
      CASE "year", "mat_year", "fr_year", "to_year"
			GF_CURR_YEAR(ld_datetime, ls_year)
			IF ls_ColType = "char(4)" THEN
			   adw_head.Setitem(1, ls_column_nm, ls_year) 
			ELSEIF ls_ColType = "char(1)" THEN
			   adw_head.Setitem(1, ls_column_nm, MidA(ls_year, 4, 1)) 
			else				
			   adw_head.Setitem(1, ls_column_nm, ls_year) 				
			END IF
			adw_head.SetColumn(ls_column_nm)
      CASE "season", "mat_season", "fr_season", "to_season" 
			GF_CURR_SEASON(ld_datetime, ls_season)
			adw_head.Setitem(1, ls_column_nm, ls_season)
			adw_head.SetColumn(ls_column_nm)
      CASE "house", "house_cd" , "in_house"
			IF gs_user_id = 'ASSIST' THEN	
				adw_head.Setitem(1, ls_column_nm, '030000') 
			ELSE
				IF ls_pgm_grp = '2' THEN
					adw_head.Setitem(1, ls_column_nm, '110000') 
				ELSE
					adw_head.Setitem(1, ls_column_nm, '010000') 
				END IF
			END IF
			adw_head.SetColumn(ls_column_nm)
		CASE "yymmdd", "yymm",  "yyyy", "fr_ymd", "to_ymd", "fr_yymm", "to_yymm" 
			CHOOSE CASE ls_ColType
				CASE 'datetime' 
			      adw_head.Setitem(1, ls_column_nm, ld_datetime)
				CASE 'date'
			      adw_head.Setitem(1, ls_column_nm, Date(ld_datetime))
				CASE ELSE
					IF ls_column_nm = "yymmdd" or ls_column_nm = "fr_ymd" or ls_column_nm = "to_ymd" THEN
			         adw_head.Setitem(1, ls_column_nm, String(ld_datetime, "yyyymmdd"))
					ELSEIF ls_column_nm = "yymm" or ls_column_nm = "fr_yymm" or ls_column_nm = "to_yymm" THEN
			         adw_head.Setitem(1, ls_column_nm, String(ld_datetime, "yyyymm"))
					ELSEIF ls_column_nm = "yyyy" THEN
			         adw_head.Setitem(1, ls_column_nm, String(ld_datetime, "yyyy")) 
					END IF
		   END CHOOSE
			adw_head.SetColumn(ls_column_nm)
   END CHOOSE
NEXT

adw_head.SetColumn(li_min_column_id)

end subroutine

on u_head_set.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_head_set.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

