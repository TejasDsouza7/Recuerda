require_relative 'storage'
require_relative 'reminder'

def print_menu
  puts "\n📘 Recuerda - Your CLI Notes & Reminder App"
  puts "1. Add Note"
  puts "2. Show Notes"
  puts "3. Edit Note"
  puts "4. Delete Note"
  puts "5. Add Reminder"
  puts "6. Show Upcoming Reminders"
  puts "7. Edit Reminder"
  puts "8. Delete Reminder"
  puts "9. Mark Note as Done"
  puts "10. Search Notes"
  puts "11. Exit"
  print "> "
end

loop do
  data = load_data
  check_reminders(data)
  print_menu
  choice = gets.chomp

  case choice
  when "1"
    print "📝 Enter your note: "
    note = gets.chomp
    data["notes"] << { "text" => note, "done" => false, "time" => Time.now.to_s }
    save_data(data)
    puts "✅ Note saved!"
  when "2"
    puts "\n📒 Your Notes:"
    data["notes"].each_with_index do |n, i|
      status = n["done"] ? "✔️ Done" : "❌ Not done"
      puts "#{i+1}. #{n["text"]} (#{n["time"]}) - #{status}"
    end
  when "3"
    puts "\n📒 Edit Notes:"
    data["notes"].each_with_index do |n, i|
      puts "#{i+1}. #{n["text"]} (#{n["time"]})"
    end
    print "Select note number to edit: "
    note_index = gets.chomp.to_i - 1
    if note_index >= 0 && note_index < data["notes"].length
      print "Enter new text for note: "
      new_text = gets.chomp
      data["notes"][note_index]["text"] = new_text
      save_data(data)
      puts "✅ Note updated!"
    else
      puts "❌ Invalid note number!"
    end
  when "4"
    puts "\n📒 Delete Notes:"
    data["notes"].each_with_index do |n, i|
      puts "#{i+1}. #{n["text"]} (#{n["time"]})"
    end
    print "Select note number to delete: "
    note_index = gets.chomp.to_i - 1
    if note_index >= 0 && note_index < data["notes"].length
      data["notes"].delete_at(note_index)
      save_data(data)
      puts "✅ Note deleted!"
    else
      puts "❌ Invalid note number!"
    end
  when "5"
    print "🔔 Enter reminder text: "
    text = gets.chomp
    print "⏰ Enter time (e.g., 2025-04-16 17:00): "
    time_input = gets.chomp
    begin
      Time.parse(time_input)
      data["reminders"] << { "text" => text, "time" => time_input, "recurring" => false }
      save_data(data)
      puts "✅ Reminder set!"
    rescue
      puts "⚠️ Invalid time format!"
    end
  when "6"
    puts "\n📅 Upcoming Reminders:"
    upcoming = data["reminders"].select { |r| Time.parse(r["time"]) > Time.now }
    upcoming.each_with_index do |r, i|
      puts "#{i+1}. #{r["text"]} at #{r["time"]}"
    end
  when "7"
    puts "\n📅 Edit Reminders:"
    data["reminders"].each_with_index do |r, i|
      puts "#{i+1}. #{r["text"]} at #{r["time"]}"
    end
    print "Select reminder number to edit: "
    reminder_index = gets.chomp.to_i - 1
    if reminder_index >= 0 && reminder_index < data["reminders"].length
      print "Enter new reminder text: "
      new_text = gets.chomp
      print "Enter new time (e.g., 2025-04-16 17:00): "
      new_time = gets.chomp
      begin
        Time.parse(new_time)
        data["reminders"][reminder_index]["text"] = new_text
        data["reminders"][reminder_index]["time"] = new_time
        save_data(data)
        puts "✅ Reminder updated!"
      rescue
        puts "⚠️ Invalid time format!"
      end
    else
      puts "❌ Invalid reminder number!"
    end
  when "8"
    puts "\n📅 Delete Reminders:"
    data["reminders"].each_with_index do |r, i|
      puts "#{i+1}. #{r["text"]} at #{r["time"]}"
    end
    print "Select reminder number to delete: "
    reminder_index = gets.chomp.to_i - 1
    if reminder_index >= 0 && reminder_index < data["reminders"].length
      data["reminders"].delete_at(reminder_index)
      save_data(data)
      puts "✅ Reminder deleted!"
    else
      puts "❌ Invalid reminder number!"
    end
  when "9"
    puts "\n📒 Mark Notes as Done:"
    data["notes"].each_with_index do |n, i|
      status = n["done"] ? "✔️ Done" : "❌ Not done"
      puts "#{i+1}. #{n["text"]} (#{n["time"]}) - #{status}"
    end
    print "Select note number to mark as done: "
    note_index = gets.chomp.to_i - 1
    if note_index >= 0 && note_index < data["notes"].length
      data["notes"][note_index]["done"] = !data["notes"][note_index]["done"]
      save_data(data)
      puts "✅ Note marked as #{data["notes"][note_index]["done"] ? "Done" : "Not Done"}!"
    else
      puts "❌ Invalid note number!"
    end
  when "10"
    print "🔍 Search Notes: "
    search_term = gets.chomp
    puts "\n📒 Search Results:"
    data["notes"].each_with_index do |n, i|
      if n["text"].include?(search_term)
        puts "#{i+1}. #{n["text"]} (#{n["time"]})"
      end
    end
  when "11"
    puts "👋 Goodbye!"
    break
  else
    puts "❓ Invalid choice!"
  end
end
