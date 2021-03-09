
-- create a table with hierarchyid data type column
-- and two other columns
create table SimpleDemo  
(Node hierarchyid not null,  
[Geographical Name] nvarchar(30) not null,  
[Geographical Type] nvarchar(9) NULL);
 
insert SimpleDemo  
values
-- second level data 
 ('/1/1/','China','Country')
,('/1/2/','Japan','Country')
,('/1/3/','South Korea','Country')
,('/2/1/','South Africa','Country')
,('/2/2/','Egypt','Country')
,('/3/1/','Australia','Country')
 
-- first level data
,('/1/','Asia','Continent')
,('/2/','Africa','Continent')
,('/3/','Oceania','Continent')
 
-- third level data
,('/1/1/1/','Beijing','City')
,('/1/2/1/','Tokyo','City')
,('/1/3/1/','Seoul','City')
,('/2/1/1/','Pretoria','City')
,('/2/2/1/','Cairo','City')
,('/3/1/1/','Canberra','City')
 
-- root level data
,('/', 'Earth', 'Planet')  
 
 
-- display without sort order returns 
-- rows in input order
select 
 Node
,Node.ToString() AS [Node Text]
,Node.GetLevel() [Node Level],
Node.GetAncestor(1),
,[Geographical Name]
,[Geographical Type]   
from SimpleDemo	


select 
	Node, 
	Node.ToString(), 
	Node.GetLevel(), 
	Node.GetAncestor(1) as ParentNode,
	Node.GetAncestor(1).ToString() as ParentNodeText	
from SimpleDemo
	


