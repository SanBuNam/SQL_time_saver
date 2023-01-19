

SELECT fd.[FileName] AS 'Loan Number'
,org.[Name] AS 'Broker Name'
,lon.[LoanProgramCode] AS 'Loan Program Code'
,CASE lon.[LoanPurpose] WHEN 1 THEN 'Purchase' WHEN 2 THEN 'Refinance' END AS 'Loan Purpose'
,org.[Code] AS 'Broker Code'
,uw.[FirstName] + ' ' + uw.[LastName] AS 'Underwriter'
,ae.[FirstName] + ' ' + ae.[LastName] AS 'AE Name'
,am.[FirstName] + ' ' + am.[LastName] AS 'AM Name'
,lo.[FirstName] + ' ' + lo.[LastName] AS 'LO Name'

,IsNull(Convert(varchar(20), st.[ApprovedDate], 101), '') AS 'UW Approved Date'
,IsNull(Convert(varchar(20), lon.[LockStartDate], 101), '') AS 'Locked Date'
,IsNull(Convert(varchar(20), lon.[LockExpirationDate], 101), '') AS 'Lock Expiration Date'
,IsNull(Convert(varchar(20), [cnd_Received].[ReceivedDate], 101), '') as 'Last Condition Received'
,IsNull(Convert(varchar(20), [cnd_Submitted].[SubmittedDate], 101), '') as 'Last Condition Submitted'
,IsNull(Convert(varchar(20), [cnd_Cleared].[ClearedDate], 101), '') as 'Last Condition Cleared'

,CASE
     WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
END as 'Last Activity Date'

,IsNull([CountCleared].ClearedCount,0) as 'No of Cleared'
,IsNull([CountTotal].TotalCount, 0) as 'Total Count'

,CASE WHEN (CASE
     WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
 END) IS NULL AND DATEDIFF(day,st.[ApprovedDate], Cast(GetDate() as Date)) = 2 THEN '2 Days No Activity' ELSE '' END AS '2 Days Activity check'

 ,CASE WHEN (CASE
     WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Received].[ReceivedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] > [cnd_Submitted].[SubmittedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Cleared].[ClearedDate] THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] > [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Submitted].[SubmittedDate] THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Cleared].[ClearedDate] >= [cnd_Received].[ReceivedDate] AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
	 WHEN [cnd_Received].[ReceivedDate] IS NOT NULL AND [cnd_Submitted].[SubmittedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Received].[ReceivedDate] as Date), '')
	 WHEN [cnd_Submitted].[SubmittedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Cleared].[ClearedDate] IS NULL THEN IsNull(Cast([cnd_Submitted].[SubmittedDate] as Date), '')
	 WHEN [cnd_Cleared].[ClearedDate] IS NOT NULL AND [cnd_Received].[ReceivedDate] IS NULL AND [cnd_Submitted].[SubmittedDate] IS NULL THEN IsNull(Cast([cnd_Cleared].[ClearedDate] as Date), '')
 END) IS NULL AND DATEDIFF(day,st.[ApprovedDate], Cast(GetDate() as Date)) = 5 THEN '5 Days No Activity' ELSE '' END AS '5 Days Activity check'

FROM [FileData] fd
LEFT JOIN [Organization] org on org.[OrganizationID] = fd.[OrganizationID]
LEFT JOIN [Loan] lon on lon.[FileDataID] = fd.[FileDataID]
LEFT JOIN [User] uw on uw.[UserName] = fd.[UnderwriterUserName]
LEFT JOIN [User] ae on ae.[UserName] = fd.[OtherUserName]
LEFT JOIN [User] am on am.[UserName] = fd.[OtherUser2Name]
LEFT JOIN [User] lo on lo.[UserName] = fd.[LoanOfficerUserName]
LEFT JOIN [Status] st on st.[FileDataID] = fd.[FileDataID]
LEFT JOIN (SELECT [FileDataID], [SubmittedDate] FROM (SELECT ROW_NUMBER() OVER (PARTITION BY [FileDataID] ORDER BY [SubmittedDate] DESC) AS rn, * FROM [Condition]) cnd WHERE cnd.rn=1) cnd_Submitted ON cnd_Submitted.FileDataID = fd.FileDataID
LEFT JOIN (SELECT [FileDataID], [ClearedDate] FROM (SELECT ROW_NUMBER() OVER (PARTITION BY [FileDataID] ORDER BY [ClearedDate] DESC) AS rn, * FROM [Condition]) cnd WHERE cnd.rn=1) cnd_Cleared ON cnd_Cleared.FileDataID = fd.FileDataID
LEFT JOIN (SELECT [FileDataID], [ReceivedDate] FROM (SELECT ROW_NUMBER() OVER (PARTITION BY [FileDataID] ORDER BY [ReceivedDate] DESC) AS rn, * FROM [Condition]) cnd WHERE cnd.rn=1) cnd_Received ON cnd_Received.FileDataID = fd.FileDataID
LEFT JOIN (SELECT [FileDataID], Count(*) AS ClearedCount FROM [Condition] WHERE [ConditionStage] = 1 AND [IsInternal] = 0 AND [ClearedDate] IS NOT NULL GROUP BY [FileDataID]) CountCleared ON CountCleared.FileDataID = fd.FileDataID
LEFT JOIN (SELECT [FileDataID], Count(*) AS TotalCount FROM [Condition] WHERE [ConditionStage] = 1 AND [IsInternal] = 0 GROUP BY [FileDataID]) CountTotal ON CountTotal.[FileDataID] = fd.FileDataID
WHERE st.LoanStatus = 5 AND fd.[FileName] NOT LIKE 'TEST%' 
order by uw.UserName