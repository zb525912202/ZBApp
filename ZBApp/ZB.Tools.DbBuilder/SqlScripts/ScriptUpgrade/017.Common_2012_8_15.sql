

--print '--------------------增加题型特殊字符------------------------------------'

--IF NOT EXISTS(SELECT * FROM CharacterType WHERE Id=8)
--BEGIN

--INSERT CharacterType VALUES(8,'判断题',0,8);
--INSERT Character VALUES(578,8,'对','√','',1);
--INSERT Character VALUES(579,8,'错','×','',2);
--INSERT Character VALUES(580,8,'对','对','',3);
--INSERT Character VALUES(581,8,'错','错','',4);
--INSERT Character VALUES(582,8,'是','是','',5);
--INSERT Character VALUES(583,8,'否','否','',6);
--INSERT Character VALUES(584,8,'真','真','',7);
--INSERT Character VALUES(585,8,'假','假','',8);

--END



--IF NOT EXISTS(SELECT * FROM CharacterType WHERE Id=9)
--BEGIN

--INSERT CharacterType VALUES(9,'选择题',0,8);
--INSERT Character VALUES(586,9,'A','A','',1);
--INSERT Character VALUES(587,9,'B','B','',2);
--INSERT Character VALUES(588,9,'C','C','',3);
--INSERT Character VALUES(589,9,'D','D','',4);
--INSERT Character VALUES(590,9,'E','E','',5);
--INSERT Character VALUES(591,9,'F','F','',6);
--INSERT Character VALUES(592,9,'G','G','',7);
--INSERT Character VALUES(593,9,'H','H','',8);
--INSERT Character VALUES(594,9,'I','I','',9);
--INSERT Character VALUES(595,9,'J','J','',10);
--INSERT Character VALUES(596,9,'a','a','',11);
--INSERT Character VALUES(597,9,'b','b','',12);
--INSERT Character VALUES(598,9,'c','c','',13);
--INSERT Character VALUES(599,9,'d','d','',14);
--INSERT Character VALUES(600,9,'e','e','',15);
--INSERT Character VALUES(601,9,'f','f','',16);
--INSERT Character VALUES(602,9,'g','g','',17);
--INSERT Character VALUES(603,9,'h','h','',18);
--INSERT Character VALUES(604,9,'i','i','',19);
--INSERT Character VALUES(605,9,'j','j','',20);
--INSERT Character VALUES(606,9,'Ⅰ','Ⅰ','',21);
--INSERT Character VALUES(607,9,'Ⅱ','Ⅱ','',22);
--INSERT Character VALUES(608,9,'Ⅲ','Ⅲ','',23);
--INSERT Character VALUES(609,9,'Ⅳ','Ⅳ','',24);
--INSERT Character VALUES(610,9,'Ⅴ','Ⅴ','',25);
--INSERT Character VALUES(611,9,'Ⅵ','Ⅵ','',26);
--INSERT Character VALUES(612,9,'Ⅶ','Ⅶ','',27);
--INSERT Character VALUES(613,9,'Ⅷ','Ⅷ','',28);
--INSERT Character VALUES(614,9,'Ⅸ','Ⅸ','',29);
--INSERT Character VALUES(615,9,'Ⅹ','Ⅹ','',30);

--END

