class Pages
  attr_accessor :url
  attr_accessor :title
  attr_accessor :description
  attr_accessor :links
  attr_accessor :topics

  def initialize
    self.url = ''
    self.title = ''
    self.description = ''
    self.links = []
    self.topics = {}
  end

end