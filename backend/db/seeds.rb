actions = ["click", "hover"]
actions.each { |action| Action.create(name: action) }

colors = ["blue", "green", "red", "yellow"]
colors.each { |color| Color.create(name: color) }

# TODO: add as many colors as possible
# TODO: allow frontend to fetch colors from API Endpoint
