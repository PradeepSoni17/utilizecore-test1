class CreateParcelRecordHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :parcel_record_histories do |t|
      t.bigint :parcel_id, null: false
      t.string :status, null: false
      t.timestamps
    end
  end
end
