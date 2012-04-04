class AddRegistrationFormToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string    :registration_form_file_name
      t.string    :registration_form_content_type
      t.integer   :registration_form_file_size
      t.datetime  :registration_form_updated_at
    end
  end
end
