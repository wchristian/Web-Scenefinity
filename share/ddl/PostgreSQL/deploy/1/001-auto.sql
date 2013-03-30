-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Fri Mar 29 19:49:50 2013
-- 
;
--
-- Table: video.
--
CREATE TABLE "video" (
  "video_id" serial NOT NULL,
  "yt_id" text NOT NULL,
  PRIMARY KEY ("video_id"),
  CONSTRAINT "video_yt_id" UNIQUE ("yt_id")
);

;
