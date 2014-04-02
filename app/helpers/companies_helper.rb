module CompaniesHelper
  
  def get_unique_tags(company)
    unique_tags = []
    
    company.articles.each do |article|
      article.tags.each do |tag|
        unique_tags << tag.tag_name
      end
    end
    
    unique_tags.uniq!
    return unique_tags
  end
  
  def add_placeholders_if_nil(section, text)
    return text unless text.nil? || text.empty?
    
    case section
    when 'title'
      return '<h1>Put Title Here</h1>'
    when 'body'
      return '<p>Put body here</p>'
    end
  end
  
end