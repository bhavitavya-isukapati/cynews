CREATE TABLE "news_items" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"summary" text NOT NULL,
	"content" text NOT NULL,
	"type" text NOT NULL,
	"scope" text NOT NULL,
	"is_india_related" boolean DEFAULT false,
	"india_confidence" integer DEFAULT 0,
	"indian_state" varchar(5),
	"indian_state_name" varchar(100),
	"indian_city" varchar(100),
	"indian_sector" varchar(100),
	"severity" text NOT NULL,
	"category" text NOT NULL,
	"source" text NOT NULL,
	"source_url" text,
	"region" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"tags" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"iocs" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"affected_systems" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"mitigations" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"bookmarked" boolean DEFAULT false NOT NULL,
	"published_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "advisories" (
	"id" serial PRIMARY KEY NOT NULL,
	"cve_id" text NOT NULL,
	"title" text NOT NULL,
	"description" text NOT NULL,
	"cvss_score" double precision NOT NULL,
	"severity" text NOT NULL,
	"affected_products" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"vendor" text NOT NULL,
	"patch_available" boolean DEFAULT false NOT NULL,
	"patch_url" text,
	"workarounds" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"references" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"status" text DEFAULT 'new' NOT NULL,
	"published_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"scope" text DEFAULT 'global' NOT NULL,
	"is_india_related" boolean DEFAULT false,
	"india_confidence" integer DEFAULT 0,
	"source_url" text,
	"source" varchar(100),
	"summary" text,
	"content" text,
	"category" varchar(100),
	"is_cert_in" boolean DEFAULT false,
	"cert_in_id" varchar(50),
	"cert_in_type" varchar(50),
	"cve_ids" jsonb DEFAULT '[]'::jsonb,
	"recommendations" jsonb DEFAULT '[]'::jsonb
);
--> statement-breakpoint
CREATE TABLE "threat_intel" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"summary" text NOT NULL,
	"description" text NOT NULL,
	"scope" text NOT NULL,
	"is_india_related" boolean DEFAULT false,
	"india_confidence" integer DEFAULT 0,
	"indian_state" varchar(5),
	"indian_state_name" varchar(100),
	"indian_city" varchar(100),
	"indian_sector" varchar(100),
	"severity" text NOT NULL,
	"category" text NOT NULL,
	"threat_actor" text,
	"threat_actor_aliases" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"target_sectors" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"target_regions" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"ttps" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"iocs" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"malware_families" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"affected_systems" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"mitigations" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"source" text NOT NULL,
	"source_url" text,
	"references" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"campaign_name" text,
	"status" text DEFAULT 'active' NOT NULL,
	"confidence_level" text DEFAULT 'medium' NOT NULL,
	"first_seen" timestamp,
	"last_seen" timestamp,
	"published_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "workspaces" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" varchar(255) NOT NULL,
	"domain" varchar(255) NOT NULL,
	"description" text,
	"is_default" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "workspace_products" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"workspace_id" uuid NOT NULL,
	"product_name" varchar(255) NOT NULL,
	"vendor" varchar(255),
	"version" varchar(100),
	"category" varchar(100),
	"keywords" jsonb DEFAULT '[]'::jsonb,
	"enabled" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "workspace_threat_matches" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"workspace_id" uuid NOT NULL,
	"threat_id" integer NOT NULL,
	"matched_product" varchar(255),
	"matched_keyword" varchar(255),
	"relevance_score" real,
	"reviewed" boolean DEFAULT false,
	"dismissed" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "workspace_settings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"workspace_id" uuid NOT NULL,
	"alert_on_critical" boolean DEFAULT true,
	"alert_on_high" boolean DEFAULT true,
	"alert_on_medium" boolean DEFAULT false,
	"auto_match_threats" boolean DEFAULT true
);
--> statement-breakpoint
ALTER TABLE "workspace_products" ADD CONSTRAINT "workspace_products_workspace_id_workspaces_id_fk" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "workspace_threat_matches" ADD CONSTRAINT "workspace_threat_matches_workspace_id_workspaces_id_fk" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "workspace_threat_matches" ADD CONSTRAINT "workspace_threat_matches_threat_id_threat_intel_id_fk" FOREIGN KEY ("threat_id") REFERENCES "public"."threat_intel"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "workspace_settings" ADD CONSTRAINT "workspace_settings_workspace_id_workspaces_id_fk" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;