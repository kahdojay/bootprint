require 'dbc-ruby'
require 'time'
require 'linkedin-scraper'
require 'geocoder'

DBC.token = 'ce98e9d9d42bd8f4cf594c517fdee969'

cohort = DBC::Cohort.all

links = []

cohort.each do |c|
  if (c.in_session == false) && (Time.parse(c.start_date) < Time.now)
    c.students.each do |s|
      if (!s.profile[:linked_in].nil?)
        links << s.profile[:linked_in]
      end

      # if (!s.profile[:twitter].nil?)
      #   links << s.profile[:twitter]
      # end

      # if (!s.profile[:github].nil?)
      #   links << s.profile[:github]
      # end
    end
  end
end

links.reject! { |l| l.empty? }
links.select! { |l| l.match(/^(https:\/\/www.linkedin.com\/)/) || l.match(/^(http:\/\/www.linkedin.com\/)/) }

links.each do |l|
  profile = Linkedin::Profile.get_profile(l)
  if (profile.nil? == false) && (profile.name.nil? == false) && (profile.location.nil? == false) && (profile.current_companies.empty? == false)

    results = Geocoder.search("#{profile.location}, #{profile.current_companies[0][:company]}")
    if !results.empty?
      coordinates = results[0].data["geometry"]["location"]
      p Graduate.create!(
        name: profile.name,
        current_location: profile.location,
        current_employer: profile.current_companies[0][:company],
        latitude: coordinates['lat'],
        longitude: coordinates['lng'],
        linkedin_url: l
        )
    end
  end
end
