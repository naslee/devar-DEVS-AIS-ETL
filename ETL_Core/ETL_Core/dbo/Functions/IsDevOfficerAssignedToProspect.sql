CREATE FUNCTION dbo.IsDevOfficerAssignedToProspect (@officerId NVARCHAR(10), @prospectId BIGINT)
RETURNS BIT
AS
BEGIN
  DECLARE @V_RETURN BIT;
  SET @V_RETURN = (SELECT isnull(max(1),0)
					FROM AIS_Prod.ADVANCE.ASSIGNMENT a 
					WHERE a.IS_ACTIVE = 1
						  and a.ACTIVE_IND='Y'
						  and a.ASSIGNMENT_ID_NUMBER = @officerId
						  and a.PROSPECT_ID = @prospectId
						  and a.PROPOSAL_ID is null /*prospect assignments only*/);
RETURN(@V_RETURN);
END;