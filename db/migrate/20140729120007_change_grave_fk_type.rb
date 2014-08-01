class ChangeGraveFkType < ActiveRecord::Migration
  def up
    execute "ALTER TABLE people ALTER COLUMN grave_id "\
            "TYPE integer USING (grave_id::integer)"
  end

  def down
    execute "ALTER TABLE people ALTER COLUMN grave_id "\
            "TYPE character varying(255) "\
            "USING (grave_id::character varying(255))"
  end
end
