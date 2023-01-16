-- Table Definition
CREATE TABLE "public"."configs" (
    "id" int8 NOT NULL,
    "created_at" timestamptz DEFAULT now(),
    "active" bool NOT NULL DEFAULT false,
    "key" text NOT NULL,
    "value" json,
    "description" text,
    PRIMARY KEY ("id")
);


-- Table Comment
COMMENT ON TABLE "public"."configs" IS 'dynamic edge configuration data';