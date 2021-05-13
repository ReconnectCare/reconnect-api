json.extract! provider, :id, :external_id, :name, :phy_code, :cell_phone, :created_at, :updated_at
json.url provider_url(provider, format: :json)
