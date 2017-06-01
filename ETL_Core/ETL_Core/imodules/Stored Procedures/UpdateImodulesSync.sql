create procedure imodules.UpdateImodulesSync
as

begin transaction

UPDATE dbo.UCD_IMODULES_SYNC
set is_active = 1 
	from dbo.ucd_imodules_sync a 
	   left outer join 
				(
				select 
					id_number
					, max(date_activated) maxActDate 
				from dbo.ucd_imodules_sync  
				group by id_number
				) b 
			on a.id_number = b.id_number 
			and a.date_activated = b.maxActDate 
where b.maxActDate is not null

commit transaction;
-- ---------------------------------------------------
-- ---------------------------------------------------

begin transaction

UPDATE dbo.UCD_IMODULES_SYNC
set	
	  is_active = 0
	, date_inactivated = current_timestamp 
from dbo.ucd_imodules_sync  a 
	left outer join 
		(
		select 
			  id_number
			, max(date_activated) maxActDate 
		from dbo.ucd_imodules_sync  
		group by id_number
		) b 
	on a.id_number = b.id_number 
	and a.date_activated = b.maxActDate 
where b.maxActDate is null 
	and a.is_active = 1

commit transaction;