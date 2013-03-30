-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Mar 29 19:49:51 2013
-- 

;
BEGIN TRANSACTION;
--
-- Table: video
--
CREATE TABLE video (
  video_id INTEGER PRIMARY KEY NOT NULL,
  yt_id text NOT NULL
);
CREATE UNIQUE INDEX video_yt_id ON video (yt_id);
COMMIT;
