Dir['dependencies'].each { |f| require f }

class SnowRescueSvc  
  def initialize(weather_svc, municipal_svc)
  end
  
  def check_and_perform_rescue
    raise NotImplementedError.new
  end
end