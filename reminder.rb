require 'time'
require_relative 'notifier'

def check_reminders(data)
  now = Time.now
  data["reminders"].reject! do |reminder|
    time = Time.parse(reminder["time"])
    if time <= now
      notify("🔔 Reminder", reminder["text"])
      true  
    else
      false
    end
  end
  save_data(data)  
end
