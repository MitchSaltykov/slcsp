require_relative '../slcsp'
require 'csv'

describe SLCSP do
  describe '.second_lowest' do
    it 'selects the second-lowest rate' do
      expect(SLCSP.second_lowest([1, 2, 3, 4])).to eq 2
      expect(SLCSP.second_lowest([4, 3, 2, 1])).to eq 2
    end

    it 'returns nothing if there are no silver plans' do
      expect(SLCSP.second_lowest([])).to be_nil
    end

    it 'returns nothing if there is only one silver plan' do
      expect(SLCSP.second_lowest([1])).to be_nil
    end

    it 'follows the provided example' do
      expect(SLCSP.second_lowest([197.3, 197.3, 201.1, 305.4, 306.7, 411.24])).to eq 201.1
    end
  end

  describe '.area_rates_for_plans' do
    it 'groups plans by state and rate area' do
      csv_data = <<~CSV
        plan_id,state,metal_level,rate,rate_area
        03584UW8758085,AL,Silver,268.26,11
        74449NR9870320,GA,Silver,298.62,7
        14561QN7177699,AL,Silver,273.9,13
      CSV
      input = CSV.parse(csv_data, headers: true)

      expect(SLCSP.area_rates_for_plans(input)).to eq({
        'AL 11' => [268.26],
        'GA 7' => [298.62],
        'AL 13' => [273.9],
      })
    end

    it 'collects all silver plan rates for a rate area' do
      csv_data = <<~CSV
        plan_id,state,metal_level,rate,rate_area
        03584UW8758085,AL,Silver,268.26,11
        28130ET1465358,AL,Silver,256.21,11
        14324EQ6876885,AL,Silver,271.77,11
      CSV
      input = CSV.parse(csv_data, headers: true)

      expect(SLCSP.area_rates_for_plans(input)).to eq({
        'AL 11' => [268.26, 256.21, 271.77],
      })
    end
  end

  describe '.silver_rates_for_area' do
    it 'returns rate values for Silver plans only' do
      csv_data = <<~CSV
        plan_id,state,metal_level,rate,rate_area
        13224PL3852542,AL,Catastrophic,178.79,11
        03584UW8758085,AL,Silver,268.26,11
        28130ET1465358,AL,Silver,256.21,11
        84291ZR3260798,AL,Gold,291.09,11
        78405DE5161755,AL,Platinum,321.37,11
        33860BJ8617521,AL,Bronze,210.31,11
      CSV
      input = CSV.parse(csv_data, headers: true)

      expect(SLCSP.silver_rates_for_area(input)).to eq(
        [268.26, 256.21]
      )
    end
  end

  describe '.areas_for_zip' do
    it 'maps from zip code to list of unique state and rate areas' do
      csv_data = <<~CSV
        zipcode,state,county_code,name,rate_area
        84315,UT,49057,Weber,2
        84315,UT,49011,Davis,3
        35584,AL,01127,Walker,3
        36553,AL,01129,Washington,13
        86544,AZ,04001,Apache,1
        00670,PR,72027,Camuy Municipio,1
        00670,PR,72083,Las Marias Municipio,1
      CSV
      input = CSV.parse(csv_data, headers: true)

      expect(SLCSP.areas_for_zip(input)).to eq({
        '84315' => ['UT 2', 'UT 3'],
        '35584' => ['AL 3'],
        '36553' => ['AL 13'],
        '86544' => ['AZ 1'],
        '00670' => ['PR 1']
      })
    end
  end

  describe '.rate_for_zip' do
    it 'outputs the second-lowest silver rate for a zip code' do
      zip = '12345'
      zip_area_map = { '12345' => ['AB 1'] }
      area_rate_map = { 'AB 1' => [1, 2, 3] }
      expect(SLCSP.rate_for_zip(zip, zip_area_map, area_rate_map)).to eq(2)
    end

    it 'outputs no rate when a zip code has no areas' do
      zip = '12345'
      zip_area_map = { '12345' => [] }
      area_rate_map = { 'AB 1' => [1, 2, 3] }
      expect(SLCSP.rate_for_zip(zip, zip_area_map, area_rate_map)).to be_nil
    end

    it 'outputs no rate when a zip code has multiple areas' do
      zip = '12345'
      zip_area_map = { '12345' => ['AB 1', 'AB 2'] }
      area_rate_map = { 'AB 1' => [1, 2, 3] }
      expect(SLCSP.rate_for_zip(zip, zip_area_map, area_rate_map)).to be_nil
    end

    it 'outputs no rate when a zip code has no rates' do
      zip = '12345'
      zip_area_map = { '12345' => ['AB 1'] }
      area_rate_map = { 'AB 1' => [] }
      expect(SLCSP.rate_for_zip(zip, zip_area_map, area_rate_map)).to be_nil
    end

    it 'outputs no rate when a zip code has only one rate' do
      zip = '12345'
      zip_area_map = { '12345' => ['AB 1'] }
      area_rate_map = { 'AB 1' => [1] }
      expect(SLCSP.rate_for_zip(zip, zip_area_map, area_rate_map)).to be_nil
    end
  end
end
