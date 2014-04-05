class AddReponsesSearchIndices < ActiveRecord::Migration

  def up
    # 1. Create the search vector column
    add_column :responses, :search_vector, 'tsvector'

    # 2. Create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX responses_search_idx
      ON responses
      USING gin(search_vector);
    SQL

    # 4 (optional). Trigger to update the vector column
    # when the responses table is updated
    execute <<-SQL
      DROP TRIGGER IF EXISTS responses_search_vector_update
      ON responses;
      CREATE TRIGGER responses_search_vector_update
      BEFORE INSERT OR UPDATE
      ON responses
      FOR EACH ROW EXECUTE PROCEDURE
    tsvector_update_trigger (search_vector, 'pg_catalog.english', text, character);
    SQL

    Response.find_each { |p| p.touch }
  end

  def down
    remove_column :responses, :search_vector
    execute <<-SQL
      DROP TRIGGER IF EXISTS responses_search_vector_update on responses;
    SQL
  end

end
