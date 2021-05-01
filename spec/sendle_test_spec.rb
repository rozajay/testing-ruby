RSpec.describe SendleTest::Pricing do
	it 'checks that a shipment is in the same zone' do
		shipment = {
			source: '4000',
			source_location:'Brisbane', 
			destination: '4000',
			destination_location:'Brisbane', 
			weight: '200'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.is_same_zone(shipment)
		expect(is_same_zone).to eq({
			destination:'4000', 
			destination_location:'Brisbane', 
			source:'4000', 
			source_location:'Brisbane', 
			weight:'200', 
		zone_status:'same-zone'})
	end

	it 'checks that a shipment is in the same zone' do
		shipment = {
			destination:'2037', 
			destination_location:'Glebe', 
			source:'2000', 
			source_location:'Sydney', 
			weight:'200', 
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.is_same_zone(shipment)
		expect(is_same_zone).to eq({
			destination:'2037', 
			destination_location:'Glebe', 
			source:'2000', 
			source_location:'Sydney', 
			weight:'200', 
		zone_status:'same-zone'})
	end

	it 'checks that a shipment is in a different zone' do
		shipment = {
			destination:'2000', 
			destination_location:'Sydney', 
			source:'4000', 
			source_location:'Brisbane', 
			weight: '200'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_different_zone = pricing.is_same_zone(shipment)
		expect(is_different_zone).to eq({
			destination:'2000', 
			destination_location:'Sydney', 
			source:'4000', 
			source_location:'Brisbane', 
			weight:'200', 
		zone_status:'different-zone'})
	end

	it 'throw error if source or destination is not found' do
		shipment = {
			source: '6151',
			source_location:'South Perth', 
			destination: '4000',
			destination_location:'Brisbane', 
			weight: '200'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		zone_not_found = pricing.is_same_zone(shipment)
		expect(zone_not_found).to eq({
			source: '6151',
			source_location:'South Perth', 
			destination: '4000',
			destination_location:'Brisbane', 
			weight: '200',
		zone_status:'not-found'})
	end

	it 'throw error if information not found' do
		shipment_with_check = 
		{
			source: '6160',
			source_location:'Freemantle', 
			destination: '5000',
			destination_location:'Adelaide', 
			weight: '200',
			zone_status:'not-found'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		zone_not_found = pricing.get_quote(shipment_with_check)
		expect(zone_not_found).to eq({
			source: '6160',
			source_location:'Freemantle', 
			destination: '5000',
			destination_location:'Adelaide', 
			weight: '200', 
		quote: '-'})
	end

	it 'find the pricing for shipments of the same zone and less than 5000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '4000',
			destination_location: 'Brisbane',
			weight: '200',
			zone_status: 'same-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '4000', 
			destination_location: 'Brisbane', 
			weight: '200', 
		quote: '4.10'})
	end

	it 'find the pricing for shipments of the same zone and less than 10000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '4000',
			destination_location: 'Brisbane',
			weight: '6000',
			zone_status: 'same-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '4000', 
			destination_location: 'Brisbane', 
			weight: '6000', 
		quote: '10.20'})
	end

	it 'find the pricing for shipments of the same zone and greater than 10000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '4000',
			destination_location: 'Brisbane',
			weight: '20000',
			zone_status: 'same-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '4000', 
			destination_location: 'Brisbane', 
			weight: '20000', 
		quote: '-'})
	end

	it 'find the pricing for shipments for different zones and less than 5000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '200',
			zone_status: 'different-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '2000', 
			destination_location: 'Sydney', 
			weight: '200', 
		quote: '4.50'})
	end

	it 'find the pricing for shipments for different zones and less than 5000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '4000',
			zone_status: 'different-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '2000', 
			destination_location: 'Sydney', 
			weight: '4000', 
		quote: '9.50'})
	end

	it 'find the pricing for shipments for different zones and less than 10000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '6000',
			zone_status: 'different-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane', 
			destination: '2000', 
			destination_location: 'Sydney', 
			weight: '6000', 
		quote: '14.90'})
	end

	it 'find the pricing for shipments for different zones and greater than 10000 gram' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '20000',
			zone_status: 'different-zone'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		is_same_zone = pricing.get_quote(shipment)
		expect(is_same_zone).to eq({
			source: '4000', 
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '20000', 
		quote: '-'})
	end

	it 'convert object into string format' do
		shipment = {
			source: '4000',
			source_location: 'Brisbane',
			destination: '2000',
			destination_location: 'Sydney',
			weight: '20000',
			quote: '-'
		}
		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')
		rendered_text = pricing.render_quote(shipment)
		expect(rendered_text).to eq('Brisbane, 4000 to Sydney, 2000, 20000gm: -')
	end

	it 'calculates pricing' do
		shipments = [
			{
				source: '4000', 
				source_location: 'Brisbane', 
				destination: '4000', 
				destination_location: 'Brisbane', 
				weight: '200',
			},
			{
				source: '5000', 
				source_location: 'Adelaide', 
				destination: '2000', 
				destination_location: 'Sydney', 
				weight: '4000', 
			},
			{
				source: '2000', 
				source_location: 'Sydney', 
				destination: '2037', 
				destination_location: 'Glebe', 
				weight: '5000', 
			},
			{
				source: '6000', 
				source_location: 'Perth', 
				destination: '4000', 
				destination_location: 'Brisbane', 
				weight: '10000', 
			},
			{
				source: '3000', 
				source_location: 'Melbourne', 
				destination: '5092', 
				destination_location: 'Modbury', 
				weight: '12000', 
			},
			{
				source: '6151',
				source_location: 'South Perth', 
				destination: '4000',
				destination_location: 'Brisbane', 
				weight: '8000'
			},
			{
				source: '6160',
				source_location: 'Freemantle', 
				destination: '5000',
				destination_location: 'Adelaide', 
				weight: '500'
			}
		]

		pricing = SendleTest::Pricing.new(pricing_file: 'data/prices.csv', zone_file: 'data/zones.csv')

		quotes = pricing.get_quotes(shipments)
		display = pricing.render_quotes(quotes)

		expected_display = 'Quote Report\\nBrisbane, 4000 to Brisbane, 4000, 200gm: 4.10\\nAdelaide, 5000 to Sydney, 2000, 4000g...6151 to Brisbane, 4000, 8000gm: -\\nFreemantle, 6160 to Adelaide, 5000, 500gm: 4.50\\nTotal: $37.10'

    expect(quotes).to eq([
			{
				source: '4000', 
				source_location: 'Brisbane', 
				destination: '4000', 
				destination_location: 'Brisbane', 
				weight: '200', 
			  quote: '4.10'},
			{
				source: '5000', 
				source_location: 'Adelaide', 
				destination: '2000', 
				destination_location: 'Sydney', 
				weight: '4000', 
			  quote: '9.50'},
			{
				source: '2000', 
				source_location: 'Sydney', 
				destination: '2037', 
				destination_location: 'Glebe', 
				weight: '5000', 
			  quote: '4.10'},
			{
				source: '6000', 
				source_location: 'Perth', 
				destination: '4000', 
				destination_location: 'Brisbane', 
				weight: '10000', 
			  quote: '14.90'},
			{
				source: '3000', 
				source_location: 'Melbourne', 
				destination: '5092', 
				destination_location: 'Modbury', 
				weight: '12000', 
			  quote: '-'},
			{
				source: '6151',
				source_location: 'South Perth', 
				destination: '4000',
				destination_location: 'Brisbane', 
				weight: '8000',
				quote: '-'
			},
			{
				source: '6160',
				source_location: 'Freemantle', 
				destination: '5000',
				destination_location: 'Adelaide', 
				weight: '500',
				quote: '4.50'
			}
		])
    
		expect(display == expected_display)
	end
end
