INSERT INTO `jobs` (name, label) VALUES
	('police', 'Police')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('police',0,'recruit','recruit',20,'{}','{}'),
    ('police',0,'police','agent',20,'{}','{}'),
	('police',0,'experimented','general',20,'{}','{}'),
	('police',0,'chief','sub-director',20,'{}','{}'),
	('police',1,'boss','director',40,'{}','{}')
;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_police', 'Police', 1)
;


INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_police', 'Police', 1)
;