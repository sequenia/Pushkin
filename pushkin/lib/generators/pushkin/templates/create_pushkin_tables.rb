class CreatePushkinTables < ActiveRecord::Migration[5.1]
  def change
    create_table :pushkin_tokens do |t|
      t.integer :user_id
      t.integer :platform
      t.boolean :is_active, default: true
      t.string :token

      t.timestamps
    end

    add_index :pushkin_tokens, [:user_id, :is_active]
    add_index :pushkin_tokens, [:token, :platform], unique: true

    create_table :pushkin_notifications do |t|
      t.datetime :start_at
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :tokens_provider_id
      t.string :tokens_provider_type
      t.integer :payload_id
      t.string :payload_type
      t.string :notification_type

      t.timestamps
    end

    add_index :pushkin_notifications, [:start_at, :started_at]
    add_index :pushkin_notifications, [:tokens_provider_type, :tokens_provider_id],
      name: 'index_pushkin_nots_on_toks_provider_type_and_toks_provider_id'
    add_index :pushkin_notifications, [:payload_type, :payload_id]
    add_index :pushkin_notifications, [:notification_type, :start_at]

    create_table :pushkin_payloads do |t|
      t.string :title
      t.string :body
      t.string :web_click_action
      t.string :android_click_action
      t.string :ios_click_action
      t.string :web_icon
      t.string :android_icon
      t.string :ios_icon
      t.string :data
      t.boolean :is_android_data_message, default: false
      t.boolean :is_ios_data_message, default: false
      t.boolean :is_web_data_message, default: false

      t.timestamps
    end

    create_table :pushkin_tokens_providers do |t|

      t.timestamps
    end

    create_table :pushkin_tokens_provider_users do |t|
      t.integer :tokens_provider_id
      t.integer :user_id

      t.timestamps
    end

    add_index :pushkin_tokens_provider_users, :tokens_provider_id
    add_index :pushkin_tokens_provider_users, :user_id

    create_table :pushkin_push_sending_results do |t|
      t.boolean :success
      t.string :error
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :notification_id
      t.integer :platform

      t.timestamps
    end

    add_index :pushkin_push_sending_results, :notification_id

    create_table :pushkin_token_results do |t|
      t.string :status
      t.string :error
      t.integer :push_sending_result_id
      t.integer :token_id
    end

    add_index :pushkin_token_results, :push_sending_result_id
    add_index :pushkin_token_results, :token_id
  end
end