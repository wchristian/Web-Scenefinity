-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sun Aug 12 18:39:59 2012
-- 
;
--
-- Table: video
--
CREATE TABLE "video" (
  "video_id" serial NOT NULL,
  "yt_id" text NOT NULL,
  PRIMARY KEY ("video_id"),
  CONSTRAINT "video_yt_id" UNIQUE ("yt_id")
);

