class SaveProvider
  def initialize odv_provider
    @odv_provider = odv_provider
  end

  def call
    provider = Provider.find_or_initialize_by(external_id: @odv_provider.user_id)

    # Always update with ODV data
    provider.name = @odv_provider.provider_name
    provider.phy_code = @odv_provider.phy_code
    provider.cell_phone = @odv_provider.cell_phone

    provider.save!
    provider
  end
end
