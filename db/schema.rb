# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_16_144427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "store_id"
    t.integer "user_id"
    t.integer "commune_id"
    t.string "firstname"
    t.string "lastname"
    t.string "street"
    t.string "street_number"
    t.string "condominium"
    t.string "apartment_number"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comment"
    t.float "latitude"
    t.float "longitude"
    t.index ["commune_id"], name: "index_addresses_on_commune_id"
    t.index ["store_id"], name: "index_addresses_on_store_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "ads", force: :cascade do |t|
    t.string "name"
    t.string "url_destination"
    t.integer "ad_type"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_ads_on_active"
    t.index ["ad_type"], name: "index_ads_on_ad_type"
  end

  create_table "brand_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "brand_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_brand_categories_on_brand_id"
    t.index ["category_id"], name: "index_brand_categories_on_category_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["name"], name: "index_brands_on_name"
  end

  create_table "categories", force: :cascade do |t|
    t.json "name", default: {}
    t.string "slug"
    t.integer "depth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.string "code"
    t.float "commission", default: 0.0
    t.boolean "featured", default: false
    t.index ["ancestry"], name: "index_categories_on_ancestry"
  end

  create_table "category_option_types", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "option_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_category_option_types_on_category_id"
    t.index ["option_type_id"], name: "index_category_option_types_on_option_type_id"
  end

  create_table "communes", force: :cascade do |t|
    t.integer "region_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer "country_id"
    t.string "name"
    t.string "rut"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "fantasy_name"
    t.string "legal_representative_rut"
    t.string "legal_representative_name"
    t.string "legal_representative_email"
    t.string "legal_representative_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["legal_representative_rut"], name: "index_companies_on_legal_representative_rut"
    t.index ["rut"], name: "index_companies_on_rut"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_countries_on_code"
  end

  create_table "deprecate_order_items", force: :cascade do |t|
    t.bigint "product_variant_id"
    t.bigint "store_order_id"
    t.bigint "store_id"
    t.integer "item_qty"
    t.float "unit_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "start_on"
    t.integer "order_id"
    t.index ["product_variant_id"], name: "index_deprecate_order_items_on_product_variant_id"
    t.index ["store_id"], name: "index_deprecate_order_items_on_store_id"
    t.index ["store_order_id"], name: "index_deprecate_order_items_on_store_order_id"
  end

  create_table "frequent_questions", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_products_stores", force: :cascade do |t|
    t.bigint "store_id"
    t.string "file_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_group_products_stores_on_store_id"
  end

  create_table "group_title_categories", force: :cascade do |t|
    t.bigint "group_title_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_group_title_categories_on_category_id"
    t.index ["group_title_id"], name: "index_group_title_categories_on_group_title_id"
  end

  create_table "group_titles", force: :cascade do |t|
    t.string "slug"
    t.hstore "name_translations"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "home", default: false
    t.boolean "burger", default: false
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "loggers_error_payments", force: :cascade do |t|
    t.string "payment_id"
    t.string "message"
    t.string "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "log", default: {}
    t.string "order_token"
  end

  create_table "option_types", force: :cascade do |t|
    t.json "name", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  create_table "option_values", force: :cascade do |t|
    t.integer "option_type_id"
    t.json "value", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "order_adjustments", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "adjustable_type"
    t.bigint "adjustable_id"
    t.integer "order_id"
    t.float "value", default: 0.0
    t.index ["adjustable_type", "adjustable_id"], name: "index_order_adjustments_on_adjustable_type_and_adjustable_id"
    t.index ["order_id"], name: "index_order_adjustments_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "product_variant_id"
    t.bigint "store_order_id"
    t.bigint "store_id"
    t.integer "item_qty"
    t.float "unit_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order_id", null: false
    t.index ["product_variant_id"], name: "index_order_items_on_product_variant_id"
    t.index ["store_id"], name: "index_order_items_on_store_id"
    t.index ["store_order_id"], name: "index_order_items_on_store_order_id"
  end

  create_table "order_logs", force: :cascade do |t|
    t.bigint "store_order_id"
    t.bigint "order_id"
    t.string "log"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_logs_on_order_id"
    t.index ["store_order_id"], name: "index_order_logs_on_store_order_id"
  end

  create_table "order_product_reviews", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.bigint "user_id"
    t.integer "rating", default: 0
    t.string "comment"
    t.integer "status", default: 0
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_product_reviews_on_order_id"
    t.index ["product_id"], name: "index_order_product_reviews_on_product_id"
    t.index ["user_id"], name: "index_order_product_reviews_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "address_id"
    t.datetime "completed_at"
    t.string "state"
    t.string "delivery_state"
    t.string "payment_state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.string "number_ticket"
    t.json "user_data", default: {}
    t.float "payment_total", default: 0.0
    t.float "shipment_total", default: 0.0
    t.float "tax_total", default: 0.0
    t.index ["number_ticket"], name: "index_orders_on_number_ticket", unique: true
    t.index ["token"], name: "index_orders_on_token", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_methods_configurations", force: :cascade do |t|
    t.integer "payment_method_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_method_id"], name: "index_payment_methods_configurations_on_payment_method_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "order_id"
    t.integer "payment_method_id"
    t.string "state"
    t.integer "total"
    t.json "payment_logs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.integer "product_id"
    t.string "sku"
    t.string "internal_sku"
    t.boolean "active"
    t.float "price"
    t.float "discount_value"
    t.float "weight"
    t.float "height"
    t.float "width"
    t.float "length"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.hstore "name_translations"
    t.hstore "short_description_translations"
    t.boolean "is_master", default: false
    t.integer "current_stock", default: 0
    t.index ["deleted_at"], name: "index_product_variants_on_deleted_at"
    t.index ["internal_sku"], name: "index_product_variants_on_internal_sku"
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["sku"], name: "index_product_variants_on_sku"
  end

  create_table "products", force: :cascade do |t|
    t.integer "store_id"
    t.integer "brand_id"
    t.integer "category_id"
    t.boolean "hide_from_results", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.hstore "name_translations"
    t.hstore "short_description_translations"
    t.string "slug"
    t.integer "group_products_store_id"
    t.float "rating", default: 0.0
    t.boolean "featured", default: false
    t.boolean "active", default: true
    t.boolean "can_published", default: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.json "name", default: {}
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.string "promo_code"
    t.integer "usage_limit"
    t.string "rules"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "promotion_type"
    t.float "promotion_value"
    t.index ["promo_code"], name: "index_promotions_on_promo_code", unique: true
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_regions_on_country_id"
  end

  create_table "repository_products", force: :cascade do |t|
    t.bigint "category_id"
    t.json "name"
    t.string "brand"
    t.string "code"
    t.string "side_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.string "slug"
    t.index ["category_id"], name: "index_repository_products_on_category_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.float "score", default: 1.0, null: false
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id", "product_id"], name: "index_reviews_on_order_id_and_product_id", unique: true
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "shipment_costs", force: :cascade do |t|
    t.bigint "commune_id", null: false
    t.integer "weight", null: false
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commune_id"], name: "index_shipment_costs_on_commune_id"
    t.index ["weight"], name: "index_shipment_costs_on_weight"
  end

  create_table "shipment_methods", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "calculator_formula"
    t.string "discount_forumla"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shipment_type"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "shipment_method_id"
    t.string "state"
    t.string "tracking_code"
    t.string "shipment_method_state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order_id"
    t.float "value", default: 0.0
    t.index ["order_id"], name: "index_shipments_on_order_id"
    t.index ["shipment_method_id"], name: "index_shipments_on_shipment_method_id"
  end

  create_table "slides", force: :cascade do |t|
    t.string "name"
    t.string "url_destination"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_slides_on_active"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.integer "product_variant_id"
    t.integer "quantity", default: 0
    t.string "movement_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order_id"
    t.index ["product_variant_id"], name: "index_stock_movements_on_product_variant_id"
  end

  create_table "store_information_reviews", force: :cascade do |t|
    t.integer "store_id"
    t.integer "approved_by_id"
    t.integer "requested_by_id"
    t.boolean "approved"
    t.string "certifications"
    t.string "facebook"
    t.string "instagram"
    t.string "mall_location"
    t.string "name"
    t.integer "sheets_row"
    t.string "twitter"
    t.string "website"
    t.string "what_we_do"
    t.integer "category_id"
    t.integer "commune_id"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "store_orders", force: :cascade do |t|
    t.integer "store_id"
    t.integer "order_id"
    t.string "mail"
    t.string "order_number"
    t.string "phone"
    t.string "special_comments"
    t.string "state"
    t.string "user_name"
    t.string "payment_state"
    t.string "delivery_state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "clean_total", default: 0.0
    t.float "global_tax_total", default: 0.0
    t.float "payment_total", default: 0.0
    t.float "shipment_total", default: 0.0
    t.float "total", default: 0.0
    t.string "ticket_number"
    t.date "ticket_date"
    t.string "module"
    t.datetime "seller_paid_at"
    t.index ["order_id"], name: "index_store_orders_on_order_id"
    t.index ["seller_paid_at"], name: "index_store_orders_on_seller_paid_at"
    t.index ["store_id"], name: "index_store_orders_on_store_id"
  end

  create_table "store_payment_methods", force: :cascade do |t|
    t.integer "store_id"
    t.integer "payment_method_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_method_id"], name: "index_store_payment_methods_on_payment_method_id"
    t.index ["store_id"], name: "index_store_payment_methods_on_store_id"
  end

  create_table "store_payment_methods_configurations_values", force: :cascade do |t|
    t.integer "payment_methods_configuration_id"
    t.integer "store_payment_method_id"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stores", force: :cascade do |t|
    t.integer "commune_id"
    t.string "certifications"
    t.string "facebook"
    t.string "instagram"
    t.string "name"
    t.integer "sheets_row"
    t.string "twitter"
    t.string "website"
    t.string "what_we_do"
    t.boolean "active"
    t.string "mall_location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category_id"
    t.integer "company_id"
    t.boolean "terms_accepted", default: false
    t.index ["commune_id"], name: "index_stores_on_commune_id"
    t.index ["mall_location"], name: "index_stores_on_mall_location"
    t.index ["name"], name: "index_stores_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "lastname"
    t.string "rut"
    t.string "jti"
    t.json "complementary_info"
    t.integer "create_by"
    t.date "birthdate"
    t.string "gender"
    t.string "provider", default: "zofri"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "variant_history_prices", force: :cascade do |t|
    t.integer "product_variant_id"
    t.float "value"
    t.float "discount_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_variant_id"], name: "index_variant_history_prices_on_product_variant_id"
  end

  create_table "variant_options_values", force: :cascade do |t|
    t.integer "option_value_id"
    t.integer "product_variant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "option_type_id"
    t.index ["option_value_id"], name: "index_variant_options_values_on_option_value_id"
    t.index ["product_variant_id"], name: "index_variant_options_values_on_product_variant_id"
  end

  create_table "views_templates", force: :cascade do |t|
    t.string "name1"
    t.integer "name2"
    t.string "name3"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_wishlists_on_product_id"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "wishlists", "products"
  add_foreign_key "wishlists", "users"
end
