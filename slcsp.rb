require 'csv'

class SLCSP
  def self.process
    zips = CSV.read('zips.csv', headers: true)
    zip_area_map = areas_for_zip(zips)

    plans = CSV.read('plans.csv', headers: true)
    area_rate_map = area_rates_for_plans(plans)

    slcsp = CSV.read('slcsp.csv', headers: true)

    puts slcsp.headers.join(',')
    slcsp.each do |row|
      zip = row['zipcode']
      rate = rate_for_zip(zip, zip_area_map, area_rate_map)
      puts [zip, rate].join(',')
    end
  end

  def self.second_lowest(rates)
    return nil unless rates&.size > 1

    rates.uniq.sort[1]
  end

  def self.area_rates_for_plans(plans)
    plans.group_by do |entry|
      state_rate_area(entry)
    end.transform_values do |rows|
      silver_rates_for_area(rows)
    end
  end

  def self.silver_rates_for_area(rows)
    rows
      .filter { |row| row['metal_level'] == 'Silver' }
      .map { |row| row['rate'].to_f }
  end

  def self.areas_for_zip(zips)
    zips.group_by do |zip|
      zip['zipcode']
    end.transform_values do |rows|
      rows.map { |row| state_rate_area(row) }.uniq
    end
  end

  def self.state_rate_area(entry)
    [entry['state'], entry['rate_area']].join(' ')
  end

  def self.rate_for_zip(zip, zip_area_map, area_rate_map)
    areas = zip_area_map[zip]

    return nil unless areas.size == 1

    rates = area_rate_map[areas.first] || []
    rate = second_lowest(rates)
  end
end
