class SnowRescueSvc
  def initialize(weather_svc, municipal_svc)
    @weather_svc = weather_svc
    @municipal_svc = municipal_svc
  end

  def check_and_perform_rescue
    @municipal_svc.send_sander if @weather_svc.avg_temperature_celcius < 0
  end
end