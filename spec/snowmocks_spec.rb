require 'snow_rescue_service'
require_relative '../lib/dependencies/weather_svc'
require_relative '../lib/dependencies/municipal_svc'
require_relative '../lib/dependencies/press_svc'
require_relative '../lib/dependencies/snowplow_malfunctioning_error'

# rspec-mocks documentation
# https://github.com/rspec/rspec-mocks

describe SnowRescueSvc do

  let(:temperature) { 0 }
  let(:weather_svc) { instance_double('WeatherSvc', avg_temperature_celcius: temperature) }
  let(:municipal_svc) { instance_double('MunicipalSvc') }

  subject { SnowRescueSvc.new(weather_svc, municipal_svc) }

  context 'when temperature is lt 0' do
    let(:temperature) { -2 }
    it 'sends a sander' do
      expect(municipal_svc).to receive(:send_sander)
      subject.check_and_perform_rescue
    end
  end

  context 'when temperature is gt 0' do
    let(:temperature) { 2 }
    it 'does not send a sander ' do
      expect(municipal_svc).not_to receive(:send_sander)
      subject.check_and_perform_rescue
    end
  end


end