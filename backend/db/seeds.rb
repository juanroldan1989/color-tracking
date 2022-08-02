puts "Seeding actions ..."
actions = ["click", "hover"]
actions.each { |action| Action.create(name: action) }
puts "Done!"

puts

puts "Seeding colors ..."
colors = ["blue", "green", "red", "yellow"]
colors.each { |color| Color.create(name: color) }
puts "Done!"

puts

puts "Seeding testing API KEY"
User.create(api_key: "testing")
puts "Done!"

# TODO: add as many colors as possible
# TODO: allow frontend to fetch colors from API Endpoint
