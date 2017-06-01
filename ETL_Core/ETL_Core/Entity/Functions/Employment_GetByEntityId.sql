CREATE function Entity.Employment_GetByEntityId(@IdNumber varchar(10), @EmploymentSequence smallint)
returns table
as
return
	select 
		  ID_NUMBER EmployeeId
		, XSEQUENCE EmployeeSequence 
		, HasGreaterThan3Records
		, employerName EmployerName
		, JOB_TITLE	JobTitle
		, employerUnit EmployerUnit

	from 
		(
			select
				  employee.ID_NUMBER 
				, row_number() over (partition by employee.ID_NUMBER order by employee.XSEQUENCE ASC) XSEQUENCE
				, case 
					when MAX(XSEQUENCE) over (partition by employee.ID_NUMBER) > 3 
						then 1 
					else 0 
						end HasGreaterThan3Records
				, case 
					when employer.PREF_MAIL_NAME is null 
						then ltrim(rtrim(EMPLOYER_NAME1)) 
					else employer.PREF_MAIL_NAME 
						end employerName
				, JOB_TITLE	
				, EMPLOYER_UNIT employerUnit
			from AIS_Prod.ADVANCE.EMPLOYMENT employee
				left outer join AIS_Prod.ADVANCE.ENTITY employer
					on employer.ID_NUMBER = employee.EMPLOYER_ID_NUMBER
					and employer.IS_ACTIVE = 1
			WHERE employee.IS_ACTIVE = 1
				and employee.JOB_STATUS_CODE = 'C'
				
		) a
	where
		ID_NUMBER = @IdNumber
		and XSEQUENCE = @EmploymentSequence;