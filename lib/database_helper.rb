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
    String      :grid_marshaled
  end  

  DB.create_table :users do
    primary_key :id

    String      :name
    Integer     :create_day
    Integer     :last_browse_day
    Integer     :days_btw_browse
    String      :grid_marshaled
    TrueClass   :is_voter, index: true
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