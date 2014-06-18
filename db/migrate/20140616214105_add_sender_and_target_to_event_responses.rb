class AddSenderAndTargetToEventResponses < ActiveRecord::Migration
  def change
    add_column :event_responses, :sender_name, :string
    add_column :event_responses, :target_name, :string
    add_column :event_responses, :priority, :integer, default: 0
    add_column :event_responses, :requirements_count, :integer, default: 0
    add_column :event_responses, :unity_id, :string, unique: true

    add_column :requirements, :left_value, :float
    add_column :requirements, :right_value, :float
    rename_column :requirements, :fact_test, :comparator
    rename_column :requirements, :fact_test_value, :status
    add_column :fact_mutations, :op, :integer
    add_column :fact_mutations, :location_hint, :integer
  end
end
