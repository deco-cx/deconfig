-- Table Definition
CREATE TABLE "public"."configs" (
    "created_at" timestamptz DEFAULT now(),
    "active" bool NOT NULL DEFAULT false,
    "key" text NOT NULL,
    "value" json,
    "description" text,
    PRIMARY KEY ("key")
);


-- Table Comment
COMMENT ON TABLE "public"."configs" IS 'dynamic edge configuration data';