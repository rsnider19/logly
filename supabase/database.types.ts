export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      _user_activities_by_date: {
        Row: {
          activity_count: number
          activity_date: string
          user_activities: Json
          user_id: string
        }
        Insert: {
          activity_count: number
          activity_date: string
          user_activities?: Json
          user_id: string
        }
        Update: {
          activity_count?: number
          activity_date?: string
          user_activities?: Json
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "public__user_activities_by_date_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      _user_activity_category_month: {
        Row: {
          activity_category_id: string | null
          activity_count: number
          activity_month: string
          user_activity_category_month_id: string
          user_id: string
        }
        Insert: {
          activity_category_id?: string | null
          activity_count?: number
          activity_month: string
          user_activity_category_month_id?: string
          user_id: string
        }
        Update: {
          activity_category_id?: string | null
          activity_count?: number
          activity_month?: string
          user_activity_category_month_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "_user_activity_category_month_activity_category_id_fkey"
            columns: ["activity_category_id"]
            isOneToOne: false
            referencedRelation: "activity_category"
            referencedColumns: ["activity_category_id"]
          },
          {
            foreignKeyName: "_user_activity_category_month_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      _user_activity_category_summary: {
        Row: {
          activity_category_id: string
          activity_count: number
          user_id: string
        }
        Insert: {
          activity_category_id: string
          activity_count?: number
          user_id: string
        }
        Update: {
          activity_category_id?: string
          activity_count?: number
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "_user_activity_category_summary_activity_category_id_fkey"
            columns: ["activity_category_id"]
            isOneToOne: false
            referencedRelation: "activity_category"
            referencedColumns: ["activity_category_id"]
          },
          {
            foreignKeyName: "_user_activity_category_summary_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      _user_activity_streak: {
        Row: {
          current_streak: number
          longest_streak: number
          user_id: string
          workout_days_this_week: number
        }
        Insert: {
          current_streak?: number
          longest_streak?: number
          user_id: string
          workout_days_this_week?: number
        }
        Update: {
          current_streak?: number
          longest_streak?: number
          user_id?: string
          workout_days_this_week?: number
        }
        Relationships: [
          {
            foreignKeyName: "public__user_activity_streak_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: true
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      activity: {
        Row: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }
        Insert: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id?: string
          created_at?: string
          created_by?: string
          description?: string | null
          embedding_content?: string | null
          hex_color?: string | null
          icon?: string | null
          is_suggested_favorite?: boolean | null
          legacy_id?: number | null
          name: string
          pace_type?: Database["public"]["Enums"]["pace_type"] | null
          updated_at?: string | null
        }
        Update: {
          activity_category_id?: string
          activity_code?: string
          activity_date_type?: Database["public"]["Enums"]["activity_date_type"]
          activity_id?: string
          created_at?: string
          created_by?: string
          description?: string | null
          embedding_content?: string | null
          hex_color?: string | null
          icon?: string | null
          is_suggested_favorite?: boolean | null
          legacy_id?: number | null
          name?: string
          pace_type?: Database["public"]["Enums"]["pace_type"] | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "activity_activity_category_id_fkey"
            columns: ["activity_category_id"]
            isOneToOne: false
            referencedRelation: "activity_category"
            referencedColumns: ["activity_category_id"]
          },
          {
            foreignKeyName: "activity_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      activity_category: {
        Row: {
          activity_category_code: string
          activity_category_id: string
          created_at: string
          created_by: string
          description: string | null
          hex_color: string
          icon: string
          legacy_id: number
          name: string
          sort_order: number
        }
        Insert: {
          activity_category_code: string
          activity_category_id?: string
          created_at?: string
          created_by: string
          description?: string | null
          hex_color: string
          icon: string
          legacy_id: number
          name: string
          sort_order: number
        }
        Update: {
          activity_category_code?: string
          activity_category_id?: string
          created_at?: string
          created_by?: string
          description?: string | null
          hex_color?: string
          icon?: string
          legacy_id?: number
          name?: string
          sort_order?: number
        }
        Relationships: [
          {
            foreignKeyName: "activity_category_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      activity_detail: {
        Row: {
          activity_detail_id: string
          activity_detail_type: Database["public"]["Enums"]["activity_detail_type"]
          activity_id: string
          created_at: string
          created_by: string
          imperial_uom: Database["public"]["Enums"]["imperial_uom"] | null
          label: string
          max_distance_in_meters: number | null
          max_duration_in_sec: number | null
          max_liquid_volume_in_liters: number | null
          max_numeric: number | null
          max_weight_in_kilograms: number | null
          metric_uom: Database["public"]["Enums"]["metric_uom"] | null
          min_distance_in_meters: number | null
          min_duration_in_sec: number | null
          min_liquid_volume_in_liters: number | null
          min_numeric: number | null
          min_weight_in_kilograms: number | null
          slider_interval: number | null
          sort_order: number
          updated_at: string | null
          updated_by: string | null
          use_for_pace_calculation: boolean
        }
        Insert: {
          activity_detail_id?: string
          activity_detail_type: Database["public"]["Enums"]["activity_detail_type"]
          activity_id: string
          created_at?: string
          created_by?: string
          imperial_uom?: Database["public"]["Enums"]["imperial_uom"] | null
          label: string
          max_distance_in_meters?: number | null
          max_duration_in_sec?: number | null
          max_liquid_volume_in_liters?: number | null
          max_numeric?: number | null
          max_weight_in_kilograms?: number | null
          metric_uom?: Database["public"]["Enums"]["metric_uom"] | null
          min_distance_in_meters?: number | null
          min_duration_in_sec?: number | null
          min_liquid_volume_in_liters?: number | null
          min_numeric?: number | null
          min_weight_in_kilograms?: number | null
          slider_interval?: number | null
          sort_order: number
          updated_at?: string | null
          updated_by?: string | null
          use_for_pace_calculation?: boolean
        }
        Update: {
          activity_detail_id?: string
          activity_detail_type?: Database["public"]["Enums"]["activity_detail_type"]
          activity_id?: string
          created_at?: string
          created_by?: string
          imperial_uom?: Database["public"]["Enums"]["imperial_uom"] | null
          label?: string
          max_distance_in_meters?: number | null
          max_duration_in_sec?: number | null
          max_liquid_volume_in_liters?: number | null
          max_numeric?: number | null
          max_weight_in_kilograms?: number | null
          metric_uom?: Database["public"]["Enums"]["metric_uom"] | null
          min_distance_in_meters?: number | null
          min_duration_in_sec?: number | null
          min_liquid_volume_in_liters?: number | null
          min_numeric?: number | null
          min_weight_in_kilograms?: number | null
          slider_interval?: number | null
          sort_order?: number
          updated_at?: string | null
          updated_by?: string | null
          use_for_pace_calculation?: boolean
        }
        Relationships: [
          {
            foreignKeyName: "activity_detail_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: false
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
          {
            foreignKeyName: "activity_detail_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "activity_detail_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      activity_embedding: {
        Row: {
          activity_id: string
          created_at: string | null
          embedding: unknown
          fts: unknown
          updated_at: string | null
        }
        Insert: {
          activity_id: string
          created_at?: string | null
          embedding?: unknown
          fts?: unknown
          updated_at?: string | null
        }
        Update: {
          activity_id?: string
          created_at?: string | null
          embedding?: unknown
          fts?: unknown
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "activity_embedding_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: true
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
        ]
      }
      ai_insight_suggested_prompt: {
        Row: {
          created_at: string | null
          display_order: number
          is_active: boolean
          prompt_id: string
          prompt_text: string
        }
        Insert: {
          created_at?: string | null
          display_order?: number
          is_active?: boolean
          prompt_id?: string
          prompt_text: string
        }
        Update: {
          created_at?: string | null
          display_order?: number
          is_active?: boolean
          prompt_id?: string
          prompt_text?: string
        }
        Relationships: []
      }
      external_data: {
        Row: {
          created_at: string
          data: Json
          external_data_id: string
          external_data_source: Database["public"]["Enums"]["external_data_source"]
          updated_at: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          data: Json
          external_data_id: string
          external_data_source: Database["public"]["Enums"]["external_data_source"]
          updated_at?: string | null
          user_id?: string
        }
        Update: {
          created_at?: string
          data?: Json
          external_data_id?: string
          external_data_source?: Database["public"]["Enums"]["external_data_source"]
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "external_data_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      external_data_mapping: {
        Row: {
          activity_id: string | null
          external_data_mapping_id: string
          external_data_source: Database["public"]["Enums"]["external_data_source"]
          source_name: string
          sub_activity_id: string | null
        }
        Insert: {
          activity_id?: string | null
          external_data_mapping_id?: string
          external_data_source: Database["public"]["Enums"]["external_data_source"]
          source_name: string
          sub_activity_id?: string | null
        }
        Update: {
          activity_id?: string | null
          external_data_mapping_id?: string
          external_data_source?: Database["public"]["Enums"]["external_data_source"]
          source_name?: string
          sub_activity_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "external_data_mapping_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: false
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
          {
            foreignKeyName: "external_data_mapping_sub_activity_id_fkey"
            columns: ["sub_activity_id"]
            isOneToOne: false
            referencedRelation: "sub_activity"
            referencedColumns: ["sub_activity_id"]
          },
        ]
      }
      favorite_user_activity: {
        Row: {
          activity_id: string
          created_at: string
          user_id: string
        }
        Insert: {
          activity_id?: string
          created_at?: string
          user_id?: string
        }
        Update: {
          activity_id?: string
          created_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_favorite_user_activity_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: false
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
          {
            foreignKeyName: "public_favorite_user_activity_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      profile: {
        Row: {
          created_at: string
          last_health_sync_date: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          last_health_sync_date?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          last_health_sync_date?: string | null
          user_id?: string
        }
        Relationships: []
      }
      sub_activity: {
        Row: {
          activity_id: string
          created_at: string
          created_by: string
          embedding_content: string | null
          icon: string | null
          legacy_id: number
          name: string
          sub_activity_code: string
          sub_activity_id: string
          updated_at: string | null
        }
        Insert: {
          activity_id: string
          created_at?: string
          created_by: string
          embedding_content?: string | null
          icon?: string | null
          legacy_id: number
          name: string
          sub_activity_code: string
          sub_activity_id?: string
          updated_at?: string | null
        }
        Update: {
          activity_id?: string
          created_at?: string
          created_by?: string
          embedding_content?: string | null
          icon?: string | null
          legacy_id?: number
          name?: string
          sub_activity_code?: string
          sub_activity_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sub_activity_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: false
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
          {
            foreignKeyName: "sub_activity_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
        ]
      }
      sub_activity_embedding: {
        Row: {
          created_at: string | null
          embedding: unknown
          fts: unknown
          sub_activity_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          embedding?: unknown
          fts?: unknown
          sub_activity_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          embedding?: unknown
          fts?: unknown
          sub_activity_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sub_activity_embedding_sub_activity_id_fkey"
            columns: ["sub_activity_id"]
            isOneToOne: true
            referencedRelation: "sub_activity"
            referencedColumns: ["sub_activity_id"]
          },
        ]
      }
      trending_activity: {
        Row: {
          activity_category_id: string | null
          activity_id: string
          current_rank: number
          previous_rank: number
          rank_change: number
        }
        Insert: {
          activity_category_id?: string | null
          activity_id: string
          current_rank: number
          previous_rank: number
          rank_change: number
        }
        Update: {
          activity_category_id?: string | null
          activity_id?: string
          current_rank?: number
          previous_rank?: number
          rank_change?: number
        }
        Relationships: [
          {
            foreignKeyName: "public_trending_activity_activity_category_id_fkey"
            columns: ["activity_category_id"]
            isOneToOne: false
            referencedRelation: "activity_category"
            referencedColumns: ["activity_category_id"]
          },
          {
            foreignKeyName: "public_trending_activity_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: true
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
        ]
      }
      user_activity: {
        Row: {
          activity_id: string
          activity_name_override: string | null
          activity_timestamp: string
          comments: string | null
          created_at: string
          external_data_id: string | null
          updated_at: string | null
          user_activity_id: string
          user_id: string
        }
        Insert: {
          activity_id: string
          activity_name_override?: string | null
          activity_timestamp: string
          comments?: string | null
          created_at?: string
          external_data_id?: string | null
          updated_at?: string | null
          user_activity_id?: string
          user_id?: string
        }
        Update: {
          activity_id?: string
          activity_name_override?: string | null
          activity_timestamp?: string
          comments?: string | null
          created_at?: string
          external_data_id?: string | null
          updated_at?: string | null
          user_activity_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_user_activity_activity_id_fkey"
            columns: ["activity_id"]
            isOneToOne: false
            referencedRelation: "activity"
            referencedColumns: ["activity_id"]
          },
          {
            foreignKeyName: "public_user_activity_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_activity_external_data_id_fkey"
            columns: ["external_data_id", "user_id"]
            isOneToOne: false
            referencedRelation: "external_data"
            referencedColumns: ["external_data_id", "user_id"]
          },
        ]
      }
      user_activity_detail: {
        Row: {
          activity_detail_id: string
          activity_detail_type: Database["public"]["Enums"]["activity_detail_type"]
          created_at: string
          distance_in_meters: number | null
          duration_in_sec: number | null
          environment_value:
            | Database["public"]["Enums"]["environment_type"]
            | null
          lat_lng: unknown
          liquid_volume_in_liters: number | null
          numeric_value: number | null
          text_value: string | null
          updated_at: string | null
          user_activity_id: string
          weight_in_kilograms: number | null
        }
        Insert: {
          activity_detail_id: string
          activity_detail_type: Database["public"]["Enums"]["activity_detail_type"]
          created_at?: string
          distance_in_meters?: number | null
          duration_in_sec?: number | null
          environment_value?:
            | Database["public"]["Enums"]["environment_type"]
            | null
          lat_lng?: unknown
          liquid_volume_in_liters?: number | null
          numeric_value?: number | null
          text_value?: string | null
          updated_at?: string | null
          user_activity_id: string
          weight_in_kilograms?: number | null
        }
        Update: {
          activity_detail_id?: string
          activity_detail_type?: Database["public"]["Enums"]["activity_detail_type"]
          created_at?: string
          distance_in_meters?: number | null
          duration_in_sec?: number | null
          environment_value?:
            | Database["public"]["Enums"]["environment_type"]
            | null
          lat_lng?: unknown
          liquid_volume_in_liters?: number | null
          numeric_value?: number | null
          text_value?: string | null
          updated_at?: string | null
          user_activity_id?: string
          weight_in_kilograms?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "user_activity_detail_activity_detail_id_fkey"
            columns: ["activity_detail_id"]
            isOneToOne: false
            referencedRelation: "activity_detail"
            referencedColumns: ["activity_detail_id"]
          },
          {
            foreignKeyName: "user_activity_detail_user_activity_id_fkey"
            columns: ["user_activity_id"]
            isOneToOne: false
            referencedRelation: "user_activity"
            referencedColumns: ["user_activity_id"]
          },
        ]
      }
      user_activity_sub_activity: {
        Row: {
          sub_activity_id: string
          user_activity_id: string
        }
        Insert: {
          sub_activity_id: string
          user_activity_id: string
        }
        Update: {
          sub_activity_id?: string
          user_activity_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_activity_sub_activity_sub_activity_id_fkey"
            columns: ["sub_activity_id"]
            isOneToOne: false
            referencedRelation: "sub_activity"
            referencedColumns: ["sub_activity_id"]
          },
          {
            foreignKeyName: "user_activity_sub_activity_user_activity_id_fkey"
            columns: ["user_activity_id"]
            isOneToOne: false
            referencedRelation: "user_activity"
            referencedColumns: ["user_activity_id"]
          },
        ]
      }
      user_ai_insight: {
        Row: {
          created_at: string
          friendly_answer_resp: Json
          friendly_answer_timing_ms: number
          nl_to_sql_resp: Json
          nl_to_sql_timing_ms: number
          openai_conversion_id: string | null
          openai_response_id: string | null
          previous_conversion_id: string | null
          previous_response_id: string | null
          query_error: Json | null
          query_results: Json | null
          query_timing_ms: number
          user_ai_insight_id: string
          user_id: string
          user_query: string
        }
        Insert: {
          created_at?: string
          friendly_answer_resp: Json
          friendly_answer_timing_ms: number
          nl_to_sql_resp: Json
          nl_to_sql_timing_ms: number
          openai_conversion_id?: string | null
          openai_response_id?: string | null
          previous_conversion_id?: string | null
          previous_response_id?: string | null
          query_error?: Json | null
          query_results?: Json | null
          query_timing_ms: number
          user_ai_insight_id?: string
          user_id: string
          user_query: string
        }
        Update: {
          created_at?: string
          friendly_answer_resp?: Json
          friendly_answer_timing_ms?: number
          nl_to_sql_resp?: Json
          nl_to_sql_timing_ms?: number
          openai_conversion_id?: string | null
          openai_response_id?: string | null
          previous_conversion_id?: string | null
          previous_response_id?: string | null
          query_error?: Json | null
          query_results?: Json | null
          query_timing_ms?: number
          user_ai_insight_id?: string
          user_id?: string
          user_query?: string
        }
        Relationships: []
      }
      user_ai_insight_step: {
        Row: {
          created_at: string | null
          duration_ms: number | null
          input_context: Json | null
          insight_id: string
          output_result: Json | null
          step_id: string
          step_name: string
          token_usage: Json | null
        }
        Insert: {
          created_at?: string | null
          duration_ms?: number | null
          input_context?: Json | null
          insight_id: string
          output_result?: Json | null
          step_id?: string
          step_name: string
          token_usage?: Json | null
        }
        Update: {
          created_at?: string | null
          duration_ms?: number | null
          input_context?: Json | null
          insight_id?: string
          output_result?: Json | null
          step_id?: string
          step_name?: string
          token_usage?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "user_ai_insight_step_insight_id_fkey"
            columns: ["insight_id"]
            isOneToOne: false
            referencedRelation: "user_ai_insight"
            referencedColumns: ["user_ai_insight_id"]
          },
          {
            foreignKeyName: "user_ai_insight_step_insight_id_fkey"
            columns: ["insight_id"]
            isOneToOne: false
            referencedRelation: "user_ai_insights_report"
            referencedColumns: ["user_ai_insight_id"]
          },
        ]
      }
    }
    Views: {
      user_ai_insights_report: {
        Row: {
          created_at: string | null
          friendly_answer_input_cost: number | null
          friendly_answer_output_cost: number | null
          friendly_answer_resp: Json | null
          friendly_answer_timing_ms: number | null
          nl_to_sql_input_cost: number | null
          nl_to_sql_output_cost: number | null
          nl_to_sql_resp: Json | null
          nl_to_sql_timing_ms: number | null
          query_error: Json | null
          query_results: Json | null
          query_timing_ms: number | null
          total_cost: number | null
          total_time_ms: number | null
          user_ai_insight_id: string | null
          user_id: string | null
          user_query: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      activity_by_id: {
        Args: { _activity_id: string }
        Returns: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }
        SetofOptions: {
          from: "*"
          to: "activity"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      activity_embedding_input: {
        Args: { p_activity: Database["public"]["Tables"]["activity"]["Row"] }
        Returns: string
      }
      convert_to_kilograms: {
        Args: { weight: number; weight_unit: string }
        Returns: number
      }
      convert_to_liters: {
        Args: { liquid_volume: number; liquid_volume_unit: string }
        Returns: number
      }
      convert_to_meters: {
        Args: { distance: number; distance_unit: string }
        Returns: number
      }
      create_activity_with_details: {
        Args: { p_user_activity: Json; p_user_activity_details: Json }
        Returns: undefined
      }
      global_trending_activity: {
        Args: never
        Returns: {
          activity_category_id: string | null
          activity_id: string
          current_rank: number
          previous_rank: number
          rank_change: number
        }[]
        SetofOptions: {
          from: "*"
          to: "trending_activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      hybrid_search_activities: {
        Args: {
          fts_weight?: number
          match_count: number
          query_embedding: unknown
          query_text: string
          rrf_k?: number
          semantic_weight?: number
          sub_weight_multiplier?: number
          trigram_weight?: number
        }
        Returns: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      log_activity_with_details: {
        Args: { p_user_activity: Json; p_user_activity_details: Json }
        Returns: undefined
      }
      my_profile: {
        Args: never
        Returns: {
          created_at: string
          last_health_sync_date: string | null
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "profile"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      popular_activities: {
        Args: never
        Returns: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      search_activities: {
        Args: { _query: string }
        Returns: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      search_sub_activities: {
        Args: { _query: string }
        Returns: {
          activity_id: string
          created_at: string
          created_by: string
          embedding_content: string | null
          icon: string | null
          legacy_id: number
          name: string
          sub_activity_code: string
          sub_activity_id: string
          updated_at: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "sub_activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      set_local_timezone: { Args: never; Returns: undefined }
      sub_activity_embedding_input: {
        Args: {
          p_sub_activity: Database["public"]["Tables"]["sub_activity"]["Row"]
        }
        Returns: string
      }
      timezone: { Args: never; Returns: string }
      trending_activities_for_user: {
        Args: never
        Returns: {
          activity_category_id: string
          activity_code: string
          activity_date_type: Database["public"]["Enums"]["activity_date_type"]
          activity_id: string
          created_at: string
          created_by: string
          description: string | null
          embedding_content: string | null
          hex_color: string | null
          icon: string | null
          is_suggested_favorite: boolean | null
          legacy_id: number | null
          name: string
          pace_type: Database["public"]["Enums"]["pace_type"] | null
          updated_at: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      update_activity_with_details: {
        Args: { p_user_activity: Json; p_user_activity_details: Json }
        Returns: undefined
      }
      user_activities_by_activity_category_id: {
        Args: { _activity_category_id: string }
        Returns: {
          activity_id: string
          activity_name_override: string | null
          activity_timestamp: string
          comments: string | null
          created_at: string
          external_data_id: string | null
          updated_at: string | null
          user_activity_id: string
          user_id: string
        }[]
        SetofOptions: {
          from: "*"
          to: "user_activity"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      user_activities_by_date: {
        Args: never
        Returns: {
          activity_count: number
          activity_date: string
          user_activities: Json
          user_id: string
        }[]
        SetofOptions: {
          from: "*"
          to: "_user_activities_by_date"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      user_activity_by_id: {
        Args: { _user_activity_id: string }
        Returns: {
          activity_id: string
          activity_name_override: string | null
          activity_timestamp: string
          comments: string | null
          created_at: string
          external_data_id: string | null
          updated_at: string | null
          user_activity_id: string
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "user_activity"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      user_activity_category_monthly: {
        Args: { _activity_category_id?: string }
        Returns: {
          activity_category_id: string | null
          activity_count: number
          activity_month: string
          user_activity_category_month_id: string
          user_id: string
        }[]
        SetofOptions: {
          from: "*"
          to: "_user_activity_category_month"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      user_activity_category_summary: {
        Args: { _end_date?: string; _start_date?: string }
        Returns: {
          activity_category_id: string
          activity_count: number
          user_id: string
        }[]
        SetofOptions: {
          from: "*"
          to: "_user_activity_category_summary"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      user_activity_day_count: {
        Args: { end_date: string; start_date: string }
        Returns: Json
      }
      user_activity_streak: {
        Args: never
        Returns: {
          current_streak: number
          longest_streak: number
          user_id: string
          workout_days_this_week: number
        }
        SetofOptions: {
          from: "*"
          to: "_user_activity_streak"
          isOneToOne: true
          isSetofReturn: false
        }
      }
    }
    Enums: {
      activity_date_type: "single" | "range"
      activity_detail_type:
        | "string"
        | "integer"
        | "double"
        | "duration"
        | "distance"
        | "location"
        | "environment"
        | "liquidVolume"
        | "weight"
      distance_uom: "meters" | "yards" | "kilometers" | "miles"
      environment_type: "indoor" | "outdoor"
      external_data_source: "legacy" | "apple_google"
      imperial_uom:
        | "yards"
        | "miles"
        | "fluidOunces"
        | "gallons"
        | "ounces"
        | "pounds"
      liquid_volume_uom: "milliliters" | "fluidOunces" | "liters" | "gallons"
      metric_uom:
        | "meters"
        | "kilometers"
        | "milliliters"
        | "liters"
        | "grams"
        | "kilograms"
      pace_type:
        | "minutesPerUom"
        | "minutesPer100Uom"
        | "minutesPer500m"
        | "floorsPerMinute"
      weight_uom: "grams" | "kilograms" | "ounces" | "pounds"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  revenue_cat: {
    Tables: {
      entitlement: {
        Row: {
          code: string
          entitlement_id: string
        }
        Insert: {
          code: string
          entitlement_id: string
        }
        Update: {
          code?: string
          entitlement_id?: string
        }
        Relationships: []
      }
      entitlement_feature: {
        Row: {
          entitlement_id: string
          feature: string
        }
        Insert: {
          entitlement_id: string
          feature: string
        }
        Update: {
          entitlement_id?: string
          feature?: string
        }
        Relationships: [
          {
            foreignKeyName: "entitlement_feature_entitlement_id_fkey"
            columns: ["entitlement_id"]
            isOneToOne: false
            referencedRelation: "entitlement"
            referencedColumns: ["entitlement_id"]
          },
          {
            foreignKeyName: "entitlement_feature_feature_fkey"
            columns: ["feature"]
            isOneToOne: false
            referencedRelation: "feature"
            referencedColumns: ["name"]
          },
        ]
      }
      feature: {
        Row: {
          name: string
        }
        Insert: {
          name: string
        }
        Update: {
          name?: string
        }
        Relationships: []
      }
      user_entitlement: {
        Row: {
          active_until: string | null
          created_at: string | null
          entitlement_id: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          active_until?: string | null
          created_at?: string | null
          entitlement_id: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          active_until?: string | null
          created_at?: string | null
          entitlement_id?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      webhook_event: {
        Row: {
          raw_payload: Json
          received_at: string
          user_id: string
          webhook_event_id: string
        }
        Insert: {
          raw_payload: Json
          received_at?: string
          user_id: string
          webhook_event_id?: string
        }
        Update: {
          raw_payload?: Json
          received_at?: string
          user_id?: string
          webhook_event_id?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      user_has_feature: {
        Args: { p_feature: string; p_user_id: string }
        Returns: boolean
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      activity_date_type: ["single", "range"],
      activity_detail_type: [
        "string",
        "integer",
        "double",
        "duration",
        "distance",
        "location",
        "environment",
        "liquidVolume",
        "weight",
      ],
      distance_uom: ["meters", "yards", "kilometers", "miles"],
      environment_type: ["indoor", "outdoor"],
      external_data_source: ["legacy", "apple_google"],
      imperial_uom: [
        "yards",
        "miles",
        "fluidOunces",
        "gallons",
        "ounces",
        "pounds",
      ],
      liquid_volume_uom: ["milliliters", "fluidOunces", "liters", "gallons"],
      metric_uom: [
        "meters",
        "kilometers",
        "milliliters",
        "liters",
        "grams",
        "kilograms",
      ],
      pace_type: [
        "minutesPerUom",
        "minutesPer100Uom",
        "minutesPer500m",
        "floorsPerMinute",
      ],
      weight_uom: ["grams", "kilograms", "ounces", "pounds"],
    },
  },
  revenue_cat: {
    Enums: {},
  },
} as const

