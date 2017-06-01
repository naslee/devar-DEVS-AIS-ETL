CREATE FUNCTION dbo.IsDevOfficerAssignedToProposal (@officerId NVARCHAR(10), @proposalId BIGINT)
RETURNS BIT
AS
BEGIN
  DECLARE @V_RETURN BIT;
  SET @V_RETURN = (SELECT isnull(max(1),0)
					FROM AIS_Prod.ADVANCE.ASSIGNMENT a 
					WHERE a.IS_ACTIVE = 1
						  and a.ACTIVE_IND='Y'
						  and a.ASSIGNMENT_ID_NUMBER = @officerId
						  and a.PROPOSAL_ID = @proposalId);
RETURN(@V_RETURN);
END;