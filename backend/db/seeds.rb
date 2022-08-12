puts "Seeding actions ..."
actions = [Action::CLICK, Action::HOVER]
actions.each { |action| Action.create(name: action) unless Action.find_by_name(action).present? }
puts "Done!"

puts

puts "Seeding colors ..."
colors = ["blue", "green", "red", "yellow"]
colors.each { |color| Color.create(name: color) unless Color.find_by_name(color).present? }
puts "Done!"

puts

puts "Seeding testing API KEY"
User.create(api_key: "testing") unless User.find_by_api_key("testing").present?
puts "Done!"
