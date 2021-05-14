class GenreMap
  @genres = [
    {
      genre: 'Action & Hero Stuff',
      subgenres: ['Action']
    },
    {
      genre: 'Adventure Stuff',
      subgenres: ['Adventure']
    },
    # // {
    # //   genre: 'Awards Shows',
    # //   subgenres: ['Awards']
    # // },
    {
      genre: 'Cartoon & Animated Stuff',
      subgenres: ['Animated']
    },
    {
      genre: 'Cooking, Dressing & Decorating',
      subgenres: ['Auction', 'Cooking', 'Dog show', 'Fashion', 'Home improvement', 'Parenting', 'Self improvement', 'Shopping', 'House/garden', 'How-to', 'Travel', 'Collectibles', 'Consumer']
    },
    {
      genre: 'Cops & Lawyers Stuff',
      subgenres: ['Crime drama', 'Crime', 'Mystery']
    },
    {
      genre: 'Cowboy Stuff',
      subgenres: ['Western']
    },
    {
      genre: 'Cultured Stuff',
      subgenres: ['Dance', 'Art', 'Arts/crafts', 'Ballet', 'Musical', 'Opera', 'Musical comedy', 'Performing arts', 'Theater',]
    },
    {
      genre: 'Earth Stuff',
      subgenres: ['Nature', 'Agriculture', 'Animals', 'Outdoors']
    },
    {
      genre: 'Entertainment',
      subgenres: ['Special', 'Variety', 'Enterntainment']
    },
    # // {
    # //   genre: 'Faith Stuff',
    # //   subgenres: ['Religious']
    # // },
    {
      genre: 'Funny Stuff',
      subgenres: ['Comedy', 'Dark comedy', 'Musical comedy', 'Comedy drama', 'Sitcom', 'Standup', 'Romantic comedy']
    },
    {
      genre: 'Game Shows',
      subgenres: ['Game show']
    },
    {
      genre: 'Guilty Pleasure',
      subgenres: ['Reality']
    },
    # // {
    # //   genre: 'Gym & Health Stuff',
    # //   subgenres: ['Aerobics', 'Excercise', 'Health']
    # // },
    # // {
    # //   genre: 'Holiday Stuff',
    # //   subgenres: ['Holiday', 'Parade']
    # // },
    {
      genre: 'Love Stuff',
      subgenres: ['Romance', 'Romantic comedy']
    },
    # // {
    # //   genre: 'Music Stuff',
    # //   subgenres: ['Music']
    # // },
    {
      genre: 'People Talking',
      subgenres: ['Interview', 'Talk']
    },
    {
      genre: 'Potentially Dramatic',
      subgenres: ['Drama', 'Miniseries', 'Anthology', 'Historical Drama', 'Soap', 'Suspense', 'Thriller', 'Docudrama', 'Documentary']
    },
    {
      genre: 'Scary Stuff',
      subgenres: ['Horror', 'Thriller']
    },
    {
      genre: 'Sci-Fi Stuff',
      subgenres: ['Paranormal', 'Science fiction', 'Fantasy']
    },
    {
      genre: 'Smart Stuff',
      subgenres: ['History', 'Docudrama', 'Documentary','Military', 'War', 'News', 'Newsmagazine', 'Bus./financial', 'Biography', 'Debate', 'Educational', 'Fundraiser', 'Law', 'Medical', 'Poltics', 'Public affairs', 'Science']
    },
    {
      genre: 'Soap Opera Stuff',
      subgenres: ['Soap']
    },
    # // {
    # //   genre: 'Special Events',
    # //   subgenres: ['Event']
    # // },
    {
      genre: 'Sports Stuff',
      subgenres: ['Action Sports', 'Archery', 'Arm Wrestling', 'Auto Racing', 'Badminton', 'Baseball', 'Basketball', 'Beach Soccer', 'Beach Volleyball', 'Bicycle Racing', 'Bicycle', 'Billiards', 'Boat Racing', 'Boat', 'Bodybuilding', 'Boxing', 'Bowling', 'Bullfighting', 'Canoe', 'Card Games', 'Cheerleading', 'Cricket', 'Darts', 'Diving', 'Dog Sled', 'Drag Racing', 'Equestrian', 'Fencing', 'Field Hockey', 'Figure Skating', 'Fishing', 'Football', 'Gaming', 'Golf', 'Gymnastics', 'Handball', 'Hockey', 'Horse', 'Hunting', 'Intl Soccer', 'Kayaking', 'Lacrosse', 'Marital Arts', 'Mixed Martial Arts', 'Motorcycle Racing', 'Motorcycle', 'Motorsports', 'Mountain Biking', 'Olympics', 'Playoff Sports', 'Poker', 'Polo', 'Pro Wrestling', 'Racquet', 'Rodeo', 'Rugby', 'Running', 'Sailing', 'Shooting', 'Skateboarding', 'Skiing', 'Snooker', 'Snowboarding', 'Snowmobile', 'Soccer', 'Softball', 'Speed Skating', 'Swimming', 'Table Tennis', 'Tennis', 'Track/Field', 'Triathlon', 'Volleyball', 'Waterpolo', 'Watersports', 'Weightlifting', 'Wrestling', 'Yacht Racing', 'Surfing', 'Sports News']
    },
    # // {
    # //   genre: 'Tech Stuff',
    # //   subgenres: ['Computers', 'Technology']
    # // }
  ]
  def self.to_h
    @genres.reduce({}) do |memo, data|
      memo[data[:genre]] = data[:subgenres]
      memo
    end
  end

  def self.find_display_genres(genres)
    return [] if genres.nil?

    display_genres = []
    GenreMap.to_h.each do |display_name, sub_genres|
      display_genres.push(display_name) if genres.any? { |genre| sub_genres.include?(genre) }
    end

    display_genres
  end
end
