CREATE TABLE 'difficulties' (
	'id'				INTEGER PRIMARY KEY,
	'name' 				TEXT,
	'enum_value' 		INTEGER,
	'language' 			TEXT);
	
CREATE TABLE 'levels' (
  	'id' 				INTEGER PRIMARY KEY,
  	'value' 			INTEGER,
  	'difficulty_id' 	INTEGER,
  	'release_date' 		INTEGER,
  	'language' 			TEXT,
  	'extra1' 			TEXT,
  	'extra2' 			TEXT,
  	'extra3' 			TEXT,
  	'fextra1' 			REAL,
  	'fextra2' 			REAL,
  	'fextra3' 			REAL);
  
CREATE TABLE 'medias' (
	'id' 				INTEGER PRIMARY KEY,
	'title' 			TEXT,
	'rects' 			TEXT,
	'difficulty' 		INTEGER,
	'language' 			TEXT,
	'time' 				REAL,
	'variants' 			TEXT,
	'extra1' 			TEXT,
	'extra2' 			TEXT,
	'extra3' 			TEXT,
	'fextra1' 			REAL,
	'fextra2' 			REAL,
	'fextra3' 			REAL);
	
CREATE TABLE 'packs' (
  	'id' 				INTEGER PRIMARY KEY,
  	'level_id' 			INTEGER,
  	'title' 			TEXT,
  	'author' 			TEXT,
  	'language'  		TEXT,
  	'extra1' 			TEXT,
  	'extra2' 			TEXT,
  	'extra3' 			TEXT,
  	'fextra1' 			REAL,
  	'fextra2' 			REAL,
  	'fextra3' 			REAL);
  
CREATE TABLE 'packs_medias' (
  	'media_id' 			INTEGER,
  	'pack_id' 			INTEGER,
  	'position' 			INTEGER,
  	'completed' 		INTEGER,
  	PRIMARY KEY ('media_id', 'pack_id'));
