class SnowRescueSvc    
  def initialize(weather_svc, municipal_svc, press_svc)
    @weather_svc, @municipal_svc, @press_svc = weather_svc, municipal_svc, press_svc
  end
  
  def check_and_perform_rescue
    temp = @weather_svc.avg_temperature_celcius
    snow = @weather_svc.snowfall_height_mm
    plows, sanders, notify_press = 0, 0, false
    if temp < -10 && snow > 10 
      plows, sanders, notify_press = 3, 2, true
    else
      sanders = 1 if temp < 0
      plows += 1 if snow > 3
      plows += 1 if snow > 5
    end  
    perform_rescue(plows, sanders, notify_press)
  end
  
  private
  
  def perform_rescue(plows, sanders, notify)
    plows.times { send_and_check_snowplow }
    sanders.times { @municipal_svc.send_sander }
    @press_svc.send_weather_alert if notify
  end
  
  def send_and_check_snowplow
    @municipal_svc.send_snowplow  
  rescue SnowplowMalfunctioningError
    @municipal_svc.send_snowplow
  end
end