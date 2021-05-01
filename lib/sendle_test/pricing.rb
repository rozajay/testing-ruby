require 'csv'

class SendleTest::Pricing

	def initialize(x)
		@pricing_file = x.values_at(:pricing_file)
		@zone_file = x.values_at(:zone_file)
		# Initialise content from csv files
		@pricing_file_content = CSV.read(@pricing_file[0])
		@zone_file_content = CSV.read(@zone_file[0])
	end

	# checks if a shipment contains locations in the same zone
	def is_same_zone(shipment)
		source, source_location, destination, destination_location, weight = shipment.values_at(:source, :source_location, :destination, :destination_location, :weight)

		source_location_found = @zone_file_content.select {|n| n.include?(source)}
		destination_location_found = @zone_file_content.select {|n| n.include?(destination)}
		if source_location_found.length() === 1 && destination_location_found.length() === 1
			return {source: source, 
				source_location: source_location, 
				destination: destination, 
				destination_location: destination_location, 
				weight: weight, 
				zone_status: source_location_found[0][2] === destination_location_found[0][2] ? 'same-zone' : 'different-zone'
			}
		end
		return {source: source, 
			source_location: source_location, 
			destination: destination, 
			destination_location: destination_location, 
			weight: weight, 
			zone_status: 'not-found'
		}
	end

	# find a quote for a particular shipment
	def get_quote(shipment_with_check)
		source, source_location, destination, destination_location, weight, zone_status = shipment_with_check.values_at(:source, :source_location, :destination, :destination_location, :weight, :zone_status)
		quotes_found = @pricing_file_content.select {|n| n.include?(zone_status)}
		if quotes_found.length() === 1
			return {
				source: source, 
				source_location: source_location, 
				destination: destination, 
				destination_location: destination_location, 
				weight: weight, 
				quote: quote_found[0][2]
			}
		elsif quotes_found.length() > 1
			specific_quote_found = quotes_found.select {|n| n[1].to_i >= weight.to_i}
			if (specific_quote_found.length() >= 1) 
				return {
					source: source, 
					source_location: source_location, 
					destination: destination, 
					destination_location: destination_location, 
					weight: weight, 
				quote: specific_quote_found[0][2]}
			end
			return {
				source: source, 
				source_location: source_location, 
				destination: destination, 
				destination_location: destination_location, 
				weight: weight, 
			quote: '-'}
		end
		return {
			source: source, 
			source_location: source_location, 
			destination: destination, 
			destination_location: destination_location, 
			weight: weight, 
		quote: '-'}
	end

	# get quotes for all provided shipments
	def get_quotes(shipments) 
		shipments_check_zone = shipments.map { |n| is_same_zone(n) }
		quotes = shipments_check_zone.map{ |n| get_quote(n)}
		return quotes
	end

	def render_quote(shipment_with_quote)
		source, source_location, destination, destination_location, weight, quote = shipment_with_quote.values_at(:source, :source_location, :destination, :destination_location, :weight, :quote)
		return "#{source_location}, #{source} to #{destination_location}, #{destination}, #{weight}gm: #{quote}"
	end

	def calculate_total(quotes)
		sum = 0
		quotes.each do |n| 
			quote = n.values_at(:quote)
			if quote != '-'
				sum += quote[0].to_f
			end
		end
		return "$#{sprintf('%.2f', sum)}"
	end

	# render the view according to provided UI
	def render_quotes(quotes)
		output_text = 'Quote Report\n'
		sum = calculate_total(quotes);
        quotes.each { |n| output_text += render_quote(n) + '\n'}
		output_text += "Total: #{sum.to_s}"
		return output_text
	end
end
