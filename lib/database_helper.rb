database = "simulation-#{APP_ENV}.db"
File.unlink(database) if File.exists?(database)
DB = Sequel.sqlite

def create_tables
  DB.create_table :developers do
    primary_key :id
    
    String      :name
    Integer     :create_day
    TrueClass   :is_active, index: true
    Integer     :dev_duration
    Integer     :dev_type # 0:Improver, 1:Ignores, 2:Malicious
    Integer     :last_service_produced_day
  end

  DB.create_table :services do
    primary_key :id
    foreign_key :developer_id, :developers

    String      :name
    Integer     :create_day
    Integer     :device_count
    String      :grid_marshaled

  end

  DB.create_table :devices do
    primary_key :id
    Integer     :create_day
  end

  DB.create_table :context_models do
    primary_key :id
    foreign_key :device_id, :devices
    foreign_key :developer_id, :developers

    Integer     :create_day
    Integer     :reputation, default: 0
  end

  DB.create_table :context_models_services do
    foreign_key :context_model_id, :context_models
    foreign_key :service_id, :services
    primary_key [:context_model_id, :service_id]
  end

  DB.create_table :downloads do
    foreign_key :service_id, :services
    foreign_key :user_id, :users
    primary_key [:service_id, :user_id]

    Integer     :vote, default: nil
    Integer     :create_day
  end
end

create_tables