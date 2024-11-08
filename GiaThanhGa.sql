USE [TESTMTR1001APP]
GO
/****** Object:  StoredProcedure [dbo].[xp_OJCalProMngCost_Site]    Script Date: 06/19/2024 15:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--xp_FGCalProMngCost '201204','SYSADMIN'
ALTER                       proc [dbo].[xp_OJCalProMngCost_Site]

@parm1 varchar(6),
@parm2 varchar(21),
@parm3 varchar(10)
--with encryption
as
DECLARE @INLastBatNbr varchar(10)  
DECLARE @INBatNbr varchar(10)  
DECLARE @CpnyID varchar(10)   
DECLARE @Perpost varchar(10)   
DECLARE @CuryID varchar(4)  
DECLARE @Date smalldatetime  
DECLARE @Amt float   
DECLARE @Acct varchar(10)   
DECLARE @Sub varchar(24)   
DECLARE @ReasonCD_RC varchar(10)
DECLARE @ReasonCD_IS varchar(10)
DECLARE @GLPostOpt varchar(1)
declare @Mon varchar(2)
declare @FiscYr varchar(4)

begin tran TranIN  
  
--lay so batnbr cuoi module IN va tang batnbr  

create table #xt_FGWrkCalCost ( Perpost char(6),  UserAddress char(21), CostRawMaterial float, CostPacking float, AquaticRawAdj float, CattleRawAdj float, AquaticRawPend float, CattleRawPend float, AquaticCost00 float, AquaticCost01 float, AquaticCost02 float, AquaticCost03 float, AquaticCost04 float, AquaticCost05 float, AquaticCost06 float, AquaticCost07 float, AquaticCost08 float, AquaticCost09 float, AquaticCost10 float, AquaticCost11 float, AquaticCost12 float, AquaticCost13 float, AquaticCost14 float, AquaticCost15 float, AquaticCost16 float, AquaticCost17 float, AquaticCost18 float, AquaticCost19 float, AquaticCost20 float, CattleCost00 float, CattleCost01 float, CattleCost02 float, CattleCost03 float, CattleCost04 float, CattleCost05 float, CattleCost06 float, CattleCost07 float, CattleCost08 float, CattleCost09 float, CattleCost10 float, CattleCost11 float, CattleCost12 float, CattleCost13 float, CattleCost14 float, CattleCost15 float, CattleCost16 float, CattleCost17 float, CattleCost18 float, CattleCost19 float, CattleCost20 float, TotalQtyRC float, CostTotal float, TotalOnhand float, CostOnhand float, Crtd_DateTime smalldatetime, S4Future01 char(30), S4Future02 char(30), S4Future03 float, S4Future04 float, S4Future05 float, S4Future06 float, S4Future07 smalldatetime, S4Future08 smalldatetime, S4Future09 int, S4Future10 int, S4Future11 char(10), S4Future12 char(10), User1 char(30), User2 char(30), User3 float, User4 float, User5 char(10), User6 char(10), User7 smalldatetime, User8 smalldatetime )
                              
create table #xt_FGWrkCalCostDet (Perpost char(6), UserAddress char(21), Prodmgrid char(10), TranDesc char(30), Qty float, AllocPct float, AllocAmt float, COGS float, LineNbr smallint, Crtd_DateTime smalldatetime, S4Future01 char(30), S4Future02 char(30), S4Future03 float, S4Future04 float, S4Future05 float, S4Future06 float, S4Future07 smalldatetime, S4Future08 smalldatetime, S4Future09 int, S4Future10 int, S4Future11 char(10), S4Future12 char(10), User1 char(30), User2 char(30), User3 float, User4 float, User5 char(10), User6 char(10), User7 smalldatetime, User8 smalldatetime)

--if @@error <> 0 GOTO Abort  

select @Mon = right(rtrim(@parm1),2),    @FiscYr = left(ltrim(@parm1),4)

--SELECT @ReasonCD_RC = ISNULL(User5,'RFGS11' ),@ReasonCD_IS = ISNULL(User6,'IRMX10' ) FROM xt_FGSetUp  

SELECT @CpnyId = CpnyId,@CuryId = BaseCuryID FROM GLSETUP  
 
declare @decpl int

select @decpl = decpl from currncy where CuryId = @CuryId

DECLARE @CostRawMaterial float, @CostPacking float, @AquaticRawAdj float, @CattleRawAdj float, @AquaticRawPend float, @CattleRawPend float, @TotalQtyRC float, @CostTotal float, @TotalOnhand float, @CostOnhand float
DECLARE @AquaticCost00 float, @AquaticCost01 float, @AquaticCost02 float, @AquaticCost03 float, @AquaticCost04 float, @AquaticCost05 float, @AquaticCost06 float, @AquaticCost07 float, @AquaticCost08 float, @AquaticCost09 float, @AquaticCost10 float, @AquaticCost11 float, @AquaticCost12 float, @AquaticCost13 float, @AquaticCost14 float, @AquaticCost15 float, @AquaticCost16 float, @AquaticCost17 float, @AquaticCost18 float, @AquaticCost19 float, @AquaticCost20 float
DECLARE @CattleCost00 float, @CattleCost01 float, @CattleCost02 float, @CattleCost03 float, @CattleCost04 float, @CattleCost05 float, @CattleCost06 float, @CattleCost07 float, @CattleCost08 float, @CattleCost09 float, @CattleCost10 float, @CattleCost11 float, @CattleCost12 float, @CattleCost13 float, @CattleCost14 float, @CattleCost15 float, @CattleCost16 float, @CattleCost17 float, @CattleCost18 float, @CattleCost19 float, @CattleCost20 float

SELECT @CostRawMaterial  = 0 , @CostPacking  = 0 , @AquaticRawAdj  = 0 , @CattleRawAdj  = 0 , @AquaticRawPend  = 0 , @CattleRawPend  = 0 , @TotalQtyRC  = 0 , @CostTotal  = 0 , @TotalOnhand  = 0 , @CostOnhand  = 0 
SELECT @AquaticCost00  = 0 , @AquaticCost01  = 0 , @AquaticCost02  = 0 , @AquaticCost03  = 0 , @AquaticCost04  = 0 , @AquaticCost05  = 0 , @AquaticCost06  = 0 , @AquaticCost07  = 0 , @AquaticCost08  = 0 , @AquaticCost09  = 0 , @AquaticCost10  = 0 , @AquaticCost11  = 0 , @AquaticCost12  = 0 , @AquaticCost13  = 0 , @AquaticCost14  = 0 , @AquaticCost15  = 0 , @AquaticCost16  = 0 , @AquaticCost17  = 0 , @AquaticCost18  = 0 , @AquaticCost19  = 0 , @AquaticCost20  = 0 
SELECT @CattleCost00  = 0 , @CattleCost01  = 0 , @CattleCost02  = 0 , @CattleCost03  = 0 , @CattleCost04  = 0 , @CattleCost05  = 0 , @CattleCost06  = 0 , @CattleCost07  = 0 , @CattleCost08  = 0 , @CattleCost09  = 0 , @CattleCost10  = 0 , @CattleCost11  = 0 , @CattleCost12  = 0 , @CattleCost13  = 0 , @CattleCost14  = 0 , @CattleCost15  = 0 , @CattleCost16  = 0 , @CattleCost17  = 0 , @CattleCost18  = 0 , @CattleCost19  = 0 , @CattleCost20  = 0 

create table #TmpCostBU (BU char(5), CostNo char(10), SiteID char(3), Cost float)

set @parm3 = SUBSTRING(@parm3,1,3)

--Tap hop chi phi theo Site + 16Cost : acc Sup
insert into #TmpCostBU(BU,CostNo, SiteID,Cost)
select v.BU,v.costNo, v.SiteID, Cost = isnull(sum(g.dramt - g.cramt),0)
from gltran g , vsFG_CostItemDetail v 
where g.perpost = @parm1 
and (rtrim(g.acct) + ltrim(rtrim(g.sub)) = v.linkcode) 
and g.rlsed =1 AND V.bu IN ('APTRG')
and v.SiteID = @parm3
--and g.BatNbr not in ('014898','014899','014939') -- Test
group by v.BU,v.costNo,v.SiteID

--select * from vsFG_CostItemDetail

--Tao Bang chi phi theo Site + 16Cost
insert into #xt_FGWrkCalCost
select 
 Perpost = @parm1,
 UserAddress = '',
 CostRawMaterial = 0,
 CostPacking = 0,
 AquaticRawAdj = 0,
 CattleRawAdj = 0,
 AquaticRawPend = 0,
 CattleRawPend = 0,
 AquaticCost00 = 0,
 AquaticCost01 = 0,
 AquaticCost02 = 0,
 AquaticCost03 = 0,
 AquaticCost04 = 0,
 AquaticCost05 = 0,
 AquaticCost06 = 0,
 AquaticCost07 = 0,
 AquaticCost08 = 0,
 AquaticCost09 = 0,
 AquaticCost10 = 0,
 AquaticCost11 = 0,
 AquaticCost12 = 0,
 AquaticCost13 = 0,
 AquaticCost14 = 0,
 AquaticCost15 = 0,
 AquaticCost16 = 0,
 AquaticCost17 = 0,
 AquaticCost18 = 0,
 AquaticCost19 = 0,
 AquaticCost20 = 0,
 CattleCost00  = 0,
 CattleCost01  = 0,
 CattleCost02  = 0,
 CattleCost03  = 0,
 CattleCost04  = 0,
 CattleCost05  = 0,
 CattleCost06  = 0,
 CattleCost07  = 0,
 CattleCost08  = 0,
 CattleCost09  = 0,
 CattleCost10  = 0,
 CattleCost11  = 0,
 CattleCost12  = 0,
 CattleCost13  = 0,
 CattleCost14  = 0,
 CattleCost15  = 0,
 CattleCost16  = 0,
 CattleCost17  = 0,
 CattleCost18  = 0,
 CattleCost19  = 0,
 CattleCost20  = 0,
 TotalQtyRC = 0,
 CostTotal = 0,
 TotalOnhand = 0,
 CostOnhand = 0,
 Crtd_DateTime = '1900-01-01 00:00:00',
 S4Future01 = '', S4Future02 = '', S4Future03 = 0, S4Future04 = 0, S4Future05 = 0, S4Future06 = 0, 
 S4Future07 = '1900-01-01 00:00:00', S4Future08 = '1900-01-01 00:00:00', S4Future09 = 0, S4Future10 = 0,
 S4Future11 = '', S4Future12 = '', User1 = '', User2 = '',  User3 = 0, User4 = 0, 
 User5 = B.SiteID , User6 = '', User7 = '1900-01-01 00:00:00', User8 = '1900-01-01 00:00:00'
 from (select distinct SiteID from #TmpCostBU) B
--if @@error <> 0 GOTO Abort
 --select * from #TmpCostBU
 --select * from  #xt_FGWrkCalCost

 --Update chi phi theo Site + 16Cost
 update A
 set CattleCost00 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost00' and SiteID = B.SiteID),0),
	 CattleCost01 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost01' and SiteID = B.SiteID),0),
	 CattleCost02 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost02' and SiteID = B.SiteID),0),
	 CattleCost03 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost03' and SiteID = B.SiteID),0),
	 CattleCost04 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost04' and SiteID = B.SiteID),0),
	 CattleCost05 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost05' and SiteID = B.SiteID),0),
	 CattleCost06 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost06' and SiteID = B.SiteID),0),
	 CattleCost07 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost07' and SiteID = B.SiteID),0),
	 CattleCost08 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost08' and SiteID = B.SiteID),0),
	 CattleCost09 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost09' and SiteID = B.SiteID),0),
	 CattleCost10 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost10' and SiteID = B.SiteID),0),
	 CattleCost11 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost11' and SiteID = B.SiteID),0),
	 CattleCost12 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost12' and SiteID = B.SiteID),0),
	 CattleCost13 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost13' and SiteID = B.SiteID),0),
	 CattleCost14 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost14' and SiteID = B.SiteID),0),
	 CattleCost15 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost15' and SiteID = B.SiteID),0),
	 CattleCost16 = Isnull((select Cost from #TmpCostBU where BU = 'APTRG' and CostNo = 'Cost16' and SiteID = B.SiteID),0)
 from #xt_FGWrkCalCost A, #TmpCostBU B
 where A.User5 = B.SiteID
--if @@error <> 0 GOTO Abort  


--Declare @TotalQtyRC float
Declare @QTYSLS float
Declare @QTYBegin float

select   @QTYSLS = 0 ,@QTYBegin = 0



--if @@error <> 0 GOTO Abort  

create table #ProductManagerIS (SiteID char(10), Prodmgrid char(10),TranDesc char(30),Qty float, StdCost float, TranAmt float,perpost char(6))
create table #ProductManagerRC (SiteID char(10), Prodmgrid char(10),TranDesc char(30),Qty float, StdCost float, TranAmt float,perpost char(6))
create table #ProductManagerVoid (SiteID char(10), Prodmgrid char(10),TranDesc char(30),Qty float, StdCost float, TranAmt float,perpost char(6))
create table #ProductManagerAdjust (SiteID char(10), Prodmgrid char(10),TranDesc char(30),Qty float,TranAmt float,perpost char(6),LineNbr int identity(1,1),COGS Float,AllocPct float, NumOfDate float)

--Sumary WIP in LastMonth
Insert into #ProductManagerAdjust(SiteID,Prodmgrid, TranDesc, Qty, TranAmt, perpost, COGS, AllocPct, NumOfDate)
select User5 as SiteID, Prodmgrid, TranDesc, Qty, S4Future04 as TranAmt, Perpost, COGS, AllocPct, S4Future03 as NumOdDate
from xt_FGCalCostDet
where Perpost in (select max(Perpost) from xt_FGCalCostDet where Perpost <> @parm1)
and S4Future01 = 'WIP'
and User5 = @parm3

update A
Set A.CattleRawAdj = B.TotalOnhand,A.AquaticRawAdj = B.CostOnhand
from #xt_FGWrkCalCost A,
(select SiteID , sum(Qty) as TotalOnhand, SUM(COGS) as CostOnhand
from #ProductManagerAdjust
group by SiteID
) B
Where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort  

--Issue Raw Material: EGG B1 
insert into #ProductManagerIS(SiteID, Prodmgrid, TranDesc, Qty, StdCost, TranAmt, perpost)
select SiteID, ProMgID,max(Trandesc) as Trandesc, sum(Qty) as Qty, max(StdCost) as StdCost,sum(Tranamt) as Tranamt,@parm1
from (
	select left(I.SiteID,3) as SiteID,  I.s4future02 as ProMgID,I.TranDesc, 
	Qty = (case when trantype in ('ii') then I.Qty when trantype in ('RC','AJ','AC') then -I.Qty*invtmult end),
	S.StdCost, 
	TranAmt = (case when trantype in ('ii') then I.Qty*S.StdCost when trantype in ('RC','AJ','AC') then -I.Qty*S.StdCost end)	
	from intran I
	inner join Inventory V on V.InvtID = I.InvtID and V.ProdMgrID = I.s4future02
	inner join ItemSite S on S.InvtID = I.InvtID and S.SiteID = I.SiteID
	where perpost = @parm1 and trantype in ('ii','aj','rc','AC') --and reasondcd = @ReasonCD_IS
	and rlsed = 1	
	and reasoncd in (select LastNbr07 from xt_OJSetup_Breed) --ISEG10 
	--and BatNbr not in ('115608') -- Loai bo batch loi
) f
where f.SiteID = @parm3
group by SiteID,ProMgID
if @@error <> 0 GOTO Abort  

update A
Set A.TotalOnhand = B.TotalOnhand,A.CostOnhand = B.CostOnhand, A.CostRawMaterial = B.CostOnhand
from #xt_FGWrkCalCost A,
(select SiteID , sum(Qty) as TotalOnhand, SUM(TranAmt) as CostOnhand
from #ProductManagerIS
group by SiteID
) B
Where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort  


--Receipt DOC
insert into #ProductManagerRC(SiteID, Prodmgrid, TranDesc, Qty, StdCost, TranAmt, perpost)
select SiteID, ProMgID,max(Trandesc) as Trandesc, sum(Qty) as Qty, max(StdCost) as StdCost,sum(Tranamt) as Tranamt,@parm1
from (
select left(I.SiteID,3) as SiteID,  I.s4future02 as ProMgID,I.TranDesc, I.Qty, V.StdCost, TranAmt = (case when trantype in ('RC') then Qty*V.StdCost when trantype in ('AJ','AC') then -TranAmt*invtmult end)	
	from intran I
	inner join Inventory V on V.InvtID = I.InvtID and V.ProdMgrID = I.s4future02
	where perpost = @parm1 and trantype in ('aj','rc','AC') --and reasondcd = @ReasonCD_IS
	and rlsed = 1	
	and reasoncd in (select LastNbr08 from xt_OJSetup_Breed) --RCDOC1
	and BatNbr not in ('109051') -- Loai bo batch loi
) f
where f.SiteID = @parm3
group by SiteID,ProMgID
if @@error <> 0 GOTO Abort  

update A
Set A.TotalQtyRC = B.TotalOnhand,A.CostTotal = B.CostOnhand
from #xt_FGWrkCalCost A,
(select SiteID , sum(Qty) as TotalOnhand, SUM(TranAmt) as CostOnhand
from #ProductManagerRC
group by SiteID
) B
Where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort  

--Receipt EggCancel
delete #ProductManagerRC

insert into #ProductManagerRC(SiteID, Prodmgrid, TranDesc, Qty, StdCost, TranAmt, perpost)
select SiteID, ProMgID,max(Trandesc) as Trandesc, sum(Qty) as Qty, max(StdCost) as StdCost,sum(Tranamt) as Tranamt,@parm1
from (
select left(I.SiteID,3) as SiteID,  I.s4future02 as ProMgID,I.TranDesc, I.Qty, V.StdCost, TranAmt = (case when trantype in ('RC') then Qty*V.StdCost when trantype in ('AJ','AC') then -TranAmt*invtmult end)	
	from intran I
	inner join Inventory V on V.InvtID = I.InvtID and V.ProdMgrID = I.s4future02
	where perpost = @parm1 and trantype in ('aj','rc','AC') --and reasondcd = @ReasonCD_IS
	and rlsed = 1	
	and reasoncd in (select LastNbr09 from xt_OJSetup_Breed) --RCEGKP
	and BatNbr not in ('109052') -- Loai bo batch loi
) f
where f.SiteID = @parm3
group by SiteID,ProMgID
if @@error <> 0 GOTO Abort  

update A
Set A.S4Future03 = B.TotalOnhand,A.S4Future04 = B.CostOnhand
from #xt_FGWrkCalCost A,
(select SiteID , sum(Qty) as TotalOnhand, SUM(TranAmt) as CostOnhand
from #ProductManagerRC
group by SiteID
) B
Where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort 

--Receipt EggVoid
insert into #ProductManagerVoid(SiteID, Prodmgrid, TranDesc, Qty, StdCost, TranAmt, perpost)
select SiteID, ProMgID,max(Trandesc) as Trandesc, sum(Qty) as Qty, max(StdCost) as StdCost,sum(Tranamt) as Tranamt,@parm1
from (
select left(I.SiteID,3) as SiteID,  I.InvtID_M as ProMgID,I.TranDesc, I.S4Future04 as Qty, V.StdCost, TranAmt = I.S4Future04*V.StdCost
	from xt_FGReceipt_Det I
	inner join xt_OJMapInvt O on O.InvtID02 = I.InvtID
	inner join Inventory V on V.InvtID = O.InvtID01 and V.ProdMgrID = I.InvtID_M	
	where perpost = @parm1 
	and I.S4Future04 <> 0
	and BatNbr not in ('0000000030') --Loai bo batch loi
) f
where f.SiteID = @parm3
group by SiteID,ProMgID

update A
Set A.S4Future03 =  A.S4Future03 + B.TotalOnhand,A.S4Future04 =A.S4Future04 + B.CostOnhand
from #xt_FGWrkCalCost A,
(select SiteID , sum(Qty) as TotalOnhand, SUM(TranAmt) as CostOnhand
from #ProductManagerVoid
group by SiteID
) B
Where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort 


Update A
Set A.CattleRawPend = (A.TotalOnhand + CattleRawAdj) - (A.TotalQtyRC + A.S4Future03)
from #xt_FGWrkCalCost A
if @@error <> 0 GOTO Abort 

DECLARE @AquaticPO float,@CattlePO float

select @CattlePO = 0 ,@AquaticPO = 0


--select @CostTotal = 0
--select @CostTotal = isnull((select SiteID, sum(Cost) from #TmpCostBU Group by SiteID),0)

Update A
Set A.CostTotal = B.Cost
from #xt_FGWrkCalCost A,
(select SiteID, sum(Cost) as Cost from #TmpCostBU Group by SiteID) B
where A.User5 = B.SiteID
if @@error <> 0 GOTO Abort  
Update A
Set A.CostTotal = A.CostTotal + (A.CostRawMaterial - A.S4Future04) + A.AquaticRawAdj
from #xt_FGWrkCalCost A
if @@error <> 0 GOTO Abort  
--select @CostTotal =   @CostTotal + @CattleRawPend + @AquaticRawPend+ @CostRawMaterial + @CostPacking +  @CattlePO + @AquaticPO


create table #ProductManager (SiteID char(10), InvtID char(30), Prodmgrid char(10),TranDesc char(30), Status char(10),Qty float,TranAmt float,perpost char(6),LineNbr int identity(1,1),COGS Float,AllocPct float, NumOfDate float, Total16Cost Float, UnitCost Float, Raw16Cost Float, TotalRaw Float, RawCost Float, AdjCost Float, QtyWip Float)

Declare @FrDate smalldatetime, @ToDate smalldatetime
select @FrDate = cast (@parm1+ '01' as smalldatetime)
select @ToDate = DATEADD (M,1,@FrDate )
select @ToDate = DATEADD (D,-1,@ToDate )

insert into #ProductManager(SiteID, InvtID,Prodmgrid ,TranDesc,Status,Qty,TranAmt,perpost, COGS , AllocPct, NumOfDate,Total16Cost, UnitCost,Raw16Cost,TotalRaw, RawCost, AdjCost, QtyWip)
select SiteID, InvtID,Formula, Descr,User6, sum(TotalWeight), 0, @parm1, Sum(User3), sum(TotalWeight * NumOfDate), Sum(NumOfDate), 0, 0, 0, 0, 0, 0, sum(QtyWip)
from (
	select left(D.SiteID,3) as SiteID, H.ProOrderNbr,D.InvtID, H.Formula, H.ForVerID,H.Descr, H.OrigWeight, H.TotalWeight, H.User3,H.Status, H.S4Future07, H.S4Future08, H.User6, NumOfDate =  DATEDIFF (D,H.S4Future07 ,H.S4Future08) , QtyWip = 0
	from xt_FGProOrder H
	inner join xt_FGProOrder_Det D on D.ProOrderNbr = H.ProOrderNbr
	where H.Status = 'C'
	and H.VerID = @parm1
	and H.S4Future07 >= @FrDate and H.S4Future08 <= @ToDate
	and H. User6 = 'FINISH'
	union all
	select left(D.SiteID,3) as SiteID, H.ProOrderNbr,D.InvtID, H.Formula, H.ForVerID,H.Descr, H.OrigWeight, H.TotalWeight, H.User3,H.Status, H.S4Future07, H.S4Future08, H.User6, NumOfDate =  DATEDIFF (D,H.S4Future07 ,@ToDate) , QtyWip = 0
	from xt_FGProOrder H
	inner join xt_FGProOrder_Det D on D.ProOrderNbr = H.ProOrderNbr
	where H.Status = 'C'
	and H.VerID = @parm1
	and H.S4Future07 >= @FrDate --and H.S4Future08 <= @ToDate
	and H. User6 = ''
	union all
	select left(D.SiteID,3) as SiteID, H.ProOrderNbr,D.InvtID, H.Formula, H.ForVerID,H.Descr, H.OrigWeight, H.TotalWeight, H.User3,H.Status, H.S4Future07, H.S4Future08, H.User6, NumOfDate =  DATEDIFF (D,@FrDate ,H.S4Future08) + 1 , QtyWip = H.TotalWeight
	from xt_FGProOrder H
	inner join xt_FGProOrder_Det D on D.ProOrderNbr = H.ProOrderNbr
	where H.Status = 'C'
	and H.VerID in (select max(Perpost) from xt_FGCalCostDet where Perpost <> @parm1)
	and H.S4Future08 >= @FrDate 
	and H.S4Future08 <= @ToDate
	and H. User6 = 'FINISH'
) f
where f.SiteID = @parm3
group by SiteID,InvtID,Formula,Descr,User6
if @@error <> 0 GOTO Abort  

create table #ProductManagerWIP (SiteID char(10), InvtID char(30), Prodmgrid char(10),TranDesc char(30), Status char(10),Qty float,TranAmt float,perpost char(6),LineNbr int identity(1,1),COGS Float,AllocPct float, NumOfDate float, Total16Cost Float, UnitCost Float, Raw16Cost Float, TotalRaw Float, RawCost Float, AdjCost Float)
insert into #ProductManagerWIP(SiteID, InvtID,Prodmgrid ,TranDesc,Status,Qty,TranAmt,perpost, COGS , AllocPct, NumOfDate,Total16Cost, UnitCost,Raw16Cost,TotalRaw, RawCost, AdjCost)
select SiteID, InvtID,Formula, Descr,User6, sum(TotalWeight), 0, @parm1, 0, sum(TotalWeight * NumOfDate), Sum(NumOfDate), 0, 0, 0, 0, 0, 0
from (
	select left(D.SiteID,3) as SiteID, H.ProOrderNbr,D.InvtID, H.Formula, H.ForVerID,H.Descr, H.OrigWeight, H.TotalWeight, H.User3,H.Status, H.S4Future07, H.S4Future08, H.User6, NumOfDate =  DATEDIFF (D,@FrDate ,H.S4Future08) 
	from xt_FGProOrder H
	inner join xt_FGProOrder_Det D on D.ProOrderNbr = H.ProOrderNbr
	where H.Status = 'C'
	and H.VerID in (select max(Perpost) from xt_FGCalCostDet where Perpost <> @parm1)
	and H.S4Future08 >= @FrDate 
	and H.S4Future08 <= @ToDate
	and H. User6 = 'FINISH'
) f
group by SiteID,InvtID,Formula,Descr,User6
if @@error <> 0 GOTO Abort  
---------------------------------- OLD
--Update A
--set A.Total16Cost = B.CostTotal - (B.CostRawMaterial - B.S4Future04)
--from #ProductManager A,
--xt_FGWrkCalCost B
--where A.SiteID = B.User5
--if @@error <> 0 GOTO Abort  

--Update A
--set A.UnitCost =  round(B.TotalCost / B.Qty,3) , A.Raw16Cost =  round(A.AllocPct *  (B.TotalCost / B.Qty),3)
--from #ProductManager A,
--(
--	select SiteID, max(Total16Cost) as TotalCost, sum(AllocPct) as Qty From #ProductManager Group by SiteID
--) B
--where A.SiteID =  B.SiteID
--if @@error <> 0 GOTO Abort  

--Update A
--set A.TotalRaw = (B.CostRawMaterial - B.S4Future04) , A.AdjCost =  B.AquaticRawAdj
--from #ProductManager A,
--xt_FGWrkCalCost B
--where A.SiteID = B.User5 
--if @@error <> 0 GOTO Abort  

--Update A
--set  A.RawCost =  round(A.Qty *  (B.TotalCost / B.Qty),3) ,
--A.COGS = A.Raw16Cost + round(A.Qty *  (B.TotalCost / B.Qty),3)
--from #ProductManager A,
--(
--	select SiteID, max(TotalRaw) as TotalCost, sum(Qty) as Qty From #ProductManager Group by SiteID
--) B
--where A.SiteID =  B.SiteID
--if @@error <> 0 GOTO Abort  

--Update A
--set A.Status = 'WIP'
--from #ProductManager A
--where A.Status = ''
--if @@error <> 0 GOTO Abort 
---------------------------------------------NEW
Update A
set A.Total16Cost = B.CostTotal - (B.CostRawMaterial - B.S4Future04) - B.AquaticRawAdj
from #ProductManager A,
#xt_FGWrkCalCost B
where A.SiteID = B.User5
if @@error <> 0 GOTO Abort  

Update A
set A.Raw16Cost =  round(A.AllocPct *  (B.TotalCost / B.Qty),3)
from #ProductManager A,
(
	select SiteID, max(Total16Cost) as TotalCost, sum(AllocPct) as Qty From #ProductManager Group by SiteID
) B
where A.SiteID =  B.SiteID
if @@error <> 0 GOTO Abort  

Update A
set A.UnitCost = B.StdCost
from #ProductManager A
inner join #ProductManagerIS B on A.SiteID =  B.SiteID and A.Prodmgrid = B.Prodmgrid
if @@error <> 0 GOTO Abort  


Update A
set A.RawCost = B.TranAmt
from #ProductManager A
inner join #ProductManagerVoid B on A.SiteID =  B.SiteID and A.Prodmgrid = B.Prodmgrid
where A.Status = 'FINISH'
if @@error <> 0 GOTO Abort

Update A
set A.RawCost = A.RawCost + B.TranAmt
from #ProductManager A
inner join #ProductManagerRC B on A.SiteID =  B.SiteID and A.Prodmgrid = B.Prodmgrid
where A.Status = 'FINISH'
if @@error <> 0 GOTO Abort

Update A
set A.AdjCost = B.CostOnhand
from #ProductManager A
inner join --#ProductManagerAdjust 
(
select SiteID ,Prodmgrid, sum(Qty) as TotalOnhand, SUM(COGS) as CostOnhand
from #ProductManagerAdjust
group by SiteID, Prodmgrid
)
B on A.SiteID =  B.SiteID and A.Prodmgrid = B.Prodmgrid
where A.Status = 'FINISH'
if @@error <> 0 GOTO Abort

Update A
set A.TotalRaw = A.UnitCost * (A.Qty - A.QtyWip), A.COGS =  A.UnitCost * A.COGS--, A.AdjCost =  B.AquaticRawAdj
from #ProductManager A
if @@error <> 0 GOTO Abort  

update A
set A.COGS = A.Raw16Cost + (TotalRaw - RawCost + AdjCost) -- A.COGS - RawCost 
from #ProductManager A
if @@error <> 0 GOTO Abort  

Update A
set A.Status = 'WIP'
from #ProductManager A
where A.Status = ''
if @@error <> 0 GOTO Abort 


delete xt_FGWrkCalCost where perpost = @parm1

delete xt_FGWrkCalCostDet where perpost = @parm1



insert into xt_FGWrkCalCost (Perpost, UserAddress, CostRawMaterial , CostPacking , AquaticRawAdj , CattleRawAdj , AquaticRawPend , CattleRawPend , AquaticCost00 , AquaticCost01 , AquaticCost02 , AquaticCost03 , AquaticCost04 , AquaticCost05 , AquaticCost06 , AquaticCost07 , AquaticCost08 , AquaticCost09 , AquaticCost10 , AquaticCost11 , AquaticCost12 , AquaticCost13 , AquaticCost14 , AquaticCost15 , AquaticCost16 , AquaticCost17 , AquaticCost18 , AquaticCost19 , AquaticCost20 , CattleCost00 , CattleCost01 , CattleCost02 , CattleCost03 , CattleCost04 , CattleCost05 , CattleCost06 , CattleCost07 , CattleCost08 , CattleCost09 , CattleCost10 , CattleCost11 , CattleCost12 , CattleCost13 , CattleCost14 , CattleCost15 , CattleCost16 , CattleCost17 , CattleCost18 , CattleCost19 , CattleCost20 , TotalQtyRC , CostTotal , TotalOnhand , CostOnhand, Crtd_DateTime, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, User1, User2, User3, User4, User5, User6, User7, User8)
SELECT @parm1, @parm2, CostRawMaterial ,CostPacking ,AquaticRawAdj ,CattleRawAdj ,AquaticRawPend ,CattleRawPend ,AquaticCost00 ,AquaticCost01 ,AquaticCost02 ,AquaticCost03 ,AquaticCost04 ,AquaticCost05 ,AquaticCost06 ,AquaticCost07 ,AquaticCost08 ,AquaticCost09 ,AquaticCost10 ,AquaticCost11 ,AquaticCost12 ,AquaticCost13 ,AquaticCost14 ,AquaticCost15 ,AquaticCost16 ,AquaticCost17 ,AquaticCost18 ,AquaticCost19 ,AquaticCost20 ,CattleCost00 ,CattleCost01 ,CattleCost02 ,CattleCost03 ,CattleCost04 ,CattleCost05 ,CattleCost06 ,CattleCost07 ,CattleCost08 ,CattleCost09 ,CattleCost10 ,CattleCost11 ,CattleCost12 ,CattleCost13 ,CattleCost14 ,CattleCost15 ,CattleCost16 ,CattleCost17 ,CattleCost18 ,CattleCost19 ,CattleCost20 ,TotalQtyRC ,CostTotal ,TotalOnhand ,CostOnhand ,Crtd_DateTime, S4Future01, S4Future02,S4Future03,S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10,S4Future11,S4Future12, User1, User2, User3, User4, User5, User6, User7, User8
From #xt_FGWrkCalCost

insert into xt_FGWrkCalCostDet(Perpost, UserAddress, Prodmgrid, TranDesc, Qty, AllocPct, AllocAmt, COGS, LineNbr, Crtd_DateTime, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, User1, User2, User3, User4, User5, User6, User7, User8)
SELECT @parm1, @parm2, Prodmgrid, TranDesc, Qty,AllocPct AllocPct,Raw16Cost AllocAmt, COGS, LineNbr,getdate() Crtd_DateTime, Status S4Future01,'' S4Future02,NumOfDate S4Future03,UnitCost S4Future04,RawCost S4Future05,AdjCost S4Future06,'' S4Future07,'' S4Future08,0 S4Future09,0 S4Future10,'' S4Future11,'' S4Future12,InvtID User1,'' User2,round((TotalRaw - RawCost + AdjCost),3) User3,0 User4,SiteID User5,'' User6,'1900/01/01' User7,'1900/01/01' User8
FROM #ProductManager

if @@error <> 0 GOTO Abort  

  
Commital:  
 commit tran TranIN  
 GOTO Finish  
  
Abort:  
 rollback tran TranIN  
  
Finish:
