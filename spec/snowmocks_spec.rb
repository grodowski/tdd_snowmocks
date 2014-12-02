require 'snow_rescue_service'
require_relative '../lib/dependencies/weather_svc'
require_relative '../lib/dependencies/municipal_svc'
require_relative '../lib/dependencies/press_svc'
require_relative '../lib/dependencies/snowplow_malfunctioning_error'

# rspec-mocks documentation
# https://github.com/rspec/rspec-mocks

describe SnowRescueSvc do 
  let(:press_svc) { PressSvc.new }
  let(:weather_svc) { WeatherSvc.new }
  let(:municipal_svc) { spy(MunicipalSvc.new) }
  
  let(:snow) { 0 }
  let(:temp) { 0 }

  subject { SnowRescueSvc.new(weather_svc, municipal_svc, press_svc) }
  
  before do 
    allow(weather_svc).to receive(:snowfall_height_mm) { snow }
    allow(weather_svc).to receive(:avg_temperature_celcius) { temp }
  end
  
  it 'does not send a snowplow' do
    expect(municipal_svc).not_to have_received(:send_snowplow)
    subject.check_and_perform_rescue
  end
  
  it 'does not send a sander' do
    expect(municipal_svc).not_to have_received(:send_sander)
    subject.check_and_perform_rescue
  end
  
  context 'when temperature is below 0' do
    let(:temp) { -2 }
    it 'sends a sander' do 
      subject.check_and_perform_rescue
      expect(municipal_svc).to have_received(:send_sander)
    end
  end
  
  context 'when snowfall exceeds 3 mm' do
    let(:snow) { 4 }
    it 'sends a snowplow' do 
      subject.check_and_perform_rescue
      expect(municipal_svc).to have_received(:send_snowplow)
    end
  
    context 'when the snowplow fails' do 
      before do 
        expect(municipal_svc).to receive(:send_snowplow).once.and_raise(SnowplowMalfunctioningError.new)
        expect(municipal_svc).to receive(:send_snowplow).once.and_return(true)
      end
    
      it 'sends another one' do 
        subject.check_and_perform_rescue
      end
    end
  end
  
  context 'when snowfall exceeds 5mm' do 
    let(:snow) { 6 }
    it 'sends two snowplows' do 
      subject.check_and_perform_rescue
      expect(municipal_svc).to have_received(:send_snowplow).twice
    end
  end
  
  context 'when snowfall exceeds 10mm and temp is below -10' do 
    let(:snow) { 11 }
    let(:temp) { -12 }
    it 'sends 3 snowplows, 2 sanders and notifies press' do 
      expect(municipal_svc).to receive(:send_snowplow).exactly(3).times.ordered
      expect(municipal_svc).to receive(:send_sander).exactly(2).times.ordered
      expect(press_svc).to receive(:send_weather_alert).once.ordered
      subject.check_and_perform_rescue
    end
  end
  
end